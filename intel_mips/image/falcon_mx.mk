ifeq ($(SUBTARGET),falcon_mountain)
include $(INCLUDE_DIR)/version.mk

# NAND configs are based on MX35LF1GEAB flash
# Max volume 32 MiB (256 blocks)
# Journal size 1 MiB to fit in small (<4 MiB) image
define Device/PRX_GENERIC
  $(Device/lantiqFullImage)
  IMAGE_SIZE := 64512k
  KERNEL_LOADADDR := 0xa0020000
  KERNEL_ENTRY := 0xa0020000
  KERNEL := kernel-bin | append-dtb | lzma | uImage lzma | pad-offset 16 0
  KERNEL_INITRAMFS := kernel-bin | append-dtb | lzma | uImage lzma
  UIMAGE_NAME:=$(if $(VERSION_IMAGE_SED),$(VERSION_IMAGE_SED))
endef

define Device/HAPS_GENERIC
  $(Device/PRX_GENERIC)
  KERNEL := kernel-bin | append-dtb | gzip | uImage gzip | pad-offset 16 0
  KERNEL_INITRAMFS := kernel-bin | append-dtb | gzip | uImage gzip
endef

# Default target
define Device/HAPS
  $(Device/HAPS_GENERIC)
  FILESYSTEMS :=
  DEVICE_DTS := falconmx_haps
  DEVICE_TITLE := FalconMX HAPS model
endef
TARGET_DEVICES += HAPS

define Device/HAPS_QSPI_NAND
  $(Device/HAPS_GENERIC)
  $(Device/NAND)
  IMAGE/kernel.bin := append-kernel
  IMAGE/nand.rootfs := append-rootfs
  IMAGES += kernel.bin nand.rootfs
  FILESYSTEMS := ubifs
  PAGESIZE := 2048
  BLOCKSIZE := 128k
  SUBPAGESIZE := 2048
  UBIFS_OPTS := -m $$(PAGESIZE) -e 124KiB -c 256 -j 1MiB
  DEVICE_DTS := falconmx_haps_qspi_nand
  DEVICE_TITLE := FalconMX HAPS QSPI NAND model
endef
TARGET_DEVICES += HAPS_QSPI_NAND

define Device/HAPS_SPI_NAND
  $(Device/HAPS_GENERIC)
  $(Device/NAND)
  IMAGE/kernel.bin := append-kernel
  IMAGE/nand.rootfs := append-rootfs
  IMAGES += kernel.bin nand.rootfs
  FILESYSTEMS := ubifs
  PAGESIZE := 2048
  BLOCKSIZE := 128k
  SUBPAGESIZE := 2048
  UBIFS_OPTS := -m $$(PAGESIZE) -e 124KiB -c 256 -j 1MiB
  DEVICE_DTS := falconmx_haps_spi_nand
  DEVICE_TITLE := FalconMX HAPS SPI NAND model
endef
TARGET_DEVICES += HAPS_SPI_NAND

define Device/HAPS_SPI_NOR
  $(Device/HAPS_GENERIC)
  IMAGE/kernel.bin := append-kernel
  IMAGE/nor.rootfs := append-rootfs
  IMAGES += kernel.bin nor.rootfs
  FILESYSTEMS := squashfs
  DEVICE_DTS := falconmx_haps_spi_nor
  DEVICE_TITLE := FalconMX HAPS SPI NOR model
endef
TARGET_DEVICES += HAPS_SPI_NOR

define Device/HAPS_QSPI_NOR
  $(Device/HAPS_GENERIC)
  IMAGE/kernel.bin := append-kernel
  IMAGE/nor.rootfs := append-rootfs
  IMAGES += kernel.bin nor.rootfs
  FILESYSTEMS := squashfs
  DEVICE_DTS := falconmx_haps_qspi_nor
  DEVICE_TITLE := FalconMX HAPS QSPI NOR model
endef
TARGET_DEVICES += HAPS_QSPI_NOR

define Device/HAPS_SPI_NAND_PONIP
  $(Device/HAPS_SPI_NAND)
  DEVICE_DTS := falconmx_haps_spi_nand_ponip
  DEVICE_TITLE := FalconMX HAPS SPI NAND PONIP model
endef
TARGET_DEVICES += HAPS_SPI_NAND_PONIP

define Device/XPRX220AEVA
  $(Device/PRX_GENERIC)
  $(Device/NAND)
  IMAGE/kernel.bin := append-kernel
  IMAGE/nand.rootfs := append-rootfs
  IMAGES += kernel.bin nand.rootfs
  FILESYSTEMS := squashfs
  PAGESIZE := 2048
  BLOCKSIZE := 128k
  SUBPAGESIZE := 2048
  DEVICE_DTS := PRX_XPRX220AEVA
  DEVICE_TITLE := Falcon Mountain SFU Evaluation Board
endef
TARGET_DEVICES += XPRX220AEVA

define Device/EASY_PRX321_EVA_PON
  $(Device/PRX_GENERIC)
  $(Device/NAND)
  FILESYSTEMS := squashfs
  DEVICE_DTS := prx300-easy-prx321-eva-pon
  DEVICE_TITLE := EASY PRX321 EVAL BOARD PON WAN
endef
TARGET_DEVICES += EASY_PRX321_EVA_PON

endif


ifeq ($(SUBTARGET),falcon_mountain_4kec)

define Device/HAPS_bootcore
  IMAGE_SIZE := 16512k
  DEVICE_DTS := falconmx_bootcore_haps
  DEVICE_TITLE := FALCON Mountain Bootcore HAPS - Intel Falcon Mountain Bootcore HAPS board
  UIMAGE_NAME := MIPS 4Kec Bootcore
  KERNEL_LOADADDR := 0x86000000
  KERNEL_ENTRY := 0x86000000
  KERNEL_INITRAMFS := kernel-bin | append-dtb | uImage none
endef
TARGET_DEVICES += HAPS_bootcore

define Device/SFU_EVA_bootcore
  IMAGE_SIZE := 16512k
  DEVICE_DTS := falconmx_bootcore_eva
  DEVICE_TITLE := FALCON Mountain Bootcore SFU EVA board
  UIMAGE_NAME := MIPS 4Kec Bootcore
  KERNEL_LOADADDR := 0x88000000
  KERNEL_ENTRY := 0x88000000
  KERNEL_INITRAMFS := kernel-bin | append-dtb | uImage none
endef
TARGET_DEVICES += SFU_EVA_bootcore

endif
