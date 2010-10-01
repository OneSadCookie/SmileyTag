START_GAME_WAIT_TIME = 2

loadWorldTextures = function ()
    winTexture = STLoadTexture("win")
    glTexParameter(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE)
	glTexParameter(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE)
	glTexParameter(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)
	glTexParameter(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR)
end

World = function (width, height)
    local world =
    {
        _width = width,
        _height = height,
        
        _smileys = {},
        _numSmileys = 0,
        
        _gameOver = NO,
        _gameTime = 0,
        
        addSmiley = function (self, smiley)
            self._numSmileys = self._numSmileys + 1
            self._smileys[self._numSmileys] = smiley
            smiley:randomizePosition(self._width, self._height)
            
            local inputManager = InputManager()
            smiley:setInputManager(inputManager)
            
            return inputManager
        end,
        
        step = function (self, dt)
            self._gameTime = self._gameTime + dt
            
            self:_renderBackground()
        
            for smiley = 1, self._numSmileys do
                self._smileys[smiley]:draw()
            end
        
            if self._gameTime >= START_GAME_WAIT_TIME then
                local winner = rules:winner(self._smileys, self._numSmileys)
                if winner ~= nil then
                    self:_drawGameOverScreen(winner)
                else
                    for smiley = 1, self._numSmileys do
                        local smiley1 = self._smileys[smiley]
                    
                        smiley1:AI(self._smileys, self._numSmileys, self._width, self._height)
                        smiley1:update(dt)
                        smiley1:resetAI()
                        smiley1:bounceOffWalls(0, self._width, 0, self._height)
                        
                        for otherSmiley = 1, smiley - 1 do
                            local smiley2 = self._smileys[otherSmiley]
                        
                            if smiley1:collidesWithSmiley(smiley2) then
                                handleSmileyCollision(smiley1, smiley2)
                            end
                        end
                    end
                end
            else
                for smiley = 1, self._numSmileys do
                    self._smileys[smiley]:pulsate(math.sin(2 * math.pi * self._gameTime))
                end
            end
        end,
        
        _renderBackground = function (self)
            glActiveTextureARB(GL_TEXTURE1_ARB)
            glDisable(GL_TEXTURE_2D)
            glActiveTextureARB(GL_TEXTURE0_ARB)
            glDisable(GL_TEXTURE_2D)
            
            renderQuad(1, 1, 1, 0, 0, self._width, self._height)
            
            glEnable(GL_TEXTURE_2D)
            glActiveTextureARB(GL_TEXTURE1_ARB)
            glEnable(GL_TEXTURE_2D)
        end,
        
        _drawGameOverScreen = function (self, winner)
            winner:drawLarge(self._width, self._height)
        
            glActiveTextureARB(GL_TEXTURE1_ARB)
            glDisable(GL_TEXTURE_2D)
            
            glActiveTextureARB(GL_TEXTURE0_ARB)
            glBindTexture(GL_TEXTURE_2D, winTexture)
            glTexEnv(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE)
        
            renderQuad(winner._red, winner._green, winner._blue,
                       0.5 * (self._width - 512),
                       0.5 * (self._height - 512.0),
                       512.0, 512.0)
                       
            glActiveTextureARB(GL_TEXTURE1_ARB)
            glEnable(GL_TEXTURE_2D)
        end
    }
    
    return world
end