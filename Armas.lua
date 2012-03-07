local ArmasBasicas = require"DnD.ArmasBasicas"
local soma_dano = require"DnD.Soma".soma
local set = require"DnD.Set"

local function magica (nome, nv)
	local arma = ArmasBasicas[nome]
	local m = {
		basica = nome,
		ataque = nv,
		dano = nv,
		decisivo = nv.."d6",
	}
	return setmetatable (m, { __index = arma, })
end

local function algida (nome, nv)
	local arma = ArmasBasicas[nome]
	local m = {
		nome = arma.nome.." Álgida",
		basica = nome,
		ataque = nv,
		dano = nv,
		decisivo = nv.."d6",
		poder = {
			nome = "Arma Álgida",
			uso = "Diário",
			acao = "livre",
			origem = set("congelante"),
			efeito = "Efeito: quando acertar inimigo, este recebe +1d8 (congelante) e fica lento.",
		},
	}
	return setmetatable (m, { __index = arma, })
end

local function inescapavel (nome, nv)
	local arma = ArmasBasicas[nome]
	local m = {
		nome = arma.nome.." Inescapável",
		basica = nome,
		ataque = nv,
		dano = nv,
		decisivo = nv.."d6",
		efeito = "Efeito: sempre que fracassar em um ataque com esta arma, recebe +1 (até o bônus\n    máximo da arma) no próximo ataque contra o mesmo alvo.\n    O bônus se encerra se acertar o alvo ou trocar de alvo.",
	}
	return setmetatable (m, { __index = arma, })
end

local function rapida (nome, nv)
	local arma = ArmasBasicas[nome]
	local m = {
		nome = arma.nome.." Rápida",
		basica = nome,
		proficiencia = nv+arma.proficiencia,
		dano = soma_dano ({}, arma.dano, nv),
		decisivo = nv.."d6",
		poder = {
			nome = "Arma Rápida",
			uso = "Diário",
			origem = set("marcial"),
			efeito = "Efeito: quando acertar inimigo, realiza At.Básico (livre) contra inimigo qualquer.",
		},
	}
	return setmetatable (m, { __index = arma, })
end

local armas = {
	adaga_magica_1 = magica ("adaga", 1),
	arco_longo_inescapavel_3 = inescapavel ("arco_longo", 1),
	azagaia_magica_1 = magica ("azagaia", 1),
	espada_longa_magica_1 = magica ("espada_longa", 1),
	espada_longa_algida_3 = algida ("espada_longa", 1),
	espada_grande_algida_3 = algida ("espada_grande", 1),

	manopla_shuriken_rapida_3 = rapida ("manopla_shuriken", 1),
}

return setmetatable (armas, { __index = ArmasBasicas })
