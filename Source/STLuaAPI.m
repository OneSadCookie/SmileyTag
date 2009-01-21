#import "STErrors.h"
#import "STLuaAPI.h"

#import <lauxlib.h>

void STLoadLuaAPI(lua_State *interpreter)
{
    lua_pushnil(interpreter);
    lua_setglobal(interpreter, "NO");

    lua_pushnumber(interpreter, 1);
    lua_setglobal(interpreter, "YES");

    lua_register(interpreter, "STImport",     STLua_Import);
    lua_register(interpreter, "STFatalError", STLua_FatalError);
    lua_register(interpreter, "STLog",        STLua_Log);
    lua_register(interpreter, "STRandom",     STLua_Random);
}

void STImport(NSString *scriptName, lua_State *interpreter)
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:scriptName
                                                         ofType:@"lua"
                                                    inDirectory:@"Scripts"];

    int error = luaL_loadfile(interpreter, [filePath fileSystemRepresentation]);
    if (error != 0)
    {
        NSString *message = NSLocalizedString(@"The error `%u' occurred while trying to load the Lua script `%@'",
                                              @"Lua error");

        STFatalError([NSString stringWithFormat:message, error, scriptName]);
    }
    
    // lua_dofile replaced in 5.1 by luaL_loadfile, lua_pcall for reasons I can
    // only find explained in Japanese...
    error = lua_pcall(interpreter, 0, 0, 0);
    if (error != 0)
    {
        NSString *message = NSLocalizedString(@"The error `%u' occurred while trying to run the Lua script `%@'",
                                              @"Lua error");

        STFatalError([NSString stringWithFormat:message, error, scriptName]);
    }
}

double STRandom(void)
{
    static BOOL initialized = NO;
    static unsigned int high, low;

    if (!initialized)
    {
        low = time(NULL);
        high = ~low;

        initialized = YES;
    }
    
    high = (high << 16) + (high >> 16);
    high += low;
    low += high;
    
    return (double)high / (double)(0xffffffff);
}

//-----

int  STLua_FatalError(lua_State *interpreter)
{
    const char *message = lua_tostring(interpreter, -1);
    
    if (message == NULL)
    {
        STFatalError(NSLocalizedString(@"An unknown fatal error occurred while running a Lua script",
                                       @"Lua fatal error error"));
    }

    STFatalError([NSString stringWithUTF8String:message]);
}

int  STLua_Import(lua_State *interpreter)
{
    const char *scriptName = lua_tostring(interpreter, -1);

    if (scriptName == NULL)
    {
        STFatalError(NSLocalizedString(@"A Lua script attempted to import a nonexistent script",
                                       @"Lua import error"));
    }
    
    STImport([NSString stringWithUTF8String:scriptName], interpreter);

    return 0;
}

int STLua_Log(lua_State *interpreter)
{
    const char *message = lua_tostring(interpreter, -1);

    if (message != NULL)
    {
        NSLog(@"Lua: %s", message);
    }
    else
    {
        NSLog(@"Lua: Unknown message");
    }

    return 0;
}

int STLua_Random(lua_State *interpreter)
{
    lua_pushnumber(interpreter, STRandom());
    return 1;
}
