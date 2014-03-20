class AI
        play: (@actuator) ->
                # Do AI stuff
                if Math.random() > 0.95
                        @actuator.game.jump()
window.AI = new AI()
                
