include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=intel_qosfapi
PKG_VERSION:=1.4.0.0
PKG_RELEASE:=1
PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://git.prpl.dev/intel/fapi_qos.git
PKG_SOURCE_VERSION:=8646c6a272551513a648d0106de1a4ee9b2eb5a3

include $(INCLUDE_DIR)/package.mk
ifeq ($(CONFIG_FEATURE_HOST_ENVIR),y)
  include $(INCLUDE_DIR)/host-build.mk
endif

define Package/intel_qosfapi
  SECTION:=intel
  CATEGORY:=Intel
  TITLE:=Intel QoS FAPI module
  DEPENDS:=+switch_cli +libhelper +libezxml +libubox +libsafec
endef

define Package/intel_qosfapi/description
	This package contains QoS FAPI module
endef

IFX_LDFLAGS_y:= -L$(STAGING_DIR)/usr/lib

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
ifeq ($(CONFIG_PACKAGE_kmod-vrx518_ep),y)
  IFX_CFLAGS_y +=-DVRX518_SUPPORT
endif
IFX_CFLAGS_y +=-DPLATFORM_XML='\"$(VENDOR_PATH)\"'
IFX_CFLAGS_y+= $(if $(SWITCH_INC),-I$(SWITCH_INC))
IFX_CFLAGS:=$(IFX_CFLAGS_y) -I$(STAGING_DIR)/usr/include
IFX_LDFLAGS:=$(IFX_LDFLAGS_y)

TARGET_CFLAGS += -I$(LINUX_DIR)/user_headers/include/net/ -I$(LINUX_DIR)/user_headers/include/ -I$(LINUX_DIR)/include/

CONFIG_OPTS=$(TARGET_CONFIGURE_OPTS)
CFLAGS="$(TARGET_CFLAGS) $(IFX_CFLAGS) "
LDFLAGS="$(IFX_LDFLAGS) "

