# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


### Core environment -----------------------------------------------------------
# Environment variables now handled in .zshenv

# Apple Silicon Homebrew (handled in .zshenv now)

### Shell options --------------------------------------------------------------
setopt AUTO_CD                 # `cd` by thinking about it
setopt AUTO_PUSHD PUSHD_SILENT PUSHD_TO_HOME
setopt EXTENDED_GLOB           # because we're adults
setopt GLOB_DOTS               # dotfiles too
setopt HIST_IGNORE_DUPS HIST_IGNORE_SPACE SHARE_HISTORY INC_APPEND_HISTORY
setopt AUTOCONTINUE            # ^C shouldn't nuke the shell state
setopt PIPE_FAIL               # fail pipelines loudly

# History: large, useful, not creepy
export HISTFILE="$ZDOTDIR/.zsh_history"
export HISTSIZE=200000
export SAVEHIST=200000

# Security: Prevent credential leakage in history
# Commands matching these patterns will not be saved to history
HISTORY_IGNORE="(security *|*API_KEY*|*api_key*|*TOKEN*|*token=*|*PASSWORD*|*password=*)"

### Oh My Zsh (feature, not a lifestyle) --------------------------------------
export ZSH="$HOME/.oh-my-zsh"
# ZSH_THEME="agnoster"           # readable, informative; switch to powerlevel10k if you care
ZSH_THEME="powerlevel10k/powerlevel10k"
# ZSH_THEME="robbyrussell"        # Simple, no special fonts needed
# ZSH_THEME="bira"               # Clean alternative
# ZSH_THEME="refined"            # Minimal and elegant
CASE_SENSITIVE="true"
DISABLE_UPDATE_PROMPT="true"
DISABLE_AUTO_UPDATE="true"     # updates on *my* schedule

# Plugins chosen for speed and utility, not Pokémon collecting
plugins=(
  git                       # dense alias set
  z                         # frecency cd (lightweight)
  fzf                       # fuzzy everything (if installed)
  brew                      # completions/aliases on macOS
  python                    # py helpers (we'll override with uv)
  history-substring-search  # ↑/↓ through matches
  direnv                    # project envs without regrets
  macos                     # pbcopy/pbpaste helpers etc.
)

source "$ZSH/oh-my-zsh.sh"
# Powerlevel10k is loaded via ZSH_THEME above - no need to source again

