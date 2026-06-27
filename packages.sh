PACKAGES=()
FLATPAKS=()

install_dnf_packages() {
	sudo dnf install -y "${PACKAGES[@]}"
}

install_flatpaks() {
	for app in "${FLATPAKS[@]}"; do
		flatpak install -y flathub "$app"
	done
}

install_dnf_packages
install_flatpaks