define Build/InstallDev
	$(INSTALL_DIR) $(STAGING_DIR)/usr/include/qosfapi
	$(CP) $(PKG_BUILD_DIR)/share/*.h $(STAGING_DIR)/usr/include/qosfapi/.
	$(CP) $(PKG_BUILD_DIR)/fapi/fapi_high.h $(STAGING_DIR)/usr/include/qosfapi/.
endef

define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR) \
	$(CONFIG_OPTS) \
	CFLAGS=$(CFLAGS) LDFLAGS=$(LDFLAGS) QOSAL_DIR="$(PKG_BUILD_DIR)"
endef

define Package/intel_qosfapi/install
	$(INSTALL_DIR) $(1)/$(VENDOR_PATH)/usr/sbin
	$(INSTALL_DIR) $(1)/$(VENDOR_PATH)/usr/lib/qosal
	$(CP) $(PKG_BUILD_DIR)/engines/cpu_n/libcpu_n.so $(1)/$(VENDOR_PATH)/usr/lib/qosal/
	$(CP) $(PKG_BUILD_DIR)/engines/switch/libswitch.so $(1)/$(VENDOR_PATH)/usr/lib/qosal/
	$(CP) $(PKG_BUILD_DIR)/engines/ppe_e/libppe_e.so $(1)/$(VENDOR_PATH)/usr/lib/qosal/
	$(if $(CONFIG_TARGET_lantiq_xrx500),$(CP) $(PKG_BUILD_DIR)/engines/ppa/libppa.so $(1)/$(VENDOR_PATH)/usr/lib/qosal/)
	$(if $(CONFIG_TARGET_x86_puma),$(CP) $(PKG_BUILD_DIR)/engines/ppa/libppa.so $(1)/$(VENDOR_PATH)/usr/lib/qosal/)
	$(CP) $(PKG_BUILD_DIR)/ipc/libqosipc.so $(1)/$(VENDOR_PATH)/usr/lib/qosal/
	$(CP) $(PKG_BUILD_DIR)/fapi/libqosfapi.so $(1)/$(VENDOR_PATH)/usr/lib/qosal/
	$(CP) $(PKG_BUILD_DIR)/misc/libsysapi.so $(1)/$(VENDOR_PATH)/usr/lib/qosal/
	$(CP) $(PKG_BUILD_DIR)/utils/libutils.so $(1)/$(VENDOR_PATH)/usr/lib/qosal/
	cd $(1)/$(VENDOR_PATH)/usr/lib/qosal/; \
		for i_file in `ls *.so`; do \
			ln -s qosal/$$$$i_file ../$$$$i_file; \
		done
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/qosd/qosd $(1)/$(VENDOR_PATH)/usr/sbin/.
	$(if $(CONFIG_TARGET_lantiq_xrx200),$(INSTALL_BIN) $(PKG_BUILD_DIR)/qosd/qosal_xrx200_cfg.xml $(1)/$(VENDOR_PATH)/usr/sbin/qosal_plat_cfg.xml)
	$(if $(CONFIG_TARGET_lantiq_xrx300),$(INSTALL_BIN) $(PKG_BUILD_DIR)/qosd/qosal_xrx300_cfg.xml $(1)/$(VENDOR_PATH)/usr/sbin/qosal_plat_cfg.xml)
	$(if $(CONFIG_TARGET_lantiq_xrx330),$(INSTALL_BIN) $(PKG_BUILD_DIR)/qosd/qosal_xrx330_cfg.xml $(1)/$(VENDOR_PATH)/usr/sbin/qosal_plat_cfg.xml)
	$(if $(CONFIG_TARGET_lantiq_xrx500),$(INSTALL_BIN) $(PKG_BUILD_DIR)/qosd/qosal_xrx500_cfg.xml $(1)/$(VENDOR_PATH)/usr/sbin/qosal_plat_cfg.xml)
	$(if $(CONFIG_TARGET_x86_puma),$(INSTALL_BIN) $(PKG_BUILD_DIR)/qosd/qosal_xrx700_cfg.xml $(1)/$(VENDOR_PATH)/usr/sbin/qosal_plat_cfg.xml)
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/qosd/qos_def_cfg.xml $(1)/$(VENDOR_PATH)/usr/sbin/qos_def_cfg.xml
	$(INSTALL_DIR) $(STAGING_DIR)/usr/include/qosfapi
	$(CP) $(PKG_BUILD_DIR)/share/*.h $(STAGING_DIR)/usr/include/qosfapi/.
	$(CP) $(PKG_BUILD_DIR)/fapi/fapi_high.h $(STAGING_DIR)/usr/include/qosfapi/.
	$(INSTALL_DIR) $(STAGING_DIR)/usr/lib/qosfapi
	$(CP) $(PKG_BUILD_DIR)/ipc/libqosipc.so $(STAGING_DIR)/usr/lib/qosfapi/.
	$(CP) $(PKG_BUILD_DIR)/fapi/libqosfapi.so $(STAGING_DIR)/usr/lib/qosfapi/.
	$(CP) $(PKG_BUILD_DIR)/utils/libutils.so $(STAGING_DIR)/usr/lib/qosfapi/.
	$(CP) $(PKG_BUILD_DIR)/utils/libutils.so $(STAGING_DIR)/usr/lib/qosfapi/.
	$(INSTALL_DIR) $(STAGING_DIR)/usr/docs
	$(CP) $(PKG_BUILD_DIR)/share/commondefs.h $(STAGING_DIR)/usr/docs/.
	$(CP) $(PKG_BUILD_DIR)/share/qosal_queue_api.h $(STAGING_DIR)/usr/docs/.
	$(CP) $(PKG_BUILD_DIR)/share/qosal_cl_api.h $(STAGING_DIR)/usr/docs/.
endef

$(eval $(call BuildPackage,intel_qosfapi))
