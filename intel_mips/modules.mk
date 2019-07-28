#
# Copyright (C) 2010 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

I2C_LANTIQ_MODULES:= \
  CONFIG_I2C_LANTIQ:drivers/i2c/busses/i2c-lantiq

define KernelPackage/i2c-intel_mips
  TITLE:=Intel I2C controller
  $(call i2c_defaults,$(I2C_LANTIQ_MODULES),52)
  DEPENDS:=kmod-i2c-core @TARGET_intel_mips
endef

define KernelPackage/i2c-intel_mips/description
  Kernel support for the Intel/Falcon I2C controller
endef

$(eval $(call KernelPackage,i2c-intel_mips))

define KernelPackage/intel_mips-vpe
  TITLE:=Intel VPE extensions
  SUBMENU:=Intel
  DEPENDS:=@TARGET_intel_mips +kmod-vpe
  KCONFIG:=CONFIG_IFX_VPE_CACHE_SPLIT=y \
	  CONFIG_IFX_VPE_EXT=y \
	  CONFIG_VPE_SOFTDOG=y \
	  CONFIG_MTSCHED=y \
	  CONFIG_PERFCTRS=n
endef

define KernelPackage/intel_mips-vpe/description
  Kernel extensions for the Intel SoC
endef

#$(eval $(call KernelPackage,intel_mips-vpe))

define KernelPackage/intel_mips-nf
  TITLE:=Intel NF extensions
  SUBMENU:=Intel
  DEPENDS:=@TARGET_intel_mips
  KCONFIG:=CONFIG_NF_CONNTRACK_EVENTS=y
endef

define KernelPackage/intel_mips-nf/description
  Netfilter extensions for the Intel SoC
endef

$(eval $(call KernelPackage,intel_mips-nf))

define KernelPackage/spi-intel_mips-ssc
  SUBMENU:=$(SPI_MENU)
  TITLE:=Intel SPI controller
  DEPENDS:=@TARGET_intel_mips +kmod-spi-bitbang @!LINUX_4_9
  KCONFIG:=CONFIG_SPI_XWAY \
	  CONFIG_SPI_XWAY_BV=y
  FILES:=$(LINUX_DIR)/drivers/spi/spi-xway.ko
  AUTOLOAD:=$(call AutoProbe,spi-xway)
endef

define KernelPackage/spi-intel_mips-ssc/description
  Intel SPI controller
endef

$(eval $(call KernelPackage,spi-intel_mips-ssc))

define KernelPackage/spi-intel_mips-ssc-csi
  SUBMENU:=$(SPI_MENU)
  TITLE:=Intel SPI controller for CSI
  DEPENDS:=@TARGET_intel_mips +kmod-spi-bitbang
  KCONFIG:=CONFIG_SPI_XWAY_CSI
  FILES:=$(LINUX_DIR)/drivers/spi/spi-xway-csi.ko
  AUTOLOAD:=$(call AutoProbe,spi-xway-csi)
endef

define KernelPackage/spi-intel_mips-ssc-csi/description
  Intel SPI controller for CSI
endef

$(eval $(call KernelPackage,spi-intel_mips-ssc-csi))

define KernelPackage/spi-intel_mips
  SUBMENU:=$(SPI_MENU)
  TITLE:=Intel SPI controller (new)
  DEPENDS:=@TARGET_intel_mips @LINUX_4_9
  KCONFIG:=CONFIG_SPI_LANTIQ_SSC \
          CONFIG_SPI=y \
          CONFIG_SPI_MASTER=y
  FILES:=$(LINUX_DIR)/drivers/spi/spi-lantiq-ssc.ko
  AUTOLOAD:=$(call AutoProbe,spi-lantiq-ssc)
endef

define KernelPackage/spi-intel_mips/description
  New Intel SPI controller
endef

$(eval $(call KernelPackage,spi-intel_mips))


define KernelPackage/spi-intel_mips-grx500
  SUBMENU:=$(SPI_MENU)
  TITLE:=Intel SPI controller for GRX500
  DEPENDS:=@(TARGET_intel_mips_xrx500||TARGET_intel_mips_falcon_mountain) +kmod-spi-bitbang
  KCONFIG:=CONFIG_SPI_GRX500 \
          CONFIG_SPI=y \
          CONFIG_SPI_MASTER=y \
          CONFIG_SPI_GRX500_POLL=n
  FILES:=$(LINUX_DIR)/drivers/spi/spi-grx500.ko
  AUTOLOAD:=$(call AutoProbe,spi-grx500)
endef

define KernelPackage/spi-intel_mips-grx500/description
  Intel SPI controller for GRX500
endef

$(eval $(call KernelPackage,spi-intel_mips-grx500))


define KernelPackage/intel_mips-svip-ve
  TITLE:=Intel SVIP virtual ethernet
  SUBMENU:=Intel
  DEPENDS:=@(TARGET_intel_mips_svip_be||TARGET_intel_mips_svip_le)
  KCONFIG:=CONFIG_LANTIQ_SVIP_VIRTUAL_ETH=y
endef

define KernelPackage/intel_mips-ve/description
  Intel SVIP virtual ethernet
endef

$(eval $(call KernelPackage,intel_mips-svip-ve))

define KernelPackage/intel_mips-svip-nat
  TITLE:=Intel SVIP NAT
  SUBMENU:=Intel
  DEPENDS:=@(TARGET_intel_mips_svip_be||TARGET_intel_mips_svip_le)
  KCONFIG:=CONFIG_IPV6=y \
	  CONFIG_LTQ_SVIP_NAT=y \
	  CONFIG_LTQ_SVIP_NAT_DESTIP_CHECK=y \
	  CONFIG_LTQ_SVIP_NAT_DESTIP_LIST_SIZE=10 \
	  CONFIG_LTQ_SVIP_NAT_RULES_TOTAL=768 \
	  CONFIG_LTQ_SVIP_NAT_UDP_PORT_BASE=50000
