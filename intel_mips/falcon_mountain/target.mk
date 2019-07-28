ARCH:=mips
SUBTARGET:=falcon_mountain
BOARDNAME:=Falcon Mountain
FEATURES:=squashfs atm jffs2 nand ubifs
CPU_TYPE:=24kc
CPU_SUBTYPE:=nomips16

KERNEL_PATCHVER:=4.9

DEFAULT_PACKAGES+=kmod-intel_eth_drv_xrx500 ltq-gphy-fw-xrx5xx

define Target/Description
	Intel Falcon Mountain
endef
