#import <OpenGL/glu.h>
#import <QuickTime/QuickTime.h>

#import "STLuaGraphics.h"

void STLoadLuaGraphicsAPI(lua_State *interpreter)
{
    lua_register(interpreter, "STLoadTexture", STLua_LoadTexture);
}

#define quit_if(b, message) if (b) { \
    NSLog(@"%s", message);           \
    return 0;                        \
}

#define quit_oserr(err, message) quit_if(err != noErr, message)

GLuint STLoadTexture(NSString* textureName)
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:textureName
                                                         ofType:@"png"
                                                    inDirectory:@"Images"];

    if (filePath == nil)
    {
        NSLog(@"Can't find image %@.png", textureName);
        return 0;
    }

    OSStatus err;
    ComponentResult cr;

    FSRef fsref;
    Boolean isdir;
    err = FSPathMakeRef((const UInt8*)[filePath fileSystemRepresentation], &fsref, &isdir);
    quit_oserr(err, "Can't make FSRef from path\n");
    quit_if(isdir, "Path is a directory\n");

    FSSpec fsspec;
    err = FSGetCatalogInfo(&fsref, kFSCatInfoNone, NULL, NULL, &fsspec, NULL);
    quit_oserr(err, "Can't convert FSRef to FSSpec\n");

    GraphicsImportComponent gi;
    err = GetGraphicsImporterForFile(&fsspec, &gi);
    quit_oserr(err, "Can't get graphics import component for file\n");

    Rect natbounds;
    cr = GraphicsImportGetNaturalBounds(gi, &natbounds);
    quit_oserr(cr, "Can't get bounds for image\n");

    quit_if(natbounds.left != 0, "Natural bounds' left is not zero\n");
    quit_if(natbounds.top != 0, "Natural bounds' top is not zero\n");

    size_t buffersize = 4 * natbounds.bottom * natbounds.right;
    void* buf = malloc(buffersize);

    GWorldPtr gw;
    err = QTNewGWorldFromPtr(&gw, k32ARGBPixelFormat, &natbounds, NULL, NULL,
                             0, buf, 4 * natbounds.right);
    quit_oserr(err, "Can't create GWorld\n");

    cr = GraphicsImportSetGWorld(gi, gw, NULL);
    quit_oserr(cr, "Can't set import component's GWorld\n");

    natbounds.top = natbounds.bottom;
    natbounds.bottom = 0;

    cr = GraphicsImportSetBoundsRect(gi, &natbounds);
    quit_oserr(cr, "Can't flip image\n");

    cr = GraphicsImportDraw(gi);
    quit_oserr(cr, "Can't draw image\n");

    err = CloseComponent(gi);
    quit_oserr(err, "Can't close graphics import component\n");

    GLuint textureID;
    glGenTextures(1, &textureID);

    glBindTexture(GL_TEXTURE_2D, textureID);
    gluBuild2DMipmaps(GL_TEXTURE_2D,
                      GL_RGBA,
                      natbounds.right,
                      natbounds.top,
                      GL_BGRA,
                      GL_UNSIGNED_INT_8_8_8_8_REV,
                      buf);
                      
    DisposeGWorld(gw);

    free(buf);

    return textureID;
}

int STLua_LoadTexture(lua_State* interpreter)
{
    const char *textureName = lua_tostring(interpreter, -1);
    lua_pushnumber(interpreter, STLoadTexture([NSString stringWithUTF8String:textureName]));

    return 1;
}
