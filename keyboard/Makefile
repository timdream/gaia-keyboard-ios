# This step is necessary to pull Gaia Keyboard from the Gaia repo.

GAIA_ROOT_DIR?=./../gaia
GAIA_KEYBOARD_ROOT_DIR=$(GAIA_ROOT_DIR)/apps/keyboard
GAIA_KEYBOARD_DIRS=$(shell find $(GAIA_KEYBOARD_ROOT_DIR) -type d)
GAIA_KEYBOARD_FILES=$(shell find $(GAIA_KEYBOARD_ROOT_DIR) -type f -name '*')

webapp: $(GAIA_DIR) $(GAIA_KEYBOARD_DIRS) $(GAIA_KEYBOARD_FILES) $(CURDIR)/Makefile
	rm -rf ./webapp/*
	mkdir -p ./webapp
	cp -r $(GAIA_KEYBOARD_ROOT_DIR)/* ./webapp/
	rm -rf ./webapp/test ./webapp/build
