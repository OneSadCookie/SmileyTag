#import "STInputController.h"
#import "STLuaInterpreter.h"

#define UP 1
#define DOWN 2
#define LEFT 3
#define RIGHT 4

@implementation STInputController

- (id)init
{
    self = [super init];
    if (self == nil)
    {
        return nil;
    }

    _player1ID = 1;
    _player2ID = 0;
    _player3ID = 0;
    _player4ID = 0;
        
    return self;
}

- (BOOL)sendControlMessage:(const char *)message forEvent:(NSEvent *)event
{
    int keyCode = [event keyCode];

    int player, control;

    switch (keyCode)
    {
        case 0x7E: player = _player1ID; control = UP;    break;
        case 0x7B: player = _player1ID; control = LEFT;  break;
        case 0x7D: player = _player1ID; control = DOWN;  break;
        case 0x7C: player = _player1ID; control = RIGHT; break;
        
        case 0x0D: player = _player2ID; control = UP;    break;
        case 0x00: player = _player2ID; control = LEFT;  break;
        case 0x01: player = _player2ID; control = DOWN;  break;
        case 0x02: player = _player2ID; control = RIGHT; break;

        case 0x22: player = _player3ID; control = UP;    break;
        case 0x26: player = _player3ID; control = LEFT;  break;
        case 0x28: player = _player3ID; control = DOWN;  break;
        case 0x25: player = _player3ID; control = RIGHT; break;

        case 0x5B: player = _player4ID; control = UP;    break;
        case 0x56: player = _player4ID; control = LEFT;  break;
        case 0x57: player = _player4ID; control = DOWN;  break;
        case 0x58: player = _player4ID; control = RIGHT; break;
        case 0x54: player = _player4ID; control = DOWN;  break;
        
        default: return NO;
    }

    if (player == NO_PLAYER)
    {
        return NO;
    }

    lua_State *L = [interpreter interpreter];

    lua_getglobal(L, message);
    lua_pushnumber(L, player);
    lua_pushnumber(L, control);
    lua_call(L, 2, 0);

    return YES;
}

- (BOOL)buttonPressed:(NSEvent *)event
{
    return [self sendControlMessage:"buttonPressed" forEvent:event];
}

- (BOOL)buttonReleased:(NSEvent *)event
{
    return [self sendControlMessage:"buttonReleased" forEvent:event];
}

- (void)setPlayer1ID:(int)ID
{
    _player1ID = ID;
}

- (void)setPlayer2ID:(int)ID
{
    _player2ID = ID;
}

- (void)setPlayer3ID:(int)ID
{
    _player3ID = ID;
}

- (void)setPlayer4ID:(int)ID
{
    _player4ID = ID;
}

@end
