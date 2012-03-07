local set = require"DnD.Set"
local basicas = require"DnD.ArmasBasicas"

return function (...)
	local profs = set(...)
	local res = {}
	for nome, arma in pairs(basicas) do
		if profs[arma.tipo] then
			res[nome] = true
		elseif profs[nome] then
			res[nome] = true
		end
	end
	return res
end

