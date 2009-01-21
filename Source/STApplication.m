#import <lualib.h>

#import "STApplication.h"
#import "STErrors.h"
#import "STInputController.h"
#import "STLuaAPI.h"
#import "STLuaInterpreter.h"
#import "STLuaGraphics.h"
#import "STLuaOpenGL.h"
#import "STOpenGLView.h"

#define SMILEY_STATE_SMILEY 1
#define SMILEY_STATE_PIRATE 3

static double colors[6][3] =
{
    { 1, 1, 0 }, { 0, 1, 0 }, { 1, 0, 1 }, { 0, 1, 1 }, { 1, 0, 0 }, { 0, 0, 1 }
};

#define addSmiley(number) addSmileyToWorld(L,                                \
                                           player##number##Type,             \
                                           player##number##In,               \
                                           number)

static BOOL addSmileyToWorld(lua_State* L,
                             NSMatrix *type,
                             NSButton *initiallyIn,
                             int number)
{
    if ([[type cellWithTag:0] state] == NSOnState)
    {
        return NO;
    }

    lua_getglobal(L, "addSmileyToWorld");
    lua_pushnumber(L, colors[number - 1][0]);
    lua_pushnumber(L, colors[number - 1][1]);
    lua_pushnumber(L, colors[number - 1][2]);

    BOOL pirate = [initiallyIn state] == NSOnState;
    
    lua_pushnumber(L, pirate ? SMILEY_STATE_PIRATE : SMILEY_STATE_SMILEY);

    BOOL computerControlled = [[type cellWithTag:1] state] == NSOnState;
    
    lua_getglobal(L, computerControlled ? "YES" : "NO");
    lua_call(L, 5, 0);

    return YES;
}

@implementation STApplication

#define checkPlayer(number)                                     \
if ([[player##number##Type cellWithTag:0] state] == NSOffState) \
{                                                               \
    ++numPlaying;                                               \
    if ([player##number##In state] == NSOnState)                \
    {                                                           \
        ++numIn;                                                \
    }                                                           \
}

- (BOOL)_userReallyWantsToPlay
{
    unsigned int numPlaying = 0;
    unsigned int numIn = 0;

    checkPlayer(1);
    checkPlayer(2);
    checkPlayer(3);
    checkPlayer(4);
    checkPlayer(5);
    checkPlayer(6);

    if ((numIn >= 1) && (numIn < numPlaying))
    {
        return YES;
    }
    else
    {
        return NSRunAlertPanel(@"Do you really want to play with that setup?",
                               @"The setup you have chosen either has all players in or no players in, and will therefore not be very interesting to play.",
                               @"No",
                               @"Yes",
                               nil) == NSAlertAlternateReturn;
    }
}

- (IBAction)newGame:(id)sender
{
    if (![self _userReallyWantsToPlay])
    {
        return;
    }

    [glView resetGameTime];
    
    lua_State *L = [interpreter interpreter];

    lua_getglobal(L, "setRulesWithName");
    lua_pushstring(L, [[gameTypePopup titleOfSelectedItem] UTF8String]);
    lua_call(L, 1, 0);

    lua_getglobal(L, "initialize");
    lua_call(L, 0, 0);

    int player1ID, player2ID, player3ID, player4ID;
    int nextID = 1;

    player1ID = addSmiley(1) ? nextID++ : 0;
    player2ID = addSmiley(2) ? nextID++ : 0;
    player3ID = addSmiley(3) ? nextID++ : 0;
    player4ID = addSmiley(4) ? nextID++ : 0;
    addSmiley(5);
    addSmiley(6);

    [inputController setPlayer1ID:player1ID];
    [inputController setPlayer2ID:player2ID];
    [inputController setPlayer3ID:player3ID];
    [inputController setPlayer4ID:player4ID];
    
    [newGamePanel orderOut:self];
    [window makeKeyAndOrderFront:self];
    (void)[window makeFirstResponder:glView];
}

- (IBAction)endGame:(id)sender
{
    [window orderOut:self];
    [newGamePanel makeKeyAndOrderFront:self];
}

- (IBAction)showPreferences:(id)sender
{
}

- (IBAction)validatePlayButton:(id)sender
{
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    lua_State *L = [interpreter interpreter];

    luaopen_math(L);
    
    STLoadLuaAPI(L);
    STLoadLuaOpenGL(L);
    STLoadLuaGraphicsAPI(L);
    STImport(@"main", L);

    [window center];
}

@end
