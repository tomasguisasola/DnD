local soma_dano = require"DnD.Soma".soma

local function modificador_atributo(atributo)
	return "mod_"..atributo:sub(1,3):lower()
end

local function mod(atributo)
	local mod_atr = modificador_atributo(atributo)
	return function(self)
		return self[mod_atr]
	end
end

return {
	["for"] = mod"for",
	forca = mod"for",
	con = mod"con",
	constituicao = mod"con",
	des = mod"des",
	destreza = mod"des",
	int = mod"int",
	inteligencia = mod"int",
	sab = mod"sab",
	sabedoria = mod"sab",
	car = mod"car",
	carisma = mod"car",

	dobra_21 = function(dado, atributo, nome)
		local mod_atr = modificador_atributo(atributo)
		local dobro_dado = dado:gsub("^1", "2")
		if dobro_dado == dado then
			dobro_dado = "2"..dado
			dado = "1"..dado
		end
		return function(self)
			if self.nivel >= 21 then
				return soma_dano(self, dobro_dado, self[mod_atr], nome)
			else
				return soma_dano(self, dado, self[mod_atr], nome)
			end
		end
	end,

	dado_mod = function(dado, atributo, nome)
		local mod_atr = modificador_atributo(atributo)
		return function(self, ...)
			return soma_dano(self, dado, self[mod_atr], nome)
		end
	end,
}
