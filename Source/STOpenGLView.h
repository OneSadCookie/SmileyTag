#import <Cocoa/Cocoa.h>

#import <lua.h>

@class STInputController;

@interface STOpenGLView : NSOpenGLView
{
    IBOutlet STInputController *inputController;
    IBOutlet STLuaInterpreter  *interpreter;
    
    NSTimeInterval             _lastFrameTime;
}

- (void)resetGameTime;

@end
