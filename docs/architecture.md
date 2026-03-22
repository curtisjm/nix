# Nix Configuration Architecture

This repository is a flake-based system and home environment configuration for Linux (NixOS) and macOS (nix-darwin + Home Manager).

## Top-Level Layout

- `flake.nix`: Entry point. Declares all inputs and composes host configurations by filtering the host inventory.
- `lib/hosts.nix`: Unified active host inventory for NixOS and Darwin hosts.
- `lib/mk-nixos-host.nix`: Small constructor for `nixpkgs.lib.nixosSystem` hosts.
- `lib/mk-darwin-host.nix`: Small constructor for `nix-darwin.lib.darwinSystem` hosts.
- `hosts/`: Thin machine entrypoints that mostly handle hardware imports and machine-only overrides.
- `modules/`: Reusable NixOS and Darwin modules, including shared system base/profile layers.
- `home/`: Home Manager profiles split into shared and platform-specific pieces.
- `overlays/`: Package overlays.
- `secrets/`: Secret references and encrypted secret metadata.
- `reference/`: Optional profile/package references and archived host definitions.

## Configuration Flow

1. `lib/hosts.nix` defines the active host inventory with per-host `platform` and `hostConfig` metadata.
2. `flake.nix` filters that inventory into active NixOS and active Darwin hosts, then maps each set through `lib/mk-nixos-host.nix` and `lib/mk-darwin-host.nix`.
3. Inactive or historical host definitions live under `reference/inactive-hosts/` and are not part of flake outputs.
4. Each host in `hosts/` imports one role profile from `modules/nixos/profiles/` or `modules/darwin/profiles/`, then layers in machine-only overrides.
5. Shared system defaults live in `modules/nixos/base.nix` and `modules/darwin/base.nix`.
6. System role profiles own the common module composition and Home Manager wiring for each host class.
7. Home profiles import shared modules from `home/shared/` plus platform-specific files from `home/nixos/` or `home/darwin/`.

This keeps host-level concerns (kernel, services, hardware) separate from user-level concerns (shell, editor, app settings).

## System Profile Structure

- `modules/nixos/base.nix`: Common Linux system defaults driven by `hostConfig` metadata.
- `modules/nixos/profiles/workstation.nix`: Shared desktop/laptop composition for active Linux workstations.
- `modules/nixos/profiles/vm.nix`: Shared VM composition for active Linux guest systems.
- `modules/darwin/base.nix`: Common Darwin metadata wiring for the primary user, Home Manager, nix settings, and host platform.
- `modules/darwin/profiles/default.nix`: Shared Darwin module composition.

This keeps host entrypoints focused on hardware imports, guest-specific boot settings, and machine-only tweaks.

## Inactive Hosts

- Archived host definitions now live under `reference/inactive-hosts/`.
- `xps` and `vm-common` remain there as historical references.
- `utm-vm` was an empty placeholder and is recorded there only as an archived placeholder note.

## Home Manager Structure

- `home/shared/`: Common user tools and app modules used by multiple profiles.
- `home/profiles/base.nix`: Shared Home Manager defaults used across role profiles.
- `home/profiles/linux-workstation.nix`: Shared Home Manager composition for desktop and thinkpad.
- `home/profiles/vm.nix`: Shared Home Manager composition for VM hosts.
- `home/profiles/darwin.nix`: Shared Home Manager composition for macOS.
- `home/desktop/default.nix`: Compatibility wrapper for the Linux workstation profile.
- `home/laptop/default.nix`: Compatibility wrapper for the Linux workstation profile (used by thinkpad host).
- `home/darwin/default.nix`: macOS Home Manager wrapper.
- `home/vm/default.nix`: Compatibility wrapper for the VM Home Manager profile.

Role-based profiles now read `hostConfig.username` and `hostConfig.homeDirectory` directly instead of hardcoding user paths in each host.

Shared modules are imported explicitly per profile to keep behavior easy to reason about.

## Overlay Structure

- `overlays/dnsenum.nix`: Real flake overlay function for the `dnsenum` package fixup.
- `overlays/default.nix`: Overlay export attrset used by `flake.nix`.

Modules that need an overlayed package apply `self.overlays.default` explicitly instead of importing `overlays/` as a NixOS module.

## Claude Code and Superpowers

Claude Code configuration now lives in:

- `home/shared/claude-code.nix`

This module enables `programs.claude-code` and configures Superpowers declaratively through Claude plugin settings:

- Adds the marketplace source `obra/superpowers-marketplace`.
- Enables plugin `superpowers@superpowers-marketplace`.

The module is imported by:

- `home/desktop/default.nix`
- `home/laptop/default.nix`
- `home/darwin/default.nix`

Result: desktop, thinkpad (via laptop profile), and darwin all receive the same Claude Code + Superpowers setup from one shared file.

## Codex and Superpowers

Codex configuration now lives in:

- `home/shared/codex.nix`

This module enables `programs.codex`, turns on Codex multi-agent support, and wires Superpowers skills declaratively:

- `features.multi_agent = true`
- `skills.superpowers = inputs.superpowers + "/skills"`

The module is imported by:

- `home/desktop/default.nix`
- `home/laptop/default.nix`
- `home/darwin/default.nix`

Result: desktop, thinkpad (via laptop profile), and darwin get Codex with the Superpowers skillset via Home Manager.

## Tailscale Configuration

- Linux hosts use `modules/nixos/tailscale.nix`.
- Darwin hosts use `modules/darwin/tailscale.nix`.

This split keeps platform-specific options isolated while preserving common behavior:

- NixOS applies `--shields-up` with `services.tailscale.extraSetFlags`.
- Darwin enables `services.tailscale` and applies `tailscale set --shields-up` during activation.

## Why This Shape

- Shared behavior is centralized in `home/shared/` to avoid duplication.
- Host-specific behavior remains isolated under `hosts/` and `modules/`.
- Profile wiring is explicit, so enabling/disabling a capability is a one-line import change per profile.
