#!/usr/bin/env zsh
# ==============================================================================
# 🧠 zsh_loader.zsh — Auto-generate ~/.zshrc for Scientific Environments
# macOS, Apple Silicon M1/M2/M3
# ==============================================================================

# --- Color Codes ---
GREEN=$'\033[0;32m'; YELLOW=$'\033[0;33m'; RED=$'\033[0;31m'; BLUE=$'\033[0;34m'; RESET=$'\033[0m'

echo "${GREEN}🔧 Installing modular environment into ~/.zshrc...${RESET}"

ZSHRC="$HOME/.zshrc"
INSTALLER="$HOME/install_env_system.zsh"
FLAG="$HOME/.zsh_envs/.installed"

# --- Backup ---
[[ -f "$ZSHRC" ]] && cp "$ZSHRC" "$ZSHRC.bak"

# --- Write ~/.zshrc ---
cat << 'EOF' > "$ZSHRC"
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

# --- Deduplication Helper ---
dedup_colon_list() {
  echo "$1" | /usr/bin/awk -v RS=':' '!seen[$1]++' | /usr/bin/paste -sd: -
}

export PATH="$(dedup_colon_list "$PATH")"
export DYLD_LIBRARY_PATH="$(dedup_colon_list "$DYLD_LIBRARY_PATH")"
export LD_LIBRARY_PATH="$(dedup_colon_list "$LD_LIBRARY_PATH")"

# --- Compiler & Core Toolchain ---
export CC=/opt/local/bin/mpicc-openmpi-mp
export CXX=/opt/local/bin/mpicxx-openmpi-mp
export FC=/opt/local/bin/gfortran-mp-13
export CFLAGS="-arch arm64"
export CXXFLAGS="-arch arm64 -std=c++20"

# --- GUI Application Support ---
configure_gui_app() {
  local app_path="$1"
  local bin_dir="$app_path/Contents/MacOS"
  local lib_dir="$app_path/Contents/lib"
  local include_dir="$app_path/Contents/include"

  [[ -d "$bin_dir" ]] && PATH="$bin_dir:$PATH"
  [[ -d "$lib_dir" ]] && DYLD_LIBRARY_PATH="$lib_dir:$DYLD_LIBRARY_PATH"
  [[ -d "$lib_dir" ]] && LDFLAGS="-L$lib_dir $LDFLAGS"
  [[ -d "$include_dir" ]] && CPPFLAGS="-I$include_dir $CPPFLAGS"
}

declare -A gui_apps=(
  [ParaView]="/Applications/ParaView.app"
  [Gmsh]="/Volumes/NVM/Applications/Gmsh.app"
  [RStudio]="/Volumes/NVM/Applications/RStudio.app"
  [MATLAB]="/Volumes/NVM/Applications/MATLAB_R2024a.app"
)

for app in "${(@k)gui_apps}"; do
  configure_gui_app "${gui_apps[$app]}"
done

# --- Load All Tool Environment Files ---
for f in "$HOME/.zsh_envs/"*.zsh_env; do
  [[ -f "$f" ]] && source "$f"
done

# <<< Scientific Environment <<<
EOF

echo "${GREEN}✅ ~/.zshrc successfully configured!${RESET}"
echo "🔁 Reload your shell or run: ${BLUE}source ~/.zshrc${RESET}"
