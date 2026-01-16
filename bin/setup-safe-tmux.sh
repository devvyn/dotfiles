#!/usr/bin/env bash
set -euo pipefail

echo "[tmux-setup] Starting hardened tmux setup"

# 1) Ensure TMUX_TMPDIR is used instead of /tmp
ZSHRC="${HOME}/.zshrc"
TMUX_TMPDIR_LINE='export TMUX_TMPDIR="$HOME/.tmux/tmp"'
if ! grep -Fq "$TMUX_TMPDIR_LINE" "$ZSHRC" 2>/dev/null; then
  echo "[tmux-setup] Adding TMUX_TMPDIR export to ${ZSHRC}"
  {
    echo ""
    echo "# Hardened tmux socket location (avoid /tmp purges)"
    echo 'mkdir -p "$HOME/.tmux/tmp" 2>/dev/null || true'
    echo "$TMUX_TMPDIR_LINE"
  } >> "$ZSHRC"
else
  echo "[tmux-setup] TMUX_TMPDIR already configured in ${ZSHRC}"
fi

mkdir -p "$HOME/.tmux/tmp"

# 2) Backup existing tmux.conf if present
TMUX_CONF="${HOME}/.tmux.conf"
if [ -f "$TMUX_CONF" ]; then
  BACKUP="${TMUX_CONF}.bak.$(date +%Y%m%d-%H%M%S)"
  echo "[tmux-setup] Backing up existing ${TMUX_CONF} to ${BACKUP}"
  cp "$TMUX_CONF" "$BACKUP"
fi

# 3) Install TPM (tmux plugin manager) if missing
if [ ! -d "${HOME}/.tmux/plugins/tpm" ]; then
  echo "[tmux-setup] Cloning tmux plugin manager (TPM)"
  git clone https://github.com/tmux-plugins/tpm "${HOME}/.tmux/plugins/tpm"
else
  echo "[tmux-setup] TPM already present"
fi

# 4) Write hardened tmux.conf
cat > "$TMUX_CONF" << 'EOF'
##### Hardened tmux config for multi-session / Claude Code use #####

# Indexing
set -g base-index 1
set -g pane-base-index 1

# History
set -g history-limit 200000

# Better crash inspection
set-option -g remain-on-exit on
set-option -g detach-on-destroy on

# Mouse (optional; comment out if you hate it)
set-option -g mouse on

# Ensure we have a socket dir (actual path chosen via TMUX_TMPDIR env)
run-shell "mkdir -p $HOME/.tmux/tmp"

##### Plugins (TPM + Resurrect + Continuum) #####
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-resurrect'
set -g @plugin 'tmux-plugins/tmux-continuum'

# Resurrect / Continuum settings
set -g @resurrect-dir "$HOME/.tmux/resurrect"
set -g @resurrect-capture-pane-contents 'on'
set -g @continuum-save-interval '5'   # minutes
set -g @continuum-restore 'on'

# Claude / multi-client friendliness
set -g allow-rename off
set -g set-titles on
set -g set-titles-string '#S:#I.#P #W'
set -g status-keys vi
setw -g mode-keys vi

# TPM bootstrap
run '~/.tmux/plugins/tpm/tpm'

##### Keybindings (minimal) #####
# Prefix: default C-b (keep for muscle memory)
# Reload config
bind r source-file ~/.tmux.conf \; display-message "tmux.conf reloaded"

# Quick save / restore (via resurrect)
bind C-s run-shell '~/.tmux/plugins/tmux-resurrect/scripts/save.sh'
bind C-r run-shell '~/.tmux/plugins/tmux-resurrect/scripts/restore.sh'
EOF

echo "[tmux-setup] Wrote hardened ${TMUX_CONF}"

# 5) Create a basic 'base' session if no tmux server running
if ! tmux has-session -t base 2>/dev/null; then
  echo "[tmux-setup] Creating persistent 'base' tmux session"
  TMUX_TMPDIR="$HOME/.tmux/tmp" tmux new-session -d -s base
fi

echo
echo "[tmux-setup] Done."
echo "Next steps:"
echo "  1) Open a new shell or 'source ~/.zshrc'"
echo "  2) Start tmux:    tmux attach -t base   (or just: tmux)"
echo "  3) Inside tmux, press:  Ctrl-b I   to install plugins (TPM)."
echo
