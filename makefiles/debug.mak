################################################################################
# Targets
#
#
.PHONY: debug debug-makefile debug-vim

debug-makefile:
	@echo "################################################################################"
	@echo "# Makefile variables:"
	@echo "# ======================================="
	@echo "#   ROOT_DIR:		$(ROOT_DIR)"
	@echo "#   DOT_CONFIG_DIR:	$(DOT_CONFIG_DIR)"
	@echo "#   DOT_THOWDEV_DIR:	$(DOT_THOWDEV_DIR)"
	@echo "#   TODAY:		$(TODAY)"
	@echo "#   HOME:		$(HOME)"
	@echo "#   XDG_CACHE_HOME:	$(XDG_CACHE_HOME)"
	@echo "#   XDG_CONFIG_HOME:	$(XDG_CONFIG_HOME)"
	@echo "#   XDG_DATA_HOME:	$(XDG_DATA_HOME)"

debug-vim:
	@echo "################################################################################"
	@echo "# vimconfig.mak variables:"
	@echo "# ======================================="
	@echo "#   VIM_CACHE_DIR:	$(VIM_CACHE_DIR)"
	@echo "#   VIM_CONFIG_DIR:	$(VIM_CONFIG_DIR)"
	@echo "#   VIM_DATA_DIR:	$(VIM_DATA_DIR)"

debug: debug-makefile debug-vim

