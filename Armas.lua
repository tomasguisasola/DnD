local ArmasBasicas = require"DnD.ArmasBasicas"
local soma_dano = require"DnD.Soma".soma
local set = require"DnD.Set"

local function magica (nome, bonus)
	local arma = ArmasBasicas[nome]
	local m = {
		nome = arma.nome.." M�gica",
		basica = nome,
		proficiencia = bonus + arma.proficiencia,
		dano = soma_dano ({}, arma.dano, bonus),
		decisivo = bonus.."d6",
	}
	return setmetatable (m, { __index = arma, })
end

local function algida (nome, bonus)
	local arma = ArmasBasicas[nome]
	local m = {
		nome = arma.nome.." �lgida",
		basica = nome,
		proficiencia = bonus + arma.proficiencia,
		dano = soma_dano ({}, arma.dano, bonus),
		decisivo = bonus.."d6",
		poder = {
			nome = "Arma �lgida",
			uso = "Di�rio",
			acao = "livre",
			origem = set("congelante"),
			efeito = "Efeito: quando acertar inimigo, este recebe +1d8 (congelante) e fica lento.",
		},
	}
	return setmetatable (m, { __index = arma, })
end

local function inescapavel (nome, bonus) -- AA 72
	local arma = ArmasBasicas[nome]
	local m = {
		nome = arma.nome.." Inescap�vel",
		basica = nome,
		proficiencia = bonus + arma.proficiencia,
		dano = soma_dano ({}, arma.dano, bonus),
		decisivo = bonus.."d6",
		poder = {
			nome = "Arma Inescap�vel",
			uso = "SL",
			acao = "livre",
			origem = set("marcial"),
			efeito = "Efeito: sempre que fracassar em um ataque com esta arma, recebe +1 (at� o b�nus\n    m�ximo da arma) no pr�ximo ataque contra o mesmo alvo.\n    O b�nus se encerra se acertar o alvo ou trocar de alvo.",
		},
	}
	return setmetatable (m, { __index = arma, })
end

local function da_cancao_pungente (nome, bonus) -- LJ2 204
	local arma = ArmasBasicas[nome]
	local m = {
		nome = arma.nome.." da Can��o Pungente",
		basica = nome,
		proficiencia = bonus + arma.proficiencia,
		dano = soma_dano ({}, arma.dano, bonus),
		decisivo = bonus.."d8",
		efeito = "Efeito: serve como implemento de bardo e de trilha exemplar de bardo.",
		poder = {
			nome = "L�mina da Can��o Pungente",
			uso = "Di",
			acao = "livre",
			origem = {},
			efeito = "Quando atingir um inimigo com um poder trovejante usando esta l�mina,\n    os inimigos a at� 2 quadrados do alvo ficam pasmos at� o FdPT.",
		},
	}
	return setmetatable (m, { __index = arma, })
end

local function rapida (nome, bonus) -- AA 76
	local arma = ArmasBasicas[nome]
	local m = {
		nome = arma.nome.." R�pida",
		basica = nome,
		proficiencia = bonus + arma.proficiencia,
		dano = soma_dano ({}, arma.dano, bonus),
		decisivo = bonus.."d6",
		poder = {
			nome = "Arma R�pida",
			uso = "Di",
			acao = "livre",
			origem = {},
			efeito = "Efeito: quando acertar inimigo, realiza At.B�sico (livre) contra inimigo qualquer.",
		},
	}
	return setmetatable (m, { __index = arma, })
end

local function trovejante (nome, bonus) -- LJ1 ??
	local arma = ArmasBasicas[nome]
	local m = {
		nome = arma.nome.." Trovejante",
		basica = nome,
		proficiencia = bonus + arma.proficiencia,
		dano = soma_dano ({}, arma.dano, bonus),
		decisivo = bonus.."d6",
		poder = {
			nome = "Arma Trovejante",
			uso = "Di",
			acao = "livre",
			origem = set("trovejante"),
			dano = "+"..math.floor((bonus+1)/2).."d8",
			efeito = "Efeito: empurra o alvo 1 quadrado",
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
	espada_longa_da_cancao_pungente_3 = da_cancao_pungente ("espada_longa", 1),
	espada_longa_trovejante_3 = trovejante ("espada_longa", 1),
	espada_grande_algida_3 = algida ("espada_grande", 1),

	manopla_shuriken_rapida_3 = rapida ("manopla_shuriken", 1),
	montante_magica_1 = magica ("montante", 1),
	montante_magico_1 = magica ("montante", 1),
	shuriken_magica_1 = magica ("shuriken", 1),
	shuriken_magico_1 = magica ("shuriken", 1),
}

return setmetatable (armas, { __index = ArmasBasicas })
