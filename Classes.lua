local set = require"DnD.Set"

local mt = {
	__index = function (tab, key)
		if key == nil then
			return nil
		end
		local Key = key:gsub ("^(.)", string.upper)
			:gsub ("_(.)([^_]*)", function (i, rest)
				return i:upper()..rest:lower()
			end)
		return require("DnD.Classes."..Key)
	end,
}

return setmetatable ({
	companheiro = {
		ca = function(self)
			local ca = 14 + self.nivel
			self.ca_oportunidade = ca
			return ca
		end,
		fortitude = function(self)
			return 11+self.nivel
		end,
		reflexos = function(self)
			return 13+self.nivel
		end,
		vontade = function(self)
			return 12+self.nivel
		end,
		pc_dia = 2,
		pv = 14 - 12 + 8, -- PV básico - constituicao + pv_nivel
		pv_nivel = 8,
		total_pericias = 0,
		pericias = set("atletismo", "exploracao", "furtividade"),
		caracteristicas_classe = {},
		poderes = {},
	},
}, mt)
