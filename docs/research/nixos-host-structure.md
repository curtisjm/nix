# NixOS host structure research

Research date: 2026-09-24. Scope: a personal headless x86-64 Proxmox development VM alongside the existing Darwin setup. This is an assessment, not an applied configuration or tested deployment.

## Recommendation

Keep one flake and the existing explicit module/profile approach. Refactor the Linux boundary between genuinely common settings and desktop settings; add a headless development profile and a new host. Do not make a framework migration a prerequisite for installing this VM.

The useful change is semantic, not directory churn: a **host** describes this particular machine; a **profile** selects its role; a **feature module** implements a reusable capability; Home Manager owns the user's environment; each project's development environment owns its language/tool versions.

## Current repository evidence

The architecture documented in `docs/architecture.md` is already coherent: `lib/hosts.nix` feeds small constructors; hosts import explicit profiles; NixOS, Darwin, and Home Manager modules remain distinct.

The problem is that Linux `base.nix` is not actually headless: it enables Firefox, PipeWire, and desktop-oriented user groups. `modules/nixos/profiles/vm.nix` imports Stylix, keyd, fonts, Thunar, and security packages. `home/profiles/vm.nix` imports i3, Kitty, and Rofi. Reusing those profiles for the new server would carry desktop behavior along. These observations are from current source, not evaluation or a running host.

There are existing staged and unstaged changes, including `lib/hosts.nix` and `flake.lock`. Preserve them; do not combine broad input upgrades with this restructuring.

## Approaches compared

| Approach | What it supplies | Fit here |
| --- | --- | --- |
| Plain Nix modules, explicit imports and profiles | NixOS's native module composition, options, defaults, and overrides | Recommended. Already present and straightforward to trace. |
| flake-parts | A module system around flake outputs, especially per-system packages, checks and development shells | Useful if the flake itself becomes complicated; not necessary merely to share NixOS modules. Can adopt independently later. |
| Dendritic pattern | Feature-oriented top-level modules that can define NixOS, Darwin and Home Manager behavior together | Reasonable when cross-platform features repeatedly require coordination. Adds another evaluation level and concepts to learn; not justified solely by one new host. |

