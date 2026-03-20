# Minimal-Churn Nix Refactor Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Reduce the most obvious duplication in the flake and profile layout without changing the overall repository shape or introducing large abstractions.

**Architecture:** Keep the current top-level structure (`flake.nix`, `hosts/`, `modules/`, `home/`) and preserve the current host entrypoints. Add a few small shared modules and constructor helpers so the repo stays familiar, but repeated logic lives in one place. Prefer low-risk extraction over redesign.

**Tech Stack:** Nix flakes, NixOS modules, nix-darwin, Home Manager

---

## Current Facts To Preserve

- `home/desktop/default.nix` and `home/laptop/default.nix` are currently identical.
- `hosts/desktop/default.nix` and `hosts/thinkpad/default.nix` share a large amount of repeated NixOS configuration.
- `hosts/utm-vm/default.nix` is empty but referenced from `flake.nix`.
- `hosts/vm-common/default.nix` imports `./hardware-configuration.nix`, but `hosts/vm-common/` does not contain that file, so do not treat it as a valid active host entrypoint.
- `hosts/xps/default.nix` exists but is not exported from `flake.nix`.
- `home/shared/opencode.nix` exists but is not documented in `docs/architecture.md`.

## Verification Conventions

- From this Linux workspace, use full `nix build` for native `x86_64-linux` outputs: `desktop`, `thinkpad`, and `kvm`.
- For cross-platform outputs that are not natively buildable here, use evaluation checks instead:
  - `nix eval .#nixosConfigurations.parallels-vm.config.networking.hostName`
  - `nix eval .#darwinConfigurations.mbp.config.system.primaryUser`
- If you later run this plan on matching native hardware, add full native builds for `parallels-vm` and `mbp` before declaring those targets verified.

### Task 1: Capture Baseline Behavior

**Files:**
- Read: `flake.nix`
- Read: `docs/architecture.md`
- Read: `home/desktop/default.nix`
- Read: `home/laptop/default.nix`
- Read: `home/vm/default.nix`
- Read: `home/darwin/default.nix`
- Read: `hosts/desktop/default.nix`
- Read: `hosts/thinkpad/default.nix`
- Read: `hosts/mbp/default.nix`
- Read: `hosts/kvm/default.nix`
- Read: `hosts/parallels-vm/default.nix`

- [ ] **Step 1: Record current working tree status**

Run: `git status --short`

Expected: You may see unrelated dirty files. Do not revert or absorb unrelated changes.

- [ ] **Step 2: Build the currently active exported systems**

Run:
- `nix build .#nixosConfigurations.desktop.config.system.build.toplevel`
- `nix build .#nixosConfigurations.thinkpad.config.system.build.toplevel`
- `nix build .#nixosConfigurations.kvm.config.system.build.toplevel`
- `nix eval .#nixosConfigurations.parallels-vm.config.networking.hostName`
- `nix eval .#darwinConfigurations.mbp.config.system.primaryUser`

Expected: Native Linux targets build or fail only for pre-existing reasons unrelated to this refactor. Cross-platform targets should at least evaluate cleanly.

- [ ] **Step 3: Confirm the stale-host issue before changing anything**

Run: `nix eval .#nixosConfigurations.utm-vm.config.networking.hostName`

Expected: Failure or unusable result, because `hosts/utm-vm/default.nix` is empty.

- [ ] **Step 4: Save short baseline notes**

Record which systems built successfully and whether `utm-vm` is currently broken.

### Task 2: Factor Repeated Flake Host Constructors

**Files:**
- Modify: `flake.nix`

- [ ] **Step 1: Add a small NixOS constructor helper**

Create a helper in the `let` block shaped like:

```nix
mkNixosHost = { system, path, hostConfig }:
  nixpkgs.lib.nixosSystem {
    inherit system;
    modules = [ path ];
    specialArgs = {
      inherit self inputs hostConfig;
    };
  };
```

- [ ] **Step 2: Add a small Darwin constructor helper**

Create a helper in the `let` block shaped like:

```nix
mkDarwinHost = { system, path, hostConfig }:
  nix-darwin.lib.darwinSystem {
    inherit system;
    modules = [ path ];
    specialArgs = {
      inherit self inputs hostConfig;
    };
  };
```

- [ ] **Step 3: Replace the repeated inline host constructors**

