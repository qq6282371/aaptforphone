# **aaptforphone**

这是一个可以在手机上运行的aapt命令，用于jni-C层解析apk包之用

有时候我需要了解一些apk信息，但是因为工作在jni的C层，很难去调用Java层的接口来解决问题

另外如果采用多线程大量的抽取apk信息，就更加难以回调Java层接口来访问apk信息（因为涉及到
线程同步的问题）


本项目所有aapt源码来自Android 5.1.1
经测试可以在Android 4.2及其以上版本运行
注意Android 
5.0以后的平台，需求在Android.mk编译中加上参数

**LOCAL_CFLAGS  += -pie -fPIE**

**LOCAL_LDFLAGS += -pie -fPIE**

本项目仅能在armeabi-v7a和x86下编译通过 armeabi无法编译通过（处理器无法支持）
