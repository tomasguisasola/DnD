local classes = require"DnD.Classes"
local soma_dano = require"DnD.Soma".soma

return function (tipo, mais)
	return function(self, valor, arma)
		local implementos = classes[self.classe].implementos or {}
		if implementos[tipo] then
			return soma_dano(self, valor, mais, arma)
		else
			return valor
		end
	end
end

