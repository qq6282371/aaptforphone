# 
# Copyright 2006 The Android Open Source Project
#
# Android Asset Packaging Tool
#

# This tool is prebuilt if we're doing an app-only build.

LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)

ifeq ($(TARGET_CPU_SMP),true)
    targetSmpFlag := -DANDROID_SMP=1
else
    targetSmpFlag := -DANDROID_SMP=0
endif

LOCAL_MODULE := cutils_static
LOCAL_SRC_FILES := libcutils/atomic.c.arm \
		libcutils/hashmap.c \
		libcutils/native_handle.c \
		libcutils/config_utils.c \
		libcutils/cpu_info.c \
		libcutils/load_file.c \
		libcutils/open_memstream.c \
		libcutils/strdup16to8.c \
		libcutils/strdup8to16.c \
		libcutils/record_stream.c \
		libcutils/process_name.c \
		libcutils/iosched_policy.c \
		libcutils/str_parms.c \
        libcutils/android_reboot.c \
        libcutils/ashmem-dev.c \
        libcutils/debugger.c \
        libcutils/klog.c \
        libcutils/memory.c \
        libcutils/partition_utils.c \
        libcutils/properties.c \
        libcutils/qtaguid.c \
        libcutils/trace.c \
        libcutils/uevent.c \
		libcutils/sched_policy.c \
		libcutils/threads.c \
		libcutils/fs.c \
        libcutils/multiuser.c \
        libcutils/socket_inaddr_any_server.c \
        libcutils/socket_local_client.c \
        libcutils/socket_local_server.c \
        libcutils/socket_loopback_client.c \
        libcutils/socket_loopback_server.c \
        libcutils/socket_network_client.c \
		libcutils/sockets.c 
		
         
LOCAL_SRC_FILES_arm += \
        arch-arm/memset32.S \

LOCAL_SRC_FILES_arm64 += \
        arch-arm64/android_memset.S \

LOCAL_SRC_FILES_mips += \
        arch-mips/android_memset.c \

LOCAL_SRC_FILES_x86 += \
        arch-x86/android_memset16.S \
        arch-x86/android_memset32.S \

LOCAL_SRC_FILES_x86_64 += \
        arch-x86_64/android_memset16_SSE2-atom.S \
        arch-x86_64/android_memset32_SSE2-atom.S \

LOCAL_CFLAGS_arm += -DHAVE_MEMSET16 -DHAVE_MEMSET32
LOCAL_CFLAGS_arm64 += -DHAVE_MEMSET16 -DHAVE_MEMSET32
LOCAL_CFLAGS_mips += -DHAVE_MEMSET16 -DHAVE_MEMSET32
LOCAL_CFLAGS_x86 += -DHAVE_MEMSET16 -DHAVE_MEMSET32
LOCAL_CFLAGS_x86_64 += -DHAVE_MEMSET16 -DHAVE_MEMSET32
LOCAL_C_INCLUDES += .
LOCAL_CFLAGS += $(targetSmpFlag) -Werror
LOCAL_ADDITIONAL_DEPENDENCIES := $(LOCAL_PATH)/Android.mk
include $(BUILD_STATIC_LIBRARY)

aaptMain := Main.cpp
aaptSources := \
    AaptAssets.cpp \
    AaptConfig.cpp \
    AaptUtil.cpp \
    AaptXml.cpp \
    ApkBuilder.cpp \
    Command.cpp \
    CrunchCache.cpp \
    FileFinder.cpp \
    Images.cpp \
    Package.cpp \
    pseudolocalize.cpp \
    qsort_r_compat.cpp \
    Resource.cpp \
    ResourceFilter.cpp \
    ResourceIdCache.cpp \
    ResourceTable.cpp \
    SourcePos.cpp \
    StringPool.cpp \
    WorkQueue.cpp \
    XMLNode.cpp \
    ZipEntry.cpp \
    ZipFile.cpp \
	VectorImpl.cpp \
	Threads.cpp \
	RefBase.cpp
	

include $(CLEAR_VARS)
LOCAL_SRC_FILES := $(aaptSources)
LOCAL_CFLAGS += -DANDROID
LOCAL_MODULE := aapt_static
LOCAL_C_INCLUDES += .
LOCAL_C_INCLUDES += ./libpng
LOCAL_C_INCLUDES += ./zlib
LOCAL_C_INCLUDES += ./nativehelper
include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_SRC_FILES := $(wildcard androidfwsrc/*.cpp) libziparchive/zip_archive.cc 
LOCAL_CFLAGS += -DANDROID
LOCAL_MODULE := androidfw_static
LOCAL_C_INCLUDES += .
LOCAL_C_INCLUDES += ./androidfwsrc
LOCAL_C_INCLUDES += ./nativehelper
LOCAL_STATIC_LIBRARIES := utils_static
include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_SRC_FILES := $(wildcard libutils/*.cpp)
LOCAL_CFLAGS += -DANDROID
LOCAL_MODULE := utils_static
LOCAL_C_INCLUDES += .
LOCAL_C_INCLUDES += ./libutils
LOCAL_C_INCLUDES += ./utils
LOCAL_STATIC_LIBRARIES := cutils_static
include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_SRC_FILES := $(wildcard libpng/*.c)
LOCAL_CFLAGS += -DANDROID
LOCAL_MODULE := png_static
LOCAL_C_INCLUDES += .
LOCAL_C_INCLUDES += ./libpng
include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_SRC_FILES := $(wildcard expat/files/lib/*.c)
LOCAL_CFLAGS += -DANDROID -DHAVE_EXPAT_CONFIG_H
LOCAL_MODULE := expat_static
LOCAL_C_INCLUDES += .
LOCAL_C_INCLUDES += ./wildcard expat/files/lib
include $(BUILD_STATIC_LIBRARY)

STATIC_LIBRARIES		:= aapt_static androidfw_static cutils_static expat_static png_static utils_static 

include $(CLEAR_VARS)
LOCAL_SRC_FILES			:= $(aaptMain)
LOCAL_STATIC_LIBRARIES	+= $(STATIC_LIBRARIES)
LOCAL_CFLAGS			+= -DANDROID 
LOCAL_LDLIBS			+= -ldl -lm -llog -lz 
LOCAL_MODULE			:= aapt
LOCAL_C_INCLUDES		+= .
LOCAL_C_INCLUDES		+= ./libpng
LOCAL_C_INCLUDES		+= ./zlib
include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)
LOCAL_SRC_FILES			:= $(aaptMain)
LOCAL_STATIC_LIBRARIES	+= $(STATIC_LIBRARIES)
LOCAL_CFLAGS			+= -DANDROID -pie -fPIE
LOCAL_LDFLAGS			+= -pie -fPIE
LOCAL_LDLIBS			+= -ldl -lm -llog -lz
LOCAL_MODULE			:= aapt_pie
LOCAL_C_INCLUDES		+= .
LOCAL_C_INCLUDES		+= ./libpng
LOCAL_C_INCLUDES		+= ./zlib
include $(BUILD_EXECUTABLE)