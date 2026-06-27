# ─────────────────────────────────────────────
# TMUX AUTO-START
# ─────────────────────────────────────────────
if command -v tmux &>/dev/null && [[ -z "$TMUX" && -t 0 ]]; then
  tmux new-session -A -s main
fi

# ─────────────────────────────────────────────
# ZINIT BOOTSTRAP
# ─────────────────────────────────────────────
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [[ ! -f "$ZINIT_HOME/zinit.zsh" ]]; then
  print -P "%F{33}▒ %F{220}Installing zinit…%f"
  command mkdir -p "$(dirname $ZINIT_HOME)"
  command git clone https://github.com/zdharma-continuum/zinit "$ZINIT_HOME" && \
    print -P "%F{34}✔ %F{220}Done.%f" || \
    print -P "%F{160}✘ Clone failed.%f"
fi

source "$ZINIT_HOME/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit


# ─────────────────────────────────────────────
# PROMPT — Starship (fast, async, beautiful)
# ─────────────────────────────────────────────
# Install starship if missing: curl -sS https://starship.rs/install.sh | sh
if command -v starship &>/dev/null; then
  eval "$(starship init zsh)"
fi


# ─────────────────────────────────────────────
# CORE PLUGINS
# ─────────────────────────────────────────────

# Syntax highlighting — must be near the top
zinit ice wait lucid atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay"
zinit light zdharma-continuum/fast-syntax-highlighting

# Autosuggestions (fish-like)
zinit ice wait lucid atload"_zsh_autosuggest_start"
zinit light zsh-users/zsh-autosuggestions

# Completions
zinit ice wait lucid blockf
zinit light zsh-users/zsh-completions

# History substring search (↑/↓ to search history by typed prefix)
zinit ice wait lucid
zinit light zsh-users/zsh-history-substring-search

# fzf — fuzzy finder (Ctrl+R history, Ctrl+T files, Alt+C dirs)
zinit ice wait lucid
zinit light Aloxaf/fzf-tab                  # replace zsh tab-complete with fzf

# fzf — pinned binary + shell integration loaded SYNCHRONOUSLY so binary+scripts match before key-bindings load.
# (apt fzf is too old for current key-bindings.zsh — async load races with binary install.)
zinit ice from"gh-r" as"program" mv"fzf -> fzf" pick"fzf" \
  multisrc"shell/{key-bindings,completion}.zsh"
zinit light junegunn/fzf

# Ubuntu/Debian renames fd → fdfind. Pick whichever exists.
if command -v fd >/dev/null 2>&1; then
  _FD=fd
elif command -v fdfind >/dev/null 2>&1; then
  _FD=fdfind
  alias fd=fdfind
fi

# z — jump to frecent directories (like autojump/zoxide but pure shell)
zinit ice wait lucid
zinit light agkozak/zsh-z

# autopair — auto-close brackets, quotes, etc.
zinit ice wait lucid
zinit light hlissner/zsh-autopair

# colored man pages
# zinit ice wait lucid
# zinit light zsh-users/zsh-manpage-completion

# git extras (gst, gco, glog aliases etc.)
zinit ice wait lucid
zinit snippet OMZP::git

# command-not-found handler
zinit ice wait lucid
zinit snippet OMZP::command-not-found


# ─────────────────────────────────────────────
# COMPLETIONS SETUP
# ─────────────────────────────────────────────
autoload -Uz compinit
compinit -C

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'   # case-insensitive
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'


# ─────────────────────────────────────────────
# HISTORY
# ─────────────────────────────────────────────
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_ALL_DUPS   # no duplicate entries
setopt HIST_IGNORE_SPACE      # commands starting with space are not saved
setopt SHARE_HISTORY          # share history across sessions
setopt HIST_REDUCE_BLANKS


# ─────────────────────────────────────────────
# CURSOR — beam (line) cursor in tmux + Ghostty
# ─────────────────────────────────────────────
_set_beam_cursor() { printf '\e[6 q' }
precmd_functions+=(_set_beam_cursor)

# ─────────────────────────────────────────────
# KEY BINDINGS
# ─────────────────────────────────────────────
bindkey '^[[1;5C' forward-word                # Ctrl+→ forward word
bindkey '^[[1;5D' backward-word               # Ctrl+← backward word
bindkey '^H' backward-kill-word               # Ctrl+Backspace delete word


# ─────────────────────────────────────────────
# FZF SETTINGS
# ─────────────────────────────────────────────
export FZF_DEFAULT_COMMAND="${_FD:-fd} --type f --hidden --follow --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="${_FD:-fd} --type d --hidden --follow --exclude .git"
export FZF_DEFAULT_OPTS="
  --height=40%
  --layout=reverse
  --border=rounded
  --info=inline
  --preview-window=right:55%:wrap
  --color=bg+:#1e1e2e,bg:#181825,spinner:#f5c2e7,hl:#f38ba8
  --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5c2e7
  --color=marker:#f5c2e7,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8
"


# ─────────────────────────────────────────────
# AUTOSUGGESTION SETTINGS
# ─────────────────────────────────────────────
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#6c7086,underline"
ZSH_AUTOSUGGEST_USE_ASYNC=1


