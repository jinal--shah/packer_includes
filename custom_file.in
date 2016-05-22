# vim: ts=4 st=4 sr noet smartindent syntax=make ft=make:
PROJECT_FILE := $(strip $(wildcard $(CUSTOM_FILE)))
ifneq ($(PROJECT_FILE),)
	include $(PROJECT_FILE)
endif
