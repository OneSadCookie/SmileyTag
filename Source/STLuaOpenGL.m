#import <OpenGL/gl.h>
#import <OpenGL/glu.h>
#import <OpenGL/glext.h>

#import "STLuaOpenGL.h"

void STLoadLuaOpenGL(lua_State *interpreter)
{
#define STGLConstant(symbol) lua_pushnumber(interpreter, symbol); lua_setglobal(interpreter, #symbol)
    STGLConstant(GL_BLEND);
    STGLConstant(GL_CLAMP_TO_EDGE);
    STGLConstant(GL_COLOR_BUFFER_BIT);
    STGLConstant(GL_DECAL);
    STGLConstant(GL_LINEAR);
    STGLConstant(GL_LINEAR_MIPMAP_LINEAR);
    STGLConstant(GL_MODELVIEW);
    STGLConstant(GL_MODULATE);
    STGLConstant(GL_ONE_MINUS_SRC_ALPHA);
    STGLConstant(GL_PROJECTION);
    STGLConstant(GL_QUADS);
    STGLConstant(GL_SRC_ALPHA);
    STGLConstant(GL_TEXTURE0_ARB);
    STGLConstant(GL_TEXTURE1_ARB);
    STGLConstant(GL_TEXTURE_2D);
    STGLConstant(GL_TEXTURE_ENV);
    STGLConstant(GL_TEXTURE_ENV_MODE);
    STGLConstant(GL_TEXTURE_MAG_FILTER);
    STGLConstant(GL_TEXTURE_MIN_FILTER);
    STGLConstant(GL_TEXTURE_WRAP_S);
    STGLConstant(GL_TEXTURE_WRAP_T);
#undef STGLConstant

#define STGLFunction(name) lua_register(interpreter, #name, STLua_##name)
    STGLFunction(glActiveTextureARB);
    STGLFunction(glBegin);
    STGLFunction(glBindTexture);
    STGLFunction(glBlendFunc);
    STGLFunction(glClear);
    STGLFunction(glClearColor);
    STGLFunction(glColor3);
    STGLFunction(glDisable);
    STGLFunction(glEnable);
    STGLFunction(glEnd);
    STGLFunction(glLoadIdentity);
    STGLFunction(glMatrixMode);
    STGLFunction(glMultiTexCoord2ARB);
    STGLFunction(glTexEnv);
    STGLFunction(glTexParameter);
    STGLFunction(glVertex2);
    STGLFunction(glViewport);
    STGLFunction(gluOrtho2D);
#undef STGLFunction
}

//-----

int STLua_glActiveTextureARB(lua_State *interpreter)
{
    glActiveTextureARB(lua_tonumber(interpreter, -1));
    return 0;
}

int STLua_glBegin(lua_State *interpreter)
{
    glBegin(lua_tonumber(interpreter, -1));
    return 0;
}

int STLua_glBindTexture(lua_State *interpreter)
{
    glBindTexture(lua_tonumber(interpreter, -2),
                  lua_tonumber(interpreter, -1));
    return 0;
}

int STLua_glBlendFunc(lua_State *interpreter)
{
    glBlendFunc(lua_tonumber(interpreter, -2),
                lua_tonumber(interpreter, -1));
    return 0;
}

int STLua_glClear(lua_State *interpreter)
{
    glClear(lua_tonumber(interpreter, -1));
    return 0;
}

int STLua_glClearColor(lua_State *interpreter)
{
    glClearColor(lua_tonumber(interpreter, -4),
                 lua_tonumber(interpreter, -3),
                 lua_tonumber(interpreter, -2),
                 lua_tonumber(interpreter, -1));
    return 0;
}

int STLua_glColor3(lua_State *interpreter)
{
    glColor3d(lua_tonumber(interpreter, -3),
              lua_tonumber(interpreter, -2),
              lua_tonumber(interpreter, -1));
    return 0;
}

int STLua_glDisable(lua_State *interpreter)
{
    glDisable(lua_tonumber(interpreter, -1));
    return 0;
}

extern int STLua_glEnable(lua_State *interpreter)
{
    glEnable(lua_tonumber(interpreter, -1));
    return 0;
}

int STLua_glEnd(lua_State *interpreter)
{
    glEnd();
    return 0;
}

int STLua_glLoadIdentity(lua_State *interpreter)
{
    glLoadIdentity();
    return 0;
}

int STLua_glMatrixMode(lua_State *interpreter)
{
    glMatrixMode(lua_tonumber(interpreter, -1));
    return 0;
}

int STLua_glMultiTexCoord2ARB(lua_State *interpreter)
{
    glMultiTexCoord2dARB(lua_tonumber(interpreter, -3),
                         lua_tonumber(interpreter, -2),
                         lua_tonumber(interpreter, -1));
    return 0;
}

int STLua_glTexEnv(lua_State *interpreter)
{
    glTexEnvi(lua_tonumber(interpreter, -3),
              lua_tonumber(interpreter, -2),
              lua_tonumber(interpreter, -1));
    return 0;
}

int STLua_glTexParameter(lua_State *interpreter)
{
    glTexParameteri(lua_tonumber(interpreter, -3),
                    lua_tonumber(interpreter, -2),
                    lua_tonumber(interpreter, -1));
    return 0;
}

int STLua_glVertex2(lua_State *interpreter)
{
    glVertex2d(lua_tonumber(interpreter, -2),
               lua_tonumber(interpreter, -1));
    return 0;
}

int STLua_glViewport(lua_State *interpreter)
{
    glViewport(lua_tonumber(interpreter, -4),
               lua_tonumber(interpreter, -3),
               lua_tonumber(interpreter, -2),
               lua_tonumber(interpreter, -1));
    return 0;
}

int STLua_gluOrtho2D(lua_State *interpreter)
{
    gluOrtho2D(lua_tonumber(interpreter, -4),
               lua_tonumber(interpreter, -3),
               lua_tonumber(interpreter, -2),
               lua_tonumber(interpreter, -1));
    return 0;
}


