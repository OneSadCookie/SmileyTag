ruleSets = {};

STImport("tag_rules")
STImport("freeze_rules")
STImport("last_man_rules")

STImport("rendering")
STImport("input")
STImport("world")
STImport("smiley")

fps = 0
time = 0

PRESSED = 1
RELEASED = 0

UP = 1
DOWN = 2
LEFT = 3
RIGHT = 4

WORLD_WIDTH = 1024
WORLD_HEIGHT = 5 * WORLD_WIDTH / 8

setRulesWithName = function (name)
    rules = ruleSets[name]()
end

initialize = function ()
    world = World(WORLD_WIDTH, WORLD_HEIGHT)
    
    numInputManagers = 0
    inputManagers = {}
end

addSmileyToWorld = function (red, green, blue, state, ai)
    numInputManagers = numInputManagers + 1
        
    inputManagers[numInputManagers] = world:addSmiley(Smiley(red,
                                                             green,
                                                             blue,
                                                             state,
                                                             ai))
end

frame = function (dt)
    world:step(dt)
end

buttonPressed = function (player, control)
    inputManagers[player]:buttonPressed(control)
end

buttonReleased = function (player, control)
    inputManagers[player]:buttonReleased(control)
end

reshape = function (width, height)
    if not texturesLoaded then
        loadSmileyTextures()
        loadWorldTextures()
        texturesLoaded = YES
    end
    
    glClearColor(0, 0, 0, 1)
    glClear(GL_COLOR_BUFFER_BIT)
    
    if 5 * width / 8 > height then
        glViewport((width - 8 * height / 5) / 2, 0, 8 * height / 5, height)
    else
        glViewport(0, (height - 5 * width / 8) / 2, width, 5 * width / 8)
    end
        
    glMatrixMode(GL_PROJECTION)
    glLoadIdentity()
    gluOrtho2D(0, WORLD_WIDTH, 0, WORLD_HEIGHT)
    glMatrixMode(GL_MODELVIEW)
    glLoadIdentity()
end
