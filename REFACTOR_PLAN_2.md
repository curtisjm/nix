# Profile-Oriented Nix Refactor Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Reorganize the repo around reusable host profiles so machine entrypoints become thin and the shared Linux, VM, and Darwin compositions are explicit.

**Architecture:** Introduce profile modules for NixOS and Home Manager, plus a small Darwin base module. Keep the current repository recognizable, but shift from copy/pasted import lists to semantic profile files like `workstation` and `vm`. This is a medium-churn cleanup, not a full framework rewrite.

**Tech Stack:** Nix flakes, NixOS modules, nix-darwin, Home Manager

---

## Current Facts To Preserve

- `hosts/desktop/default.nix` and `hosts/thinkpad/default.nix` are almost the same host with different hardware and device-specific settings.
- `home/desktop/default.nix` and `home/laptop/default.nix` are identical.
- `hosts/parallels-vm/default.nix` and `hosts/kvm/default.nix` have overlapping VM concerns.
- `hosts/vm-common/default.nix` is not directly usable as a real host entrypoint because it references a missing `hardware-configuration.nix`.
- `hosts/mbp/default.nix` hardcodes `curtis`, `/Users/curtis`, and `aarch64-darwin` instead of consuming `hostConfig`.
- `hosts/kvm/default.nix` still hardcodes hostname, timezone, locale, and user values instead of using `hostConfig`, so normalize that before extracting a shared VM profile.
- `overlays/default.nix` is a NixOS module that sets `nixpkgs.overlays`; it is not a reusable overlay function yet.

## Verification Conventions

- From this Linux workspace, use full `nix build` for native `x86_64-linux` outputs: `desktop`, `thinkpad`, and `kvm`.
- For cross-platform outputs that are not natively buildable here, use evaluation checks instead:
  - `nix eval .#nixosConfigurations.parallels-vm.config.networking.hostName`
  - `nix eval .#darwinConfigurations.mbp.config.system.primaryUser`
- If you later run this plan on matching native hardware, add full native builds for `parallels-vm` and `mbp` before declaring those targets verified.

### Task 1: Capture Baseline and Define Success Criteria

**Files:**
- Read: `flake.nix`
- Read: `docs/architecture.md`
- Read: active host files and profile files under `home/`

- [ ] **Step 1: Record current git status**

Run: `git status --short`

Expected: Possible unrelated dirty files; do not revert them.

- [ ] **Step 2: Build active exported configurations**

Run:
- `nix build .#nixosConfigurations.desktop.config.system.build.toplevel`
- `nix build .#nixosConfigurations.thinkpad.config.system.build.toplevel`
- `nix build .#nixosConfigurations.kvm.config.system.build.toplevel`
- `nix eval .#nixosConfigurations.parallels-vm.config.networking.hostName`
- `nix eval .#darwinConfigurations.mbp.config.system.primaryUser`

- [ ] **Step 3: Write down the target end state**

Success means:
- host files are thin
- profile modules own long import lists
- Darwin uses `hostConfig`
- inactive/broken host placeholders are resolved or clearly isolated

### Task 2: Create Explicit Home Manager Profile Modules

**Files:**
- Create: `home/profiles/base.nix`
- Create: `home/profiles/linux-workstation.nix`
- Create: `home/profiles/vm.nix`
- Create: `home/profiles/darwin.nix`
- Modify: `home/desktop/default.nix`
- Modify: `home/laptop/default.nix`
- Modify: `home/vm/default.nix`
- Modify: `home/darwin/default.nix`

- [ ] **Step 1: Create `home/profiles/base.nix`**

Put the true common defaults here:
- `home.packages = [ pkgs.tree ]`
- `programs.yazi.enable = true`
- `programs.home-manager.enable = true`

- [ ] **Step 2: Create `home/profiles/linux-workstation.nix`**

Move the shared Linux workstation imports here, including the current common set from desktop/laptop:
- shared shell/editor/dev modules
- `opencode`
- `codex`
- `claude-code`
- Linux GUI/app modules like `hyprland`, `kitty`, `noctalia`, `qutebrowser`, `direnv`

- [ ] **Step 3: Create `home/profiles/vm.nix`**

Move the VM-specific Home Manager imports here from `home/vm/default.nix`.

- [ ] **Step 4: Create `home/profiles/darwin.nix`**

Move the shared Darwin Home Manager imports here from `home/darwin/default.nix`, keeping Darwin-only file wiring intact.

- [ ] **Step 5: Convert old profile entrypoints into thin wrappers**

Reduce these files to tiny wrappers:
- `home/desktop/default.nix`
- `home/laptop/default.nix`
- `home/vm/default.nix`
- `home/darwin/default.nix`

Each wrapper should only:
- import the correct profile module(s)
- set username/home directory/state version if still needed

