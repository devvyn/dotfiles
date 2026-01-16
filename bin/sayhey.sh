#!/bin/zsh

phrases=(
  "hey"
  "yo"
  "psst"
  "ahem"
  "ding"
  "bing"
  "ping"
  "boop"
  "beep"
  "oi"
  "hoy"
  "ahoy"
)

say "${phrases[RANDOM % ${#phrases[@]} + 1]}"

