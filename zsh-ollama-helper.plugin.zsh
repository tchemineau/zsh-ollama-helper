# ----------------------------------------------------------------------------
# Ollama Helper Plugin for ZSH - AI Naming Convention
# ----------------------------------------------------------------------------

_ai_check_service() {
  if ! pgrep -x "Ollama" > /dev/null; then
    echo "⚠️ Ollama is not running. Please launch the application first."
    return 1
  fi
}

ai-ask() {
  _ai_check_service || return 1
  ollama run llama3:8b "Respond concisely: $@"
}

ai-how() {
  _ai_check_service || return 1
  local p="Provide ONLY the macOS terminal command for: $@. "
  p+="No explanation, no intro/outro, no markdown, just the raw command."
  local cmd=$(ollama run llama3:8b "$p")
  echo -e "\033[0;32m$cmd\033[0m"
  echo "$cmd" # Return command for other functions
}

ai-run() {
  _ai_check_service || return 1
  local force=false
  local query="$@"

  # Check for -y flag
  if [[ "$1" == "-y" ]]; then
    force=true
    shift
    query="$@"
  fi

  # Get the command using our ai-how logic
  # We capture only the last line to avoid potential ollama noise
  local cmd=$(ai-how "$query" | tail -n 1)

  if [[ "$force" == true ]]; then
    eval "$cmd"
  else
    echo -e "$cmd\n"
    echo -n "🚀 Execute this command? (y/N): "
    read -r answer
    if [[ "$answer" =~ ^[Yy]$ ]]; then
      eval "$cmd"
    else
      echo "Aborted."
    fi
  fi
}

ai-fix() {
  _ai_check_service || return 1
  local last_cmd=$(fc -ln -1)
  echo "Analyzing failure: $last_cmd"
  ai-how "fix this failed terminal command: $last_cmd"
}

ai-look() {
  _ai_check_service || return 1
  local files=$(ls -F | head -n 20)
  ai-ask "Based on these files: [$files], help me with: $@"
}

