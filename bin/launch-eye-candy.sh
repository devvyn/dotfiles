#!/bin/bash
# Launch Eye Candy - Opens multiple iTerm2 windows with different animations
# Perfect for ADHD-friendly workspace decoration!

# Function to create a new iTerm2 window with a command
launch_iterm_window() {
    local title="$1"
    local command="$2"

    osascript <<EOF
tell application "iTerm"
    activate
    create window with default profile
    tell current session of current window
        set name to "$title"
        write text "$command"
    end tell
end tell
EOF
}

# Welcome message
figlet "Eye Candy Time!" | lolcat

echo ""
echo "🐠 Launching visual treats in separate windows..."
echo ""
sleep 1

# Window 1: Asciiquarium (fishies!)
echo "🐠 Window 1: Launching aquarium..."
launch_iterm_window "🐠 Fishies" "asciiquarium"
sleep 0.5

# Window 2: Matrix rain
echo "💚 Window 2: Launching Matrix rain..."
launch_iterm_window "💚 Matrix" "cmatrix -b -u 8"
sleep 0.5

# Window 3: Hypnotic patterns
echo "🌀 Window 3: Launching hypnotic patterns..."
launch_iterm_window "🌀 Patterns" "python3 ~/hypno-patterns.py"
sleep 0.5

# Window 4: Fortune + cowsay loop (slow scroll for readability)
echo "🐮 Window 4: Launching wisdom cow..."
launch_iterm_window "🐮 Wisdom" 'while true; do fortune | cowsay | while IFS= read -r line; do echo "$line" | lolcat; sleep 0.3; done; echo ""; sleep 6; done'

echo ""
figlet "Enjoy!" | lolcat
echo ""
echo "✨ All windows launched! Press Ctrl+C in each window to close."
echo ""
