# Nix Configuration Architecture

This repository is a flake-based system and home environment configuration for Linux (NixOS) and macOS (nix-darwin + Home Manager).

## Top-Level Layout

- `flake.nix`: Entry point. Declares all inputs and composes host configurations.
- `hosts/`: Machine-specific operating system definitions.
- `modules/`: Reusable NixOS and Darwin modules.
- `home/`: Home Manager profiles split into shared and platform-specific pieces.
- `overlays/`: Package overlays.
- `secrets/`: Secret references and encrypted secret metadata.
- `reference/`: Optional profile/package references.

## Configuration Flow

1. `flake.nix` defines `nixosConfigurations` and `darwinConfigurations`.
2. Each host in `hosts/` imports system modules from `modules/`.
3. Each host also enables Home Manager and selects one profile under `home/`.
4. Home profiles import shared modules from `home/shared/` plus platform-specific files from `home/nixos/` or `home/darwin/`.

This keeps host-level concerns (kernel, services, hardware) separate from user-level concerns (shell, editor, app settings).

## Home Manager Structure

- `home/shared/`: Common user tools and app modules used by multiple profiles.
- `home/desktop/default.nix`: Desktop Linux Home Manager profile.
- `home/laptop/default.nix`: Laptop Linux Home Manager profile (used by thinkpad host).
- `home/darwin/default.nix`: macOS Home Manager profile.
- `home/vm/default.nix`: VM-oriented Linux Home Manager profile.

Shared modules are imported explicitly per profile to keep behavior easy to reason about.

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

## Why This Shape

- Shared behavior is centralized in `home/shared/` to avoid duplication.
- Host-specific behavior remains isolated under `hosts/` and `modules/`.
- Profile wiring is explicit, so enabling/disabling a capability is a one-line import change per profile.
