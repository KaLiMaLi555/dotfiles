# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

eval "$(/opt/homebrew/bin/brew shellenv)"

# Set directory for zinit
ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"

# Download zinit if not downloaded
if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source zinit
source "$ZINIT_HOME/zinit.zsh"

# Prompt plugin
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Add in plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Add zinit snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::command-not-found


# Load completions
autoload -U compinit && compinit

zinit cdreplay -q

# Completion Styling
# zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Keybinding
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# History
HISTSIZE=10000
HISTFILE=$HOME/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt share_history
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Aliases
alias c=clear
alias rm='rm -rf'
alias v=nvim
alias ca='conda activate'
alias cod='conda deactivate'
alias tn='tmux new -s'
alias ta='tmux a -t'
# alias astart='aws ec2 start-instances --instance-ids i-0508eeae076668d8f'
# alias astop='aws ec2 stop-instances --instance-ids i-0508eeae076668d8f'
# alias token_aws='./scripts/aws-token.sh kirtan default'
# alias ip_aws='./scripts/aws-ip.sh'

alias ls='ls --color'

# alias ls='eza --color=always --long --icons=always --git --no-filesize --no-time --no-user --no-permissions'
# alias lt='eza -l --tree --level=3 --color=always --long --icons=always --git --no-filesize --no-time --no-user --no-permissions'
# alias cd="z"
#
# cx() { cd "$@" && l; }

# Shell integretions
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"