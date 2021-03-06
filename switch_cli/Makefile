include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=switch_cli
PKG_SOURCE_VERSION:=1.0.8
PKG_RELEASE:=1
PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://git.prpl.dev/intel/switch_cli.git
PKG_SOURCE_VERSION:=8c93ff7cd307792e5f90897cf669c37fec7ce6b2
PKG_CONFIG_DEPENDS:=CONFIG_SWITCH_CLI_HELP_PRINTOUT
PKG_FIXUP:=autoreconf
PKG_LICENSE:=Intel

include $(INCLUDE_DIR)/package.mk

define Package/switch_cli
  SECTION:=intel
  CATEGORY:=Intel
  TITLE:=Ethernet Switch Command Line Utility
  DEPENDS:=@(TARGET_intel_mips_xrx500||TARGET_intel_mips_prx300)
  URL:=http://www.intel.com
  MAINTAINER:=Intel Corporation
  MENU:=1
endef

define Package/switch_cli/description
  Advanced Utility for Ethernet Switch driver with ioctl support
endef

define Package/switch_cli/config
  menu "switch_cli features"
	depends on PACKAGE_switch_cli
	config SWITCH_CLI_HELP_PRINTOUT
	bool 'Help text'
	default y
	help
	  Compiles in helpful text information for every command and parameter.
	  This help text increases the overall code size.
	  Remove the help text option in case you want to get code size
	  optimized footprint.
	endmenu
endef

CONFIGURE_ARGS += \
	--enable-kernelincl="$(LINUX_DIR)/include/net/switch_api/" \
	--enable-gswip \
	$(call autoconf_bool,CONFIG_SWITCH_CLI_HELP_PRINTOUT,printhelp)

define Package/switch_cli/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/switch_cli $(1)/usr/bin/
endef

$(eval $(call BuildPackage,switch_cli))
