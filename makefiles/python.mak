################################################################################
# Targets
#
#
.PHONY: activate-python clean-python help-python install-python python

################################################################################
# Variables
#
#
SYSTEM_PYTHON_PATH = $(shell which python)
SYSTEM_PYTHON_VERSION = $(shell python --version)

PYTHON_VERSION = $(SYSTEM_PYTHON_VERSION)

DIR_VENV_PYTHON = .venv_python

ifndef PYTHON_VERSION
$(error PYTHON_VERSION is not set)
endif


activate-python: | $(DIR_VENV_PYTHON)
	@echo "################################################################################"
	@echo "# Activate $(DIR_VENV_PYTHON) with $(PYTHON_VERSION) using the following command:"
	@echo "source $(DIR_VENV_PYTHON)/bin/activate"
	@echo ""
	@echo "(Use \"deactivate\" to deactivate this virtual environment for python)"

clean-python:
	@echo "################################################################################"
	@echo "# Delete $(DIR_VENV_PYTHON)"
	@rm -rf $(DIR_VENV_PYTHON)

help-python:
	@echo "# ========================================"
	@echo "# Python targets:"
	@printf "#  %-17s %s\n" "activate-python:"	"See \"python\" target"
	@printf "#  %-17s %s\n" "clean-python:"		"Delete virtual python environment"
	@printf "#  %-17s %s\n" "install-python:"	"See \"python\" target"
	@printf "#  %-17s %s\n" "python:"	        "Show activation instruction for virtual python environments"
	@printf "#  %-17s %s\n" "help-python:"		"Show this target list (python targets)"

install-python python: activate-python

# Check, if $(DIR_VENV_PYTHON) exists
$(DIR_VENV_PYTHON):
	@echo "################################################################################"
	@echo "# Current/system python version: $(SYSTEM_PYTHON_VERSION) ($(SYSTEM_PYTHON_PATH))"
	@echo "# Install new virtual python environment: ($(DIR_VENV_PYTHON))"
	@python -m venv $(DIR_VENV_PYTHON)
