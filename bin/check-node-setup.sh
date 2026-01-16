#!/bin/zsh

echo "🔍 Checking npm and claude-code status..."
echo ""

# Source the shell configuration
source ~/.zshrc

echo "📋 System status:"
echo "Node.js version: $(node --version 2>/dev/null || echo 'Not found')"
echo "npm version: $(npm --version 2>/dev/null || echo 'Not found')"
echo "claude-code version: $(claude --version 2>/dev/null || echo 'Not found')"
echo ""

echo "📂 NVM status:"
echo "NVM version: $(nvm --version 2>/dev/null || echo 'Not found')"
echo "Current node: $(nvm current 2>/dev/null || echo 'Not found')"
echo ""

echo "🛠️ To fix:"
echo "1. Open a new terminal window"
echo "2. Run: source ~/.zshrc"
echo "3. Check if nvm, npm, and claude are available"
echo "4. If claude-code is missing, install it with: npm install -g @anthropic-ai/claude-cli"
echo ""

if command -v nvm >/dev/null 2>&1; then
  echo "✅ NVM is properly loaded!"
  echo "Your current Node.js setup:"
  nvm list 2>/dev/null || echo "No Node.js versions installed via NVM"
else
  echo "❌ NVM is not loaded in this shell"
fi
