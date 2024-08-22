#!/bin/bash

# Arte ASCII
echo "___  ___           _               __  "
echo "|  \/  |          | |             /  | "
echo "| .  . | __ _ _ __| | __  ______ \`| | "
echo "| |\/| |/ _\` |'__| |/ / |______|  | | "
echo "| |  | | (_| | |  |   <           _| |_"
echo "\_|  |_/\__,_|_|  |_|\_\          \___/"
echo "                                       "
echo "                                       "

echo "Iniciando a configuração do ambiente..."

# Executa o script de configuração do terminal
./terminal.sh

# Executa o script de configuração do tema
./theme.sh

# Checagem final da instalação
echo "Verificando se todos os pacotes foram instalados corretamente..."

MISSING_PACKAGES=()
PACKAGES=("neovim" "tmux" "tmuxinator" "curl" "unzip" "i3" "feh" "xbacklight" "xinput" "i3blocks" "rxvt-unicode-256color" "screen" "scrot" "redshift" "alsa-utils" "acpi" "fonts-font-awesome" "xdotool" "xclip")
for package in "${PACKAGES[@]}"; do
  if ! dpkg -l | grep -q "$package"; then
    MISSING_PACKAGES+=("$package")
  fi
done

if [ ${#MISSING_PACKAGES[@]} -eq 0 ]; then
  echo "Todos os pacotes foram instalados com sucesso."
else
  echo "Os seguintes pacotes não foram instalados corretamente: ${MISSING_PACKAGES[*]}"
fi

echo "Configuração do ambiente concluída."
