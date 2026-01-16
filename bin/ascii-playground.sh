#!/bin/bash
# ASCII Art Playground Demo
# A collection of fun terminal eye candy

# Colors for sections
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

show_section() {
    echo -e "\n${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}$1${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

# 1. FIGLET - Big ASCII text
show_section "FIGLET - Big Text Art"
echo "Try: figlet 'Your Text Here'"
echo "Example:"
figlet "Hello World"

# 2. FIGLET + LOLCAT - Rainbow text
show_section "FIGLET + LOLCAT - Rainbow Text"
echo "Try: figlet 'ADHD Brain' | lolcat"
echo "Example:"
figlet "ADHD Brain" | lolcat

# 3. COWSAY + FORTUNE - Wise cow
show_section "COWSAY + FORTUNE - Wise Cow"
echo "Try: fortune | cowsay | lolcat"
echo "Example:"
fortune | cowsay

# 4. JP2A - Image to ASCII
show_section "JP2A - Image to ASCII"
echo "Try: jp2a --colors image.jpg"
echo "(Need an image file to demo this one)"

# 5. CMATRIX - Matrix rain
show_section "CMATRIX - Matrix Rain Effect"
echo "Try: cmatrix"
echo "(Press Ctrl+C to exit)"
echo -e "${YELLOW}Skipping auto-run (it's infinite)${NC}"

# 6. ASCIIQUARIUM - Fish tank
show_section "ASCIIQUARIUM - Animated Aquarium"
echo "Try: asciiquarium"
echo "(Press Ctrl+C to exit)"
echo -e "${YELLOW}Skipping auto-run (it's infinite)${NC}"

# Fun combos
show_section "FUN COMBOS"
echo "1. Rainbow fortune:"
echo "   fortune | cowsay | lolcat"
echo ""
echo "2. Big rainbow headers:"
echo "   figlet -f standard 'Project Name' | lolcat"
echo ""
echo "3. Add to your .zshrc for startup fun:"
echo "   fortune | cowsay | lolcat"

# Final rainbow message
echo ""
figlet "Have Fun!" | lolcat
echo ""
