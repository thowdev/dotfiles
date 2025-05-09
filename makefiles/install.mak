################################################################################
# Targets
#
#
.PHONY: install install-stow

################################################################################
# Install GNU stow with OS specific install manager
#
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

