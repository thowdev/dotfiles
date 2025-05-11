################################################################################
# Targets
#
#
.PHONY: debug debug-makefile debug-vim

debug-makefile:
	@echo "################################################################################"
	@echo "# Makefile variables:"
	@echo "# ======================================="
	@printf "#   %-20s %s\n" "ROOT_DIR:"        "$(ROOT_DIR)"
	@printf "#   %-20s %s\n" "DOT_CONFIG_DIR:"  "$(DOT_CONFIG_DIR)"
	@printf "#   %-20s %s\n" "DOT_THOWDEV_DIR:" "$(DOT_THOWDEV_DIR)"
	@printf "#   %-20s %s\n" "TODAY:"           "$(TODAY)"
	@printf "#   %-20s %s\n" "HOME:"            "$(HOME)"
	@printf "#   %-20s %s\n" "XDG_CACHE_HOME:"  "$(XDG_CACHE_HOME)"
	@printf "#   %-20s %s\n" "XDG_CONFIG_HOME:" "$(XDG_CONFIG_HOME)"
	@printf "#   %-20s %s\n" "XDG_DATA_HOME:"   "$(XDG_DATA_HOME)"

debug-python:
	@echo "################################################################################"
	@echo "# python.mak variables:"
	@echo "# ======================================="
	@printf "#   %-20s %s\n" "SYSTEM_PYTHON_PATH:"		"$(SYSTEM_PYTHON_PATH)"
	@printf "#   %-20s %s\n" "SYSTEM_PYTHON_VERSION:"	"$(SYSTEM_PYTHON_VERSION)"
	@printf "#   %-20s %s\n" "PYTHON_VERSION:"			"$(PYTHON_VERSION)"
	@printf "#   %-20s %s\n" "DIR_VENV_PYTHON:"			"$(DIR_VENV_PYTHON)"

debug-stow:
	@echo "################################################################################"
	@echo "# stow.mak variables:"
	@echo "# ======================================="
	@printf "#   %-20s %s\n" "OS:"	"$(OS)"

debug-vim:
	@echo "################################################################################"
	@echo "# vimconfig.mak variables:"
	@echo "# ======================================="
	@printf "#   %-20s %s\n" "VIM_CACHE_DIR:"       "$(VIM_CACHE_DIR)"
	@printf "#   %-20s %s\n" "VIM_CONFIG_DIR:"      "$(VIM_CONFIG_DIR)"
	@printf "#   %-20s %s\n" "VIM_CONFIG_DIR_REAL:" "$(VIM_CONFIG_DIR_REAL)"
	@printf "#   %-20s %s\n" "VIM_DATA_DIR:"        "$(VIM_DATA_DIR)"
	@printf "#   %-20s %s\n" "VIM_AUTOLOAD_DIR:"    "$(VIM_AUTOLOAD_DIR)"
	@printf "#   %-20s %s\n" "VIM_SEARCH_DIRS:"     "$(VIM_SEARCH_DIRS)"

debug: debug-makefile debug-python debug-stow debug-vim

