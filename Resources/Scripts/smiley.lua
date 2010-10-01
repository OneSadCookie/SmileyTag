SMILEY_RADIUS = 32

COLOR_PROPORTION = 0.5

SMILEY_STATE_SMILEY = 1
SMILEY_STATE_SHIELD = 2
SMILEY_STATE_PIRATE = 3
SMILEY_STATE_SLEEPY = 4

CUT_OFF_DISTANCE = 128 * SMILEY_RADIUS

modulatedTextures = { 0, 0, 0, 0 }
decaledTextures = { 0, 0, 0, 0 }

loadTexture = function (name)
    local textureID = STLoadTexture(name)

    glTexParameter(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE)
	glTexParameter(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE)
	glTexParameter(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)
	glTexParameter(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR)
    
    return textureID
end

loadSmileyTextures = function ()
    modulatedTextures[SMILEY_STATE_SMILEY] = loadTexture("smiley_modulated")
    decaledTextures[SMILEY_STATE_SMILEY]   = loadTexture("smiley_decaled")
    
    modulatedTextures[SMILEY_STATE_SHIELD] = loadTexture("shield_modulated")
    decaledTextures[SMILEY_STATE_SHIELD]   = loadTexture("shield_decaled")
    
    modulatedTextures[SMILEY_STATE_PIRATE] = loadTexture("pirate_modulated")
    decaledTextures[SMILEY_STATE_PIRATE]   = loadTexture("pirate_decaled")
    
    modulatedTextures[SMILEY_STATE_SLEEPY] = loadTexture("sleepy_modulated")
    decaledTextures[SMILEY_STATE_SLEEPY]   = loadTexture("sleepy_decaled")
    
    glActiveTextureARB(GL_TEXTURE1_ARB)
    glEnable(GL_TEXTURE_2D)
    glActiveTextureARB(GL_TEXTURE0_ARB)
    glEnable(GL_TEXTURE_2D)
	glEnable(GL_BLEND)
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
end

handleSmileyCollision = function(smiley1, smiley2)
    local newState1, newState2 =
        rules:smileyStatesAfterCollision(smiley1, smiley2)

    if smiley1._state ~= newState1 then
        smiley1._state = newState1
        smiley1._timeInState = 0
    end
    
    if smiley2._state ~= newState2 then
        smiley2._state = newState2
        smiley2._timeInState = 0
    end
end

