include $(TOPDIR)/rules.mk

PKG_NAME:=vrx518_ppe_fw
PKG_VERSION:=1.3.7
PKG_RELEASE:=1
PKG_SOURCE_DATE:=2019-10-24
PKG_SOURCE_VERSION:=0537848df78f7bb091fb5dc0f32bc7a16aaace98
PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://git.prpl.dev/intel/vrx518_ppe_fw.git

include $(INCLUDE_DIR)/package.mk

define Package/vrx518_ppe_fw
  SECTION:=intel
  CATEGORY:=Intel
  TITLE:=VRX518 PPE firmware
  URL:=http://www.intel.com
  MAINTAINER:=Intel
endef

define Package/vrx518_ppe_fw/description
	VRX518 PPE firmware
endef

Build/Compile=

define Package/vrx518_ppe_fw/install
	$(INSTALL_DIR) $(1)/lib/firmware

ifeq ($(CONFIG_TARGET_lantiq_xrx330),y)
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/platform/xrx330/ppe_fw.bin $(1)/lib/firmware/
endif
ifeq ($(CONFIG_TARGET_lantiq_xrx500),y)
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/platform/xrx500/ppe_fw.bin $(1)/lib/firmware/
endif
ifeq ($(CONFIG_TARGET_intel_mips_xrx500),y)
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/platform/xrx500/ppe_fw.bin $(1)/lib/firmware/
endif
ifeq ($(CONFIG_TARGET_x86_puma),y)
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/platform/xrx750/ppe_fw.bin $(1)/lib/firmware/
endif
endef

$(eval $(call BuildPackage,vrx518_ppe_fw))