- [ ] **Step 6: Verify Home Manager wiring indirectly via system builds**

Run:
- `nix build .#nixosConfigurations.desktop.config.system.build.toplevel`
- `nix build .#nixosConfigurations.thinkpad.config.system.build.toplevel`
- `nix build .#nixosConfigurations.kvm.config.system.build.toplevel`
- `nix eval .#nixosConfigurations.parallels-vm.config.networking.hostName`
- `nix eval .#darwinConfigurations.mbp.config.system.primaryUser`

- [ ] **Step 7: Commit**

Run:
- `git add home/profiles home/desktop/default.nix home/laptop/default.nix home/vm/default.nix home/darwin/default.nix`
- `git commit -m "refactor: introduce home-manager profile modules"`

### Task 3: Create Shared NixOS Base and Role Profiles

**Files:**
- Create: `modules/nixos/base.nix`
- Create: `modules/nixos/profiles/workstation.nix`
- Create: `modules/nixos/profiles/vm.nix`
- Modify: `hosts/desktop/default.nix`
- Modify: `hosts/thinkpad/default.nix`
- Modify: `hosts/kvm/default.nix`
- Modify: `hosts/parallels-vm/default.nix`

- [ ] **Step 1: Create `modules/nixos/base.nix`**

Move cross-host Linux basics here:
- shell defaults
- timezone/locale from `hostConfig`
- user creation from `hostConfig`
- common audio, printing, Firefox, `allowUnfree`
- common networking base
- `system.stateVersion`

- [ ] **Step 2: Create `modules/nixos/profiles/workstation.nix`**

This module should own the long shared import list for desktop/thinkpad:
- `inputs.home-manager.nixosModules.home-manager`
- `inputs.stylix.nixosModules.stylix`
- `inputs.agenix.nixosModules.default`
- repo modules like `theme`, `stylix`, `noctalia`, `packages`, `hyprland`, `keyd`, `fonts`, `thunar`, `regreet`, `virtualization`, `tailscale`, `shared/emacs`

Keep `networking.nix` out if it is ThinkPad-specific.

- [ ] **Step 3: Create `modules/nixos/profiles/vm.nix`**

Use the shared VM pieces from `kvm` and `parallels-vm`:
- HM module
- stylix input if still needed
- packages/fonts/keyd/thunar
- common VM audio/user/base settings

Do not copy `hosts/vm-common/default.nix` wholesale. Use it as reference only.

- [ ] **Step 4: Normalize KVM to the same `hostConfig` pattern first**

Before extracting common VM logic, update `hosts/kvm/default.nix` to use `hostConfig` for hostname, timezone, locale, and user settings so the VM profile is built from one consistent pattern.

- [ ] **Step 5: Convert Linux host entrypoints into thin machine files**

After the profile modules exist:
- `hosts/desktop/default.nix` should mostly be hardware config + workstation profile + desktop-only settings
- `hosts/thinkpad/default.nix` should mostly be hardware config + ThinkPad hardware module + workstation profile + ThinkPad-only settings
- `hosts/kvm/default.nix` should mostly be hardware config + VM profile + KVM-only settings
- `hosts/parallels-vm/default.nix` should mostly be hardware config + VM profile + Parallels-only settings

- [ ] **Step 6: Keep device-specific settings local**

Do not move:
- Nvidia settings from desktop
- fingerprint/upower/tuned from ThinkPad
- Parallels graphics settings
- KVM bootloader or guest-agent specifics unless they are truly shared

- [ ] **Step 7: Rebuild Linux systems**

Run:
- `nix build .#nixosConfigurations.desktop.config.system.build.toplevel`
- `nix build .#nixosConfigurations.thinkpad.config.system.build.toplevel`
- `nix build .#nixosConfigurations.kvm.config.system.build.toplevel`
- `nix eval .#nixosConfigurations.parallels-vm.config.networking.hostName`

- [ ] **Step 8: Commit**

Run:
- `git add modules/nixos/base.nix modules/nixos/profiles hosts/desktop/default.nix hosts/thinkpad/default.nix hosts/kvm/default.nix hosts/parallels-vm/default.nix`
- `git commit -m "refactor: move nixos hosts to role profiles"`

### Task 4: Make Darwin Consume `hostConfig`

**Files:**
- Create: `modules/darwin/base.nix`
- Modify: `hosts/mbp/default.nix`
- Modify: `home/darwin/default.nix`
- Modify: `flake.nix`

- [ ] **Step 1: Extend `hostConfig` for Darwin**

Add any missing Darwin metadata to `mbpConfig` in `flake.nix`, such as:
- username
- hostname
- home directory
- system/platform if you want it in one place

- [ ] **Step 2: Create `modules/darwin/base.nix`**

