local RegisterNetEvent, TriggerServerEvent,RemoveEventHandler,AddEventHandler,TriggerEvent = RegisterNetEvent, TriggerServerEvent,RemoveEventHandler,AddEventHandler,TriggerEvent

local TriggerServerCallback = function(a, ...)
	local result
	local promis = promise.new()
	local b = GetGameTimer()
	local c = RegisterNetEvent(('cb_:client:%s:%s'):format(a, b),function(...)
		promis:resolve({...})
	end)
	TriggerServerEvent('cb_:server', a, b, ...)
	result = Citizen.Await(promis)
	RemoveEventHandler(c)
	return table.unpack(result)
end

local RegisterClientCallback = function(a,b)
	AddEventHandler(('cb_c:%s'):format(a), function(cb,...)
		cb(b(...))
	end)
end

RegisterNetEvent('cb_:client')
AddEventHandler('cb_:client', function(a,...)
	local promis = promise.new()
	TriggerEvent(('cb_c:%s'):format(a), function(...)
		promis:resolve({...})
	end, ...)
	local resolve = Citizen.Await(promis)
	TriggerServerEvent(('cb_:server:%s'):format(a), table.unpack(resolve))
end)


exports("TriggerServerCallback",TriggerServerCallback)
exports("RegisterClientCallback",RegisterClientCallback)