# ─────────────────────────────────────────────
# GENERAL ZSH OPTIONS
# ─────────────────────────────────────────────
setopt AUTO_CD              # type a dir name to cd into it
setopt CORRECT              # suggest corrections for typos
setopt EXTENDED_GLOB        # extended glob patterns
setopt NO_BEEP              # silence
setopt INTERACTIVE_COMMENTS # allow # comments in interactive shell
setopt PROMPT_SUBST


# ─────────────────────────────────────────────
# ENVIRONMENT
# ─────────────────────────────────────────────
export EDITOR='nvim'
export VISUAL='nvim'
export PAGER='less'
export LESS='-R --use-color'
export MANPAGER='less -R --use-color -Dd+r -Du+b'
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"
# Machine-local secrets (API keys, tokens) live in ~/.zshrc.local — gitignored.
# See examples/zshrc.local for the template.


# ─────────────────────────────────────────────
# ALIASES — General
# ─────────────────────────────────────────────
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'

alias ls='ls --color=auto -F'
alias la='ls -lAh --color=auto'
alias ll='ls -lh --color=auto'
alias lt='ls --color=auto -lhtr'   # sort by time, newest last

alias grep='grep --color=auto'
alias diff='diff --color=auto'
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -Iv'                  # interactive + verbose, NOT --no-preserve-root
alias mkdir='mkdir -pv'

alias c=clear
alias v='nvim'

alias reload='source ~/.zshrc && echo "✔ .zshrc reloaded"'
alias zshrc='$EDITOR ~/.zshrc'

# ─────────────────────────────────────────────
# ALIASES — Git shortcuts (beyond OMZP::git)
# ─────────────────────────────────────────────
alias g='git'
alias gs='git status -sb'
alias ga='git add'
alias gc='git commit -m'
alias gca='git commit --amend --no-edit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate --all'
alias gd='git diff'
alias gds='git diff --staged'

# ─────────────────────────────────────────────
# ALIASES — Docker / misc
# ─────────────────────────────────────────────
alias dk='docker'
alias dkc='docker compose'
alias dkps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'


# ─────────────────────────────────────────────
# FUNCTIONS
# ─────────────────────────────────────────────

# mkcd — make dir and cd into it
mkcd() { mkdir -p "$1" && cd "$1" }

# fcd — fzf cd into any subdirectory
fcd() {
  local dir
  dir=$(fd --type d --hidden --follow --exclude .git 2>/dev/null | fzf +m) && cd "$dir"
}

# fkill — fuzzy kill process(es). One process per line, multi-select with Tab
fkill() {
  local sig=${1:-9}
  local cols=$(tput cols 2>/dev/null || echo 120)
  local selected
  selected=$(
    ps -eo pid=,user=,%cpu=,%mem=,command= \
      | awk -v w=$cols '{
          pid=$1; user=$2; cpu=$3; mem=$4;
          $1=$2=$3=$4="";
          sub(/^[ \t]+/, "");
          cmd=$0;
          gsub(/[\r\n]/, " ", cmd);
          maxcmd = w - 36;
          if (maxcmd < 20) maxcmd = 20;
          if (length(cmd) > maxcmd) cmd = "…" substr(cmd, length(cmd) - maxcmd + 2);
          printf "%-7s %-10s %5s %5s  %s\n", pid, user, cpu, mem, cmd
        }' \
      | fzf -m --height=50% --layout=reverse \
            --header="PID     USER       CPU%  MEM%  COMMAND    (Tab: multi-select, Enter: kill)"
  ) || { echo "✗ cancelled"; return 1; }

  [[ -z "$selected" ]] && { echo "✗ nothing selected"; return 1; }

  local count=$(echo "$selected" | wc -l | tr -d ' ')
  local pids=$(echo "$selected" | awk '{print $1}')

  if echo "$pids" | xargs kill -$sig 2>/dev/null; then
    local s="process"
    [[ $count -gt 1 ]] && s="processes"
    echo "✔ killed $count $s (signal $sig)"
  else
    echo "✗ failed to kill some processes"
    return 1
  fi
}

# Ctrl+K — fuzzy kill process widget
_fkill_widget() {
  BUFFER=""
  zle reset-prompt
  fkill
  zle reset-prompt
}
zle -N _fkill_widget
bindkey '^K' _fkill_widget

# extract — universal archive extractor
extract() {
  case "$1" in
    *.tar.bz2) tar xjf "$1" ;;
    *.tar.gz)  tar xzf "$1" ;;
    *.tar.xz)  tar xJf "$1" ;;
    *.tar)     tar xf  "$1" ;;
    *.zip)     unzip   "$1" ;;
    *.gz)      gunzip  "$1" ;;
    *.bz2)     bunzip2 "$1" ;;
    *.rar)     unrar x "$1" ;;
    *.7z)      7z x    "$1" ;;
    *)         echo "Unknown format: $1" ;;
  esac
}

# up N — go up N directories
up() { local p; for i in $(seq 1 "${1:-1}"); do p+="../"; done; cd "$p" }

eval "$(starship init zsh)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# ─────────────────────────────────────────────
# LOCAL OVERLAY (machine-specific, untracked)
# ─────────────────────────────────────────────
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"
