#import "imshow.h"

#import <Cocoa/Cocoa.h>
#import <string.h>
#import <stdio.h>

#define KEYCODE_ESC 53
#define KEYCODE_LEFT 123
#define KEYCODE_RIGHT 124

NSWindow *window;
NSImageView *image_view;

@interface AppDelegate : NSObject <NSApplicationDelegate>

@end

@implementation AppDelegate

- (void)dealloc
{
    [super dealloc];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)app
{
    return YES;
}

- (void)applicationDidFinishLaunching:(NSNotification *)note
{
    NSEvent* (^handler)(NSEvent*) = ^(NSEvent *event)
    {
        NSEvent *result = event;
        if(event.keyCode == KEYCODE_ESC)
        {
            [NSApp terminate:nil];
            result = nil;
        }
        else if(event.keyCode == KEYCODE_RIGHT)
        {
            [self displayNextImage];
        }
        else if(event.keyCode == KEYCODE_LEFT)
        {
            [self displayPrevImage];
        }

        return result;
    };

    [NSEvent addLocalMonitorForEventsMatchingMask:NSEventMaskKeyDown handler:handler];

    [self displayNextImage];
}

- (void)displayNextImage
{
    int w, h;
    uint32_t *p = imshow_get_next_image(&w, &h);
    [self displayImage:p width:w height:h];
}

- (void)displayPrevImage
{
    int w, h;
    uint32_t *p = imshow_get_prev_image(&w, &h);
    [self displayImage:p width:w height:h];
}

- (void)displayImage:(uint32_t *)pixels width:(int)w height:(int)h
{
    [window setFrame:[window frameRectForContentRect:NSMakeRect(0, 0, w, h)] display:YES];
    [window center];

    id old_image = [image_view image];
    if(old_image != nil)
    {
        [old_image release];
    }

    NSBitmapImageRep *representation = [[NSBitmapImageRep alloc]
        initWithBitmapDataPlanes: nil
        pixelsWide: w
        pixelsHigh: h
        bitsPerSample: 8
        samplesPerPixel: 4
        hasAlpha: YES
        isPlanar: NO
        colorSpaceName: NSCalibratedRGBColorSpace
        bytesPerRow: w * 4
        bitsPerPixel: 32
    ];

    memcpy([representation bitmapData], pixels, w*h*sizeof(uint32_t));

    NSImage *image = [[NSImage alloc] initWithSize:NSMakeSize(w, h)];
    [image addRepresentation:representation];
    [representation release];

    [image_view setImage:image];
}

@end

int
main(int num_args, char *args[])
{
    int num_images = imshow_init(num_args, args);
    if(num_images <= 0)
    {
        puts("ERROR: No valid images given.");
        puts("USAGE: imshow <images...>");
        return 1;
    }

    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    id app_name = @"imshow";

    AppDelegate *delegate = [AppDelegate new];

    [NSApplication sharedApplication];
    [NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];
    [NSApp setDelegate:delegate];

    NSMenu *menu = [[NSMenu alloc] init];
    [menu autorelease];

    NSMenuItem *app_menu_item = [[NSMenuItem alloc] init];
    [app_menu_item autorelease];

    [menu addItem:app_menu_item];
    [NSApp setMainMenu:menu];

    NSMenu *app_menu = [[NSMenu alloc] init];
    [app_menu autorelease];

    NSMenuItem *app_quit = [[NSMenuItem alloc]  initWithTitle:[@"Quit " stringByAppendingString:app_name]
                                                action:@selector(terminate:)
                                                keyEquivalent:@"q"];
    [app_quit autorelease];

    [app_menu addItem:app_quit];
    [app_menu_item setSubmenu:app_menu];

    NSUInteger window_style = NSWindowStyleMaskTitled | NSWindowStyleMaskClosable | NSWindowStyleMaskResizable | NSWindowStyleMaskMiniaturizable;
    NSRect window_rect = NSMakeRect(10, 10, 640, 480);
    window = [[NSWindow alloc]  initWithContentRect:window_rect
                                styleMask:window_style
                                backing:NSBackingStoreBuffered
                                defer:NO];
    [window autorelease];
    [window setTitle:app_name];

    NSImage *image = [[NSImage alloc] initWithSize:NSMakeSize(640, 480)];
    image_view = [NSImageView imageViewWithImage:image];
    [image_view autorelease];

    [image_view setImageScaling:NSImageScaleNone];
    [image_view setImageFrameStyle:NSImageFrameNone];
    [image_view setImageAlignment:NSImageAlignCenter];

    [window setContentView:image_view];

    NSWindowController *window_controller = [[NSWindowController alloc] initWithWindow:window];
    [window_controller autorelease];

    [window makeKeyAndOrderFront:nil];
    [window center];

    [NSApp activateIgnoringOtherApps:YES];
    [NSApp run];

    [pool drain];

    imshow_quit();
}

