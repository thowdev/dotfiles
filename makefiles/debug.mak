################################################################################
# Targets
#
#
.PHONY: debug debug-makefile

debug-makefile:
	@echo "################################################################################"
	@echo "# Makefile variables:"
	@echo "# ======================================="
	@printf "#   %-20s %s\n" "ROOT_DIR:"        "$(ROOT_DIR)"
	@printf "#   %-20s %s\n" "TODAY:"           "$(TODAY)"
	@printf "#   %-20s %s\n" "HOME:"            "$(HOME)"
	@printf "#   %-20s %s\n" "HOST_NAME:" 		"$(HOST_NAME)"
	@printf "#   %-20s %s\n" "XDG_CACHE_HOME:"  "$(XDG_CACHE_HOME)"
	@printf "#   %-20s %s\n" "XDG_CONFIG_HOME:" "$(XDG_CONFIG_HOME)"
	@printf "#   %-20s %s\n" "XDG_DATA_HOME:"   "$(XDG_DATA_HOME)"
	@printf "#   %-20s %s\n" "XDG_SEARCH_DIRS:"   "$(XDG_SEARCH_DIRS)"

debug: debug-makefile

