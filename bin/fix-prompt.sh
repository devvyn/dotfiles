#!/bin/bash

echo "🔤 Fixing your prompt display..."
echo ""

# Install powerline fonts
echo "Installing Nerd Fonts (this might take a moment)..."
brew install --cask font-meslo-lg-nerd-font font-fira-code-nerd-font 2>/dev/null

echo "✅ Fonts installed!"
echo ""
echo "🎯 Next steps:"
echo "1. In iTerm2:"
echo "   • Go to Preferences → Profiles → Text"
echo "   • Change font to 'MesloLGS NF' or 'FiraCode Nerd Font'"
echo "   • Size 12-14 usually works well"
echo ""
echo "2. Restart your terminal or run: source ~/.zshrc"
echo ""
echo "Alternative: Switch to a simpler theme by running:"
echo "   echo 'ZSH_THEME=\"robbyrussell\"' >> ~/.zshrc.local"
echo ""