Use the helpers for:
- `desktop`
- `thinkpad`
- `kvm`
- `parallels-vm`
- `utm-vm`
- `mbp`

Keep host names and behavior unchanged.

- [ ] **Step 4: Re-run representative builds**

Run:
- `nix build .#nixosConfigurations.desktop.config.system.build.toplevel`
- `nix build .#nixosConfigurations.thinkpad.config.system.build.toplevel`
- `nix eval .#darwinConfigurations.mbp.config.system.primaryUser`

Expected: Same behavior as baseline.

- [ ] **Step 5: Commit**

Run:
- `git add flake.nix`
- `git commit -m "refactor: factor flake host constructors"`

### Task 3: Extract Shared Home Manager Base Defaults

**Files:**
- Create: `home/shared/base.nix`
- Modify: `home/desktop/default.nix`
- Modify: `home/laptop/default.nix`
- Modify: `home/vm/default.nix`
- Modify: `home/darwin/default.nix`

- [ ] **Step 1: Create a minimal shared HM base module**

Put only truly shared defaults into `home/shared/base.nix`, such as:
- `home.packages = [ pkgs.tree ]`
- `programs.yazi.enable = true`
- `programs.home-manager.enable = true`

- [ ] **Step 2: Import the new base module everywhere**

Add `../shared/base.nix` to:
- `home/desktop/default.nix`
- `home/laptop/default.nix`
- `home/vm/default.nix`
- `home/darwin/default.nix`

- [ ] **Step 3: Remove duplicated no-op boilerplate**

Remove empty or comment-only blocks instead of moving them:
- empty `home.sessionVariables`
- empty `home.file`
- commented placeholder sections that no longer add value

- [ ] **Step 4: Keep real per-profile differences in place**

Do not centralize:
- `home.stateVersion`
- Darwin-specific `home.file` entries
- Linux/Darwin username and home directory differences

- [ ] **Step 5: Build representative targets**

Run:
- `nix build .#nixosConfigurations.desktop.config.system.build.toplevel`
- `nix build .#nixosConfigurations.thinkpad.config.system.build.toplevel`
- `nix build .#nixosConfigurations.kvm.config.system.build.toplevel`
- `nix eval .#nixosConfigurations.parallels-vm.config.networking.hostName`
- `nix eval .#darwinConfigurations.mbp.config.system.primaryUser`

Expected: Success.

- [ ] **Step 6: Commit**

Run:
- `git add home/shared/base.nix home/desktop/default.nix home/laptop/default.nix home/vm/default.nix home/darwin/default.nix`
- `git commit -m "refactor: extract shared home-manager base"`

### Task 4: Deduplicate the Linux Workstation Home Profile

**Files:**
- Create: `home/shared/linux-workstation.nix`
- Modify: `home/desktop/default.nix`
- Modify: `home/laptop/default.nix`

- [ ] **Step 1: Move the shared Linux workstation imports into one module**

Put the common import list from `home/desktop/default.nix` and `home/laptop/default.nix` into `home/shared/linux-workstation.nix`.

- [ ] **Step 2: Make desktop and laptop wrappers thin**

Reduce `home/desktop/default.nix` and `home/laptop/default.nix` so they:
- import `../shared/base.nix`
- import `../shared/linux-workstation.nix`
- set `home.username`
- set `home.homeDirectory`
- set `home.stateVersion`

Do not have `home/shared/linux-workstation.nix` import `home/shared/base.nix`; keep that layering explicit in the thin wrappers.

- [ ] **Step 3: Preserve host-driven behavior**

Do not add separate laptop/desktop branching here. Existing modules already consume:
- `hostConfig.isLaptop`
- `hostConfig.hasNvidia`
- `hostConfig.monitors`

- [ ] **Step 4: Build both Linux workstation hosts**

Run:
- `nix build .#nixosConfigurations.desktop.config.system.build.toplevel`
- `nix build .#nixosConfigurations.thinkpad.config.system.build.toplevel`

Expected: Success.

- [ ] **Step 5: Commit**

Run:
- `git add home/shared/linux-workstation.nix home/desktop/default.nix home/laptop/default.nix`
- `git commit -m "refactor: share linux workstation home profile"`

### Task 5: Extract a Shared NixOS Workstation Base Module

