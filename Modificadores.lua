local soma_dano = require"DnD.Soma".soma
local armas = require"DnD.Armas"

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
		local dobro_dado = dado:gsub("^1", "2")
		if dobro_dado == dado then
			dobro_dado = "2"..dado
			dado = "1"..dado
		end
		return function(self, dano, poder_arma)
			local atr
			if atributo:match"/" then -- forca/destreza
				local poder, nome_arma = poder_arma:match"^([^+]*)%+(.*)$"
				local arma = armas[nome_arma]
				if arma.tipo:match"dist" then
					atr = self.mod_des
				else
					atr = self.mod_for
				end
			else
				atr = self[modificador_atributo(atributo)]
			end
			if self.nivel >= 21 then
				return soma_dano(self, dobro_dado, atr, nome)
			else
				return soma_dano(self, dado, atr, nome)
			end
		end
	end,

	dado_mod = function(dado, atributo, nome)
		return function(self, valor, poder_arma)
			local atr
			if atributo:match"/" then -- forca/destreza
				local poder, nome_arma = poder_arma:match"^([^+]*)%+(.*)$"
				local arma = armas[nome_arma]
				if arma.tipo:match"dist" then
					atr = self.mod_des
				else
					atr = self.mod_for
				end
			else
				atr = self[modificador_atributo(atributo)]
			end
			return soma_dano(self, dado, atr, nome)
		end
	end,

	forca_ou_carisma = function(self, ataque, poder_arma)
		return soma_dano (self, math.max(self.mod_for, self.mod_car), ataque, poder_arma)
	end,

	forca_ou_destreza = function(self, ataque, poder_arma)
		local poder, nome_arma = poder_arma:match"^([^+]*)%+(.*)$"
		local arma = armas[nome_arma]
		if arma.tipo:match"dist" then
			return soma_dano(self, self.mod_des, ataque, poder_arma)
		else
			return soma_dano(self, self.mod_for, ataque, poder_arma)
		end
	end,

	soma_mod = function (atr1, atr2)
		return function (self, valor, poder_arma)
			local a1 = self[modificador_atributo(atr1)]
			local a2 = self[modificador_atributo(atr2)]
			local atr = soma_dano (self, a1, a2, poder_arma)
			return soma_dano (self, valor, atr, poder_arma)
		end
	end,
}
