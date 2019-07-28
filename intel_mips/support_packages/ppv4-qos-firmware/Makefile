include $(TOPDIR)/rules.mk

PKG_NAME:=ppv4-qos-firmware
PKG_BASE_NAME:=ppv4-qos-fw
PKG_VERSION:=1.0.4
PKG_RELEASE:=1
PKG_SOURCE:=$(PKG_BASE_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=http://localhost
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_BASE_NAME)-$(PKG_VERSION)
PKG_LICENSE:=Intel
PKG_LICENSE_FILES:=LICENSE

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  TITLE:=PPv4 QoS Firmware
  SECTION:=intel
  CATEGORY:=Intel
  MAINTAINER:=Intel
  DEPENDS:=@TARGET_intel_mips_falcon_mountain
endef

define Package/$(PKG_NAME)/config
  $(call Package/$(PKG_NAME)/override_version)
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/lib/firmware/
	$(CP) $(PKG_BUILD_DIR)/ppv4-qos-fw.bin $(1)/lib/firmware/ppv4-qos-fw.bin
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
