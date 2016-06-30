# vim: ts=4 st=4 sr noet smartindent syntax=make ft=make:

.PHONY: clean
clean: ## delete build assets
	@rm -rf $(PUPPET_DIR)

.PHONY: prereqs
prereqs: no_detached_head sshkeyfile get_puppet ## set up build env

.PHONY: validate
validate: check_vars check_includes check_for_changes valid_packer ## check build env is sane

.PHONY: build
build: prereqs validate tag_project ## run prereqs, validate then build.
	@PACKER_LOG=$(PACKER_LOG) packer build $(PACKER_DEBUG) "$(PACKER_JSON)"

PUPDIR=$(PUPPET_DIR)
PUPGB=$(PUPPET_BRANCH)
PUPGR=$(PUPPET_REPO)
PUPGT=$(PUPPET_GIT_TAG)
.PHONY: get_puppet
get_puppet: ## fetch puppet modules and run puppet librarian
	@if [[ ! -e "$(PUPDIR)" ]]; then                                  \
	    echo -e "\033[1;37m$(PUPDIR) doesn't exist - cloning.\033[0m"  \
	    && git clone --branch $(PUPGB) $(PUPGR) $(PUPDIR)             \
	    && cd $(PUPDIR)                                               \
	    && [[ -z "$(PUPGT)" ]]                                        \
	    || echo -e "\033[1;37mchecking out tag $(PUPGT)\033[0m"        \
	    && git checkout $(PUPGT);                                     \
	else                                                              \
	    echo -e "\033[1;37m... $(PUPDIR) already exists.\033[0m"       \
	    && echo -e "\033[1;37mRun 'make clean' to start fresh.\033[0m"; \
	fi;
	@echo -e "\033[1;37mRunning librarian-puppet in $(PUPDIR)\033[0m" \
	&& cd $(PUPPET_DIR) && librarian-puppet install;