**Files:**
- Create: `modules/nixos/base.nix`
- Modify: `hosts/desktop/default.nix`
- Modify: `hosts/thinkpad/default.nix`

- [ ] **Step 1: Extract only the clearly shared workstation settings**

Move the repeated blocks from `hosts/desktop/default.nix` and `hosts/thinkpad/default.nix` into `modules/nixos/base.nix`, including:
- zsh shell setup
- `networking.hostName = hostConfig.hostname`
- `networking.networkmanager.enable`
- timezone and locale wiring from `hostConfig`
- `xdg.portal`
- printing
- PipeWire + rtkit
- user account structure
- Firefox
- `nixpkgs.config.allowUnfree`
- small shared `environment.systemPackages`
- `system.stateVersion`
- shared `nix.settings` for flakes/Hyprland cache, if truly identical

- [ ] **Step 2: Keep device-specific logic in the hosts**

Do not move:
- ThinkPad hardware module import
- ThinkPad `networking.nix`
- fingerprint reader
- `services.tuned`
- `services.upower`
- desktop Nvidia config
- host-specific theme values
- host-specific `custom.keyd` values

- [ ] **Step 3: Keep Home Manager host wiring local**

Leave the `home-manager.users... = import ../../home/...` blocks in the host files for approach 1. Do not invent custom options just to remove a few lines.

- [ ] **Step 4: Rebuild workstation hosts**

Run:
- `nix build .#nixosConfigurations.desktop.config.system.build.toplevel`
- `nix build .#nixosConfigurations.thinkpad.config.system.build.toplevel`

Expected: Success.

- [ ] **Step 5: Commit**

Run:
- `git add modules/nixos/base.nix hosts/desktop/default.nix hosts/thinkpad/default.nix`
- `git commit -m "refactor: extract shared nixos workstation base"`

### Task 6: Resolve Stale Structure and Update Documentation

**Files:**
- Modify: `flake.nix`
- Modify: `docs/architecture.md`
- Move or delete: `hosts/xps/`
- Modify or remove: `hosts/utm-vm/default.nix`

- [ ] **Step 1: Ask one targeted question before touching inactive hosts**

Ask the user:

`Do you want to keep \`xps\` and \`utm-vm\` as placeholders, or should I archive them now? Recommended default: archive both, because \`xps\` is unreferenced and \`utm-vm\` is empty but exported.`

- [ ] **Step 2: Apply the answer with minimal churn**

If the user accepts the recommendation:
- remove `utm-vm` from `flake.nix`
- move `hosts/xps/` to an inactive/reference location such as `reference/inactive-hosts/xps/`

If the user wants placeholders retained:
- remove `utm-vm` from flake outputs until it has a real module
- leave `hosts/xps/` in place, but document that it is inactive

- [ ] **Step 3: Update the architecture doc**

Add:
- `home/shared/base.nix`
- `home/shared/linux-workstation.nix`
- `modules/nixos/base.nix`
- `home/shared/opencode.nix`
- active vs inactive host guidance

- [ ] **Step 4: Final verification**

Run:
- `nix build .#nixosConfigurations.desktop.config.system.build.toplevel`
- `nix build .#nixosConfigurations.thinkpad.config.system.build.toplevel`
- `nix build .#nixosConfigurations.kvm.config.system.build.toplevel`
- `nix eval .#nixosConfigurations.parallels-vm.config.networking.hostName`
- `nix eval .#darwinConfigurations.mbp.config.system.primaryUser`

- [ ] **Step 5: Commit**

Run:
- `git add -A flake.nix docs/architecture.md hosts/xps hosts/utm-vm reference/inactive-hosts/xps`
- `git commit -m "docs: clarify active hosts and shared module structure"`

### Task 7: Final Review

**Files:**
- Review: all changed files

- [ ] **Step 1: Review diff for accidental behavior changes**

Run:
- `git diff --stat HEAD~5..HEAD`
- `git diff`

- [ ] **Step 2: Confirm that the refactor stayed small**

Verify:
- no module internals were rewritten without need
- no new abstraction exists solely to remove 2-3 lines
- desktop and thinkpad behavior remain host-driven

- [ ] **Step 3: Prepare handoff note**

Include:
- what was centralized
- what intentionally stayed explicit
- whether `xps` and `utm-vm` were archived or retained
