
################################################################################
# Targets
#
#
.PHONY: clean_vim clean_all_vim debug-vim
.DEFAULT_GOAL := help

################################################################################
# Variables
#
#
VIM_CONFIG_DIR  := $(DOT_CONFIG_DIR)/vim
VIM_BACKUP_DIR  := $(VIM_CONFIG_DIR)/backup
VIM_UNDO_DIR  := $(VIM_CONFIG_DIR)/undo
VIM_VIMBACKUP_DIR  := $(VIM_CONFIG_DIR)/vimbackup

debug-vim:
	@echo "vimconfig.mak variables:"
	@echo "++++++++++++++++++++++++"
	@echo "VIM_CONFIG_DIR: $(VIM_CONFIG_DIR)"
	@echo "VIM_BACKUP_DIR: $(VIM_BACKUP_DIR)"
	@echo "VIM_UNDO_DIR: $(VIM_UNDO_DIR)"
	@echo "VIM_VIMBACKUP_DIR: $(VIM_VIMBACKUP_DIR)"


clean_all_vim: clean_vim
	@echo "Delete \"$(VIM_VIMBACKUP_DIR)\""
	@rm -rf $(VIM_VIMBACKUP_DIR)

clean_vim:
	@echo "Cleanup \"$(VIM_CONFIG_DIR)\" folder"
	@echo "  1. Create \"$(VIM_VIMBACKUP_DIR)\""
	@mkdir -p $(VIM_VIMBACKUP_DIR)

	@echo "  2. Create backups of \"$(VIM_BACKUP_DIR)\" & \"$(VIM_UNDO_DIR)\""
	@TODAY=$(shell date +%Y%m%d_%H%M%S) && \
	if [ -d "$(VIM_BACKUP_DIR)" ]; then \
		mv $(VIM_BACKUP_DIR) $(VIM_VIMBACKUP_DIR)/$$TODAY-backup; \
	fi && \
	if [ -d "$(VIM_UNDO_DIR)" ]; then \
		mv $(VIM_UNDO_DIR) $(VIM_VIMBACKUP_DIR)/$$TODAY-undo; \
	fi

	@echo "  3. Delete all subfolders except \"ftplugin\" & \"vimbackup\""
	@find $(VIM_CONFIG_DIR) \
		-mindepth 1 \
		-maxdepth 1 \
		-type d \
		! -name ftplugin \
		! -name vimbackup \
		-exec rm -rf {} +
