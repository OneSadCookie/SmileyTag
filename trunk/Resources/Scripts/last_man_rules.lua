LastManRules = function ()
    local rules =
    {
        accelerations =
        {
            1200, -- SMILEY_STATE_SMILEY
            1200, -- SMILEY_STATE_SHIELD
            1200, -- SMILEY_STATE_PIRATE
               0  -- SMILEY_STATE_SLEEPY
        },
        
        maxSpeeds =
        {
             600, -- SMILEY_STATE_SMILEY
               0, -- SMILEY_STATE_SHIELD
             400, -- SMILEY_STATE_PIRATE
               0  -- SMILEY_STATE_SLEEPY
        },
        
        timeouts =
        {
            nil,  -- SMILEY_STATE_SMILEY
            nil,  -- SMILEY_STATE_SHIELD
            nil,  -- SMILEY_STATE_PIRATE
            2.0   -- SMILEY_STATE_SLEEPY
        },
        
        statesAfterTimeout =
        {
            SMILEY_STATE_SMILEY, -- SMILEY_STATE_SMILEY
            SMILEY_STATE_SMILEY, -- SMILEY_STATE_SHIELD
            SMILEY_STATE_PIRATE, -- SMILEY_STATE_PIRATE
            SMILEY_STATE_PIRATE  -- SMILEY_STATE_SLEEPY
        },
        
        preferences =
        {
            -- SMILEY_STATE_SMILEY
            {
                -1, --SMILEY_STATE_SMILEY
                 0, --SMILEY_STATE_SHIELD
                -1, --SMILEY_STATE_PIRATE
                -1  --SMILEY_STATE_SLEEPY
            },
            -- SMILEY_STATE_SHIELD
            {
                 0, --SMILEY_STATE_SMILEY
                 0, --SMILEY_STATE_SHIELD
                 0, --SMILEY_STATE_PIRATE
                 0  --SMILEY_STATE_SLEEPY
            },
            -- SMILEY_STATE_PIRATE
            {
                 3, --SMILEY_STATE_SMILEY
                 0, --SMILEY_STATE_SHIELD
                -1, --SMILEY_STATE_PIRATE
                 0  --SMILEY_STATE_SLEEPY
            },
            -- SMILEY_STATE_SLEEPY
            {
                 0, --SMILEY_STATE_SMILEY
                 0, --SMILEY_STATE_SHIELD
                 0, --SMILEY_STATE_PIRATE
                 0  --SMILEY_STATE_SLEEPY
            },
        },
        
        cornerHatred =
        {
            4, -- SMILEY_STATE_SMILEY
            0, -- SMILEY_STATE_SHIELD
            0, -- SMILEY_STATE_PIRATE
            0  -- SMILEY_STATE_SLEEPY
        },
        
        _lastTagged = nil,
                
        smileyStatesAfterCollision = function (self, smiley1, smiley2)        
            if smiley1._state == SMILEY_STATE_PIRATE and
               smiley2._state == SMILEY_STATE_SMILEY then
                self._lastTagged = smiley2
                return SMILEY_STATE_PIRATE, SMILEY_STATE_SLEEPY
            elseif smiley1._state == SMILEY_STATE_SMILEY and
                   smiley2._state == SMILEY_STATE_PIRATE then
                self._lastTagged = smiley1
                return SMILEY_STATE_SLEEPY, SMILEY_STATE_PIRATE
            else
                return smiley1._state, smiley2._state
            end
        end,
        
        winner = function (self, allSmileys, numSmileys)
            isOver = YES
            
            for i = 1, numSmileys do
                if allSmileys[i]._state == SMILEY_STATE_SMILEY then
                    isOver = NO
                    break
                end
            end
            
            if isOver then
                return self._lastTagged
            else
                return nil
            end
        end
    }
    
    return rules
end

ruleSets["Last Man Standing"] = LastManRules
