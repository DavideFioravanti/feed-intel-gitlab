#
# Copyright (C) 2008 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
# $Id: $

include $(TOPDIR)/rules.mk

PKG_NAME:=ltq-voice-vmmc-xrx500-firmware
PKG_VERSION:=1.2.11.10.0
PKG_HASH:=602e59a5bd20be0e38311155f8b35033847902f43941ef1ba2d5f65658294304
PKG_BASE_NAME:=fw_voip_xrx500

PKG_SOURCE:=$(PKG_BASE_NAME)-$(PKG_VERSION).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_BASE_NAME)-$(PKG_VERSION)
PKG_RELEASE:=1
PKG_UNPACK:=gzip -dc $(DL_DIR)/$(PKG_SOURCE) | $(TAR) -C $(PKG_BUILD_DIR) $(TAR_OPTIONS)
PKG_SOURCE_URL:=http://localhost
PKG_TARGET_BASE_NAME:=xrx500_firmware.bin
FIRMWARE_DIR=/lib/firmware
VOICEFW_DIR=$(FIRMWARE_DIR)/voice

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  SECTION:=intel
  CATEGORY:=Intel
  SUBMENU:=Voice Subsystem
  TITLE:=xRX500 family voice firmware
  URL:=http://www.intel.com/
  MAINTAINER:=Intel Corporation
  DEPENDS:=ltq-voice-tapi
  MENU:=1
endef

define Package/$(PKG_NAME)/description
	xRX500 voice firmware.
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/$(FIRMWARE_DIR)
	$(INSTALL_DIR) $(1)/$(VOICEFW_DIR)
	$(CP) $(PKG_BUILD_DIR)/fw*.bin $(1)/$(VOICEFW_DIR)/$(PKG_BASE_NAME)-$(PKG_VERSION).bin
	ln -snf $(VOICEFW_DIR)/$(PKG_BASE_NAME)-$(PKG_VERSION).bin $(1)/$(FIRMWARE_DIR)/$(PKG_TARGET_BASE_NAME)
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
