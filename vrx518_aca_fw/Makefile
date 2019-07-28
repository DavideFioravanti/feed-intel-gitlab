include $(TOPDIR)/rules.mk

PKG_NAME:=vrx518_aca_fw
PKG_VERSION:=1.5.0
PKG_RELEASE:=1
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=http://sources.openwrt.org/
PKG_HASH:=36f811df89ecd659f94e7b55d6b18954ccb1712385bd35a8ab555955df412fb6

include $(INCLUDE_DIR)/package.mk

define Package/vrx518_aca_fw
  SECTION:=intel
  CATEGORY:=Intel
  TITLE:=VRX518 ACA firmware
  URL:=http://www.intel.com
  MAINTAINER:=Intel
endef

define Package/vrx518_aca_fw/description
	VRX518 ACA firmware
endef

Build/Compile=

define Package/vrx518_aca_fw/install
	$(INSTALL_DIR) $(1)/lib/firmware/09a9
ifeq ($(CONFIG_TARGET_lantiq_xrx220),y)
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/platform/xrx200/aca_fw.bin $(1)/lib/firmware/09a9
endif
ifeq ($(CONFIG_TARGET_lantiq_xrx330),y)
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/platform/xrx330/aca_fw.bin $(1)/lib/firmware/09a9
endif
ifeq ($(CONFIG_TARGET_lantiq_xrx500),y)
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/platform/xrx500/aca_fw.bin $(1)/lib/firmware/09a9
endif
ifeq ($(CONFIG_TARGET_intel_mips_xrx500),y)
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/platform/xrx500/aca_fw.bin $(1)/lib/firmware/09a9
endif
ifeq ($(CONFIG_TARGET_x86_puma),y)
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/platform/xrx750/aca_fw.bin $(1)/lib/firmware/09a9
endif
endef

$(eval $(call BuildPackage,vrx518_aca_fw))