### Extras (installed-or-not safe) --------------------------------------------
# Syntax highlighting & autosuggestions — installed via brew usually
[[ -r /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] \
  && source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
[[ -r /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]] \
  && source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# fzf sane defaults: ripgrep for source, preview with bat if available
if command -v fzf >/dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git"'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  if command -v bat >/dev/null 2>&1; then
    export FZF_PREVIEW_COMMAND='bat --style=numbers --color=always --line-range :500 {}'
  fi
fi

# zoxide is nicer than `z`; use it if present (keeps `z` alias for muscle memory)
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
  alias z='zoxide query -i'
fi

# direnv — project-local envs, but controlled
if command -v direnv >/dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi

### Python, uv, marimo, notebooks ---------------------------------------------
# uv is the grown-up here - modern Python package/project manager
# NOTE: These aliases work best in uv-managed projects (with pyproject.toml)
# For system Python or other virtual envs, you may need to temporarily unalias
if command -v uv >/dev/null 2>&1; then
  alias pip="uv pip"                    # use uv's faster pip implementation
  alias ipython="uv run ipython"        # run ipython in current project context
  alias python="uv run python"          # run python with project dependencies
  alias pytest="uv run pytest"          # run tests with project context
  alias jupyter="uv run jupyter"        # run jupyter with project deps
fi

# Fast project bootstrap
mkpy() {
  # mkpy myproj -> create venv (uv) + scaffold
  [[ -z "$1" ]] && { echo "mkpy <n>"; return 2; }
  mkdir -p "$1" && cd "$1" || return
  uv init --quiet
  uv add --dev ruff pytest
  cat > pyproject.toml <<'PY'
[tool.ruff]
line-length = 100
target-version = "py311"
PY
  git init -q && echo ".venv/\n.pytest_cache/\n__pycache__/" > .gitignore
  echo "✅ Python project ready with uv."
}

### Git: aliases + emoji commits (because you like neat logs) ------------------
alias g='git'
alias gst='git status -sb'
alias gl='git --no-pager log --oneline --graph --decorate -n 20'
alias gco='git checkout'
alias ga='git add'
alias gc='git commit'
alias gca='git commit -a'
alias gp='git push'
alias gpf='git push --force-with-lease'
alias grhh='git reset --hard HEAD'
alias gsw='git switch'

# Gitmoji quick commit: gcmj ":sparkles: add feature" -> prompts if message omitted
gcmj() {
  local msg="$*"
  if [[ -z "$msg" ]]; then
    echo "Pick a gitmoji, then type message. Examples:"
    printf "  ✨  :sparkles:\n  🐛  :bug:\n  ♻️  :recycle:\n  🧪  :test_tube:\n  📝  :memo:\n"
    read -r "?message: " msg
  fi
  git commit -m "$msg"
}

### Just, make, task runners ---------------------------------------------------
alias j='just'                 # because you will
alias js='just --list'         # show recipes, don't execute surprises

### Files & search (modern coreutils, if present) ------------------------------
# Using eza (modern ls), bat (syntax-highlighted cat), ripgrep, fd
# These aliases align with CLAUDE.md tool preferences
if command -v eza >/dev/null 2>&1; then
  alias ls='eza -lF --git --group-directories-first'  # Combined best features
  alias ll='eza -lah --git'
  alias tree='eza --tree'
else
  alias ls='ls -GFh'
  alias ll='ls -lah'
fi
command -v bat >/dev/null 2>&1 && alias cat='bat' || true
command -v rg >/dev/null 2>&1 && alias grep='rg' || true
command -v fd >/dev/null 2>&1 && alias find='fd' || true

### Mac niceties ---------------------------------------------------------------
cdf() { cd "$(osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)')" 2>/dev/null || echo "Finder not cooperating."; }
alias o='open'                 # open files/apps
alias of='open -a Finder .'

### NVM (Node Version Manager) -----------------------------------------------
# Load NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Auto-use node version from .nvmrc when cd-ing into directories
autoload -U add-zsh-hook
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc

### Enhanced tmux functions ###
# Smart tmux session creation/attachment
t() {
  if [[ -z "$1" ]]; then
    # No args: show sessions or create 'main'
    if tmux list-sessions >/dev/null 2>&1; then
      tmux list-sessions
      echo "\nUse: t <session-name> to attach"
    else
      tmux new-session -d -s main && tmux attach -t main
    fi
  else
    # Attach to session or create if doesn't exist
    tmux attach -t "$1" 2>/dev/null || tmux new-session -d -s "$1" && tmux attach -t "$1"
  fi
}

# Quick project session
tproj() {
  local proj_name=${1:-$(basename $PWD)}
  local session_name="proj-$proj_name"
  
  if ! tmux has-session -t "$session_name" 2>/dev/null; then
    tmux new-session -d -s "$session_name" -c "$PWD"
    tmux new-window -t "$session_name" -n "editor" -c "$PWD"
    tmux new-window -t "$session_name" -n "tests" -c "$PWD"
    tmux select-window -t "$session_name:1"
  fi
  tmux attach -t "$session_name"
}

# Kill all tmux sessions except current
tkillall() {
  local current=$(tmux display-message -p '#S' 2>/dev/null)
  tmux list-sessions -F '#S' | while read session; do
    [[ "$session" != "$current" ]] && tmux kill-session -t "$session"
  done
}

# Better tmux aliases
alias tls='tmux list-sessions'
alias ta='tmux attach -t'
alias tn='tmux new-session -s'
alias tk='tmux kill-session -t'
alias tcc='tmux -CC attach -t main 2>/dev/null || tmux -CC new -s main'

### Claude Code workflow (context-aware sessions) -------------------------------
# Context-aware Claude Code launcher - ensures correct CLAUDE.md is loaded
alias cl='~/devvyn-meta-project/scripts/claude-launcher.sh'

# Quick shortcuts for specific contexts
alias clmeta='cd ~/devvyn-meta-project && claude'  # Meta-project / coordination work
alias clproj='~/devvyn-meta-project/scripts/claude-launcher.sh --project-select'  # Select project

# Bridge operations (no Claude Code session needed)
# coord is globally installed via: uv tool install -e ~/devvyn-meta-project
alias bridge='coord'                      # coord CLI shortcut
alias inbox='coord inbox code'            # Check bridge inbox
alias bridgecheck='~/devvyn-meta-project/scripts/claude-launcher.sh --check'  # Quick bridge status

### Prompt tweaks (agnoster) ---------------------------------------------------
# Keep it informative but not a Times Square billboard
export DEFAULT_USER="$USER"    # don't paint username if local
export VIRTUAL_ENV_DISABLE_PROMPT=1

### Key bindings ---------------------------------------------------------------
# Enable vim mode
bindkey -v

# Keep useful emacs bindings in vim mode
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
bindkey '^R' history-incremental-search-backward

# History search with vim mode
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# Better vim mode indicators (optional - shows mode in right prompt)
function zle-line-init zle-keymap-select {
    VIM_PROMPT="%{$fg_bold[yellow]%} [% NORMAL]%  %{$reset_color%}"
    RPS1="${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/}"
    zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

### Local overrides ------------------------------------------------------------
# Put machine- or secret-specific stuff here; not checked into dotfiles.
[[ -r "$ZDOTDIR/.zshrc.local" ]] && source "$ZDOTDIR/.zshrc.local"

# End. If this ever gets slow, it's because you started enabling cute plugins again.
#source /opt/homebrew/share/zsh/site-functions

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Fun terminal greeting - random ASCII art on startup
[[ -f ~/.terminal-greeting.sh ]] && source ~/.terminal-greeting.sh

# ~/.zshrc — Claude Code Auto-Launch
# ============================================
# Chat Agent approved design (2025-12-01)
# Supports: env var bypass, keypress escape, SSH detection, tmux inheritance

_claude_shell_init() {
  # Skip if already checked this session
  [[ -n "$CLAUDE_SHELL_CHECKED" ]] && return
  export CLAUDE_SHELL_CHECKED=1

  # Skip if explicitly disabled
  [[ "$CLAUDE_SHELL" == "0" ]] && { export SHELL_MODE=human; return; }

  # Skip if not interactive TTY
  [[ ! -t 0 || ! -t 1 || $- != *i* ]] && { export SHELL_MODE=script; return; }

  # Skip if SSH session (default to human shell on remote)
  [[ -n "$SSH_CONNECTION" ]] && { export SHELL_MODE=human; return; }

  # Skip if inside tmux/screen and SHELL_MODE already set
  [[ -n "$TMUX" || -n "$STY" ]] && [[ -n "$SHELL_MODE" ]] && return

  # Skip if nested shell with Claude already active
  [[ -n "$CLAUDE_ACTIVE" ]] && return

  # Welcome screen with escape hatch
  echo ""
  echo "╔════════════════════════════════════╗"
  echo "║   Claude Code Shell Environment    ║"
  echo "╚════════════════════════════════════╝"
  echo ""
  echo "Starting in 2s... [Enter]=now [h]=human shell [Ctrl+C]=cancel"
  echo ""

  # Interruptible wait
  if read -t 2 -n 1 key 2>/dev/null; then
    case "$key" in
      h|H)
        echo "→ Human shell mode"
        export SHELL_MODE=human
        return
        ;;
      "")
        # Enter pressed — proceed immediately
        ;;
    esac
  fi

  # Launch Claude Code
  export SHELL_MODE=claude
  export CLAUDE_ACTIVE=1
  exec claude
}

_claude_shell_init

fpath+=~/.zfunc; autoload -Uz compinit; compinit

zstyle ':completion:*' menu select
export PATH="$HOME/.config/emacs/bin:$PATH"

# Added by GitLab Knowledge Graph installer
export PATH="$HOME/.local/bin:$PATH"

# Add ~/bin to PATH for user scripts
export PATH="$HOME/bin:$PATH"

# Meta-project scripts (agent tools, automation)
export PATH="$HOME/devvyn-meta-project/scripts:$PATH"

# Task Master aliases added on 2025-10-10
alias tm='task-master'
alias taskmaster='task-master'
alias pico8="/Applications/PICO-8.app/Contents/MacOS/pico8"

# Conmigo Terminal - AI Learning Station
export PATH="$HOME/devvyn-meta-project/study-station/scripts:$PATH"

# Hardened tmux socket location (avoid /tmp purges)
mkdir -p "$HOME/.tmux/tmp" 2>/dev/null || true
export TMUX_TMPDIR="$HOME/.tmux/tmp"
export PODCAST_NETLIFY_URL="https://luminous-selkie-098a98.netlify.app"