endef

define KernelPackage/intel_mips-svip-nat/description
  Performs MAC and IP address translation of incoming and ougoing
  IP packets relative the address mapping details provided by the
  SVIP NAT rules. The packets will be intercept in the IP module and
  when an appropriate NAT rule exists the source and destination address
  details are replaced, and the packets are sent out the destined Ethernet
  interface.
endef

$(eval $(call KernelPackage,intel_mips-svip-nat))


define KernelPackage/intel_eth_drv_xrx500
 SUBMENU:=Intel
 TITLE:= Intel Ethernet Driver for xRX500 (Module Support)
 DEPENDS:=@(TARGET_intel_mips_xrx500||TARGET_intel_mips_falcon_mountain) +kmod-intel_eth_xrx500_fw
 KCONFIG:= \
        CONFIG_LTQ_ETH_XRX500 \
        CONFIG_SW_ROUTING_MODE=y \
        CONFIG_XRX500_ETH_DRV_THERMAL_SUPPORT=n \
        CONFIG_HAPS_CPU_LOOPBACK_TEST=n
 FILES:= \
        $(LINUX_DIR)/drivers/net/ethernet/lantiq/ltq_eth_drv_xrx500.ko
  AUTOLOAD:=$(call AutoProbe,ltq_eth_drv_xrx500)
endef

define KernelPackage/intel_eth_drv_xrx500/description
 Intel Ethernet Driver (Module Support)
endef

$(eval $(call KernelPackage,intel_eth_drv_xrx500))

define KernelPackage/intel_eth_toe_drv_xrx500
 SUBMENU:=Intel
 TITLE:= Intel Ethernet TOE Driver for xRX500
 DEPENDS:=kmod-intel_eth_drv_xrx500
 KCONFIG:= \
	CONFIG_LTQ_TOE_DRIVER=y
endef

define KernelPackage/intel_eth_toe_drv_xrx500/description
 Intel Ethernet TOE Driver
endef

$(eval $(call KernelPackage,intel_eth_toe_drv_xrx500))

define KernelPackage/intel_eth_xrx500_fw
 SUBMENU:=Intel
 TITLE:= Intel Ethernet Driver FW loading for xRX500 (Module Support)
 DEPENDS:=@(TARGET_intel_mips_xrx500||TARGET_intel_mips_falcon_mountain)
 KCONFIG:= \
        CONFIG_XRX500_PHY_FW
 FILES:= \
        $(LINUX_DIR)/drivers/net/ethernet/lantiq/xrx500_phy_fw.ko
  AUTOLOAD:=$(call AutoProbe,xrx500_phy_fw)
endef

define KernelPackage/intel_eth_xrx500_fw/description
 Intel Ethernet Driver FW loading (Module Support)
endef

$(eval $(call KernelPackage,intel_eth_xrx500_fw))


define KernelPackage/usb-dwc3-grx500
  TITLE:=Intel DWC3 USB GRX500 driver
  DEPENDS:=+kmod-usb-dwc3
  KCONFIG:= \
	CONFIG_PHY_GRX500_USB \
	CONFIG_USB_DWC3_GRX500

  FILES:= \
	$(LINUX_DIR)/drivers/phy/phy-grx500-usb.ko \
	$(LINUX_DIR)/drivers/usb/dwc3/dwc3-grx500.ko

  AUTOLOAD:=$(call AutoProbe,phy-grx500-usb dwc3-grx500)
  $(call AddDepends/usb)
endef

define KernelPackage/usb-dwc3-grx500/description
 This driver provides generic platform glue for the integrated DesignWare
 USB3 IP Core in Intel GRX500 Platforms
endef

$(eval $(call KernelPackage,usb-dwc3-grx500))


define KernelPackage/intel_ppv4_qos_drv
 SUBMENU:=Intel
 TITLE:=Intel PPv4 QoS Driver
 DEPENDS:=@TARGET_intel_mips_falcon_mountain +ppv4-qos-firmware
 KCONFIG:= \
	CONFIG_LTQ_PPV4_QOS=y \
	CONFIG_LTQ_PPV4_QOS_TEST=n
endef

define KernelPackage/intel_ppv4_qos_drv/description
 Intel PPv4 QoS Driver
endef

$(eval $(call KernelPackage,intel_ppv4_qos_drv))


define KernelPackage/intel_ppv4_qos_drv_mod
 SUBMENU:=Intel
 TITLE:=Intel PPv4 QoS Driver
 DEPENDS:=@TARGET_intel_mips_falcon_mountain @!PACKAGE_kmod-intel_ppv4_qos_drv +ppv4-qos-firmware
 KCONFIG:= \
	CONFIG_LTQ_PPV4_QOS \
	CONFIG_LTQ_PPV4_QOS_TEST=y
 FILES:= \
	$(LINUX_DIR)/drivers/net/ethernet/lantiq/ppv4/qos/pp_qos_drv.ko
  AUTOLOAD:=$(call AutoProbe,pp_qos_drv)
endef

define KernelPackage/intel_ppv4_qos_drv_mod/description
 Intel PPv4 QoS Driver (Module Support)
endef

$(eval $(call KernelPackage,intel_ppv4_qos_drv_mod))

define KernelPackage/intel-extmark
  TITLE:=Intel Extension Mark Support
  SUBMENU:=Intel
  KCONFIG:= \
	CONFIG_NETWORK_EXTMARK=y
endef

define KernelPackage/intel-extmark/description
 Add extension mark(extmark) param in sk_buff
endef

$(eval $(call KernelPackage,intel-extmark))
