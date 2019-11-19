include $(TOPDIR)/rules.mk

BOARD:=intel_mips
BOARDNAME:=Intel MIPS
SUBTARGETS:=xrx500
FEATURES:=squashfs
VENDOR_PATH="/opt/intel"
MAINTAINER:=John Crispin <john@phrozen.org>

KERNEL_PATCHVER:=4.9

define Target/Description
	Build firmware images for Intel MIPS SoC
endef

include $(INCLUDE_DIR)/target.mk

$(eval $(call BuildTarget))
