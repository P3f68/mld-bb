#!/usr/bin/make -f

################################################################################
#
# Build Command für x86_64 
#   - MACHINE=amd64 DISTRO=MLD DISTRO_TYPE=release make image
#
# Build Command für x86_64 
#   - MACHINE=i386 DISTRO=MLD DISTRO_TYPE=release make image
#
# Build raspberrypi
#   - kernel-source
#     https://github.com/agherzan/meta-raspberrypi
# 
################################################################################


# Adjust according to the number CPU cores to use for parallel build.
# Default: Number of processors in /proc/cpuinfo, if present, or 1.
NR_CPU := $(shell [ -f /proc/cpuinfo ] && grep -c '^processor\s*:' /proc/cpuinfo || echo 1)
BB_NUMBER_THREADS ?= $(NR_CPU)
PARALLEL_MAKE ?= -j $(NR_CPU)

XSUM ?= md5sum
DISTRO_TYPE ?= release
DISTRO ?= MLD

BUILD_DIR = $(CURDIR)/builds/$(DISTRO)/$(DISTRO_TYPE)/$(MACHINE)
TOPDIR = $(BUILD_DIR)
DL_DIR = $(CURDIR)/sources
SSTATE_DIR = $(CURDIR)/builds/$(DISTRO)/sstate-cache
TMPDIR = $(TOPDIR)/tmp
DEPDIR = $(TOPDIR)/.deps
MACHINEBUILD = $(MACHINE)
export MACHINEBUILD

BBLAYERS ?= \
	$(CURDIR)/openembedded-core/meta \
	$(CURDIR)/meta-openembedded/meta-oe \
	$(CURDIR)/meta-openembedded/meta-multimedia \
	$(CURDIR)/meta-openembedded/meta-networking \
	$(CURDIR)/meta-openembedded/meta-filesystems \
	$(CURDIR)/meta-openembedded/meta-python \
	$(CURDIR)/meta-mld-source \
	$(CURDIR)/meta-mld-source/meta-hardware/meta-x86 \
	$(CURDIR)/meta-mld-source/meta-hardware/meta-rpi \
	$(CURDIR)/meta-mld-source/meta-hardware/meta-rpi3 \
	$(CURDIR)/meta-mld-source/meta-hardware/meta-sunxi \
<<<<<<< HEAD
	$(CURDIR)/meta-mld-source/meta-hardware/meta-rpi \
    $(CURDIR)/meta-mld-source/meta-system \
=======
        $(CURDIR)/meta-mld-source/meta-system \
>>>>>>> abdad1195364865694ba4fcab0dc81ada92bb32a
	$(CURDIR)/meta-local \

#	$(CURDIR)/meta-yocto/meta-yocto \
#	$(CURDIR)/meta-yocto/meta-yocto-bsp \

#	$(CURDIR)/meta-mld-source/meta-hardware/meta-sunxi \
#	$(CURDIR)/meta-mld-source/meta-hardware/meta-rpi \
#       $(CURDIR)/meta-mld-source/meta-hardware/meta-amlogic \

CONFFILES = \
	$(TOPDIR)/env.source \
	$(TOPDIR)/conf/$(DISTRO).conf \
	$(TOPDIR)/conf/bblayers.conf \
	$(TOPDIR)/conf/local.conf \
	$(TOPDIR)/conf/site.conf

CONFDEPS = \
	$(DEPDIR)/.env.source.$(BITBAKE_ENV_HASH) \
	$(DEPDIR)/.$(DISTRO).conf.$($(DISTRO)_CONF_HASH) \
	$(DEPDIR)/.bblayers.conf.$(BBLAYERS_CONF_HASH) \
	$(DEPDIR)/.local.conf.$(LOCAL_CONF_HASH)

GIT ?= git
GIT_REMOTE := $(shell $(GIT) remote)
GIT_USER_NAME := $(shell $(GIT) config user.name)
GIT_USER_EMAIL := $(shell $(GIT) config user.email)

hash = $(shell echo $(1) | $(XSUM) | awk '{print $$1}')

