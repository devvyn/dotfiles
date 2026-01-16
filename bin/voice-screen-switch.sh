#!/bin/bash
# Voice Control helper - Jump mouse to specific screens
# Usage: ./voice-screen-switch.sh [laptop|external|left|right]

move_mouse() {
    local x=$1
    local y=$2
    cliclick m:$x,$y
}

case "$1" in
    "laptop"|"right"|"main")
        # MacBook center: (640, 400)
        move_mouse 640 400
        echo "🖥️  Jumped to MacBook (right display)"
        ;;
    "external"|"left"|"philips")
        # External center: (-960, 424)
        move_mouse -960 424
        echo "🖥️  Jumped to Philips (left display)"
        ;;
    "laptop-left")
        # Left side of MacBook
        move_mouse 200 400
        ;;
    "laptop-right")
        # Right side of MacBook
        move_mouse 1080 400
        ;;
    "external-left")
        # Left side of external
        move_mouse -1700 424
        ;;
    "external-right")
        # Right side of external (near edge with laptop)
        move_mouse -200 424
        ;;
    *)
        echo "Usage: $0 [laptop|external|left|right]"
        echo ""
        echo "Available commands:"
        echo "  laptop, right, main    - Jump to MacBook screen"
        echo "  external, left, philips - Jump to Philips screen"
        exit 1
        ;;
esac
