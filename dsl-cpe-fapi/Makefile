#
# Copyright (C) 2017 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=dsl-cpe-fapi
PKG_SOURCE_VERSION:=0.7.1
PKG_RELEASE:=1
PKG_BASE_NAME:=dsl_cpe_fapi
PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://git.prpl.dev/intel/dsl_cpe_api.git
PKG_SOURCE_VERSION:=bbe7b9f847d26a941b63636e1d096082100dde23
DSL_BIN_DIR=/$(VENDOR_PATH)/bin

PKG_FIXUP:=autoreconf
PKG_FIXUP:=libtool
PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk

# Get config values from general image config or other packages in dependency list
# Definition of these values will be overtaken from package 'dsl-cpe-mei-vrx'

# Set default config values if necessary (not defined before)

define Package/$(PKG_NAME)
	SECTION:=intel
	CATEGORY:=Intel
	TITLE:=DSL CPE FAPI shared lib
	URL:=http://www.intel.com/
	MAINTAINER:=Intel Corporation
	DEPENDS:= +libpthread +librt +dsl-cpe-control-vrx +PACKAGE_safeclibs:safeclibs
	MENU:=1
endef

define Package/$(PKG_NAME)/description
	This package contains the DSL CPE FAPI.
endef

define Package/$(PKG_NAME)/config
$(call Package/$(PKG_NAME)/override_version)
$(call Package/$(PKG_NAME)/override_source_path)
$(call Package/$(PKG_NAME)/config_debug_level)
source "$(SOURCE)/Config.in"
endef

CONFIGURE_ARGS += \
	--enable-vrx \
	--enable-driver-include="-I$(STAGING_DIR)/usr/include/drv_dsl_cpe_api" \
	--enable-ifxos-include="-I$(STAGING_DIR)/usr/include/ifxos" \
	--enable-ifxos-library="-L$(STAGING_DIR)/usr/lib" \
	--enable-dsl-fapi-include="-I$(STAGING_DIR)/usr/include/dsl-fapi" \
	--enable-dsl-fapi-library="-L$(STAGING_DIR)/usr/lib" \
	--disable-cli
#	--enable-cli \
#	--enable-cli-include="-I$(STAGING_DIR)/usr/include/cli" \
#	--enable-cli-library="-L$(STAGING_DIR)/usr/lib"	\

#ifeq ($(CONFIG_dsl-cpe-fapi_FAPI_DAEMON),y)
#CONFIGURE_ARGS += --enable-dsl-fapi-daemon=yes
#else
CONFIGURE_ARGS += --enable-dsl-fapi-daemon=no
#endif

TARGET_CFLAGS += -I$(LINUX_DIR)/user_headers/include/net/ -I$(LINUX_DIR)/user_headers/include/ -I$(LINUX_DIR)/include/

ifeq ($(CONFIG_USE_MUSL),y)
TARGET_CFLAGS += -DCONFIG_USE_MUSL
endif

ifeq ($(CONFIG_PACKAGE_safeclibs),y)
CONFIGURE_ARGS += \
	--enable-safec-support=yes \
	--enable-safec-include="-I$(STAGING_DIR)/usr/include" \
	--enable-safec-library="-L$(STAGING_DIR)/usr/lib"
endif

define Build/Configure
	# remove "configured" stamps of other configs
	@- rm $(PKG_BUILD_DIR)/.configured*
	$(call Build/Configure/Default)
endef

define Build/Clean
	@- rm -Rf $(PKG_BUILD_DIR)/ipkg*
	@- [ -e $(PKG_BUILD_DIR)/Makefile ] && $(MAKE) -C $(PKG_BUILD_DIR) clean
	$(call Build/Clean/Default)
endef

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/{lib,include/dsl-fapi}
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/include/* $(1)/usr/include/dsl-fapi
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/dsl_fapi_config.h $(1)/usr/include/dsl-fapi
	mkdir -p $(1)/usr/lib
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/lib/*.{a,la,so*} $(1)/usr/lib/
endef

define Build/UninstallDev
	- rm -f $(1)/usr/lib/libdslfapi*.*
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/lib
	cd $(1)/usr/lib && rm -f "libdslfapi.so.0" && ln -s "../../$(VENDOR_PATH)/usr/lib/libdslfapi.so" "libdslfapi.so.0"
	$(INSTALL_DIR) $(1)/$(VENDOR_PATH)/usr/lib
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/lib/libdslfapi.so $(1)/$(VENDOR_PATH)/usr/lib/
	$(INSTALL_DIR) $(1)/$(DSL_BIN_DIR)
	#$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/dsl_fapid $(1)/$(DSL_BIN_DIR)/
	#$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/dsl_fapi_pipe.sh $(1)/$(DSL_BIN_DIR)/
	$(INSTALL_BIN) ./files/dsl_fapi.cfg $(1)/$(DSL_BIN_DIR)/
	$(INSTALL_DIR) $(STAGING_DIR)/usr/docs
	$(CP) $(PKG_BUILD_DIR)/include/dsl_fapi.h $(STAGING_DIR)/usr/docs/
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
