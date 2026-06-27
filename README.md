# dotfiles

Single-repo, stow-based dotfiles for macOS and Linux. One command installs everything.

## Install

**Mac (personal):**
```bash
git clone https://github.com/KaLiMaLi555/dotfiles ~/dotfiles
~/dotfiles/install.sh --profile=mac-personal
```

**Remote Linux VM (Ubuntu/Debian):**
```bash
git clone https://github.com/KaLiMaLi555/dotfiles ~/dotfiles
~/dotfiles/install.sh --profile=remote-vm
```

Idempotent. Re-running is safe. Use `DRY_RUN=1 ./install.sh` to preview.

## What it links

| Tool | Profile(s) | Notes |
|---|---|---|
| zsh + zinit + starship + fzf | all | shell + prompt |
| tmux (modular) | all | mac gets `dev.conf` rendered from template; vm gets `vm.conf` |
| nvim | all | vendored from `stow/nvim/` |
| git | all | identity in `~/.gitconfig.local` (untracked) |
| btop | all | system monitor |
| aerospace | mac-* | tiling window manager |
| ghostty | mac-* | terminal |

## Profiles

```
profiles/
├── base.inc             # zsh tmux starship git nvim btop
├── mac-personal/        # adds aerospace ghostty; WORK_DIR=~/work/galleri5
├── mac-work/            # adds aerospace ghostty; WORK_DIR=~/work
└── remote-vm/           # base only; WORK_DIR=~/work
```

To add a profile: `mkdir profiles/new-role && echo '@include base.inc' > profiles/new-role/tools.txt`.

## Local overlay (machine-specific secrets)

This repo never contains secrets. Two files are sourced/included if present:

- `~/.zshrc.local` — API keys, host PATH, work aliases
- `~/.gitconfig.local` — git `[user]` block, signing key

Templates live in `examples/`. Copy and fill in:

```bash
cp ~/dotfiles/examples/zshrc.local ~/.zshrc.local && chmod 600 ~/.zshrc.local
cp ~/dotfiles/examples/gitconfig.local ~/.gitconfig.local
```

## Daily workflow

Editing `~/.zshrc` IS editing the tracked file (it's a symlink into `stow/zsh/.zshrc`).

```bash
vim ~/.zshrc                    # change anything
cd ~/dotfiles && git diff       # review
git commit -am 'zsh: add ...' && git push
# on the other machine:
cd ~/dotfiles && git pull && ./install.sh
```

Add a new tool:

```bash
mkdir -p ~/dotfiles/stow/<tool>/.config/<tool>
cp ~/.config/<tool>/* ~/dotfiles/stow/<tool>/.config/<tool>/
echo "<tool>" >> ~/dotfiles/profiles/mac-personal/tools.txt
~/dotfiles/install.sh --only=<tool>
```

## Uninstall

```bash
~/dotfiles/uninstall.sh
```

Unlinks every package and restores the latest backup from `.backup/`.

## Repo layout

```
~/dotfiles/
├── install.sh                          # bootstrap
├── uninstall.sh                        # unlink + restore
├── Brewfile / Brewfile.cask            # macOS packages
├── packages/apt.txt                    # Ubuntu packages
├── profiles/<role>/{tools.txt,env}     # which packages link, what WORK_DIR is
├── lib/*.sh                            # log, detect, run, link, render, ensure-local
├── os/{macos,linux,common}/install.sh  # per-OS dep install
├── stow/<tool>/...                     # one stow package per tool
├── templates/*.tmpl                    # rendered into stow/ at install time
└── examples/                           # templates for ~/.zshrc.local etc.
```
