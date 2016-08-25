local action = function(msg, blocks)
if blocks[1] == 'bc' then
    	local res = api.sendAdmin(blocks[2], true)
    	if not res then
    		api.sendAdmin('Can\'t broadcast: wrong markdown')
    	else
	        local hash = 'bot:users'
	        local ids = db:hkeys(hash)
	        local sent, not_sent, err_429, err_403 = 0, 0, 0, 0
	        if next(ids) then
	            for i=1,#ids do
	                local res, code = api.sendMessage(ids[i], blocks[2], true)
	                if not res then
	                	if code == 429 then
	                		err_429 = err_429 + 1
	                		db:sadd('bc:err429', ids[i])
	                	elseif code == 403 then
	                		err_403 = err_403 + 1
	                	else
	                		not_sent = not_sent + 1
	                	end
	                else
	                	sent = sent + 1
	                end
	            end
	            api.sendMessage(msg.from.id, 'Broadcast delivered\n\n*Sent: '..sent..'\nNot sent: '..not_sent + err_429 + err_403..'*\n- Requests rejected for flood (hash: _bc:err429_ ): '..err_429..'\n- Users that blocked the bot: '..err_403, true)
	        else
	            api.sendMessage(msg.from.id, 'No users saved, no broadcast')
	        end
	    end
	end
	if blocks[1] == 'bcg' then
		local res = api.sendAdmin(blocks[2], true)
    	if not res then
    		api.sendAdmin('Can\'t broadcast: wrong markdown')
    		return
    	end
	    local groups = db:smembers('bot:groupsid')
	    if not groups then
	    	api.sendMessage(msg.from.id, 'No (groups) id saved')
	    else
	    	for i=1,#groups do
	    		api.sendMessage(groups[i], blocks[2], true)
	        	print('Sent', groups[i])
	    	end
	    	api.sendMessage(msg.from.id, 'Broadcast delivered')
	    end
	end
end
return {
	action = action,
	cron = false,
	triggers = {
	'^%$(bc) (.*)$',
	'^%$(bcg) (.*)$'
}
}
