PLATFORM=$(shell uname)
APPNAME=imshow

.PHONY: debug

ifeq (${PLATFORM}, Darwin)
debug:
		clang -g -Wall -x objective-c -framework Cocoa src/platform_macos.m src/imshow.c -o ${APPNAME}
release:
		clang -O3 -x objective-c -framework Cocoa src/platform_macos.m src/imshow.c -o ${APPNAME}
else
debug:
		gcc -g -Wall src/platform_x.c imshow.c -o ${APPNAME}
release:
		gcc -O3 src/platform_x.c imshow.c -o ${APPNAME}
endif



install: release
	mv imshow ~/bin/imshow

