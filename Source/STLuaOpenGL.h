#import <lua.h>

extern void STLoadLuaOpenGL(lua_State *interpreter);

//-----

extern int STLua_glActiveTextureARB(lua_State *interpreter);
extern int STLua_glBegin(lua_State *interpreter);
extern int STLua_glBindTexture(lua_State *interpreter);
extern int STLua_glBlendFunc(lua_State *interpreter);
extern int STLua_glClear(lua_State *interpreter);
extern int STLua_glClearColor(lua_State *interpreter);
extern int STLua_glColor3(lua_State *interpreter);
extern int STLua_glDisable(lua_State *interpreter);
extern int STLua_glEnable(lua_State *interpreter);
extern int STLua_glEnd(lua_State *interpreter);
extern int STLua_glLoadIdentity(lua_State *interpreter);
extern int STLua_glMatrixMode(lua_State *interpreter);
extern int STLua_glMultiTexCoord2ARB(lua_State *interpreter);
extern int STLua_glTexEnv(lua_State *interpreter);
extern int STLua_glTexParameter(lua_State *interpreter);
extern int STLua_glVertex2(lua_State *interpreter);
extern int STLua_glViewport(lua_State *interpreter);

extern int STLua_gluOrtho2D(lua_State *interpreter);


