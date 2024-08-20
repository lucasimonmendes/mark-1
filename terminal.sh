#!/bin/bash

# Função para verificar se um pacote está instalado
check_package() {
  dpkg -l | grep -q "$1"
}

echo "Iniciando a configuração do terminal..."

# Atualiza a lista de pacotes
echo "Atualizando a lista de pacotes..."
sudo apt update

# Instalação de pacotes
PACKAGES=("neovim" "tmux" "tmuxinator" "curl" "unzip")
for package in "${PACKAGES[@]}"; do
  if check_package "$package"; then
    echo "$package já está instalado."
  else
    echo "Instalando $package..."
    sudo apt install -y "$package"
  fi
done

echo "Configuração do terminal concluída."
