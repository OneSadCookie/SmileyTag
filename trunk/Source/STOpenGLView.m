#import <OpenGL/gl.h>

#import "STErrors.h"
#import "STInputController.h"
#import "STLuaInterpreter.h"
#import "STOpenGLView.h"

@implementation STOpenGLView

static NSOpenGLPixelFormatAttribute STOpenGLAttributes[] =
{
    NSOpenGLPFADoubleBuffer,
    0
};

- (id)initWithFrame:(NSRect)frame
{
    NSOpenGLPixelFormat *pixelFormat = [[[NSOpenGLPixelFormat alloc] initWithAttributes:
        STOpenGLAttributes] autorelease];

    self = [super initWithFrame:frame pixelFormat:pixelFormat];
    if (self == nil)
    {
        STFatalError(NSLocalizedString(@"Can't create OpenGL context",
                                       @"GL context creation failure message"));
    }

    _lastFrameTime = 0;

    (void)[NSTimer scheduledTimerWithTimeInterval:0.001
                                           target:self
                                         selector:@selector(display)
                                         userInfo:nil
                                          repeats:YES];

    return self;
}

- (BOOL)resignFirstResponder
{
    return NO;
}

- (void)keyDown:(NSEvent *)event
{
    BOOL handled = [inputController buttonPressed:event];

    if (!handled)
    {
        [super keyDown:event];
    }
}

- (void)keyUp:(NSEvent *)event
{
    BOOL handled = [inputController buttonReleased:event];

    if (!handled)
    {
        [super keyUp:event];
    }
}

- (void)resetGameTime
{
    _lastFrameTime = 0;
}

- (void)drawRect:(NSRect)rect
{
    if (_lastFrameTime == 0)
    {
        _lastFrameTime = [NSDate timeIntervalSinceReferenceDate];
    }

    NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];

    lua_State *L = [interpreter interpreter];
    
    lua_getglobal(L, "frame");
    lua_pushnumber(L, now - _lastFrameTime);
    lua_call(L, 1, 0);

    _lastFrameTime = now;

    [[self openGLContext] flushBuffer];
}

- (void)update
{
    [super update];
}

- (void)reshape
{
    [super reshape];

    NSRect bounds = [self bounds];

    lua_State *L = [interpreter interpreter];
    
    lua_getglobal(L, "reshape");
    lua_pushnumber(L, bounds.size.width);
    lua_pushnumber(L, bounds.size.height);
    lua_call(L, 2, 0);
}

@end
