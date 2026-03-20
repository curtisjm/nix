# Data-Driven Flake Redesign Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Redesign the configuration around a single host inventory, generated flake outputs, reusable role profiles, and cleaner Nix-native composition.

**Architecture:** Move host metadata out of ad hoc blocks in `flake.nix` and into a dedicated inventory. Generate NixOS and Darwin systems from that inventory with helper functions and role/profile modules. Keep business logic in modules and profiles, while `flake.nix` becomes an orchestrator rather than a pile of repeated constructors.

**Tech Stack:** Nix flakes, NixOS modules, nix-darwin, Home Manager, Nix library functions (`mapAttrs`, `optionalAttrs`, `mkMerge`, overlays)

---

## Current Facts To Preserve

- `flake.nix` already has the beginnings of a host-metadata model with `commonConfig`, `vmConfig`, `thinkpadConfig`, `desktopConfig`, and `mbpConfig`.
- The repo does not currently have a dedicated `lib/` layer for host construction.
- `overlays/default.nix` is a NixOS module, not a reusable overlay function.
- `hosts/utm-vm/default.nix` is empty.
- `hosts/vm-common/default.nix` is not valid as a real host entrypoint because it imports a missing `hardware-configuration.nix`.
- `home/desktop/default.nix` and `home/laptop/default.nix` are identical, which is a strong sign that the profile should be role-based instead of host-based.

## Verification Conventions

- From this Linux workspace, use full `nix build` for native `x86_64-linux` outputs: `desktop`, `thinkpad`, and `kvm`.
- For cross-platform outputs that are not natively buildable here, use evaluation checks instead:
  - `nix eval .#nixosConfigurations.parallels-vm.config.networking.hostName`
  - `nix eval .#darwinConfigurations.mbp.config.system.primaryUser`
- If you later run this plan on matching native hardware, add full native builds for `parallels-vm` and `mbp` before declaring those targets verified.

## Review Checkpoints

- Stop after Task 2 and get user review before changing the profile layout.
- Stop after Task 4 and get user review before changing overlay behavior.
- Treat Task 6 (`flake check`) as optional unless the user explicitly wants that extra phase.

### Task 1: Freeze Current Behavior and Define the Inventory Model

**Files:**
- Read: `flake.nix`
- Read: all active host files
- Read: all current Home Manager profile files
- Read: `overlays/default.nix`

- [ ] **Step 1: Capture current build status**

Run:
- `git status --short`
- `nix build .#nixosConfigurations.desktop.config.system.build.toplevel`
- `nix build .#nixosConfigurations.thinkpad.config.system.build.toplevel`
- `nix build .#nixosConfigurations.kvm.config.system.build.toplevel`
- `nix eval .#nixosConfigurations.parallels-vm.config.networking.hostName`
- `nix eval .#darwinConfigurations.mbp.config.system.primaryUser`

- [ ] **Step 2: Write down the target host metadata schema before coding**

The inventory should capture at least:
- host name
- flake output kind (`nixos` or `darwin`)
- system string
- module entrypoint path
- role/profile (`workstation`, `vm`, `darwin`)
- username
- hostname
- home directory
- timezone
- locale
- feature flags like `isLaptop`, `hasNvidia`
- optional extra modules as one consistent type, either a list of module paths or a list of imported module values

- [ ] **Step 3: Decide what to do with inactive hosts**

Ask the user:

`Before I convert the repo to a host inventory, should I archive inactive/broken hosts like \`xps\`, \`utm-vm\`, and \`vm-common\`, or keep them in the inventory as inactive entries? Recommended default: archive them and keep the inventory limited to active systems.`

### Task 2: Create a Dedicated Host Inventory and Constructor Layer

**Files:**
- Create: `lib/hosts.nix`
- Create: `lib/mk-nixos-host.nix`
- Create: `lib/mk-darwin-host.nix`
- Modify: `flake.nix`

- [ ] **Step 1: Create `lib/hosts.nix`**

Define one attrset containing all active host metadata. Keep it declarative and data-only.

- [ ] **Step 2: Create `lib/mk-nixos-host.nix`**

Export a helper that accepts:
- `inputs`
- `self`
- `nixpkgs`
- host metadata

and returns `nixpkgs.lib.nixosSystem`.

- [ ] **Step 3: Create `lib/mk-darwin-host.nix`**

Export a helper that accepts:
- `inputs`
- `self`
- `nix-darwin`
- host metadata

and returns `nix-darwin.lib.darwinSystem`.

- [ ] **Step 4: Make `flake.nix` orchestrate instead of hardcode**

Replace the repeated inline outputs with:
- host inventory import
- host constructor imports
- generated `nixosConfigurations`
- generated `darwinConfigurations`

- [ ] **Step 5: Use Nix library helpers deliberately**

Use:
- `lib.mapAttrs`
- `lib.filterAttrs`
- `lib.optionalAttrs`

