LOCAL_PATH:= $(call my-dir)
include $(CLEAR_VARS)

LOCAL_SRC_FILES := \
    jcapimin.c jcapistd.c jccoefct.c jccolor.c jcdctmgr.c jchuff.c \
    jcinit.c jcmainct.c jcmarker.c jcmaster.c jcomapi.c jcparam.c \
    jcphuff.c jcprepct.c jcsample.c jctrans.c jdapimin.c jdapistd.c \
    jdatadst.c jdatasrc.c jdcoefct.c jdcolor.c jddctmgr.c jdhuff.c \
    jdinput.c jdmainct.c jdmarker.c jdmaster.c jdmerge.c jdphuff.c \
    jdpostct.c jdsample.c jdtrans.c jerror.c jfdctflt.c jfdctfst.c \
    jfdctint.c jidctflt.c jidctfst.c jidctint.c jidctred.c jquant1.c \
    jquant2.c jutils.c jmemmgr.c jmemnobs.c

LOCAL_SRC_FILES_arm += armv6_idct.S

# jsimd_arm_neon.S does not compile with clang.
LOCAL_CLANG_ASFLAGS_arm += -no-integrated-as


LOCAL_CFLAGS += -DAVOID_TABLES
LOCAL_CFLAGS += -O3 -fstrict-aliasing 
#LOCAL_CFLAGS += -march=armv6j

# enable tile based decode
LOCAL_CFLAGS += -DANDROID_TILE_BASED_DECODE

ifeq ($(TARGET_ARCH),x86)
  LOCAL_CFLAGS += -DANDROID_INTELSSE2_IDCT
  LOCAL_SRC_FILES += jidctintelsse.c
endif

ifeq ($(strip $(TARGET_ARCH)),arm)
    #use NEON accelerations
    LOCAL_CFLAGS += -DNV_ARM_NEON -D__ARM_HAVE_NEON
    LOCAL_SRC_FILES += \
        jsimd_arm_neon.S \
        jsimd_neon.c
endif

# use mips assembler IDCT implementation if MIPS DSP-ASE is present
ifeq ($(strip $(TARGET_ARCH)),mips)
  ifeq ($(strip $(ARCH_MIPS_HAS_DSP)),true)
  LOCAL_CFLAGS += -DANDROID_MIPS_IDCT
  LOCAL_SRC_FILES += \
      mips_jidctfst.c \
      mips_idct_le.S
  endif
endif

LOCAL_MODULE := libjpeg

#include $(BUILD_STATIC_LIBRARY)
include $(BUILD_SHARED_LIBRARY)


