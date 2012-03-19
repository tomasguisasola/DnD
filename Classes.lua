local set = require"DnD.Set"

local mt = {
	__index = function (tab, key)
		local Key = key:gsub ("_(.)", string.upper)
			:gsub ("^(.)(.*)$", function (i, r)
				return i:upper()..r:lower()
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
		pv = 14 - 12 + 8, -- PV b�sico - constituicao + pv_nivel
		pv_nivel = 8,
		total_pericias = 0,
		pericias = set("atletismo", "exploracao", "furtividade"),
		caracteristicas_classe = {},
		poderes = {},
	},
}, mt)