Centralize the repeated Darwin host wiring:
- `users.users.${hostConfig.username}`
- `home-manager` wiring
- `system.primaryUser`
- `nixpkgs.hostPlatform`
- `nix.settings.experimental-features`

Make `hosts/mbp/default.nix` pass `hostConfig` through Home Manager explicitly:

```nix
home-manager.extraSpecialArgs = { inherit inputs hostConfig; };
```

Keep this module small and declarative.

- [ ] **Step 3: Thin `hosts/mbp/default.nix`**

Reduce it to:
- imports
- MBP-specific settings
- host/profile selection
- Homebrew-specific values that truly belong to this machine

- [ ] **Step 4: Remove hardcoded username/home directory from `home/darwin/default.nix` if possible**

Prefer `hostConfig` over string literals where the module already receives it.

- [ ] **Step 5: Verify Darwin config from this workspace**

Run: `nix eval .#darwinConfigurations.mbp.config.system.primaryUser`

If you are on the MBP itself, also run: `nix build .#darwinConfigurations.mbp.system`

- [ ] **Step 6: Commit**

Run:
- `git add modules/darwin/base.nix hosts/mbp/default.nix home/darwin/default.nix flake.nix`
- `git commit -m "refactor: derive darwin host settings from hostConfig"`

### Task 5: Replace Manual Flake Host Entries with Metadata-Driven Wiring

**Files:**
- Modify: `flake.nix`

- [ ] **Step 1: Add host metadata attrsets**

Instead of hand-writing each system constructor, define a small data structure for:
- host path
- platform/system
- `hostConfig`
- host kind (`nixos` or `darwin`)

- [ ] **Step 2: Generate outputs from metadata**

Use `lib.mapAttrs` or `builtins.listToAttrs` to generate:
- `nixosConfigurations`
- `darwinConfigurations`

- [ ] **Step 3: Keep the result readable**

Do not move every piece of logic into the metadata table. Approach 2 should still read clearly to a human skimming `flake.nix`.

- [ ] **Step 4: Rebuild representative systems**

Run:
- `nix build .#nixosConfigurations.desktop.config.system.build.toplevel`
- `nix build .#nixosConfigurations.kvm.config.system.build.toplevel`
- `nix eval .#darwinConfigurations.mbp.config.system.primaryUser`

- [ ] **Step 5: Commit**

Run:
- `git add flake.nix`
- `git commit -m "refactor: generate flake hosts from metadata"`

### Task 6: Resolve Broken and Inactive Host Structure

**Files:**
- Modify or remove: `hosts/utm-vm/default.nix`
- Move or delete: `hosts/xps/`
- Move or delete: `hosts/vm-common/`
- Modify: `flake.nix`
- Modify: `docs/architecture.md`

- [ ] **Step 1: Ask one targeted question**

Ask:

`Do you want \`xps\`, \`utm-vm\`, and \`vm-common\` kept as future work, or should I archive/remove them as part of this refactor? Recommended default: archive \`xps\` and \`vm-common\`, and either implement or remove \`utm-vm\` from flake outputs.`

- [ ] **Step 2: Apply the answer cleanly**

Recommended implementation:
- move `vm-common` logic into `modules/nixos/profiles/vm.nix`
- archive `hosts/vm-common/` to `reference/inactive-hosts/vm-common/`
- archive `hosts/xps/` to `reference/inactive-hosts/xps/`, or remove it if the user prefers
- remove `utm-vm` from outputs unless it is fully implemented during this refactor

- [ ] **Step 3: Update `docs/architecture.md`**

Document:
- `home/profiles/`
- `modules/nixos/profiles/`
- `modules/darwin/base.nix`
- active vs archived hosts

- [ ] **Step 4: Commit**

Run:
- `git add -A hosts/xps hosts/vm-common hosts/utm-vm reference/inactive-hosts docs/architecture.md flake.nix modules/nixos/profiles`
- `git commit -m "docs: align host inventory with new profile structure"`

### Task 7: Full Verification and Handoff

**Files:**
- Review: all changed files

- [ ] **Step 1: Build every active exported target**

Run:
- `nix build .#nixosConfigurations.desktop.config.system.build.toplevel`
- `nix build .#nixosConfigurations.thinkpad.config.system.build.toplevel`
- `nix build .#nixosConfigurations.kvm.config.system.build.toplevel`
- `nix eval .#nixosConfigurations.parallels-vm.config.networking.hostName`
- `nix eval .#darwinConfigurations.mbp.config.system.primaryUser`

- [ ] **Step 2: Review diff for abstraction creep**

Verify:
- host files are thinner than before
- profile modules have a clear single purpose
- no new layer exists only to rename one import list

- [ ] **Step 3: Prepare handoff summary**

Include:
- which new profile files exist
- which host files became wrappers/thin entrypoints
- what happened to `xps`, `utm-vm`, and `vm-common`
