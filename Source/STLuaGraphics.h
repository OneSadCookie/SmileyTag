#import <Cocoa/Cocoa.h>
#import <OpenGL/gl.h>

#import <lua.h>

extern void STLoadLuaGraphicsAPI(lua_State *interpreter);

extern GLuint STLoadTexture(NSString* textureName);

//-----

extern int STLua_LoadTexture(lua_State* interpreter);
