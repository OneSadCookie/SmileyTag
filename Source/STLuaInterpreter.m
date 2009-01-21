#import <lauxlib.h>

#import "STLuaAPI.h"
#import "STLuaInterpreter.h"

@implementation STLuaInterpreter

- (id)init
{
    _interpreter = lua_open();

    if (_interpreter == NULL)
    {
        [self dealloc];
        return nil;
    }
    
    lua_atpanic(_interpreter, STLua_FatalError);

    return self;
}

- (void)dealloc
{
    lua_close(_interpreter);
    [super dealloc];
}

- (lua_State *)interpreter
{
    return _interpreter;
}

@end
