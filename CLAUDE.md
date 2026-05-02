# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A NixOS flake-based configuration managing two hosts (`radish`, `onion`) and standalone home-manager configs. Tracks `nixos-unstable`; `stateVersion` is set to `25.11`.

## Architecture

- **flake.nix** — Defines outputs:
  - `nixosConfigurations.{radish,onion}` — system configs
  - `homeConfigurations.{leo,leo-radish,leo-onion}` — standalone home-manager (not wired as NixOS module). `leo` is the base; `leo-radish` / `leo-onion` layer in host-specific home tweaks from `hosts/{host}/home.nix`.
- **common/default.nix** — Shared system config imported by both hosts: bootloader, networking, tailscale, locale, user account (`leo`), niri desktop, nix-ld, CachyOS kernel (BORE scheduler, zen4 LTO).
- **hosts/{radish,onion}/configuration.nix** — Host-specific system config (hostname, LUKS, hardware). `onion` overrides to stock kernel temporarily and adds Nvidia drivers.
- **home/default.nix** — Home-manager entry point; imports all `home/programs/*.nix` modules.

System config and home-manager are applied separately — they are not wired together as a NixOS module.

## Common Commands

```bash
# Rebuild system + home (the `rebuild` fish alias — works on any host via $(hostname))
rebuild
# expands to:
sudo nixos-rebuild switch --flake ~/nixos#(hostname) && home-manager switch --flake ~/nixos#leo-(hostname)

# System only
sudo nixos-rebuild switch --flake ~/nixos#radish

# Home-manager only
home-manager switch --flake ~/nixos#leo-radish   # or leo-onion / leo

# Update flake inputs
nix flake update

# Check flake evaluates without errors
nix flake check
```

## Home Config Layout

`home/default.nix` imports all modules. Host-specific home overrides go in `hosts/{host}/home.nix` (e.g., `radish/home.nix` sets a larger terminal font). Each module uses standard home-manager `programs.*` options.

## Secrets

Secrets are encrypted with `age`. The key lives at `~/.config/age/key.txt`; the recipient public key is in `secrets/recipients.txt`. Currently one secret: `secrets/glm.age` (GLM API key). The `zcode` fish function (defined in `home/secret-wrappers.nix`) decrypts it at runtime to invoke Claude Code against the GLM endpoint.

## Neovim / Notes System

Neovim is configured via `programs.nixvim` in `home/programs/nvim.nix` (nixvim from `nix-community` input). Custom Lua modules live in `home/programs/lua/notes/` and are injected via `extraFiles`.

### Lua modules
- **`notes/init.lua`** — Core engine. Manages `~/notes`. Parses markdown into blocks: journals (split on `[[header]]` lines) and pages (one block per file). Extracts `[[wikilinks]]` and `#tags`. Dirty-checked cache rebuilt on `BufWritePost`.
- **`notes/pickers.lua`** — FZF-lua pickers: wikilinks (`<leader>nl`), tags (`<leader>nt`), all blocks (`<leader>nf`), backlinks (`<leader>nb`).
- **`notes/source.lua`** — Custom blink-cmp completion source for `[[wikilinks]]` and `#tags`. Registered as "notes" provider with high score_offset.

### Notes directory structure
```
~/notes/
  journals/YYYY_MM_DD.md   — daily journal, [[blocks]] split sections
  pages/**/*.md             — standalone pages, one block per file
```

### Key plugins
- **blink-cmp** — completion with super-tab preset + custom notes source
- **fzf-lua** — file/block picker
- **marksman** LSP — markdown (gd/gr on wikilinks)
- **treesitter** — syntax highlighting

### Keybindings
- `<leader>jj` — open today's journal
- `<leader>nl` / `nt` / `nf` / `nb` — wikilinks / tags / blocks / backlinks pickers
- `<leader>ff` / `fg` / `fb` / `fr` — fzf files / grep / buffers / oldfiles

## Key Details

- Unfree packages are allowed in both nixpkgs contexts.
- `onion` uses stock kernel (`linuxPackages_latest`) with `lib.mkForce` to override the CachyOS kernel from `common`; switch to CachyOS once initial setup is stable.
- The CachyOS kernel binary cache (`attic.xuyh0120.win/lantian`) is configured in `common/default.nix` — required to avoid building the kernel from source.
