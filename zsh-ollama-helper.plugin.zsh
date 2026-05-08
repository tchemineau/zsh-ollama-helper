# ----------------------------------------------------------------------------
# Ollama Helper Plugin for ZSH
# ----------------------------------------------------------------------------

# Quick Q&A with the model
ask() {
  if ! pgrep -x "Ollama" > /dev/null; then
    echo "⚠️ Ollama is not running. Please launch the application first."
    return 1
  fi
  ollama run llama3:8b "Respond concisely: $@"
}

# Generate a specific terminal command based on natural language
how() {
  if ! pgrep -x "Ollama" > /dev/null; then
    echo "⚠️ Ollama is not running. Please launch the application first."
    return 1
  fi
  
  local prompt="Provide ONLY the macOS terminal command for: $@. "
  prompt+="Do not provide any explanation, no intro/outro text, "
  prompt+="no markdown code blocks, just the raw command."

  local cmd=$(ollama run llama3:8b "$prompt")
  
  # Print the suggested command in Green
  echo -e "\033[0;32m$cmd\033[0m"
}

# Analyze and fix the last executed command
fix() {
  local last_cmd=$(fc -ln -1)
  echo "Analyzing: $last_cmd"
  how "fix this terminal command that failed: $last_cmd"
}

# List files and ask a question about the current directory
look() {
  local files=$(ls -F | head -n 20)
  ask "Based on these files: [$files], help me with: $@"
}