Smiley = function (red, green, blue, state, ai)
    local smiley =
    {    
        _red = red,
        _green = green,
        _blue = blue,
        
        _x = 0,
        _y = 0,
        
        _vx = 0,
        _vy = 0,
        
        _radius = SMILEY_RADIUS,
        
        _state = state,
        _timeInState = 0,
        
        _inputManager = nil,
        
        _usingAI = ai,
        
        setInputManager = function (self, inputManager)
            self._inputManager = inputManager
        end,
        
        randomizePosition = function (self, width, height)
            local radius = self._radius
        
            self._x = STRandom() * (width - 2 * radius) + radius
            self._y = STRandom() * (height - 2 * radius) + radius
        end,
        
        collidesWithSmiley = function (self, smiley)
            local xSquare = (self._x - smiley._x) * (self._x - smiley._x)
            local ySquare = (self._y - smiley._y) * (self._y - smiley._y)
                        
            return xSquare + ySquare < (4 * self._radius * self._radius) 
        end,

        bounceOffWalls = function (self, leftWallX, rightWallX, topWallY, bottomWallY)
            local radius = self._radius
        
            local leftX = leftWallX + radius
            if self._x < leftX then
                self._x = 2 * leftX - self._x
                self._vx = -1 * self._vx
            end
            
            local rightX = rightWallX - radius
            if self._x > rightX then
                self._x = 2 * rightX - self._x
                self._vx = -1 * self._vx
            end
            
            local topY = topWallY + radius
            if self._y < topY then
                self._y = 2 * topY - self._y
                self._vy = -1 * self._vy
            end
            
            local bottomY = bottomWallY - radius
            if self._y > bottomY then
                self._y = 2 * bottomY - self._y
                self._vy = -1 * self._vy
            end
        end,
    
        draw = function (self)
            glActiveTextureARB(GL_TEXTURE1_ARB)
            glBindTexture(GL_TEXTURE_2D, decaledTextures[self._state])
            glTexEnv(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_DECAL)
            
            glActiveTextureARB(GL_TEXTURE0_ARB)
            glBindTexture(GL_TEXTURE_2D, modulatedTextures[self._state])
            glTexEnv(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE)
        
            renderQuad(self._red, self._green, self._blue,
                       self._x - self._radius, self._y - self._radius,
                       2 * self._radius, 2 * self._radius)
        end,
        
        drawLarge = function (self, worldWidth, worldHeight)
            glActiveTextureARB(GL_TEXTURE1_ARB)
            glBindTexture(GL_TEXTURE_2D, decaledTextures[self._state])
            glTexEnv(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_DECAL)
            
            glActiveTextureARB(GL_TEXTURE0_ARB)
            glBindTexture(GL_TEXTURE_2D, modulatedTextures[self._state])
            glTexEnv(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE)
        
            renderQuad(self._red, self._green, self._blue,
                       0.5 * (worldWidth - 512.0), 0.25 * (worldHeight - 512.0),
                       512.0, 512.0)
        end,
        
        pulsate = function (self, amount)
            if self._usingAI then
                self._radius = SMILEY_RADIUS
            else
                self._radius = SMILEY_RADIUS * (1 + 0.2 * amount)
            end
        end,
        
        update = function(self, dt)
            self._radius = SMILEY_RADIUS
        
            local acceleration = rules.accelerations[self._state]
            local maxSpeed = rules.maxSpeeds[self._state]
        
            if self._inputManager:buttonIsPressed(UP) then
                self._vy = self._vy + (dt * acceleration);
            end
            if self._inputManager:buttonIsPressed(DOWN) then
                self._vy = self._vy - (dt * acceleration);
            end
            if self._inputManager:buttonIsPressed(LEFT) then
                self._vx = self._vx - (dt * acceleration);
            end
            if self._inputManager:buttonIsPressed(RIGHT) then
                self._vx = self._vx + (dt * acceleration);
            end
            
            local speed = math.sqrt((self._vx * self._vx) + (self._vy * self._vy))
            if speed > maxSpeed then
                self._vx = self._vx * maxSpeed / speed
                self._vy = self._vy * maxSpeed / speed
            end
            
            self._x = self._x + (self._vx * dt);
            self._y = self._y + (self._vy * dt);
            
            self._timeInState = self._timeInState + dt
            
            if rules.timeouts[self._state] ~= nil then
                if rules.timeouts[self._state] <= self._timeInState then
                    self._state = rules.statesAfterTimeout[self._state]
                    self.timeInState = 0
                end
            end
        end,
        
        _bias = function (self, myX, myY, otherX, otherY, preference)
            local xDifference = myX - otherX
            local yDifference = myY - otherY
            
            local distance = math.sqrt(xDifference * xDifference +
                                  yDifference * yDifference)
                                  
            distance = distance / CUT_OFF_DISTANCE
                                    
            local preferenceFactor = preference * (distance)
            
            if myX > otherX then
                if myY > otherY then
                    return -preferenceFactor, -preferenceFactor
                else
                    return -preferenceFactor, preferenceFactor
                end
            else
                if myY > otherY then
                    return preferenceFactor, -preferenceFactor
                else
                    return preferenceFactor, preferenceFactor
                end
            end
        end,
        
        AI = function (self, allSmileys, numSmileys, worldWidth, worldHeight)
            if not self._usingAI then
                return
            end
            
            local myPreferenceTable = rules.preferences[self._state]
            
            local horizontalBias = 0
            local verticalBias = 0
            
            local horizontalPreference, verticalPreference
            
            local targetX, targetY
            local targetDistance = 1000000
            local foundTarget = NO
            
            for i = 1, numSmileys do
                local smiley = allSmileys[i]
            
                if myPreferenceTable[smiley._state] <= 0 then
                    horizontalPreference, verticalPreference =
                        self:_bias(self._x, self._y, smiley._x, smiley._y,
                                   myPreferenceTable[smiley._state])
                
                    horizontalBias = horizontalBias + horizontalPreference
                    verticalBias = verticalBias + verticalPreference
                else
                    local distance = math.sqrt((self._x - smiley._x) * (self._x - smiley._x)
                                        + (self._y - smiley._y) * (self._y - smiley._y))
                    distance = distance / myPreferenceTable[smiley._state]
                    
                    if distance < targetDistance then
                        targetX = smiley._x
                        targetY = smiley._y
                        targetDistance = distance
                        foundTarget = YES
                    end
                end
            end
                        
            if foundTarget then
                if targetX > self._x then
                    horizontalBias = horizontalBias + 0.2
                    if targetY > self._y then
                        verticalBias = verticalBias + 0.2
                    else
                        verticalBias = verticalBias - 0.2
                    end
                else
                    horizontalBias = horizontalBias - 0.2
                    if targetY > self._y then
                        verticalBias = verticalBias + 0.2
                    else
                        verticalBias = verticalBias - 0.2
                    end
                end
            end
            
            local cornerHatred = rules.cornerHatred[self._state];
            
            horizontalPreference, verticalPreference =
                self:_bias(self._x, self._y, 0, 0, cornerHatred)
            horizontalBias = horizontalBias + horizontalPreference
            verticalBias = verticalBias + verticalPreference
                        
            horizontalPreference, verticalPreference =
                self:_bias(self._x, self._y, worldWidth, 0, cornerHatred)
            horizontalBias = horizontalBias + horizontalPreference
            verticalBias = verticalBias + verticalPreference
            
            horizontalPreference, verticalPreference =
                self:_bias(self._x, self._y, worldWidth, worldHeight, cornerHatred)
            horizontalBias = horizontalBias + horizontalPreference
            verticalBias = verticalBias + verticalPreference
            
            horizontalPreference, verticalPreference =
                self:_bias(self._x, self._y, 0, worldHeight, cornerHatred)
            horizontalBias = horizontalBias + horizontalPreference
            verticalBias = verticalBias + verticalPreference
            
            if horizontalBias > 0 then
                self._inputManager:buttonPressed(RIGHT)
            elseif horizontalBias < 0 then
                self._inputManager:buttonPressed(LEFT)
            end
            
            if verticalBias > 0 then
                self._inputManager:buttonPressed(UP)
            elseif verticalBias < 0 then
                self._inputManager:buttonPressed(DOWN)
            end
        end,
        
        resetAI = function (self)
            if not self._usingAI then
                return
            end
        
            self._inputManager:buttonReleased(RIGHT)
            self._inputManager:buttonReleased(LEFT)
            self._inputManager:buttonReleased(UP)
            self._inputManager:buttonReleased(DOWN)
        end
    }
    
    return smiley
end