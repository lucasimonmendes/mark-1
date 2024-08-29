#!/usr/bin/env bash

###############################################################################
# Author: Lucas Simon <lucasimonmendes@gmail.com>
#
# Program name: Mark 1
# Version: 0.2
# License: MIT
# Description: This program installs the necessary tools to work with the terminal and styling and window manager for productivity.
#
# CHANGELOG:
# 21/08/2024 - Lucas Simon
#   - [Added] styling features and program downloads.
# 28/08/2024 - Lucas Simon
#   - [Added] formating program and add the dialog interface.
###############################################################################
set -e # if there is an error, exit

############################################ Variables
readonly programName="Mark-1"
readonly programVersion="0.2"

######################################################

############################################ Tests
for check in 'dialog' 'curl'; do
	if ! which "$check" &>/dev/null; then
		echo "Necessario ter $check instalado."
		exit 1
	fi
done

check_package() {
	dpkg -l | grep -q "$1"
}

##################################################

############################################ Functions

function checkInstalation() {
	dialog --title "Checando..." --sleep 2 --infobox "Checando se os pacotes foram instalados corretamente, aguarde!" 5 60
	MISSING_PACKAGES=()
	for package in "${PACKAGES[@]}"; do
		if ! dpkg -l | grep -q "$package"; then
			MISSING_PACKAGES+=("$package")
		fi
	done

	if [ ${#MISSING_PACKAGES[@]} -eq 0 ]; then
		dialog --title "Pacotes instalados ;)" --msgbox "Todos os pacotes foram instalados com sucesso." 5 60
	else
		dialog --title "Erro :(" --msgbox "Os seguintes pacotes não foram instalados corretamente: ${MISSING_PACKAGES[*]}" 6 50
	fi
}

function installTerminal() {
	#	updatePackages

	dialog --title "Instalando ferramentas..." --sleep 2 --infobox "Instalando ferramentas do terminal." 5 60
	local terminalApps=("neovim" "tmux" "tmuxinator" "curl" "unzip" "git")

	for package in "${terminalApps[@]}"; do
		if check_package "$package"; then
			dialog --title "$package instalado!" --sleep 3 --infobox "$package já está instalado." 5 60
		else
			dialog --title "Instalando $package" --sleep 3 --infobox "Instalando $package via apt..." 5 60
			sudo apt install -y "$package"
		fi
	done

	checkInstalation terminalApps
}

function installStyles() {
	dialog --title "Instalando estilos..." --sleep 2 --infobox "Instalando estilos e fontes." 5 60
	local styleApps=("i3" "feh" "x11-xserver-utils" "screen" "polybar" "rofi" "alsa-utils")

	for package in "${styleApps[@]}"; do
		if check_package "$package"; then
			dialog --title "$package instalado!" --sleep 3 --infobox "$package já está instalado." 5 60
		else
			dialog --title "Instalando $package" --sleep 3 --infobox "Instalando $package via apt..." 5 60
			sudo apt install -y "$package"
		fi
	done

	checkInstalation styleApps

	installFonts

}

function installFonts() {
	local FONT_DIR="$HOME/.local/share/fonts"
	local FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2/Meslo.zip"

	if [ -d "$FONT_DIR/Meslo" ]; then
		dialog --title "Fonte ja instalada" --sleep 2 --infobox "A fonte NerdFont MesloGS já está instalada." 5 60
	else
		dialog --title "Baixando fonte..." --sleep 2 --infobox "Baixando e instalando a fonte NerdFont MesloGS..." 5 60
		mkdir -p "$FONT_DIR"
		cd "$FONT_DIR"
		curl -fLo "Meslo.zip" "$FONT_URL"
		unzip Meslo.zip -d Meslo
		rm Meslo.zip
		fc-cache -fv
		dialog --title "Fonte instalada!" --msgbox "Fonte NerdFont MesloGS instalada com sucesso." 5 60
	fi

}
######################################################

############################################ Main

# Menu
menu=$(
	dialog --stdout \
		--backtitle "$programName - $programVersion" \
		--title "$programName" \
		--item-help \
		--menu "O que voce deseja fazer?" \
		0 0 0 \
		1 "Instalar ferramentas do terminal." \
		"Instala as ferramentas essenciais para programar com editor de texto, multiplexador de terminal e git." \
		2 "Instalar ferramentas e gerenciador de janelas." \
		"Instala fontes e ferramentas como window manager para a produtividade e estilo."
)

# User choice
case $menu in
1) installTerminal ;;
2) installStyles ;;
esac