Do not introduce cleverness that makes the inventory harder to read.

- [ ] **Step 6: Build representative systems**

Run:
- `nix build .#nixosConfigurations.desktop.config.system.build.toplevel`
- `nix eval .#darwinConfigurations.mbp.config.system.primaryUser`

- [ ] **Step 7: Commit**

Run:
- `git add lib flake.nix`
- `git commit -m "refactor: generate systems from a shared host inventory"`

- [ ] **Step 8: Review checkpoint**

Stop here and ask the user to review the host inventory and generated flake structure before continuing.

### Task 3: Replace Host-Centric Home Manager Layout with Role Profiles

**Files:**
- Create: `home/profiles/base.nix`
- Create: `home/profiles/linux-workstation.nix`
- Create: `home/profiles/vm.nix`
- Create: `home/profiles/darwin.nix`
- Modify: `home/desktop/default.nix`
- Modify: `home/laptop/default.nix`
- Modify: `home/vm/default.nix`
- Modify: `home/darwin/default.nix`

- [ ] **Step 1: Create role-based HM profiles**

Build the Home Manager layer around roles, not machine names:
- `linux-workstation`
- `vm`
- `darwin`

- [ ] **Step 2: Keep wrappers only if they add compatibility value**

If existing paths are important for stability, keep the old files as thin wrappers. Otherwise, point host wiring directly at `home/profiles/...`.

- [ ] **Step 3: Move common defaults into `home/profiles/base.nix`**

Include only the defaults that are shared across all or nearly all profiles.

- [ ] **Step 4: Preserve host-driven branches**

Existing modules already use:
- `hostConfig.isLaptop`
- `hostConfig.hasNvidia`
- `hostConfig.monitors`

Keep using those instead of splitting the same behavior into multiple copies.

- [ ] **Step 5: Build workstation and Darwin targets**

Run:
- `nix build .#nixosConfigurations.desktop.config.system.build.toplevel`
- `nix build .#nixosConfigurations.thinkpad.config.system.build.toplevel`
- `nix build .#nixosConfigurations.kvm.config.system.build.toplevel`
- `nix eval .#nixosConfigurations.parallels-vm.config.networking.hostName`
- `nix eval .#darwinConfigurations.mbp.config.system.primaryUser`

- [ ] **Step 6: Commit**

Run:
- `git add home/profiles home/desktop/default.nix home/laptop/default.nix home/vm/default.nix home/darwin/default.nix`
- `git commit -m "refactor: convert home-manager to role profiles"`

### Task 4: Create System Role Profiles for NixOS and Darwin

**Files:**
- Create: `modules/nixos/base.nix`
- Create: `modules/nixos/profiles/workstation.nix`
- Create: `modules/nixos/profiles/vm.nix`
- Create: `modules/darwin/base.nix`
- Create: `modules/darwin/profiles/default.nix`
- Modify: active host entrypoints in `hosts/`

- [ ] **Step 1: Create `modules/nixos/base.nix`**

Move the common Linux system foundation here:
- user creation from metadata
- locale/timezone
- shell defaults
- common services
- base package policy
- shared `nix.settings`

- [ ] **Step 2: Create `modules/nixos/profiles/workstation.nix`**

Own the workstation composition here:
- HM module import
- stylix input
- agenix input
- workstation repo modules
- shared workstation service imports

- [ ] **Step 3: Create `modules/nixos/profiles/vm.nix`**

Own the VM composition here, using the useful shared pieces from `kvm`, `parallels-vm`, and `vm-common` without copying broken host assumptions.

Before extracting shared VM logic, normalize `hosts/kvm/default.nix` so hostname, timezone, locale, and user values come from `hostConfig`, matching the pattern already used by `parallels-vm`.

- [ ] **Step 4: Create `modules/darwin/base.nix` and `modules/darwin/profiles/default.nix`**

Use metadata-driven Darwin wiring:
- primary user
- home-manager user
- host platform
- nix settings
- Darwin module import composition

If any Home Manager module under `home/darwin/` needs `hostConfig`, make that propagation explicit in the host wiring, for example:

```nix
home-manager.extraSpecialArgs = { inherit inputs hostConfig; };
```

- [ ] **Step 5: Reduce host entrypoints to hardware + overrides**

After this step, host files should mostly contain:
- hardware imports
- hardware-specific tweaks
- one role/profile import
- machine-only overrides

- [ ] **Step 6: Build all active systems**

Run:
- `nix build .#nixosConfigurations.desktop.config.system.build.toplevel`
- `nix build .#nixosConfigurations.thinkpad.config.system.build.toplevel`
- `nix build .#nixosConfigurations.kvm.config.system.build.toplevel`
- `nix eval .#nixosConfigurations.parallels-vm.config.networking.hostName`
- `nix eval .#darwinConfigurations.mbp.config.system.primaryUser`

- [ ] **Step 7: Commit**

