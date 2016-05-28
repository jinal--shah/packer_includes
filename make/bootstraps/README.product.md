# "PRODUCT"

## Env Vars

### MANDATORY for packer

* AMI\_NAME: generated for you. Assumes this is based on a centos 6.5 build.

* AWS\_ACCESS\_KEY\_ID: must be passed to `make`

* AWS\_INSTANCE\_TYPE: user-definable. See default under user_vars/product.mak

* AWS\_REGION: user-definable. See default under user_vars/product.mak

* AWS\_SECRET\_ACCESS\_KEY:  must be passed to `make`

* AMI\_SOURCE\_ID: generated for you based on an aws cli call.

* BUILD\_GIT\_BRANCH: branch of **your project's repo**, not packer_includes

* BUILD\_GIT\_ORG: github org of **your project's repo**, not packer_includes

* BUILD\_GIT\_REPO: github uri to **your project's repo**, not packer_includes

* BUILD\_GIT\_SHA: commit sha1 of your project's repo at build time.

* BUILD\_TIME: human-readable-ish timestamp %Y%m%d%H%M%S

* EUROSTAR\_SERVICE\_NAME: the product name e.g. booking

* EUROSTAR\_SERVICE\_ROLE: the purpose served by an instance from this AMI e.g gateway

* EUROSTAR\_RELEASE\_VERSION: the version of this build. Can be the git tag of the repo.

* METRICS\_REMOTE\_HOST: metrics service entrypoint - hostname (DNS-resolvable)

* METRICS\_REMOTE\_PORT: metrics service entrypoint - port

* PACKER\_DIR: the base working dir for packer. Usually ./

## Recipes

Run `make` or `make help` to see the summary help info.

### Introspection (Info targets)

        make mandatory_vars # lists env vars that must be defined before packer runs

        make show_env       # shows values of exported env vars before packer would run

        make print_vars     # as above but shows the line in the Makefile (if any) that
                              actually set the value.

### Validation

        make check_vars # succeeds if all mandatory vars are defined

