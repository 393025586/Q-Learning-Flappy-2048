class AI
        constructor: (@live_reward = 1, @dead_reward = -1000, @alpha = 0.5, @gamma = 0.8, @scale = 0.1) ->
                @Q = {}
                @dead_already = false
                
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
        scaleDown: (ai_state, step) ->
                S = []
                for s in ai_state
                        S.push Math.floor(s / step)
                return S

        initQ: (s) ->
                scaled_bird_height = @state.size / @scale
                # Lazy initialization
                if not @Q[s[0]]?
                        @Q[s[0]] = {}
                if not @Q[s[0]][s[1]]?
                        @Q[s[0]][s[1]] = {jump: (if s[1] < scaled_bird_height then -100 else 0), idle: (if s[1] > scaled_bird_height then -5 else 0)}
                return @Q[s[0]][s[1]]
                

        writeQ: (s, a, r) ->
                @initQ(s)[a] = r

        readQ: (s) ->
                @initQ(s)
                
        
        play: (@game, @state, @ui) ->
                # Observe 
                ai_state = @getAiState(@state)
                s = @scaleDown(ai_state[0..1], @scale)
                # Immediate reward
                # should handle death once only
                #r = if ai_state[2] then @dead_reward else @live_reward
                @ui.state.textContent = "(#{s[0]}, #{s[1]}) Dead: #{ai_state[2]}"

                r = @live_reward
                if ai_state[2]
                        if not @dead_already
                                r = @dead_reward
                                @dead_already = true
                else if @dead_already
                        @dead_already = false

                #console.log "Reward: #{r}"
                @ui.reward.textContent = "#{r}"
                # Update last Q(s', a) with max(all Q(s, a*))
                rewards_for_actions = @readQ s
                @ui.qs.textContent = "Jump: #{rewards_for_actions.jump}, Idle: #{rewards_for_actions.idle}"

                # Update Q
                if @last_s? and @last_a?
                        old = @readQ(@last_s)[@last_a]
                        est_future = Math.max(rewards_for_actions.jump, rewards_for_actions.idle)
                        @writeQ @last_s, @last_a, old + @alpha * (r + @gamma * est_future - old)
                # Choose new action from current state
                action_source = "Q"
                if rewards_for_actions.jump > rewards_for_actions.idle
                        @game.jump()
                        @last_a = "jump"
                else if rewards_for_actions.jump == rewards_for_actions.idle
                        action_source = "R"
                        if Math.random() > 0.95
                                @game.jump()
                                @last_a = "jump"
                        else
                                @last_a = "idle"
                else
                        @last_a = "idle"
                #console.log "Choose: #{@last_a}"
                @ui.action.textContent = "#{@last_a}(#{action_source})"
                @last_s = s

                
window.AI = new AI()
