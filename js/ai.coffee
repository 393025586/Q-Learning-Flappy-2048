class AI
        getAiState: (state) ->
                # returns [right to next block's left, top to current block's bottom, dead]
                ab = state.ableft - state.size
                cd = state.cdleft - state.size
                dead = state.score == 0
                if ab < 0
                        return [cd, state.birdtop - state.abceiling, dead]
                if cd < 0
                        return [ab, state.birdtop - state.cdceiling, dead]
                if ab < cd
                        return [cd, state.birdtop - state.abceiling, dead]
                return [ab, state.birdtop - state.cdceiling, dead]
                        
        play: (@game, @state) ->
                # Do AI stuff
                if Math.random() > 0.95
                        @game.jump()

                ai_state = @getAiState(@state)
                console.log ai_state
                
                
window.AI = new AI()