Run:
- `git add modules hosts`
- `git commit -m "refactor: move host logic into system role profiles"`

- [ ] **Step 8: Review checkpoint**

Stop here and ask the user to review the new role/profile layer before changing overlays.

### Task 5: Convert the Overlay into a Real Reusable Flake Overlay

**Files:**
- Create: `overlays/dnsenum.nix`
- Modify: `overlays/default.nix`
- Modify: any host/profile currently consuming `../../overlays`
- Modify: `flake.nix`

- [ ] **Step 1: Split the actual overlay function out of `overlays/default.nix`**

Create `overlays/dnsenum.nix` with a real overlay shape:

```nix
final: prev: {
  dnsenum = ...
}
```

- [ ] **Step 2: Replace the current module-style overlay wrapper**

Make `overlays/default.nix` either:
- export an attrset of overlay functions, or
- become a tiny compatibility layer if needed

Do not keep the current "module pretending to be an overlay" design.

- [ ] **Step 3: Update consumers**

Replace imports like `../../overlays` in host modules with explicit overlay application in the correct module/profile layer.

The replacement must preserve behavior by applying the exported overlay to `nixpkgs.overlays`, for example in a shared module/profile using:

```nix
nixpkgs.overlays = [ self.overlays.default ];
```

Do not stop at exporting `overlays.default`; make sure the active systems actually consume it after removing the old module-style import.

- [ ] **Step 4: Export the overlay from the flake**

Add a flake output such as:

```nix
overlays.default = import ./overlays/dnsenum.nix;
```

- [ ] **Step 5: Rebuild the host that currently uses the overlay**

Run: `nix build .#nixosConfigurations.kvm.config.system.build.toplevel`

Expected: success with unchanged package behavior.

- [ ] **Step 6: Commit**

Run:
- `git add overlays flake.nix hosts/kvm/default.nix modules`
- `git commit -m "refactor: expose a real reusable flake overlay"`

### Task 6: Optional Phase 2 - Add Useful Flake Checks

**Files:**
- Modify: `flake.nix`

- [ ] **Step 1: Only do this after the redesign is stable**

Skip this task if the core refactor is already large or risky.

- [ ] **Step 2: Add lightweight checks for representative systems**

Add flake `checks` entries that force evaluation or build for:
- `desktop`
- `thinkpad`
- `mbp`

Keep checks focused and useful. Do not make `flake check` unbearably slow.

- [ ] **Step 3: Verify the checks**

Run: `nix flake check`

Expected: success, or a clearly understood failure that you fix before continuing.

- [ ] **Step 4: Commit**

Run:
- `git add flake.nix`
- `git commit -m "refactor: add flake checks for representative hosts"`

### Task 7: Archive or Normalize Inactive Host Artifacts

**Files:**
- Modify or move: `hosts/xps/`
- Modify or remove: `hosts/utm-vm/default.nix`
- Move or remove: `hosts/vm-common/`
- Modify: `flake.nix`
- Modify: `lib/hosts.nix`
- Modify: `docs/architecture.md`

- [ ] **Step 1: Keep the active inventory clean**

Active host inventory should only contain working, supported systems.

- [ ] **Step 2: Archive or remove broken placeholders**

Recommended default:
- archive `xps` to `reference/inactive-hosts/xps/`
- archive `vm-common` to `reference/inactive-hosts/vm-common/`
- remove `utm-vm` from outputs unless fully implemented

- [ ] **Step 3: Update documentation to match the redesigned structure**

Document:
- `lib/hosts.nix`
- constructor helpers
- role-based system profiles
- role-based Home Manager profiles
- flake overlays
- active vs archived hosts

- [ ] **Step 4: Commit**

Run:
- `git add -A flake.nix lib/hosts.nix hosts/xps hosts/vm-common hosts/utm-vm reference/inactive-hosts docs/architecture.md`
- `git commit -m "docs: align architecture docs with the data-driven flake design"`

### Task 8: Full Verification and Final Handoff

**Files:**
- Review: all changed files

- [ ] **Step 1: Run the full active build matrix**

Run:
- `nix build .#nixosConfigurations.desktop.config.system.build.toplevel`
- `nix build .#nixosConfigurations.thinkpad.config.system.build.toplevel`
- `nix build .#nixosConfigurations.kvm.config.system.build.toplevel`
- `nix eval .#nixosConfigurations.parallels-vm.config.networking.hostName`
- `nix eval .#darwinConfigurations.mbp.config.system.primaryUser`

- [ ] **Step 2: If checks were added, run them**

Run: `nix flake check`

- [ ] **Step 3: Review for over-abstraction**

Confirm:
- the inventory is readable
- host entrypoints are smaller than before
- profile modules have clear boundaries
- helpers do real work without hiding important logic

- [ ] **Step 4: Prepare final summary**

Include:
- which new abstraction layers exist
- which old host-specific files became wrappers
- what happened to inactive hosts
- whether overlay exports and flake checks were added
