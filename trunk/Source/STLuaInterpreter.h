#import <Cocoa/Cocoa.h>

#import <lua.h>

@interface STLuaInterpreter : NSObject
{
    lua_State *_interpreter;
}

- (id)init;

- (lua_State *)interpreter;

@end
