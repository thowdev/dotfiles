################################################################################
# Targets
#
#
.PHONY: install-stow

###############################################################################
# Detect OS
#
UNAME := $(shell uname)
ifeq ($(UNAME), Darwin)
	OS := macos
else
	OS := $(shell cat /etc/os-release | grep ^ID= | cut -d= -f2 | tr -d '"')
endif

################################################################################
# Install GNU stow with OS specific install manager
#
#
install-stow:
	@echo "################################################################################"
	@echo "# Install stow on $(OS)"
ifeq ($(OS), macos)
	@brew install stow
else ifeq ($(OS), fedora)
	@sudo dnf install -y stow
else ifeq ($(OS), rhel)
	@sudo yum install -y epel-release
	@sudo yum install -y stow
else ifeq ($(OS), sles)
	@sudo zypper install -y stow
else ifeq ($(OS), ubuntu)
	@sudo apt update
	@sudo apt install -y stow
else
	@echo "Unsupported operating system"
	@exit 1
endif

################################################################################
# Help
#
#
help-stow:
	@echo "# ========================================"
	@echo "# Stow: "
	@printf "#  %-15s %s\n" "install-stow:"	"Install GNU stow using the system package manager"
