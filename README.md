# Dotfiles

Personal app configurations for vanilla Arch Linux.

Basic configs without any window manager or desktop environment dependencies.

## Setup

### 1. Clone repository
```bash
rad clone rad:z3meM3mj7gA1wXNjs95LqVWhArXuT dotfiles
cd dotfiles
```

### 2. Install packages
```bash
sudo pacman -S --needed - < packages/pacman.list
paru -S --needed - < packages/aur.list
```

### 3. Install configurations
```bash
./install.sh
```

## Structure

```
dotfiles/
├── .config/
│   ├── nvim/         # Neovim
│   ├── nushell/      # Nushell shell
│   ├── starship.toml # Starship prompt
│   ├── ghostty/      # Terminal
│   ├── mpd/          # Music player
│   ├── mpd-discord-rpc/
│   ├── atuin/        # Shell history
│   ├── fastfetch/    # System info
│   ├── git/          # Git config
│   └── tmux/         # Terminal multiplexer
├── .local/bin/       # Custom scripts
├── packages/         # Package lists
└── README.md
```

## Features

- **Editor**: Neovim (custom config)
- **Shell**: Nushell + Starship prompt
- **Terminal**: Ghostty
- **Music**: MPD + Discord RPC
- **History**: Atuin
- **Multiplexer**: Tmux

## Usage

These configs work independently of any window manager.
Use with your preferred WM/DE (Hyprland, Sway, i3, etc.).

## Pushing Changes

```bash
cd ~/dotfiles
git add .
git commit -m "Update"
git push
rad sync
```

## License

MIT
