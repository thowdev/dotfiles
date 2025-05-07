.PHONY: clean install install-stow simulate stow help uninstall

.DEFAULT_GOAL := help

###############################################################################
# Detect OS
#
UNAME := $(shell uname)
ifeq ($(UNAME), Darwin)
	OS := macos
else
	OS := $(shell cat /etc/os-release | grep ^ID= | cut -d= -f2 | tr -d '"')
endif

###############################################################################
# Cleanup
#
clean uninstall:
	stow -v --dotfiles -t ${HOME} -D .

###############################################################################
# Help
#
help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  help			Show this help message"
	@echo "  clean			Unstow all files from ${HOME}"
	@echo "  install		Install GNU stow using the system package manager"
	@echo "  install-stow		see \"install\"-target"
	@echo "  stow			Stow all files to ${HOME}, ignoring Makefile and stow-related files"
	@echo "  simulate		Simulate stow command from "stow"-target
	@echo "  uninstall		see \"clean\"-target"
	@echo ""
	@echo "Detected OS: $(OS)"

###############################################################################
# Install GNU stow with OS specific install manager
#
install install-stow:
ifeq ($(OS), macos)
	brew install stow
else ifeq ($(OS), fedora)
	sudo dnf install -y stow
else ifeq ($(OS), rhel)
	sudo yum install -y epel-release
	sudo yum install -y stow
else ifeq ($(OS), sles)
	sudo zypper install -y stow
else ifeq ($(OS), ubuntu)
	sudo apt update
	sudo apt install -y stow
else
	@echo "Unsupported operating system"
	@exit 1
endif

###############################################################################
# Simulate stow command from "stow"-target
#
simulate:
	stow -v -n --dotfiles -t ${HOME} -R . --ignore=Makefile

###############################################################################
# Run stow for the current directory, ignoring Makefile and stow-related files
#
stow:
	stow -v --dotfiles -t ${HOME} -R . --ignore=Makefile
