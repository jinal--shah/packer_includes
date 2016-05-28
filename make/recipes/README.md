# RECIPES

If you want to create a reusable recipes snippet, it should fall in to one
of these categories:

## introspection (info)

Such recipes will provide the user some customised debug / info without actually
validating or building.

e.g. help, show_env, mandatory_vars, print_vars are examples of these in the
product.mak

## prereqs

These recipes make sure the build env is set up.

e.g the sshkeyfile target provides an example of such a recipe.

## validation

Targets like check_vars or validate in product.mak

## building

The build recipe should always call these other targets:

* prereqs
* validate
* build

e.g.
        .PHONY: prereqs
        prereqs: sshkeyfile puppet_librarian;

        .PHONY: validate
        validate: check_vars check_aws_access
            @packer validate $(PACKER_JSON)

        .PHONY: build
        build: prereqs validate ## do stuff
            PACKER_LOG=$(PACKER_LOG) packer build $(PACKER_DEBUG) $(PACKER_JSON)

# product.mak

Contains the basic recipes used to packerise an app.

This one does not presuppose any reliance on running puppet or ansible, so don't expect
any puppet-librarian commands or anything.

Check out microservice\_puppet.mak if you want something like that.
