# ~/.zshrc — Modular Scientific Environment Setup (Generated)

# --- Load Core Scripts ---
source "$HOME/.zsh_paths"
source "$HOME/.zsh_compilers"
source "$HOME/.zsh_gui"
source "$HOME/.zsh_lib"
source "$HOME/.zsh_creat"

# --- First-Time Setup ---
FLAG="$HOME/.zsh_envs/.installed"
if [[ ! -f "$FLAG" ]]; then
  echo "🛠️ First-time setup... running install_env_system..."
  /usr/bin/env zsh "$HOME/install_env_system.zsh" && touch "$FLAG"
else
  echo "✅ Scientific environment already installed."
fi

# >>> Scientific Environment >>>