Official/project facts: NixOS modules support composition through `imports`; [the NixOS module documentation](https://wiki.nixos.org/wiki/Module) explains their structure. [flake-parts](https://flake.parts/) explicitly targets modular flake outputs and per-system handling. Its [modules extension](https://flake.parts/options/flake-parts-modules.html) can publish class-checked NixOS/Home Manager modules. The [Dendritic pattern's own specification](https://github.com/mightyiam/dendritic) describes a top-level configuration containing lower-level modules, commonly but not necessarily using flake-parts; it explicitly requires understanding the Nix module system and deferred modules. The suitability assessments in the table are recommendations, not upstream requirements.

## Suggested boundaries

Illustrative names, not a mandatory migration layout:

```text
hosts/curtis/                  machine identity, generated hardware, boot, stateVersion
modules/nixos/base.nix         Nix policy, locale, minimum shared system defaults
modules/nixos/profiles/
  workstation.nix             desktop Linux composition
  headless-dev.nix            SSH, networking, guest agent, optional containers
modules/nixos/features/       reusable services where extraction earns its keep
home/profiles/
  terminal.nix               shared shell/editor/Git/tmux composition
  linux-headless.nix         terminal profile plus Linux-only user tools
  darwin.nix                 existing macOS composition
```

Recommendations:

- Keep Proxmox/QEMU boot and hardware details separate from the headless role. A future bare-metal server could then reuse the role.
- Move desktop behavior out of the common Linux base while preserving workstation imports. Keep the working Darwin path unchanged initially.
- Prefer explicit feature imports over automatically enabling every file in a directory. Avoid a custom `enable` option for every tiny private file; introduce options when real consumers need configuration.
- Keep the inventory small: identity/platform/entrypoint metadata, not a parallel language for specifying all NixOS options.
- Keep state-version values per installed host/user environment rather than one global value changed on upgrades.
- Start with one normal administrative user, `curtis`. An isolated agent user is a separate security decision, not a reason to reshape the whole flake.

## Home Manager and project environments

The [Home Manager NixOS integration](https://github.com/nix-community/home-manager/blob/master/docs/manual/installation/nixos.md) lets a system rebuild activate user environments. `useGlobalPkgs = true` reuses the system package set rather than evaluating another one; the documentation notes consistency and evaluation benefits. Standalone Home Manager remains possible, but this machine has one owner, so keeping the existing integrated model is the simpler recommendation.

System configuration should own accounts, SSH, firewall, Tailscale, Docker/Podman services, and QEMU integration. Home Manager should own shell/editor/Git/tmux settings and user-facing agent preferences. Neither layer should embed authentication tokens.

Project-specific compilers, runtimes and libraries belong in project `devShells`/`shell.nix` where practical, not an ever-growing global package list. [`nix develop`](https://nix.dev/manual/nix/2.35/command-ref/new-cli/nix3-develop) enters the environment defined by a derivation, including flake development shells. This recommendation keeps two projects from implicitly depending on whatever Python/Node happens to be installed globally. It is an environment mechanism, not a security sandbox for agents.

## Secrets

Do not put plaintext secrets in Nix expressions or files copied into the Nix store. [agenix](https://github.com/ryantm/agenix) documents that store contents are readable by system users; it deploys encrypted files and decrypts them to runtime paths using keys on the target. The repository already uses agenix, so retaining it for machine service secrets avoids another migration.

[sops-nix](https://github.com/Mic92/sops-nix) is an alternative with structured encrypted documents, age/GPG support, declarative ownership, and activation-time extraction of individual secrets. Consider it if that workflow becomes valuable, not simply because a new host is being added. Its documentation distinguishes SOPS cloud KMS capabilities from what sops-nix officially supports.

Recommendation: keep interactive OAuth login state local and writable, separately from declarative non-secret preferences. Back up/recover decryption identities deliberately; encrypted Git files alone do not recover secrets after losing the corresponding private keys. Do not give an agent access to unrelated workstation or production credentials simply by copying an entire home directory.

## Pinning and upgrades

The [Nix flake manual](https://nix.dev/manual/nix/2.35/command-ref/new-cli/nix3-flake#lock-files) explains that `flake.lock` resolves inputs to locked revisions. An unstable input with a committed lockfile is pinned until deliberately updated; it is not a promise of runtime stability. New files in Git-backed local flakes must be added to Git for Nix to include them.

The [`system.stateVersion` definition](https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/misc/version.nix) explicitly says it selects compatibility defaults for installed state, does not choose the package release, and normally should not change after installation. Home Manager has its own independent compatibility value. Choose the new VM's values from the actual initial installation; do not copy the old KVM value merely because it exists.

Recommendation: first implement against the existing lock without unrelated upgrades. Then choose an update policy. A pinned unstable development VM is reasonable if Curtis is comfortable testing upgrades; a supported stable NixOS input can be added separately if less platform churn is desired, with a compatible Home Manager input. Do not silently change the shared input for Darwin merely to change Linux policy.

## Build and deployment

The [NixOS rebuild documentation](https://wiki.nixos.org/wiki/Nixos-rebuild) distinguishes `--build-host` (where a configuration is built) from `--target-host` (where it is activated) and permits using both. [Nix remote builds](https://nix.dev/manual/nix/2.35/advanced-topics/distributed-builds) allow a Linux builder to build Linux derivations from a macOS controller. Do not assume an ARM Mac can directly build an x86-64 Linux system without an appropriate builder or other cross-platform mechanism.

Recommendation for this one VM: initially copy/clone the reviewed configuration to the VM and build there. Native `nixos-rebuild` over SSH is enough before introducing deployment frameworks. Later, build and target can both be the VM while editing on the Mac. Exact command syntax should be checked against the installed NixOS release.

Validation should progress from evaluation to Linux build to activation and actual connectivity checks. A successful evaluation does not prove the system builds, boots, or preserves remote access. Keep the Proxmox console available for SSH/network changes. Rollback of a NixOS generation is not rollback of databases, home directories, or other mutable data.

## Coding agents: installation, configuration and execution

Recommendation: treat an agent as a development tool running inside the personal VM, not a service on the Proxmox hypervisor. Start with supervised sessions under `curtis`; add unattended workers only after choosing their access boundaries.

### Installation and updates

The current `modules/nixos/llm-agents.nix` already installs Claude Code, Codex, OpenCode, Pi and CodeRabbit from the independent `llm-agents` flake input. Keep this package source initially, but select only the tools actually wanted. The Darwin module currently installs OMP through Nix as well as other tools through Homebrew, so `docs/architecture.md` is incomplete about current agent packaging. Do not unify Darwin installers as part of the first Linux change.

[Numtide's own documentation](https://github.com/numtide/llm-agents.nix) recommends its independently pinned package set for tested dependencies and binary-cache reuse. Upstream updating daily does not update this host automatically: its selected revision remains in the local lockfile. Recommendation: update that input deliberately, test the agents, and rebuild; avoid installing competing copies through npm or native self-updaters. Trusting the Numtide cache is an explicit third-party supply-chain choice, not an official OpenAI or Anthropic guarantee.

Current upstream packaging supplies Linux sandbox helpers for [Claude Code](https://github.com/numtide/llm-agents.nix/blob/main/packages/claude-code/package.nix) and [Codex](https://github.com/numtide/llm-agents.nix/blob/main/packages/codex/package.nix). Claude's wrapper also disables its self-updater. These are observations of upstream source, not confirmation that every behavior exists or works in the locally pinned revision. Check the pin and run sandbox tests before deployment.

### Separate reproducible preferences from mutable state

| Layer | Recommended owner | Examples |
| --- | --- | --- |
| Installed programs | Nix/Home Manager, with the cache configured at system level | Selected agents, Git, ripgrep, tmux |
| Non-secret preferences | Initially user-managed; optionally Home Manager once stable | Default permissions, selected model, launcher scripts |
| Project instructions and environment | The project repository | Build/test commands, agent instructions, devShell or existing container setup |
| Writable runtime state | Agent itself, in the user's home | OAuth tokens, sessions, history, local trust decisions |
| Unattended service credentials | Runtime secret delivery, narrowly scoped | Dedicated API credentials, not a copied personal home directory |

The current repo explicitly chooses user-managed agent runtime configuration. Retain that initially rather than symlinking entire agent directories into the read-only Nix store. If selected settings become declarative later, define ownership clearly: UI/CLI commands that rewrite a Nix-managed file may fail or be overwritten on activation. [Claude settings documentation](https://code.claude.com/docs/en/settings) describes user, project, local and managed scopes, including settings its UI writes. [Codex authentication documentation](https://learn.chatgpt.com/docs/auth) describes credential stores and refreshable local authentication state.

### Remote access and authentication

- Preferred starting workflow: SSH over Tailscale to the VM, enter the project environment, launch an agent in tmux. Tmux retains a terminal session across disconnects, not VM reboots or process crashes.
- The desktop app can also run remote project work over SSH. [Official OpenAI remote-connection documentation](https://learn.chatgpt.com/docs/remote-connections#connect-to-an-ssh-host) requires a working SSH alias and Codex installed/authenticated on the remote user's login-shell PATH. This is different from installing a graphical desktop inside the VM. Do not expose an app-server port publicly. NixOS compatibility of this exact setup remains to be tested.
- For Codex, the official headless flow is `codex login --device-auth`, subject to account/workspace availability; SSH forwarding of the browser callback is an alternative. For Claude, open its login URL on the Mac and complete the printed-code flow when prompted. Use the intended work account and workspace. Sources: [Codex authentication](https://learn.chatgpt.com/docs/auth#login-on-headless-devices), [Claude authentication](https://code.claude.com/docs/en/authentication).
- Do not put tokens in Nix strings, Git, shell startup files, or shared VM templates. Do not copy all Mac credentials to the VM. Authenticate only tools needed for the actual workflow.

### Permissions and isolation

Keep each agent's command sandbox enabled and request approval for wider access. [OpenAI's security documentation](https://learn.chatgpt.com/docs/agent-approvals-security) distinguishes OS-enforced sandboxing from approval prompts. [Claude's sandbox documentation](https://code.claude.com/docs/en/sandboxing) documents Linux bubblewrap/socat requirements. Test a permitted workspace write and an attempted write outside it; merely launching the program is not a sandbox test.

The personal VM separates this environment from the hypervisor, but does not separate an unrestricted agent from Curtis's files inside it. Git worktrees prevent parallel tasks from sharing one working directory; they are not a security boundary. `nix develop` supplies dependencies; it is not a security boundary either. Default workspace sandboxing should not be assumed to hide every credential readable by the Unix user.

Recommendation for unattended work: a separate unprivileged worker identity or disposable worker VM, restricted credentials and network access, resource limits, logs and an explicit restart policy. No passwordless sudo, Proxmox credentials, or production credentials by default. A user account in the rootful Docker group can effectively control its VM as root; mounting its Docker socket inside an agent container undermines that container boundary. See [Docker's daemon security guidance](https://docs.docker.com/engine/security/#docker-daemon-attack-surface). Rootless containers are an option, but compatibility with the real project's Docker/Testcontainers workflow needs testing.

Do not introduce an orchestration framework or permanent agent daemons before the first real development task works. For concurrent supervised tasks, start with separate worktrees and sessions. Unattended services can later use systemd with bounded permissions; avoid blindly restarting a failed agent that can repeat external side effects.

### NixOS-specific development friction

Agents execute the same tools that a developer does, so the real compatibility test is the project's build/test/browser workflow. Start agents inside the project's environment, or require explicit `nix develop --command ...` for non-interactive commands; do not assume an SSH app-server inherits an interactive direnv shell.

Prefer packaged tools and project environments. [`nix-ld`](https://github.com/nix-community/nix-ld) helps run downloaded Linux binaries expecting a conventional dynamic loader; it does not provide every missing library or make NixOS identical to Ubuntu. Consider it for editor servers and vendor tools, then add only dependencies demonstrated by failures. Use a project container for a workflow that genuinely assumes a conventional Linux filesystem. Do not redesign coworkers' project environments merely to install this host.

## Suggested validation before calling the host ready

1. Evaluate the new host and affected existing Linux hosts; separately check Darwin's evaluation remains intact. The current lock has independently aged inputs, so evaluation may expose compatibility work. Do not infer compatibility from successful imports alone.
2. Build the system on Linux. Preserve existing dirty/staged work and avoid a global lock refresh during structural changes.
3. Confirm console recovery, boot, QEMU guest reporting, SSH and Tailscale access before closing the recovery session.
4. Confirm agent versions, login, a harmless remote task and sandbox enforcement. Test desktop SSH integration separately if selected.
5. Clone one real development repository, enter its environment, run its normal test command and exercise any needed containers/browser tooling.
6. Decide what mutable data needs backup. Declarative configuration and OS rollback do not recover unpushed code, credentials or local databases after disk loss.

## Remaining design questions

1. Are agents interactive tools launched by Curtis, or unattended workers needing narrower identities and credentials?
2. Which Linux hosts remain worth supporting, versus intentionally archiving?
3. Does the personal VM need a desktop at all? Current assumption: terminal/SSH development only.
4. Should Linux retain the existing unstable pin or follow a separately pinned stable release?
5. What actual project command must work first? Use that as the acceptance test, rather than treating all imported modules as proof of readiness.
