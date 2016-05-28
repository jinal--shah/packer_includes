# vim: ts=4 st=4 sr noet smartindent syntax=make:
# ... if the including product-role dir contains a custom packer.json
# .e.g because the default json is unsuitable, it will be used
# instead of the default
CUSTOM_JSON := $(strip $(wildcard packer.json))
ifeq ($(CUSTOM_JSON),)
	PACKER_JSON=packer_includes/json/product.default.json
else
	PACKER_JSON=packer.json
endif

export PACKER_JSON

# BUILD_GIT_*: used to AWS-tag the built AMI, and generate its unique name
#              so we can trace its providence later.
#
# ... to rebuild using same version of tools, we can't trust the git tag
# but the branch, sha and repo, because git tags are mutable and movable.
export BUILD_GIT_BRANCH=$(shell git describe --contains --all HEAD)
export BUILD_GIT_SHA=$(shell git rev-parse --short=$(GIT_SHA_LEN) --verify HEAD)
export BUILD_GIT_REPO=$(shell   \
	git remote show -n origin   \
	| grep '^ *Push *'          \
	| awk {'print $$NF'}        \
)
export BUILD_GIT_ORG=$(shell \
	echo $(BUILD_GIT_REPO)   \
	| sed -e 's!.*[:/]\([^/]\+\)/.*!\1!' \
)
export BUILD_TIME=$(shell date +%Y%m%d%H%M%S)

# AMI_SOURCE_ID: ami that this new one builds on, determined by make
export AMI_SOURCE_ID?=$(shell                                            \
	aws --cli-read-timeout 10 ec2 describe-images --region $(AWS_REGION) \
	--filter 'Name=manifest-location,Values=$(AMI_SOURCE_FILTER)'        \
	--filter 'Name=tag:os,Values=$(AMI_SOURCE_OS)'                       \
	--filter 'Name=tag:os_release,Values=$(AMI_SOURCE_OS_RELEASE)'       \
	--filter 'Name=tag:build_git_org,Values=$(AMI_SOURCE_GIT_ORG)'       \
	--filter 'Name=tag:build_git_branch,Values=$(AMI_SOURCE_GIT_BRANCH)' \
	--filter 'Name=tag:channel,Values=$(AMI_SOURCE_CHANNEL)'             \
	--query 'Images[*].[ImageId,CreationDate]'                           \
	--output text                                                        \
	| sort -k2 | tail -1 | awk {'print $$1'}                             \
)
export AMI_OS=$(AMI_SOURCE_OS)
export AMI_OS_RELEASE=$(AMI_SOURCE_OS_RELEASE)
export AMI_OS_INFO=$(AMI_OS)-$(AMI_OS_RELEASE)
export AMI_NAME_GIT_INFO=$(BUILD_GIT_SHA)-$(BUILD_GIT_BRANCH)
PRODUCT_DETAILS=$(EUROSTAR_SERVICE_NAME)-$(EUROSTAR_SERVICE_ROLE)-$(EUROSTAR_RELEASE_VERSION)
DESC_TXT=$(EUROSTAR_SERVICE_NAME);$(EUROSTAR_SERVICE_ROLE);$(EUROSTAR_RELEASE_VERSION)
export AMI_DESCRIPTION=$(AMI_OS_INFO): $(DESC_TXT)
# AMI_NAME : must be unique in AWS account, so we can locate it unambiguously.
export AMI_NAME=$(AMI_PREFIX)-$(PRODUCT_DETAILS)-$(BUILD_TIME)-$(AMI_NAME_GIT_INFO)

