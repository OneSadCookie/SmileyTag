FreezeRules = function ()
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
             600, -- SMILEY_STATE_SHIELD
             600, -- SMILEY_STATE_PIRATE
               0  -- SMILEY_STATE_SLEEPY
        },
        
        timeouts =
        {
            nil,  -- SMILEY_STATE_SMILEY
            1.5,  -- SMILEY_STATE_SHIELD
            nil,  -- SMILEY_STATE_PIRATE
            nil   -- SMILEY_STATE_SLEEPY
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
                -3, --SMILEY_STATE_PIRATE
                 1  --SMILEY_STATE_SLEEPY
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
                 2, --SMILEY_STATE_SMILEY
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
            2, -- SMILEY_STATE_SMILEY
            2, -- SMILEY_STATE_SHIELD
            0, -- SMILEY_STATE_PIRATE
            0  -- SMILEY_STATE_SLEEPY
        },
        
        smileyStatesAfterCollision = function (self, smiley1, smiley2)        
            if smiley1._state == SMILEY_STATE_PIRATE and
               smiley2._state == SMILEY_STATE_SMILEY then
                return SMILEY_STATE_PIRATE, SMILEY_STATE_SLEEPY
            elseif smiley1._state == SMILEY_STATE_SMILEY and
                   smiley2._state == SMILEY_STATE_PIRATE then
                return SMILEY_STATE_SLEEPY, SMILEY_STATE_PIRATE
            elseif smiley1._state == SMILEY_STATE_SMILEY and
                   smiley2._state == SMILEY_STATE_SLEEPY then
                return SMILEY_STATE_SMILEY, SMILEY_STATE_SMILEY
            elseif smiley1._state == SMILEY_STATE_SLEEPY and
                   smiley2._state == SMILEY_STATE_SMILEY then
                return SMILEY_STATE_SMILEY, SMILEY_STATE_SMILEY
            else
                return smiley1._state, smiley2._state
            end
        end,
        
        winner = function (self, allSmileys, numSmileys)
            isOver = YES
            
            pirate = nil
            
            for i = 1, numSmileys do
                if allSmileys[i]._state == SMILEY_STATE_SMILEY then
                    isOver = NO
                    break
                elseif allSmileys[i]._state == SMILEY_STATE_PIRATE then
                    pirate = allSmileys[i]
                end
            end
            
            if isOver then
                return pirate
            else
                return nil
            end
        end
    }
    
    return rules
end

ruleSets["Freeze"] = FreezeRules
