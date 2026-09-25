# Curtis personal VM

Headless x86-64 NixOS guest on Big Ben. No GPU, desktop, container daemon or unattended agent services. Agent packages use the existing locked `llm-agents` input; authentication and preferences remain user-managed.

```text
hosts/curtis                  UEFI, virtual disks, QEMU, SSH public key
└── profiles/headless-dev     Linux base, SSH/Tailscale, agent packages
    └── home/linux-headless   terminal profile, direnv, basic Neovim
        └── home/terminal     existing shell, Git and tmux modules
```

## Before installation

This configuration declares an installation layout; it does not discover, partition or format disks. In the VM installer, inspect `lsblk -f` and confirm the **512 GiB virtual disk**. Never run guest partitioning commands in the Proxmox host shell.

Use GPT with a 1 GiB FAT32 EFI partition labeled `CURTIS_EFI`, mounted at `/mnt/boot`, and an ext4 root partition labeled `curtis-root`, mounted at `/mnt`. The labels must match `default.nix`. If the VM already has an installation/data, do not format it: inspect and adapt the filesystem declarations instead. There is no swap configured initially.

UEFI firmware must have Secure Boot disabled. The small Proxmox EFI variables disk is separate from the FAT32 partition inside the 512 GiB guest disk.

After the partitions are mounted and this reviewed repository is available inside the installer:

```sh
sudo nixos-install --flake .#curtis
sudo nixos-enter --command 'passwd curtis'
```

Run these from the repository root. Complete the root-password prompt for console recovery; set Curtis's password before reboot so console login and password-protected sudo work. No password is embedded in Git. `stateVersion = "26.11"` matches this new host's currently locked unstable NixOS version; it is a compatibility baseline, not an update selector. Reconsider it if choosing a different release before first installation; do not raise it routinely on upgrades.

## First boot and access

Use the Proxmox console to log in as `curtis`, then enroll this **guest** in Tailscale:

```sh
sudo tailscale up
tailscale ip -4
```

The Proxmox host's existing Tailscale enrollment does not enroll the VM. DHCP supplies the guest's office LAN address. OpenSSH accepts this Mac's existing Ed25519 public key; confirm that key still matches the intended client. Password and root SSH login are disabled. The guest firewall permits SSH only on `tailscale0`; Tailscale policy must also allow your client to reach the guest. This intentionally requires console enrollment before remote access. Do not open port 22 to the office LAN just to bypass enrollment.

From the Mac, connect using `ssh curtis@<guest-tailscale-ip>` and keep console access until verified. Add a concrete SSH alias in the Mac's SSH config if using desktop-app remote projects. Do not expose an agent app-server listener publicly.

## Development and agents

Use per-project development environments and run the agent from that environment. `nix develop` and Git worktrees are not security sandboxes. Leave each agent's sandbox/approval checks enabled; no passwordless sudo is configured. Authenticate directly on the guest using the tool's headless login flow. Never commit tokens or copy an entire Mac agent directory.

The existing Linux package module supplies Codex, Claude Code, OpenCode, Pi and CodeRabbit. No agent runs automatically. Start supervised terminal sessions in tmux; sessions survive SSH disconnections, not reboots. Test the sandbox and actual project build/test command before relying on the guest for work. Desktop-app SSH integration also needs a working remote `codex` in the login-shell PATH and authentication.

The headless profile intentionally uses basic Neovim. The existing desktop LazyVim module expects a separately cloned Lua configuration and includes extensive language tooling; adopt it separately if needed. Docker/Podman and unattended worker identities are deferred until an actual workflow requires them.

## Validation

From the repository root (evaluation also works on the Mac):

```sh
nix eval --impure --no-write-lock-file --json .#nixosConfigurations.curtis.config \
  --apply 'c: import ./tests/curtis.nix c'
```

Build on an x86-64 Linux machine, or use an appropriately configured Linux builder:

```sh
nix build --no-write-lock-file .#nixosConfigurations.curtis.config.system.build.toplevel
```

Evaluation is not build/boot proof. Before regular use, verify boot, SSH, Tailscale, QEMU guest reporting, agent login/sandboxing and one real project. Keep backups of unpushed work and other important mutable data; NixOS generations are not data backups.
