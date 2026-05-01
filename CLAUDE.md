# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A NixOS flake-based configuration managing two hosts and a standalone home-manager setup. Pinned to nixpkgs 25.11 / home-manager release-25.11.

## Architecture

- **flake.nix** — Defines three outputs:
  - `nixosConfigurations.radish` and `nixosConfigurations.onion` (system configs)
  - `homeConfigurations.leo` (standalone home-manager, not a NixOS module)
- **common/default.nix** — Shared system config imported by both hosts (bootloader, networking, tailscale, locale, user account, niri desktop, nix-ld)
- **hosts/{radish,onion}/configuration.nix** — Host-specific config (hostname, LUKS, hardware). Each imports `../../common` and its own `hardware-configuration.nix`.
- **home.nix** — User-level packages and dotfiles via home-manager (git, bash aliases, user packages)

System config and home-manager are applied separately — they are not wired together as a NixOS module.

## Common Commands

```bash
# Rebuild system config (requires sudo) — substitute hostname as needed
sudo nixos-rebuild switch --flake ~/nixos#radish

# Rebuild home-manager config
home-manager switch --flake ~/nixos#leo

# Both at once (defined as the `rebuild` shell alias on radish)
rebuild

# Update flake inputs
nix flake update

# Check flake evaluates without errors
nix flake check
```

## Neovim / Notes System

Neovim is configured via `programs.nixvim` in `home/programs/nvim.nix`. It uses nixvim (flaked in via nix-community input). Custom Lua modules live in `home/programs/lua/notes/` and are injected via `extraFiles`.

### Lua modules
- **`notes/init.lua`** — Core engine. Manages `~/notes` directory. Parses markdown into blocks: journals (split on `[[header]]` lines) and pages (one block per file). Extracts `[[wikilinks]]` and `#tags`. Maintains a dirty-checked cache rebuilt on `BufWritePost`.
- **`notes/pickers.lua`** — FZF-lua pickers: wikilinks (`<leader>nl`), tags (`<leader>nt`), all blocks (`<leader>nf`), backlinks (`<leader>nb`). Blocks show as `relpath:line:col:[header] snippet`.
- **`notes/source.lua`** — Custom blink-cmp completion source for `[[wikilinks]]` and `#tags`. Supports nested path segments (e.g. `folder/sub`). Registered as "notes" provider with high score_offset.

### Notes directory structure
```
~/notes/
  journals/YYYY_MM_DD.md   — daily journal, `[[blocks]]` split sections
  pages/**/*.md             — standalone pages, one block per file, path = name
```

### Key plugins
- **nixvim** — declarative nvim config
- **blink-cmp** — completion with super-tab preset + custom notes source
- **fzf-lua** — file/block picker
- **marksman** LSP — markdown intelligence (gd/gr on wikilinks)
- **treesitter** — syntax highlighting

### Keybindings
- `<leader>jj` — open today's journal
- `<leader>nl` / `nt` / `nf` / `nb` — wikilinks / tags / blocks / backlinks pickers
- `<leader>ff` / `fg` / `fb` / `fr` — fzf files / grep / buffers / oldfiles

## Key Details

- Unfree packages are allowed in both nixpkgs contexts (system and home-manager).
- `onion` host is partially set up — its `hardware-configuration.nix` and LUKS config still need to be copied from the actual machine (see TODOs in `hosts/onion/configuration.nix`).
- The `rebuild` alias hardcodes `#radish`; it won't work on onion without modification.
