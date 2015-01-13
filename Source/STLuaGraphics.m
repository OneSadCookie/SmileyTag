#import <ApplicationServices/ApplicationServices.h>

#if __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ < 1050
// This function was publicized in 10.5, but is available prior
CG_EXTERN CFDataRef CGDataProviderCopyData(CGDataProviderRef provider);
#endif

#import <OpenGL/glu.h>

#import "STLuaGraphics.h"

void STLoadLuaGraphicsAPI(lua_State *interpreter)
{
    lua_register(interpreter, "STLoadTexture", STLua_LoadTexture);
}

#define quit_if(b, ...) if (b) { \
    NSLog(__VA_ARGS__);          \
    return 0;                    \
}

#define quit_oserr(err, message) quit_if(err != noErr, message)

GLuint STLoadTexture(NSString* textureName)
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:textureName
                                                         ofType:@"png"
                                                    inDirectory:@"Images"];

    quit_if(filePath == nil, @"Can't find image %@.png", textureName);
    CFURLRef url = (CFURLRef)[NSURL fileURLWithPath:filePath];
    
    // This whole mess seems highly dubious (how do we know the data is RGBA
    // and will always be so?)  But it allows loading non-premultiplied data
    // without QuickTime (deprecated) or libpng...
    
    CGImageSourceRef imageSource = CGImageSourceCreateWithURL(url, NULL);
    [(id)imageSource autorelease];
    quit_if(imageSource == NULL, @"Can't create source for image %@.png", textureName);
    
    CGImageRef image = CGImageSourceCreateImageAtIndex(imageSource, 0, NULL);
    [(id)image autorelease];
    quit_if(image == NULL, @"Can't create image %@.png", textureName);
    
    NSData *imageData = (NSData *)CGDataProviderCopyData(
        CGImageGetDataProvider(image));
    [imageData autorelease];
    
    size_t width = CGImageGetWidth(image);
    size_t height = CGImageGetHeight(image);
    
    quit_if((width & (width - 1)) || (height & (height - 1)),
        @"Image %@.png is non-power-of-two", textureName);
    
    GLuint textureID;
    glGenTextures(1, &textureID);

    glBindTexture(GL_TEXTURE_2D, textureID);
    gluBuild2DMipmaps(GL_TEXTURE_2D,
                      GL_RGBA,
                      width,
                      height,
                      GL_RGBA,
                      GL_UNSIGNED_BYTE,
                      [imageData bytes]);
    
    return textureID;
}

int STLua_LoadTexture(lua_State* interpreter)
{
    const char *textureName = lua_tostring(interpreter, -1);
    lua_pushnumber(interpreter, STLoadTexture([NSString stringWithUTF8String:textureName]));

    return 1;
}
