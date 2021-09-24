local RegisterNetEvent, TriggerClientEvent,RemoveEventHandler,AddEventHandler,TriggerEvent = RegisterNetEvent, TriggerClientEvent,RemoveEventHandler,AddEventHandler,TriggerEvent


local RegisterServerCallback = function(a, b)
	AddEventHandler(('cb_s:%s'):format(a), function(cb, s, ...)
		local resolve = {b(s, ...)}
		cb(table.unpack(resolve))
	end)
end

local TriggerClientCallback = function(src, a, ...)
	local resolve
	local promis = promise.new()
	local e = RegisterNetEvent(('cb_:server:%s'):format(a),function(...)
		local _src = source
		if src == _src then
			promis:resolve({...})
		end
	end)
	TriggerClientEvent('cb_:client', src, a, ...)
	resolve = Citizen.Await(promis)
	RemoveEventHandler(e)
	return table.unpack(resolve)
end


RegisterNetEvent('cb_:server')
AddEventHandler('cb_:server', function(a,b, ...)
	local src = source
	local promis = promise.new()
	TriggerEvent('cb_s:'..a, function(...)
		promis:resolve({...})
	end, src, ...)
	local resolve = Citizen.Await(promis)
	TriggerClientEvent(('cb_:client:%s:%s'):format(a, b), src, table.unpack(resolve))
end)



exports("TriggerClientCallback",TriggerClientCallback)

exports("RegisterServerCallback",RegisterServerCallback)