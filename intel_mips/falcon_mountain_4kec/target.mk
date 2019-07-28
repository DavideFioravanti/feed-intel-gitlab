ARCH:=mips
SUBTARGET:=falcon_mountain_4kec
BOARDNAME:=Falcon Mountain Bootcore
# Use the same toolchain as the MIPS interAptiv CPU uses.
# This is MIPS 4KEc V7.4 CPU (mips32r2 + mips16, no dsp)
CPU_TYPE:=24kc
#CPU_SUBTYPE:=nomips16

KERNEL_PATCHVER:=4.9

DEVICE_TYPE:=bootloader
DEFAULT_PACKAGES:=base-files libc libgcc busybox

define Target/Description
	Intel Falcon Mountain Boot Core
endef
