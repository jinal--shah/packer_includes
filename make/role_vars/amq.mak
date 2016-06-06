# vim: ts=4 st=4 sr noet smartindent syntax=make ft=make:
export MANDATORY_VARS+= \
	ACTIVEMQ_USER       \
	ACTIVEMQ_PASS

export ACTIVEMQ_USER?=
export ACTIVEMQ_PASS?=

# ... lots of installation happens after deployment, and
# we use the same puppet modules for that, so don't delete
# them from the AMI.
export KEEP_PUPPET=true
