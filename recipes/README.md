# RECIPES

If you want to create a reusable recipes snippet, it should fall in to one
of these categories:

## introspection (info)

Such recipes will provide the user some customised debug / info without actually
validating or building.

e.g. help, show_env, mandatory_vars, print_vars are examples of these in the
product.in

## prereqs

These recipes make sure the build env is set up.

e.g the sshkeyfile target provides an example of such a recipe.

## validation

Targets like check_vars or validate in product.in

## building

The build recipe should always call these other targets:

* prereqs
* validate
* build

e.g.

        .PHONY: build
        build: prereqs validate ## do stuff
            PACKER_LOG=$(PACKER_LOG) packer build $(PACKER_DEBUG) $(PACKER_JSON)

        .PHONY: prereqs
        prereqs: sshkeyfile puppet_librarian;

        .PHONY: validate
        prereqs: check_vars check_aws_access
            @packer validate $(PACKER_JSON)
