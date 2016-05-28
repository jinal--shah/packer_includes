[100]: https://github.com/jinal--shah/packer_base_centos/blob/master/uploads/cloud-init/usr/local/bin/cloud-init/README.md
# HOWTO: Create a Product's AMIs.

Quickstart to show you what your project repo will need to create
a new product.

## Example use-case: api gateway (no puppet or ansible etc ...)

... want to build an api proxy (simple rpm install on centos 6)

The config of each instance is customised based on the env in which the
instance launches.

**These env or instance-specific customisations will be handled at instance-up**
**time by cloud-init.**

The api proxy is a simple rpm install with a config file /etc/api\_proxy/vhost.conf

That config file will be modified by a user-data script

## 1. Create a project repo structure

        api_gateway                 # product name: $EUROSTAR_SERVICE_NAME
        │
        ├── .gitignore              # at minimum exclude **/packer_includes, **/*.pem
        │
        └── packer                  # all packer assets live under here.
            │
            └── proxy               # instance's role: $EUROSTAR_SERVICE_ROLE
                │
                ├── scripts         # to run during packer build, install stuff.
                │
                └── uploads         # contains overlay files
                    │
                    └── cloud-init  # files embedded in AMI under /usr/local/bin/cloud-init
                        │
                        └── usr
                            └── local
                                └── bin
                                    └── cloud-init # scripts to run via user-data
                                                     to customise vhost.conf

**See [this README] [100] for more information about the way we use cloud-init.**



## 2. Packer\_includes library files

        cd api_gateway/packer/proxy
        git clone git@github.com:jinal--shah/packer_includes.git # assumes ssh access to repo
        git checkout refs/tags/1.0.0


## 3. Makefile

In this case we can merely include packer_includes/make/bootstraps/product.mak - this declares
all default eurostar and aws environment vars required to build. It also includes all
of the `make` recipes we want.

        # api_gateway/packer/proxy/Makefile
        include packer_includes/make/bootstraps/product.mak

## 4. Build scripts and app config

Add a script under the scripts dir to perform the install:

```bash
        #!/bin/sh
        # api_gateway/packer/proxy/scripts/install_proxy.sh
        # ... assumes RHEL-based build
        
        # ... prereqs met or fail: need epel
        [[ -r /etc/yum.repos.d/epel.repo ]] || exit 1

        # ... install stuff
        yum -y install api_gateway --enablerepo epel
        chkconfig api_gateway off   # we will start it via cloud-init

        # ... verify
        curl -s http://localhost/_health  | grep 'OK' || exit 1

        service api_gateway stop # started after configured by cloud-init
```

Put any file assets that should live on the host under uploads/<role name>.

e.g.
        api_gateway/.../uploads/proxy
                                └── etc
                                    └── api_gateway
                                        └── vhosts.conf

## 5. Add a cloud-init script to customise vhosts.conf

Write the script in any language as long as the vm can run
the command to execute it.

        .../uploads/cloud-init/usr/local/bin/cloud-init
                                             └── 00060-configure_api_proxy.sh


## 6. Create your packer.json

The product.default.json file might be enough ...

If not, create your own called packer.json in  api\_gateway/packer/proxy/

## 7. Environment Variables for Make

Everything that the Make file is about (other than validations and prereqs)
is to make sure packer is passed the correct environment variables.

Read ./bootstraps/README.product.md to see what is required.

So what are you waiting for? Build it!


