#import <Cocoa/Cocoa.h>

#import <lua.h>

extern void STLoadLuaAPI(lua_State *interpreter);

extern void STImport(NSString *scriptName, lua_State *interpreter);
extern double STRandom(void);

//-----

extern int  STLua_FatalError(lua_State *interpreter) __attribute__((noreturn));
extern int  STLua_Import(lua_State *interpreter);
extern int  STLua_Log(lua_State *interpreter);
extern int  STLua_Random(lua_State *interpreter);
