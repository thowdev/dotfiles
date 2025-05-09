
################################################################################
# Targets
#
#
.PHONY: backup_vim clean_vim clean_all_vim debug-vim

################################################################################
# Variables
#
#
VIM_CACHE_DIR		:= $(XDG_CACHE_HOME)/vim
VIM_CONFIG_DIR		:= $(XDG_CONFIG_HOME)/vim
VIM_DATA_DIR		:= $(XDG_DATA_HOME)/vim
VIM_AUTOLOAD_DIR	:= $(VIM_CONFIG_DIR)/autoload
VIM_SEARCH_DIRS		:= $(XDG_SEARCH_DIRS) $(VIM_CONFIG_DIR)

################################################################################
# Backup all vim related caches, configs and data
#
#
backup_vim:
	@echo "Backup \"$(VIM_CACHE_DIR)\""
	@if [ -d "$(VIM_CACHE_DIR)" ]; then \
		mv $(VIM_CACHE_DIR) $(VIM_CACHE_DIR)-$(TODAY); \
	fi
	@echo "Backup \"$(VIM_AUTOLOAD_DIR)\""
	@if [ -d "$(VIM_AUTOLOAD_DIR)" ]; then \
		mv $(VIM_AUTOLOAD_DIR) $(VIM_AUTOLOAD_DIR)-$(TODAY); \
	fi
	@echo "Backup \"$(VIM_DATA_DIR)\""
	@if [ -d "$(VIM_DATA_DIR)" ]; then \
		mv $(VIM_DATA_DIR) $(VIM_DATA_DIR)-$(TODAY); \
	fi

################################################################################
# Delete all vim related caches, configs and data INcluding their backups
#
#
clean_all_vim: clean_vim
	@echo "Searching and deleting old vim-* and autoload-* dirs in $(VIM_SEARCH_DIRS)"
	@for dir in $(VIM_SEARCH_DIRS); do \
		find -L $$dir -maxdepth 1 -type d \
			\( -name 'vim-[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]_[0-9][0-9][0-9][0-9][0-9][0-9]' \
			-o -name 'autoload-[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]_[0-9][0-9][0-9][0-9][0-9][0-9]' \) \
			-print -exec rm -rf {} \;; \
	done

################################################################################
# Delete all vim related caches, configs and data EXcluding their backups
#
#
clean_vim: backup_vim
	@echo "Delete \"$(VIM_CACHE_DIR)\""
	@rm -rf $(VIM_CACHE_DIR)
	@echo "Delete \"$(VIM_AUTOLOAD_DIR)\""
	@rm -rf "$(VIM_AUTOLOAD_DIR)"
	@echo "Delete \"$(VIM_DATA_DIR)\""
	@rm -rf $(VIM_DATA_DIR)
