PLATFORM=$(shell uname)
APPNAME=imshow

.PHONY: debug

ifeq (${PLATFORM}, Darwin)
debug:
		clang -g -x objective-c -framework Cocoa src/platform_macos.m src/imshow.c -o ${APPNAME}
else
debug:
		gcc -g src/platform_linux.c imshow.c -o ${APPNAME}
endif

install: debug
	mv imshow ~/bin/imshow
