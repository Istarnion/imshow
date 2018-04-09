# imshow

An extremely simple tool for showing images.

## Motivation and goals
I work from the command line a lot, and I often want to look at image files without opening Finder, finding the files, and opening them in Preview.

I _can_ run Preview from the command line, but I would have to make an alias to make the command shorter. But more importantly:
- Preview does not quit when all windows are closed
- Preview opes all other windows that were not closed last time
- Preview does not close on ESC
- Preview does not let me open a list of images, and scroll through them using arrow keys.

So that's why I'm making imshow.

...Well to be honest, I wanted to learn Objective C and see how Cocoa was.

## Features
- Simple to use. run `imshow` with a list of files, and scroll through them using the arrow keys. Hit ESC to close.
- Supports many image formats (All that stb_image supports, because that is what I use to load images)
- Lightweight: As bare bones as practicly possible, using C from the cross platform logic, and the native platforms window system

## TODO
- Linux platform
- Zoom and pan, supporting both gestures and mouse
- Windows platform

