
##############################################################
#
# AESD-ASSIGNMENTS
#
##############################################################

#TODO: Fill up the contents below in order to reference your assignment 3 git contents
AESD_ASSIGNMENTS_VERSION = 694bb2fad02286af36c9ed2a765c85bc4c568880
# Note: Be sure to reference the *ssh* repository URL here (not https) to work properly
# with ssh keys and the automated build/test system.
# Your site should start with git@github.com:
AESD_ASSIGNMENTS_SITE = 'git@github.com:LiamThornback/LinuxSystemProgrammingAndBuildrootCourseraCourse-A3.git'
AESD_ASSIGNMENTS_SITE_METHOD = git
AESD_ASSIGNMENTS_GIT_SUBMODULES = YES

# define AESD_ASSIGNMENTS_BUILD_CMDS
# 	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)/finder-app all
# endef

# TODO add your writer, finder and finder-test utilities/scripts to the installation steps below
# define AESD_ASSIGNMENTS_INSTALL_TARGET_CMDS
# 	# create the configuration directory on the target
# 	$(INSTALL) -d 0755 $(@D)/conf/ $(TARGET_DIR)/etc/finder-app/conf/
# 
# 	# install configuration files with correct permissions
# 	$(INSTALL) -m 0755 $(@D)/conf/* $(TARGET_DIR)/etc/finder-app/conf/
# 
# 	# install test scripts in /bin
# 	$(INSTALL) -m 0755 $(@D)/assignment-autotest/test/assignment4/* $(TARGET_DIR)/bin
# 
# 	# install the writer executable in /bin
# 	$(INSTALL) -m 0755 $(@D)/finder-app/writer $(TARGET_DIR)/bin
# 
# 	# install the finder script in /bin
# 	$(INSTALL) -m 0755 $(@D)/finder-app/finder.sh $(TARGET_DIR)/bin
# 
# 	# install the finder test script in /bin
# 	$(INSTALL) -m 0755 $(@D)/finder-app/finder-test.sh $(TARGET_DIR)/bin
# endef

##############################################################
# Compiling the aesdsocket program
##############################################################

define AESD_ASSIGNMENTS_BUILD_CMDS
    $(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/server clean
    $(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/server \
        CC="$(TARGET_CC)" \
        CFLAGS="$(TARGET_CFLAGS)"
endef

##############################################################
# What files go into the target root file-system
##############################################################

define AESD_ASSIGNMENTS_INSTALL_TARGET_CMDS
    # 1. The daemon binary
    $(INSTALL) -D -m 0755 $(@D)/server/aesdsocket \
        $(TARGET_DIR)/usr/bin/aesdsocket
    # 2. The SysV init script – name must start with S99 to run late in boot
    $(INSTALL) -D -m 0755 $(@D)/server/aesdsocket-start-stop \
        $(TARGET_DIR)/etc/init.d/S99aesdsocket
endef

# ---- START DEBUG BLOCK ----
define AESD_ASSIGNMENTS_CHECK_SSH_ENV
    @echo "============================================="
    @echo " SSH Environment Check Inside Buildroot Make "
    @echo "============================================="
    @echo "User: $$(shell whoami)"
    @echo "Home: $${HOME}"
    @echo "SSH_AUTH_SOCK: $${SSH_AUTH_SOCK}"
    @echo "--- ssh-add -l ---"
    @ssh-add -l || echo "ssh-add command failed or no keys found"
    @echo "--- ls -la ~/.ssh ---"
    @ls -la $${HOME}/.ssh || echo "Could not list ~/.ssh"
    @echo "--- ssh -Tvvv git@github.com ---"
    @ssh -Tvvv git@github.com || echo "SSH test connection failed"
    @echo "============================================="
    @echo " End SSH Environment Check                   "
    @echo "============================================="
endef
AESD_ASSIGNMENTS_PRE_DOWNLOAD_HOOKS += AESD_ASSIGNMENTS_CHECK_SSH_ENV
# ---- END DEBUG BLOCK ----

$(eval $(generic-package))
