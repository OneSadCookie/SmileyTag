InputManager = function ()
    local inputManager =
    {
        _upPressed = NO,
        _downPressed = NO,
        _leftPressed = NO,
        _rightPressed = NO,
        
        _buttonStateChanged = function (self, button, state)
            if button == UP then
                self._upPressed = state
            elseif button == DOWN then
                self._downPressed = state
            elseif button == LEFT then
                self._leftPressed = state
            else
                self._rightPressed = state
            end
        end,
        
        buttonPressed = function (self, button)
            self:_buttonStateChanged(button, YES)
        end,
        
        buttonReleased = function (self, button)
            self:_buttonStateChanged(button, NO)
        end,
        
        buttonIsPressed = function (self, button)        
            if button == UP then
                return self._upPressed
            elseif button == DOWN then
                return self._downPressed
            elseif button == LEFT then
                return self._leftPressed
            else
                return self._rightPressed
            end
        end
    }
    
    return inputManager
end