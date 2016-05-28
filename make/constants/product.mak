# vim: ts=4 st=4 sr noet smartindent syntax=make ft=make:
AMI_PREFIX=eurostar_product
AMI_SOURCE_OS=centos
AMI_SOURCE_OS_RELEASE=6.5
GIT_SHA_LEN=8
export AMI_SOURCE_FILTER=*/eurostar_monlog-*
export SHELL=/bin/bash
export SSH_KEYPAIR_NAME=eurostar
# SSH_PRIVATE_KEY_FILE ... for build this is the AWS dev account's 'eurostar' key
export SSH_PRIVATE_KEY_FILE=eurostar.pem
export SSH_USERNAME=ec2-user

