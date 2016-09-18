# build/os-auto.mak.  Generated from os-auto.mak.in by configure.

export OS_CFLAGS   := $(CC_DEF)PJ_AUTOCONF=1 -I/Users/daiquanyi/Documents/ioscode/18phone/pjproject-2.5.5/third_party/openh264/include -O2 -Wno-unused-label -DPJ_SDK_NAME="\"iPhoneOS9.3.sdk\"" -arch armv7 -isysroot /Applications/XCode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS9.3.sdk -DPJ_IS_BIG_ENDIAN=0 -DPJ_IS_LITTLE_ENDIAN=1

export OS_CXXFLAGS := $(CC_DEF)PJ_AUTOCONF=1 -O2 -Wno-unused-label -DPJ_SDK_NAME="\"iPhoneOS9.3.sdk\"" -arch armv7 -isysroot /Applications/XCode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS9.3.sdk 

export OS_LDFLAGS  := -L/Users/daiquanyi/Documents/ioscode/18phone/pjproject-2.5.5/third_party/openh264/lib -O2 -arch armv7 -isysroot /Applications/XCode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS9.3.sdk -framework AudioToolbox -framework Foundation -lopenh264 -lstdc++ -lm -lpthread  -framework CoreAudio -framework CoreFoundation -framework AudioToolbox -framework CFNetwork -framework UIKit -framework UIKit -framework AVFoundation -framework CoreGraphics -framework QuartzCore -framework CoreVideo -framework CoreMedia -framework OpenGLES

export OS_SOURCES  := 


