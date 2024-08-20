#!/bin/bash

FONT_DIR="$HOME/.local/share/fonts"
FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2/Meslo.zip"
SCRIPT_DIR="$(dirname "$(realpath "$0")")"
WALLPAPER_PATH="$SCRIPT_DIR/wallpaper.png"

# Função para verificar se o i3 está instalado
check_package() {
  dpkg -l | grep -q "$1"
}

echo "Iniciando a configuração do tema..."

# Instalação de pacotes necessários para o tema
THEME_PACKAGES=("i3" "feh")
for package in "${THEME_PACKAGES[@]}"; do
  if check_package "$package"; then
    echo "$package já está instalado."
  else
    echo "Instalando $package..."
    sudo apt install -y "$package"
  fi
done

# Baixa e instala a fonte NerdFont MesloGS
if [ -d "$FONT_DIR/Meslo" ]; then
  echo "A fonte NerdFont MesloGS já está instalada."
else
  echo "Baixando e instalando a fonte NerdFont MesloGS..."
  mkdir -p "$FONT_DIR"
  cd "$FONT_DIR"
  curl -fLo "Meslo.zip" "$FONT_URL"
  unzip Meslo.zip -d Meslo
  rm Meslo.zip
  fc-cache -fv
  echo "Fonte NerdFont MesloGS instalada com sucesso."
fi

# Configura o papel de parede no i3
if [ -f "$WALLPAPER_PATH" ]; then
  if grep -q "feh --bg-scale $WALLPAPER_PATH" ~/.config/i3/config; then
    echo "O papel de parede já está configurado no i3."
  else
    echo "Configurando o papel de parede no i3..."
    echo "exec --no-startup-id feh --bg-scale $WALLPAPER_PATH" >>~/.config/i3/config
    echo "Papel de parede configurado com sucesso."
  fi
else
  echo "O arquivo de papel de parede não foi encontrado em $WALLPAPER_PATH."
fi

echo "Configuração do tema concluída."
