Funcoes = {
	guerrilheiro = {
		nome = "Guerrilheiro",
		iniciativa = 2,
		pv = function (self) return 8 + self.constituicao + (self.nivel * 8) end,
		ca = function (self) return self.nivel + 14 end,
		defesas = function (self) return self.nivel + 12 end,
		ataque_ca = function (self) return self.nivel + 5 end,
		ataque_outras = function (self) return self.nivel + 3 end,
	},
	bruto = {
		nome = "Bruto",
		iniciativa = 2,
		pv = function (self) return 8 + self.constituicao + (self.nivel * 8) end,
		ca = function (self) return self.nivel + 14 end,
		defesas = function (self) return self.nivel + 12 end,
		ataque_ca = function (self) return self.nivel + 3 end,
		ataque_outras = function (self) return self.nivel + 1 end,
	},
	soldado = {
		nome = "Soldado",
		iniciativa = 2,
		pv = function (self) return 8 + self.constituicao + (self.nivel * 8) end,
		ca = function (self) return self.nivel + 14 end,
		defesas = function (self) return self.nivel + 12 end,
		ataque_ca = function (self) return self.nivel + 7 end,
		ataque_outras = function (self) return self.nivel + 5 end,
	},
	espreitador = {
		nome = "Espreitador",
		iniciativa = 2,
		pv = function (self) return 8 + self.constituicao + (self.nivel * 8) end,
		ca = function (self) return self.nivel + 14 end,
		defesas = function (self) return self.nivel + 12 end,
		ataque_ca = function (self) return self.nivel + 5 end,
		ataque_outras = function (self) return self.nivel + 3 end,
	},
	controlador = {
		nome = "Controlador",
		iniciativa = 2,
		pv = function (self) return 8 + self.constituicao + (self.nivel * 8) end,
		ca = function (self) return self.nivel + 14 end,
		defesas = function (self) return self.nivel + 12 end,
		ataque_ca = function (self) return self.nivel + 5 end,
		ataque_outras = function (self) return self.nivel + 4 end,
	},
	artilheiro = {
		nome = "Artilheiro",
		iniciativa = 2,
		pv = function (self) return 8 + self.constituicao + (self.nivel * 8) end,
		ca = function (self) return self.nivel + 14 end,
		defesas = function (self) return self.nivel + 12 end,
		ataque_ca = function (self) return self.nivel + 7 end,
		ataque_outras = function (self) return self.nivel + 5 end,
	},
}

local xp_por_nivel = {
	100, 125, 150, 175, 200, 250, 300, 350, 400, 500, 600, 700, 800, 1000, 1200, 1400, 1600, 2000, 2400, 2800, 3200, 4150, 5100, 6050, 7000, 9000, 11000, 13000, 15000, 19000,
}

string.tagged = function(s, tags)
	return s:gsub("%$([%w_]+)", tags)
end

Monstro = {
	iniciativa = function(self)
		return (Funcoes[self.funcao].iniciativa or 0) + math.floor(self.nivel/2)
	end,
	nome_funcao = function(self)
		return Funcoes[self.funcao].nome
	end,
	sangrando = function(self)
		return math.floor(self.pv/2)
	end,
	xp = function(self)
		return xp_por_nivel[self.nivel]
	end,
}

local modelo_geral = [[
  $nome_funcao de nível $nivel    $xp XP
CA:  $ca        Defesas: $defesas
FOR: $forca (+$mod_for)  DES: $destreza (+$mod_des)  SAB: $sabedoria (+$mod_sab)
CON: $constituicao (+$mod_con)  INT: $inteligencia (+$mod_int)  CAR: $carisma (+$mod_car)
PV: $pv ($sangrando)  Iniciativa: +$iniciativa
Ataque: +$ataque_ca x CA
        +$ataque_outras x Defesas
Reduza o bônus de ataque em 2 para os poderes que afetem vários alvos.
]]

local meta = {
	__index = function(self, key)
		local v = Monstro[key]
		if type(v) == "function" then
			return v(self)
		else
			local f = Funcoes[self.funcao][key]
			if type(f) == "function" then
				return f(self)
			elseif f then
				return f
			else
				return v
			end
		end
	end,
	__tostring = function(self)
		local s = modelo_geral:tagged(self)
		return s
	end,
}
setmetatable(Monstro, {
	__call = function (self, obj)
--[[
		for _, nome in ipairs{ "forca", "constituicao", "destreza", "inteligencia", "sabedoria", "carisma", } do
			obj['_'..nome] = obj[nome]
			obj[nome] = nil
		end
--]]
		return setmetatable(obj, meta)
	end,
})

return Monstro
