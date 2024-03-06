export THEOS_DEVICE_IP = localhost -p 2222
TARGET = iphone:9.2:10.1
ARCHS = armv7 armv7s arm64 arm64e
#PREFIX = $(THEOS)/toolchain/Xcode.xctoolchain/usr/bin/
FINALPACKAGE = 1
THEOS_PACKAGE_SCHEME = rootless

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SafariViewController

SafariViewController_FILES = Tweak.xm
SafariViewController_FRAMEWORKS = UIKit
SafariViewController_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
