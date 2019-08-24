ifeq ($(SUBTARGET),xrx500)

define Build/rax40sign
   rax40sign $@
   mv $@.pega $@
endef

define Device/xrx500
  $(Device/lantiqFullImage)
  $(Device/NAND)
  IMAGE_SIZE := 64512k
  KERNEL_LOADADDR := 0xa0020000
  KERNEL_ENTRY := 0xa0020000
  IMAGE_PREFIX := $$(DEVICE_NAME)
endef

define Device/GRX550_2000_VDSL35B_11AC
  $(Device/xrx500)
  DEVICE_DTS := easy550_anywan
  DEVICE_TITLE := GRX550 11AC Dual Band Wifi VDSL Gateway
  ROOTFS_PREPARE := add-servicelayer-schema
  DEVICE_PACKAGES := $(UGW_PACKAGES) $(DSL_CPE_UGW_PACKAGE) $(DSL_CPE_PACKAGES)
endef
TARGET_DEVICES += GRX550_2000_VDSL35B_11AC

define Device/GRX550_2000_ETHWAN_11AC_OWRT
  $(Device/xrx500)
  DEVICE_DTS := easy550_anywan
  DEVICE_TITLE := GRX550 11AC Dual Band Wifi OpenWRT Ethernet Router
  DEVICE_PACKAGES := $(OWRT_PACKAGES) $(DSL_CPE_PACKAGES)
endef
TARGET_DEVICES += GRX550_2000_ETHWAN_11AC_OWRT

define Device/NETGEAR_RAX40
  $(Device/xrx500)
  DEVICE_DTS := netgear_rax40
  DEVICE_TITLE := Netgear RAX40
  DEVICE_PACKAGES := $(OWRT_PACKAGES) $(DSL_CPE_PACKAGES)
  IMAGES := sysupgrade.bin fullimage.img fullimage.signed
  IMAGE/fullimage.signed = fullimage 16 | check-size $$$$(IMAGE_SIZE) | rax40sign
endef
TARGET_DEVICES += NETGEAR_RAX40

define Device/GRX550_2000_GFAST_11AC
  $(Device/xrx500)
  DEVICE_DTS := easy550_anywan
  DEVICE_TITLE := GRX550 11AC Dual Band Wifi G.Fast Gateway
  ROOTFS_PREPARE := add-servicelayer-schema
  DEVICE_PACKAGES := $(UGW_PACKAGES) $(DSL_CPE_GFAST_PACKAGES)
endef
TARGET_DEVICES += GRX550_2000_GFAST_11AC

define Device/GRX550_MR_GFAST_CO
  $(Device/xrx500)
  DEVICE_DTS := easy550_anywan
  DEVICE_TITLE := GRX550_MR_GFAST_CO
  ROOTFS_PREPARE := add-servicelayer-schema
  DEVICE_PACKAGES := $(UGW_PACKAGES) $(DSL_CPE_GFAST_PACKAGES) $(GFAST_CO_PACKAGES)
endef
TARGET_DEVICES += GRX550_MR_GFAST_CO

define Device/GRX550_2000_V1_VDSL35B_11AC
  $(Device/xrx500)
  DEVICE_DTS := easy550_V1_anywan
  DEVICE_TITLE := GRX550(v1) 11AC Dual Band Wifi VDSL Gateway
  ROOTFS_PREPARE := add-servicelayer-schema
  DEVICE_PACKAGES := $(UGW_PACKAGES) $(DSL_CPE_UGW_PACKAGE) $(DSL_CPE_PACKAGES)
endef
TARGET_DEVICES += GRX550_2000_V1_VDSL35B_11AC

define Device/GRX550_2000_V1_ETHWAN_11AC_OWRT
  $(Device/xrx500)
  DEVICE_DTS := easy550_V1_anywan
  DEVICE_TITLE := GRX550(v1) 11AC Dual Band WiFi OpenWrt Ethernet Router
  DEVICE_PACKAGES := $(OWRT_PACKAGES) $(DSL_CPE_PACKAGES)
endef
TARGET_DEVICES += GRX550_2000_V1_ETHWAN_11AC_OWRT

define Device/GRX350_1600_VDSL35B_11AC
  $(Device/xrx500)
  DEVICE_DTS := easy350_anywan
  DEVICE_TITLE := GRX350 11AC Dual Band Wifi VDSL Gateway
  ROOTFS_PREPARE := add-servicelayer-schema
  DEVICE_PACKAGES := $(UGW_PACKAGES) $(DSL_CPE_UGW_PACKAGE) $(DSL_CPE_PACKAGES)
endef
TARGET_DEVICES += GRX350_1600_VDSL35B_11AC

define Device/GRX350_1200_VDSL35B_11AC
  $(Device/xrx500)
  DEVICE_DTS := easy350_anywan_600m
  DEVICE_TITLE := GRX350-1200 11AC Dual Band Wifi VDSL Gateway
  ROOTFS_PREPARE := add-servicelayer-schema
  DEVICE_PACKAGES := $(UGW_PACKAGES) $(DSL_CPE_UGW_PACKAGE) $(DSL_CPE_PACKAGES)
endef
TARGET_DEVICES += GRX350_1200_VDSL35B_11AC

define Device/GRX350_1600_ETHWAN_11AC_OWRT
  $(Device/xrx500)
  DEVICE_DTS := easy350_anywan
  DEVICE_TITLE := GRX350 11AC Dual Band Wifi OpenWRT Ethernet Router
  DEVICE_PACKAGES := $(OWRT_PACKAGES) $(DSL_CPE_PACKAGES)
endef
TARGET_DEVICES += GRX350_1600_ETHWAN_11AC_OWRT

endif

ifeq ($(SUBTARGET),xrx500_4kec)

define Device/easy350550_bootcore
  IMAGE_SIZE := 16512k
  DEVICE_DTS := easy350550_bootcore
  DEVICE_TITLE := LANTIQ EASY350/550 ANYWAN BOOTCORE
  UIMAGE_NAME := MIPS 4Kec Bootcore
  KERNEL_LOADADDR := 0x88000000
  KERNEL_ENTRY := 0x88000000
  KERNEL_INITRAMFS := kernel-bin | append-dtb | uImage none
endef
TARGET_DEVICES += easy350550_bootcore

endif