.DEFAULT_GOAL := all
all: init
	@echo
	@echo "Openembedded for the MLD environment has been initialized"
	@echo "properly. Now you can start building your image, by doing either:"
	@echo
	@echo "MACHINE=amd64 DISTRO=MLD DISTRO_TYPE=release make image"
	@echo "	or"
	@echo "cd $(BUILD_DIR) ; source env.source ; bitbake $(DISTRO)-image"
	@echo

$(BBLAYERS):
	[ -d $@ ] || $(MAKE) $(MFLAGS) update

setupmbuild:
ifeq ($(MACHINEBUILD),amd64)
MACHINE=genericx86-64
MACHINEBUILD=x86
else ifeq ($(MACHINEBUILD),i386)
MACHINE=genericx86
MACHINEBUILD=x86
else ifeq ($(MACHINEBUILD),rpi)
MACHINE=raspberrypi
MACHINEBUILD=rpi
else ifeq ($(MACHINEBUILD),rpi2)
MACHINE=raspberrypi2
MACHINEBUILD=rpi2
else ifeq ($(MACHINEBUILD),rpi3)
MACHINE=raspberrypi3
MACHINEBUILD=rpi3
else ifeq ($(MACHINEBUILD),bpi)
MACHINE=bananapi
MACHINEBUILD=bpi
else ifeq ($(MACHINEBUILD),cubieboard)
MACHINE=cubieboard
MACHINEBUILD=cubieboard
else ifeq ($(MACHINEBUILD),cubieboard2)
MACHINE=cubieboard2
MACHINEBUILD=cubieboard2
else ifeq ($(MACHINEBUILD),cubietruck)
MACHINE=cubietruck
MACHINEBUILD=cubietruck
else ifeq ($(MACHINEBUILD),mele)
MACHINE=mele
MACHINEBUILD=mele
else ifeq ($(MACHINEBUILD),wetekplay)
MACHINE=wetekplay
MACHINEBUILD=wetekplay
endif

initialize: init

init: setupmbuild $(BBLAYERS) $(CONFFILES)

image: init
	@. $(TOPDIR)/env.source && cd $(TOPDIR) && bitbake $(DISTRO)-image

test : init
	@. $(TOPDIR)/env.source && cd $(TOPDIR) && bitbake -c menuconfig busybox


update:
	@echo 'Updating Git repositories...'
	@HASH=`$(XSUM) $(MAKEFILE_LIST)`; \
	if [ -n "$(GIT_REMOTE)" ]; then \
		$(GIT) pull --ff-only || $(GIT) pull --rebase; \
	fi; \
	if [ "$$HASH" != "`$(XSUM) $(MAKEFILE_LIST)`" ]; then \
		echo 'Makefile changed. Restarting...'; \
		$(MAKE) $(MFLAGS) --no-print-directory $(MAKECMDGOALS); \
	else \
		$(GIT) submodule sync && \
		$(GIT) submodule update --init && \
		cd meta-mld-source  && \
		if [ -n "$(GIT_REMOTE)" ]; then \
			$(GIT) checkout master && \
			$(GIT) pull ; \
		fi; \
		echo "The mld-source is now up-to-date." ; \
		cd .. ; \
	fi

.PHONY: all image init initialize update usage machinebuild

BITBAKE_ENV_HASH := $(call hash, \
	'BITBAKE_ENV_VERSION = "0"' \
	'CURDIR = "$(CURDIR)"' \
	'MACHINEBUILD2 = "${MACHINEBUILD}"' \
	)

$(TOPDIR)/env.source: $(DEPDIR)/.env.source.$(BITBAKE_ENV_HASH)
	@echo 'Generating $@'
	@echo 'export BB_ENV_EXTRAWHITE="MACHINE DISTRO MACHINEBUILD"' > $@
	@echo 'export MACHINE' >> $@
	@echo 'export DISTRO' >> $@
	@echo 'export MACHINEBUILD' >> $@
	@echo 'export PATH=$(CURDIR)/openembedded-core/scripts:$(CURDIR)/bitbake/bin:$${PATH}' >> $@

