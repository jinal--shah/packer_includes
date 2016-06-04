# vim: ts=4 st=4 sr noet smartindent syntax=make:
AMI_SOURCE_GIT_REPO?=*
AMI_SOURCE_GIT_ORG?=*
AMI_SOURCE_GIT_BRANCH?=*
AMI_SOURCE_GIT_SHA?=*
AMI_SOURCE_GIT_TAG?=*
AMI_SOURCE_CHANNEL?=stable
export AWS_ACCESS_KEY_ID?=
export AWS_INSTANCE_TYPE?=t2.small
export AWS_REGION?=eu-west-1
export AWS_SECRET_ACCESS_KEY?=
# PACKER_LOG: set to 1 for verbose - but the security-conscious be warned:
#             this will log all env var values including aws access creds ...
# PACKER_DEBUG: set to -debug for breakpoint mode. BUT, BUT, BUT ...
#               THERE IS A BUG IN PACKER 0.10.0 - DEBUG WILL HANG
#
export EUROSTAR_SERVICE_NAME?=
export EUROSTAR_SERVICE_ROLE?=
export EUROSTAR_RELEASE_VERSION?=
export METRICS_REMOTE_HOST?=
export METRICS_REMOTE_PORT?=
export PACKER?=$(shell which packer)
export PACKER_DEBUG?=
export PACKER_LOG?=
export PACKER_DIR?=./
export PACKER_INCLUDES_GIT_TAG?=
