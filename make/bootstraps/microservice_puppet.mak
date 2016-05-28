# vim: ts=4 st=4 sr noet smartindent syntax=make ft=make:
#
# ### MANDATORY_VARS
# put any custom overrides or additions in current project in mandatory_vars.mak
CUSTOM_FILE=mandatory_vars.mak
include packer_includes/make/mandatory_vars/product.mak
include packer_includes/make/mandatory_vars/microservice_puppet.mak
include packer_includes/make/custom_file.mak

# ### CONSTANTS (not user-defineable)
# put any custom overrides or additions in current project in constants.mak
CUSTOM_FILE=constants.mak
include packer_includes/make/constants/product.mak
include packer_includes/make/custom_file.mak

# ### ROLE_VARS (optional based on specific role e.g. amq | gateway etc ...)
# put custom overrides or additions in current project in user_vars.mak
CUSTOM_FILE=role_vars.mak
PROJECT_FILE := $(strip $(wildcard role_vars/$(EUROSTAR_SERVICE_ROLE).mak))
ifneq ($(PROJECT_FILE),)
	include $(PROJECT_FILE)
endif
include packer_includes/make/custom_file.mak

# ### USER_VARS (user-defineable)
# put any custom overrides or additions in current project in user_vars.mak
CUSTOM_FILE=user_vars.mak
include packer_includes/make/user_vars/product.mak
include packer_includes/make/user_vars/puppet.mak
include packer_includes/make/custom_file.mak

# ### GENERATED VARS: determined by make based on other values.
# put any custom overrides or additions in current project in generated_vars.mak
CUSTOM_FILE=generated_vars.mak
include packer_includes/make/generated_vars/product.mak
include packer_includes/make/custom_file.mak

# ### RECIPES ...
CUSTOM_FILE=recipes.mak
include packer_includes/make/recipes/common.mak
include packer_includes/make/recipes/microservice_puppet.mak
include packer_includes/make/custom_file.mak
