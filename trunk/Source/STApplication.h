#import <Cocoa/Cocoa.h>

#import <lua.h>

@class STLuaInterpreter, STOpenGLView, STInputController;

@interface STApplication : NSObject
{
    IBOutlet STOpenGLView *glView;
    IBOutlet STLuaInterpreter *interpreter;
    IBOutlet NSPanel *newGamePanel;
    IBOutlet NSButton *playButton;
    IBOutlet STInputController *inputController;
    IBOutlet NSPopUpButton *gameTypePopup;
    
    IBOutlet NSButton *player1In;
    IBOutlet NSMatrix *player1Type;
    IBOutlet NSButton *player2In;
    IBOutlet NSMatrix *player2Type;
    IBOutlet NSButton *player3In;
    IBOutlet NSMatrix *player3Type;
    IBOutlet NSButton *player4In;
    IBOutlet NSMatrix *player4Type;
    IBOutlet NSButton *player5In;
    IBOutlet NSMatrix *player5Type;
    IBOutlet NSButton *player6In;
    IBOutlet NSMatrix *player6Type;
    
    IBOutlet NSWindow *window;
}

- (IBAction)endGame:(id)sender;
- (IBAction)newGame:(id)sender;
- (IBAction)showPreferences:(id)sender;
- (IBAction)validatePlayButton:(id)sender;

@end
