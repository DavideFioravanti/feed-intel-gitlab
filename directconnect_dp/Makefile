include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=directconnect-dp
PKG_VERSION:=0.2.4.2
PKG_RELEASE:=1
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.xz
PKG_SOURCE_URL:=http://sources.openwrt.org/
PKG_HASH:=5c08e67359f2d93201ee4b57811c180c49487ecdba8bfee306c4a851a3464318

include $(INCLUDE_DIR)/package.mk

define KernelPackage/directconnect-dp
  SECTION:=intel
  CATEGORY:=Intel
  TITLE:=DirectConnect datapath driver
  DEPENDS:=@TARGET_intel_mips
  KCONFIG:=CONFIG_DIRECTCONNECT_DP_API
  FILES:=$(PKG_BUILD_DIR)/common/directconnect_datapath.ko \
	$(if $(CONFIG_TARGET_intel_mips_xrx500),$(PKG_BUILD_DIR)/dc_mode/dc_mode0/dc_mode0-xrx500.ko) \
	$(if $(CONFIG_TARGET_intel_xrx330),$(if (CONFIG_PACKAGE_kmod-vrx518_ep), \
		$(PKG_BUILD_DIR)/dc_mode/dc_mode1/dc_mode1-xrx330.ko))
  AUTOLOAD:=$(call AutoProbe,directconnect_datapath dc_mode0-xrx500 dc_mode1-xrx330)
endef

define KernelPackage/directconnect-dp/description
  DirectConnect datapath driver
endef

define KernelPackage/directconnect-dp/config
  source "$(SOURCE)/config/Config.in"
  $(call Package/kmod-directconnect-dp/override_version)
  $(call Package/kmod-directconnect-dp/override_source_path)
endef

EXTRA_CFLAGS += \
	-DCONFIG_DIRECTCONNECT_DP_DBG \
	-DCONFIG_DIRECTCONNECT_DP_LITEPATH \
	-DSW_DCMODE1_BUILTIN \
	$(if $(CONFIG_TARGET_intel_mips_xrx500), \
		-DHAVE_DATAPATH_API \
	)

export CONFIG_DIRECTCONNECT_DP_LITEPATH=y
export CONFIG_SW_DCMODE1_BUILTIN=y

ifeq ($(CONFIG_TARGET_intel_mips_xrx500),y)
	export CONFIG_DIRECTCONNECT_DP_XRX500=y
endif

ifeq ($(CONFIG_TARGET_x86_puma),y)
	export CONFIG_DIRECTCONNECT_DP_XRX750=y
	EXTRA_CFLAGS += -DHAVE_DATAPATH_API
endif

ifeq ($(CONFIG_TARGET_intel_xrx330),y)
ifeq ($(CONFIG_PACKAGE_kmod-vrx518_ep),y)
	# for VRX518 only
	export CONFIG_DIRECTCONNECT_DP_330=y
	EXTRA_CFLAGS += -DHAVE_DATAPATH_API
endif
endif

EXTRA_CFLAGS += -I$(PKG_BUILD_DIR)/include

define Build/InstallDev
	$(INSTALL_DIR) $(STAGING_DIR)/include/net/
	$(CP) $(PKG_BUILD_DIR)/include/*.h $(STAGING_DIR)/include/net/
endef

define Build/Compile
	$(MAKE) -C "$(LINUX_DIR)" \
		CROSS_COMPILE="$(TARGET_CROSS)" \
		ARCH="$(LINUX_KARCH)" \
		SUBDIRS="$(PKG_BUILD_DIR)" \
		EXTRA_CFLAGS="$(EXTRA_CFLAGS)" \
		modules
endef

$(eval $(call KernelPackage,directconnect-dp))
