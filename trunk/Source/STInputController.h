#import <Cocoa/Cocoa.h>

@class STLuaInterpreter;

#define NO_PLAYER 0

@interface STInputController : NSObject
{
    IBOutlet STLuaInterpreter *interpreter;

    int _player1ID, _player2ID, _player3ID, _player4ID;
}

- (void)setPlayer1ID:(int)ID;
- (void)setPlayer2ID:(int)ID;
- (void)setPlayer3ID:(int)ID;
- (void)setPlayer4ID:(int)ID;

- (BOOL)buttonPressed:(NSEvent *)event;
- (BOOL)buttonReleased:(NSEvent *)event;

@end
