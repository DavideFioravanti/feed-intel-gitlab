include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=intel_qoscli
PKG_VERSION:=1.1.0.0
PKG_RELEASE:=1
PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://git.prpl.dev/intel/cli_qos_src.git
PKG_SOURCE_VERSION:=2cc95cec7affd91f2d60b0897392eda9776109d9

include $(INCLUDE_DIR)/package.mk
ifeq ($(CONFIG_FEATURE_HOST_ENVIR),y)
  include $(INCLUDE_DIR)/host-build.mk
endif

define Package/intel_qoscli
  SECTION:=intel
  CATEGORY:=Intel
  TITLE:=Intel QoS CLI module
  DEPENDS:= +intel_qosfapi +libhelper +libsafec
endef

define Package/intel_qoscli/description
	This package contains QoS CLI module
endef

ifeq ($(CONFIG_TARGET_lantiq_xrx200),y)
  IFX_CFLAGS_y +=-DPLATFORM_XRX288
endif
ifeq ($(CONFIG_TARGET_lantiq_xrx330),y)
  IFX_CFLAGS_y +=-DPLATFORM_XRX330
  export PLATFORM_XRX330=1
endif
ifeq ($(CONFIG_TARGET_lantiq_xrx300),y)
  IFX_CFLAGS_y +=-DPLATFORM_XRX300
endif
ifeq ($(CONFIG_TARGET_lantiq_xrx500),y)
  export PLATFORM_XRX500=1
  IFX_CFLAGS_y +=-DPLATFORM_XRX500
endif
ifeq ($(CONFIG_TARGET_x86_puma),y)
  export PLATFORM_PUMA=1
  IFX_CFLAGS_y +=-DPLATFORM_PUMA
ifeq ($(CONFIG_PACKAGE_kmod-lan_port_separation),y)
  export ENABLE_LAN_PORT_SEPARATION=1
  IFX_CFLAGS_y +=-DENABLE_LAN_PORT_SEPARATION
endif
endif

FX_CFLAGS_y +=-DPLATFORM_XML='\"$(VENDOR_PATH)\"'
IFX_CFLAGS:=$(IFX_CFLAGS_y) -I$(STAGING_DIR)/usr/include
TARGET_CFLAGS += $(IFX_CFLAGS) -I$(STAGING_DIR)/usr/include/qosfapi
TARGET_LDFLAGS += -L$(STAGING_DIR)/usr/lib/qosfapi
CFLAGS="$(TARGET_CFLAGS) "
EXTRA_CFLAGS += -DCONFIG_LANTIQ_OPENWRT

define Package/intel_qoscli/install
	$(INSTALL_DIR) $(1)/$(VENDOR_PATH)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/qos_cli $(1)/$(VENDOR_PATH)/usr/sbin/.
	cd $(1)/$(VENDOR_PATH)/usr/sbin; \
		ln -s qos_cli qoscfg; \
		ln -s qos_cli qcfg; \
		ln -s qos_cli ifcfg; \
		ln -s qos_cli classcfg
endef

$(eval $(call BuildPackage,intel_qoscli))