$(DISTRO)_CONF_HASH := $(call hash, \
	'$(DISTRO)_CONF_VERSION = "1"' \
	'CURDIR = "$(CURDIR)"' \
	'BB_NUMBER_THREADS = "$(BB_NUMBER_THREADS)"' \
	'PARALLEL_MAKE = "$(PARALLEL_MAKE)"' \
	'DL_DIR = "$(DL_DIR)"' \
	'SSTATE_DIR = "$(SSTATE_DIR)"' \
	'TMPDIR = "$(TMPDIR)"' \
	)

$(TOPDIR)/conf/$(DISTRO).conf: $(DEPDIR)/.$(DISTRO).conf.$($(DISTRO)_CONF_HASH)
	@echo 'Generating $@'
	@test -d $(@D) || mkdir -p $(@D)
	@echo 'DISTRO_TYPE = "$(DISTRO_TYPE)"' >> $@
	@echo 'SSTATE_DIR = "$(SSTATE_DIR)"' >> $@
	@echo 'TMPDIR = "$(TMPDIR)"' >> $@
	@echo 'BB_GENERATE_MIRROR_TARBALLS = "1"' >> $@
	@echo 'BBINCLUDELOGS = "yes"' >> $@
	@echo 'CONF_VERSION = "1"' >> $@
	@echo 'EXTRA_IMAGE_FEATURES = "debug-tweaks"' >> $@
	@echo 'IMAGE_FEATURES += "package-management"' >> $@ 
	@echo 'PACKAGE_CLASSES ?= "package_deb"' >> $@
	@echo 'USER_CLASSES = "buildstats"' >> $@
	@echo '#PRSERV_HOST = "localhost:0"' >> $@


LOCAL_CONF_HASH := $(call hash, \
	'LOCAL_CONF_VERSION = "0"' \
	'CURDIR = "$(CURDIR)"' \
	'TOPDIR = "$(TOPDIR)"' \
	)

$(TOPDIR)/conf/local.conf: $(DEPDIR)/.local.conf.$(LOCAL_CONF_HASH)
	@echo 'Generating $@'
	@test -d $(@D) || mkdir -p $(@D)
	@echo 'IMAGE_FSTYPES = "iso"' > $@
	@echo 'TOPDIR = "$(TOPDIR)"' > $@
	@echo 'require $(TOPDIR)/conf/$(DISTRO).conf' >> $@

$(TOPDIR)/conf/site.conf: $(CURDIR)/site.conf
	@ln -s ../../../../../site.conf $@

$(CURDIR)/site.conf:
	@echo 'SCONF_VERSION = "1"' >> $@
	@echo 'BB_NUMBER_THREADS = "$(BB_NUMBER_THREADS)"' >> $@
	@echo 'PARALLEL_MAKE = "$(PARALLEL_MAKE)"' >> $@
	@echo 'BUILD_OPTIMIZATION = "-march=native -O2 -pipe"' >> $@
	@echo 'DL_DIR = "$(DL_DIR)"' >> $@
	@echo 'INHERIT += "rm_work"' >> $@

BBLAYERS_CONF_HASH := $(call hash, \
	'BBLAYERS_CONF_VERSION = "0"' \
	'CURDIR = "$(CURDIR)"' \
	'BBLAYERS = "$(BBLAYERS)"' \
	)

$(TOPDIR)/conf/bblayers.conf: $(DEPDIR)/.bblayers.conf.$(BBLAYERS_CONF_HASH)
	@echo 'Generating $@'
	@test -d $(@D) || mkdir -p $(@D)
	@echo 'LCONF_VERSION = "4"' >> $@
	@echo 'BBFILES = ""' >> $@
	@echo 'BBLAYERS = "$(BBLAYERS)"' >> $@

$(CONFDEPS):
	@test -d $(@D) || mkdir -p $(@D)
	@$(RM) $(basename $@).*
	@touch $@
