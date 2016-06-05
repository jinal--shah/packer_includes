# vim: ts=4 st=4 sr noet smartindent syntax=make:
# ... if the including product-role dir contains a custom packer.json
# .e.g because the default json is unsuitable, it will be used
# instead of the default

# ... PACKER_JSON
# - in order of precedence use the first of:
# 1. project specific 'packer.json' file in the dir in which Make is invoked
# 2. packer_includes role file (e.g. product-amq.json or microservice_puppet-amq.json)
# 3. packer_includes default artefact file e.g. product.json or microservice_puppet.json
CUSTOM_JSON := $(strip $(wildcard packer.json))
ROLE_JSON_FILE := packer_includes/json/$(ARTEFACT_TYPE)-$(EUROSTAR_SERVICE_ROLE).json
ROLE_JSON := $(strip $(wildcard $(ROLE_JSON_FILE)))
ifeq ($(CUSTOM_JSON),)
ifeq ($(ROLE_JSON),)
	PACKER_JSON=packer_includes/json/$(ARTEFACT_TYPE).json
else
	PACKER_JSON=$(ROLE_JSON)
endif
else
	PACKER_JSON=$(CUSTOM_JSON)
endif

export PACKER_JSON

# BUILD_GIT_*: used to AWS-tag the built AMI, and generate its unique name
#              so we can trace its provenance later.
#
# ... to rebuild using same version of tools, we can't trust the git tag
# but the branch, sha and repo, because git tags are mutable and movable.
export BUILD_GIT_TAG:=$(shell git describe --exact-match HEAD 2>/dev/null)
ifeq ($(BUILD_GIT_TAG),)
	export BUILD_GIT_BRANCH:=$(shell git describe --contains --all HEAD)
else
	export BUILD_GIT_BRANCH:=detached_head
endif
export BUILD_GIT_SHA:=$(shell git rev-parse --short=$(GIT_SHA_LEN) --verify HEAD)
export BUILD_GIT_REPO:=$(shell \
	git remote show -n origin  \
	| grep '^ *Push *'         \
	| awk {'print $$NF'}       \
)
export BUILD_GIT_ORG:=$(shell \
	echo $(BUILD_GIT_REPO)               \
	| sed -e 's!.*[:/]\([^/]\+\)/.*!\1!' \
)
export BUILD_TIME:=$(shell date +%Y%m%d%H%M%S)

AWS_TAG_SOURCE_OS_INFO:=os<$(AMI_SOURCE_OS)>os_release<$(AMI_SOURCE_OS_RELEASE)>
AWS_TAG_SOURCE_GIT_INFO:=repo<$(AMI_SOURCE_GIT_REPO)>branch<$(AMI_SOURCE_GIT_BRANCH)>
AWS_TAG_SOURCE_GIT_REF:=tag<$(AMI_SOURCE_GIT_TAG)>sha<$(AMI_SOURCE_GIT_SHA)>

# AMI_SOURCE_ID: ami that this new one builds on, determined by make
export AMI_SOURCE_ID?=$(shell                                            \
	aws --cli-read-timeout 10 ec2 describe-images --region $(AWS_REGION) \
	--filters 'Name=manifest-location,Values=$(AMI_SOURCE_FILTER)'       \
	          'Name=tag:os_info,Values=$(AWS_TAG_SOURCE_OS_INFO)'        \
	          'Name=tag:build_git_info,Values=$(AWS_TAG_SOURCE_GIT_INFO)'\
	          'Name=tag:build_git_ref,Values=$(AWS_TAG_SOURCE_GIT_REF)'  \
	          'Name=tag:channel,Values=$(AMI_SOURCE_CHANNEL)'            \
	--query 'Images[*].[ImageId,CreationDate]'                           \
	--output text                                                        \
	| sort -k2 | tail -1 | awk {'print $$1'}                             \
)

# ... value of source ami's ami_sources tag used as prefix for this ami's sources tag
#     to show provenance.
export AMI_PREVIOUS_SOURCES:=$(shell                                     \
	aws --cli-read-timeout 10 ec2 describe-tags --region $(AWS_REGION)   \
	--filters 'Name=resource-id,Values=$(AMI_SOURCE_ID)'                 \
	          'Name=key,Values=ami_sources'                              \
	--query 'Tags[*].Value'                                              \
	--output text                                                        \
)

export AMI_OS=$(AMI_SOURCE_OS)
export AMI_OS_RELEASE=$(AMI_SOURCE_OS_RELEASE)
export AMI_OS_INFO=$(AMI_OS)-$(AMI_OS_RELEASE)

PRODUCT_DETAILS=$(EUROSTAR_SERVICE_NAME)-$(EUROSTAR_SERVICE_ROLE)-$(EUROSTAR_RELEASE_VERSION)
DESC_TXT=$(EUROSTAR_SERVICE_NAME);$(EUROSTAR_SERVICE_ROLE);$(EUROSTAR_RELEASE_VERSION)
export AMI_DESCRIPTION=$(AMI_OS_INFO): $(DESC_TXT)

# AMI_NAME : must be unique in AWS account, so we can locate it unambiguously.
export AMI_NAME=$(AMI_PREFIX)-$(PRODUCT_DETAILS)-$(BUILD_GIT_ORG)-$(BUILD_TIME)

export AWS_TAG_AMI_SOURCES:=$(AMI_PREVIOUS_SOURCES)<$(AMI_SOURCE_PREFIX):$(AMI_SOURCE_ID)>
export AWS_TAG_BUILD_GIT_INFO:=repo<$(BUILD_GIT_REPO)>branch<$(BUILD_GIT_BRANCH)>
export AWS_TAG_BUILD_GIT_REF:=tag<$(BUILD_GIT_TAG)>sha<$(BUILD_GIT_SHA)>
export AWS_TAG_OS_INFO:=$(AWS_TAG_SOURCE_OS_INFO)

