# packer\_includes

*This repo must not contain any product-specific stuff.*

That should belong in your specific product repo.

This one contains:

* ./make: Makefile snippets (includes), that will do all of the heavy lifting

* ./json: Some commonly used packer json - use them or treat them as reference

* ./scripts: build scripts used during packering

* ./uploads: common assets we always upload to our image before packerising.

## groups: product, microservice\_puppet, role

### product
Assets grouped under a product subdir are expected to be invoked or uploaded
for anything you build using this repo.

### microservice\_puppet
Assets under microservice\_puppet are additional fixtures we use specifically
for, well, those microservice amis built using puppet.

### role/\*
The role subdir will contain additional subdirs named after the finite list
of values that $EUROSTAR\_SERVICE\_ROLE can take.

e.g. role/amq

Assets under each role subdir are to be invoked when building an ami for that
kind of role.

This would be in addition to anything under microservice_puppet and / or product.
