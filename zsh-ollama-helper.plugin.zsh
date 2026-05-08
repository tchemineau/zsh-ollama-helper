# ----------------------------------------------------------------------------
# Ollama Helper Plugin for ZSH - AI Naming Convention
# ----------------------------------------------------------------------------

# Check if Ollama is running before calling the API
_ai_check_service() {
  if ! pgrep -x "Ollama" > /dev/null; then
    echo "⚠️ Ollama is not running. Please launch the application first."
    return 1
  fi
}

# Ask a general question to the local model
ai_ask() {
  _ai_check_service || return 1
  ollama run llama3:8b "Respond concisely: $@"
}

# Get a specific terminal command for a task
ai_how() {
  _ai_check_service || return 1
  
  local prompt="Provide ONLY the macOS terminal command for: $@. "
  prompt+="No explanation, no intro/outro, no markdown, just the raw command."

  local cmd=$(ollama run llama3:8b "$prompt")
  echo -e "\033[0;32m$cmd\033[0m"
}

# Fix the last failed command in history
ai_fix() {
  _ai_check_service || return 1
  local last_cmd=$(fc -ln -1)
  echo "Analyzing: $last_cmd"
  ai_how "fix this failed terminal command: $last_cmd"
}

# Context-aware help based on current directory listing
ai_look() {
  _ai_check_service || return 1
  local files=$(ls -F | head -n 20)
  ai_ask "Based on these files: [$files], help me with: $@"
}

