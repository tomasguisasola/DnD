local ArmasBasicas = require"DnD.ArmasBasicas"
local soma_dano = require"DnD.Soma".soma
local set = require"DnD.Set"

local function magica (nome, bonus) -- LJ1 234
	local arma = ArmasBasicas[nome]
	local m = {
		nome = arma.nome.." Mágica",
		basica = nome,
		proficiencia = bonus + arma.proficiencia,
		dano = soma_dano ({}, arma.dano, bonus),
		decisivo = bonus.."d6",
	}
	return setmetatable (m, { __index = arma, })
end

local function algida (nome, bonus) -- LJ1 232
	local arma = ArmasBasicas[nome]
	local m = {
		nome = arma.nome.." Álgida",
		basica = nome,
		proficiencia = bonus + arma.proficiencia,
		dano = soma_dano ({}, arma.dano, bonus),
		decisivo = bonus.."d6",
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

local function da_cancao_pungente (nome, bonus) -- LJ2 204
	local arma = ArmasBasicas[nome]
	local m = {
		nome = arma.nome.." da Canção Pungente",
		basica = nome,
		proficiencia = bonus + arma.proficiencia,
		dano = soma_dano ({}, arma.dano, bonus),
		decisivo = bonus.."d8",
		implemento = set("bardo"),
		poder = {
			nome = "Lâmina da Canção Pungente",
			uso = "Di",
			acao = "livre",
			origem = {},
			efeito = "Efeito: quando atingir um inimigo com um poder trovejante usando esta lâmina,\n    os inimigos a até 2 quadrados do alvo ficam pasmos até o FdPT.",
		},
	}
	return setmetatable (m, { __index = arma, })
end

local function da_transferencia (nome, bonus) -- AA 79
	local arma = ArmasBasicas[nome]
	local m = {
		nome = arma.nome.." da Transferência",
		basica = nome,
		proficiencia = bonus + arma.proficiencia,
		dano = soma_dano ({}, arma.dano, bonus),
		decisivo = bonus.."d6",
		poder = {
			nome = "Arma da Transferência",
			uso = "Di",
			acao = "livre",
			origem = {},
			efeito = "Efeito: quando obtém sucesso em um ataque com esta arma, pode transferir para o\n    alvo uma condição ou dano contínuo que o estiver afligindo.  A condição\n    ou dano contínuo segue seu curso normal no alvo.",
		},
	}
	return setmetatable (m, { __index = arma, })
end

local function de_drenar_vitalidade (nome, bonus) -- LJ1 234
	local arma = ArmasBasicas[nome]
	local m = {
		nome = arma.nome.." de Drenar Vitalidade",
		basica = nome,
		proficiencia = bonus + arma.proficiencia,
		dano = soma_dano ({}, arma.dano, bonus),
		decisivo = bonus.."d6",
		efeito = "Propriedade: Quando você reduz um inimigo a 0 PV ou menos com esta arma, recebe\n    5 PVT.",
	}
	return setmetatable (m, { __index = arma, })
end

local function dinamica (nome, bonus) -- AA 69
	local arma = ArmasBasicas[nome]
	local m = {
		nome = arma.nome.." Dinâmica",
		basica = nome,
		proficiencia = bonus + arma.proficiencia,
		dano = soma_dano ({}, arma.dano, bonus),
		decisivo = bonus.."d6",
		poder = {
			nome = "Arma Dinâmica",
			uso = "En",
			acao = "mínima",
			origem = {},
			efeito = "Efeito: usando uma ação mínima, você pode transformar sua arma em qualquer outra\n    arma corpo-a-corpo (simples, militar ou superior) até o FdEn ou até quando\n    gastar outra ação mínima para cancelar o efeito.",
		},
	}
	return setmetatable (m, {__index = arma, })
end

local function do_cruzado (nome, bonus) -- AA 67
	local arma = ArmasBasicas[nome]
	local m = {
		nome = arma.nome.." do Cruzado",
		basica = nome,
		proficiencia = bonus + arma.proficiencia,
		dano = soma_dano ({}, arma.dano, bonus),
		decisivo = bonus.."d6",
		efeito = "Propriedade: metade do dano é radiante.\n    Pode ser usada como símbolo sagrado.\n    Decisivo = d10 X mortos-vivos.",
		poder = {
			nome = "Arma do Cruzado",
			uso = "Di",
			acao = "padrão",
			origem = {},
			efeito = "Efeito: recupera uma utilização de Canalizar Divindade neste encontro.",
		},
	}
	return setmetatable (m, { __index = arma, })
end

local function do_duelista (nome, bonus) -- AA 70
	local arma = ArmasBasicas[nome]
	local m = {
		nome = arma.nome.." do Duelista",
		basica = nome,
		proficiencia = bonus + arma.proficiencia,
		dano = soma_dano ({}, arma.dano, bonus),
		decisivo = bonus.."d6",
		efeito = "Decisivo: com VdC, troque o d6 por d8.",
		poder = {
			nome = "Arma do Duelista",
			uso = "Di",
			acao = "mínima",
			origem = {},
			efeito = "Efeito: você obtém VdC contra a criatura que atacar com esta arma no seu turno.",
		},
	}
	return setmetatable (m, { __index = arma, })
end

local function dos_ferimentos (nome, bonus) -- AA 70
	local arma = ArmasBasicas[nome]
	local cont
	if bonus == 1 or bonus == 2 then
		cont = 5
	elseif bonus == 3 or bonus == 4 then
		cont = 10
	elseif bonus == 5 or bonus == 6 then
		cont = 15
	end
	local m = {
		nome = arma.nome.." dos Ferimentos",
		basica = nome,
		proficiencia = bonus + arma.proficiencia,
		dano = soma_dano ({}, arma.dano, bonus),
		decisivo = bonus.."d6",
		efeito = "Propriedade: quando causar dano contínuo com esta arma, o alvo sofre -"..bonus.." de penalidade nos TRs contra este efeito.",
		poder = {
			nome = "Arma dos Ferimentos",
			uso = "Di",
			acao = "livre",
			origem = {},
			efeito = "Efeito: quando atingir alvo com esta arma, cause "..cont.." de dano contínuo (TR).",
		},
	}
	return setmetatable (m, { __index = arma, })
end

local function da_explosao_flamejante (nome, bonus)
	local arma = ArmasBasicas[nome]
	local dano = math.floor ((bonus+1) / 2)
	local m = {
		nome = arma.nome.." da Explosão Flamejante",
		basica = nome,
		proficiencia = bonus + arma.proficiencia,
		dano = soma_dano ({}, arma.dano, bonus),
		decisivo = bonus.."d6",
		poder = {
			nome = "Arma da Explosão Flamejante",
			uso = "Di",
			acao = "mínima",
			origem = set("marcial"),
			efeito = "Efeito: o próximo ABaD realizado com esta arma, antes do FdsT, torna-se uma\n    explosão de área 1 centralizada no alvo X Reflexos.\n    Ao invés do dano normal, cada alvo sofre "..(dano * 5).." de dano contínuo flamejante.",
		},
	}
	return setmetatable (m, { __index = arma, })
end

local function da_explosao_trovejante (nome, bonus)
	local arma = ArmasBasicas[nome]
	local m = {
		nome = arma.nome.." da Explosão Trovejante",
		basica = nome,
		proficiencia = bonus + arma.proficiencia,
		dano = soma_dano ({}, arma.dano, bonus),
		decisivo = bonus.."d6",
		poder = {
			nome = "Arma da Explosão Trovejante",
			uso = "Di",
			acao = "mínima",
			origem = set("marcial"),
			efeito = "Efeito: o próx. At.Básico realizado com esta arma, antes do fim do turno,\n    torna-se uma explosão de área 1 centralizada no alvo X Fortitude.",
		},
	}
	return setmetatable (m, { __index = arma, })
end

local function do_cruzado_do_sol (nome, bonus)
	local arma = ArmasBasicas[nome]
	local m = {
		nome = arma.nome.." do Cruzado do Sol",
		basica = nome,
		proficiencia = bonus + arma.proficiencia,
		dano = soma_dano ({}, arma.dano, bonus),
		decisivo = bonus.."d6",
		efeito = "Efeito: metade do dano é radiante e pode ser usada como implemento",
		poder = {
			nome = "Arma do Cruzado do Sol",
			uso = "Di",
			acao = "padrão",
			origem = {},
			ataque = function(self) return self.mod_car end,
			defesa = "Ref",
			dano = soma_dano ({}, "1d8", 0),
			efeito = "Efeito: partículas de luz irrompem da arma e prendem-se aos inimigos adjacentes,\n    realizando um ataque de explosão contígua 1.",
		},
	}
	return setmetatable (m, { __index = arma, })
end

local function flamejante (nome, bonus)
	local arma = ArmasBasicas[nome]
	local adicional = math.floor ((bonus+1) / 2)
	local m = {
		nome = arma.nome.." Flamejante",
		basica = nome,
		proficiencia = bonus + arma.proficiencia,
		dano = soma_dano ({}, arma.dano, bonus),
		decisivo = bonus.."d6",
		poder = {
			nome = "Arma Flamejante",
			uso = "Di",
			acao = "livre",
			origem = set("marcial"),
			efeito = "Efeito: você pode ativar este poder quando atinge um inimigo com esta arma.\n    O alvo sofre +"..adicional.."d6 de dano flamejante e "..(adicional*5).." de dano contínuo flamejante (TR).",
		},
	}
	return setmetatable (m, { __index = arma, })
end

local function inescapavel (nome, bonus) -- AA 72
	local arma = ArmasBasicas[nome]
	local m = {
		nome = arma.nome.." Inescapável",
		basica = nome,
		proficiencia = bonus + arma.proficiencia,
		dano = soma_dano ({}, arma.dano, bonus),
		decisivo = bonus.."d6",
		poder = {
			nome = "Arma Inescapável",
			uso = "SL",
			acao = "livre",
			origem = set("marcial"),
			efeito = "Efeito: sempre que fracassar em um ataque com esta arma, recebe +1 (máx +"..bonus..")\n    no próximo ataque contra o mesmo alvo (até acertar ou trocar de alvo)."
		},
	}
	return setmetatable (m, { __index = arma, })
end

local function lamina_do_sol (nome, bonus)
	local arma = ArmasBasicas[nome]
	local dano
	if bonus == 1 or bonus == 2 then
		dano = 1
	elseif bonus == 3 or bonus == 4 then
		dano = 2
	elseif bonus == 5 or bonus == 6 then
		dano = 3
	end
	local m = {
		nome = arma.nome.." Lâmina do Sol",
		basica = nome,
		proficiencia = bonus + arma.proficiencia,
		dano = soma_dano ({}, arma.dano, bonus),
		decisivo = bonus.."d6",
		efeito = "Propriedade: pode irradiar luz plena ou penumbra a até 20 a gosto do portador.\n    O dano desta arma pode ser radiante, a gosto do portador.",
		poder = {
			nome = "Lâmina do Sol",
			uso = "Di",
			acao = "padrão",
			origem = {},
			efeito = function (self)
				return "Efeito: partículas de luz irrompem da arma e prendem-se aos inimigos adjacentes;\n    FOR+"..bonus.." X Ref -> "..dano.."d8 radiante."
			end,
		},
	}
	return setmetatable (m, { __index = arma, })
end

local function matadora_dragoes (nome, bonus)
	local arma = ArmasBasicas[nome]
	local m = {
		nome = arma.nome.." Matadora de Dragões",
		basica = nome,
		proficiencia = bonus + arma.proficiencia,
		dano = soma_dano ({}, arma.dano, bonus),
		decisivo = bonus.."d6",
		efeito = "Resistência 5 contra sopro de dragões",
		poder = {
			nome = "Matadora de Dragões",
			uso = "Di",
			acao = "livre",
			origem = {},
			efeito = "Quando atingir um inimigo com esta arma, causa +"..bonus.."d6 (ou +"..bonus.."d10 contra dragões).",
		},
	}
	return setmetatable (m, { __index = arma, })
end

local function portadora_da_morte (nome, bonus) -- 76
	local arma = ArmasBasicas[nome]
	local cont
	if bonus == 1 or bonus == 2 then
		cont = 5
	elseif bonus == 3 or bonus == 4 then
		cont = 10
	elseif bonus == 5 or bonus == 6 then
		cont = 15
	end
	local m = {
		nome = arma.nome.." Portadora da Morte",
		basica = nome,
		proficiencia = bonus + arma.proficiencia,
		dano = soma_dano ({}, arma.dano, bonus),
		decisivo = bonus.."d6",
		efeito = "O dano decisivo é necrótico",
		poder = {
			nome = "Portadora da Morte",
			uso = "Di",
			acao = "livre",
			origem = {},
			efeito = "Efeito: quando atingir um inimigo com esta arma, cause "..cont.." de dano contínuo (TR, com -2 de penalidade, encerra)",
		},
	}
	return setmetatable (m, { __index = arma, })
end

local function rapida (nome, bonus) -- AA 76
	local arma = ArmasBasicas[nome]
	local m = {
		nome = arma.nome.." Rápida",
		basica = nome,
		proficiencia = bonus + arma.proficiencia,
		dano = soma_dano ({}, arma.dano, bonus),
		decisivo = bonus.."d6",
		poder = {
			nome = "Arma Rápida",
			uso = "Di",
			acao = "livre",
			origem = {},
			efeito = "Efeito: quando acertar inimigo, realiza AtB (livre) contra inimigo qualquer.",
		},
	}
	return setmetatable (m, { __index = arma, })
end

local function resoluta (nome, bonus) -- AA 77
	local arma = ArmasBasicas[nome]
	local m = {
		nome = arma.nome.." Resoluta",
		basica = nome,
		proficiencia = bonus + arma.proficiencia,
		dano = soma_dano ({}, arma.dano, bonus),
		decisivo = bonus.."d6",
		poder = {
			nome = "Arma Resoluta",
			uso = "Di",
			acao = "livre",
			origem = {},
			efeito = "Efeito: quando fracassar em um ataque à distância com essa arma;\n    a arma não retorna imediatamente à sua mão para, no CdPT do ALVO, realizar\n    um ataque básico à distância contra ele e então voltar à sua mão.",
		},
	}
	return setmetatable (m, { __index = arma, })
end

local function restritiva (nome, bonus) -- AA 77
	local arma = ArmasBasicas[nome]
	local m = {
		nome = arma.nome.." Restritiva",
		basica = nome,
		proficiencia = bonus + arma.proficiencia,
		dano = soma_dano ({}, arma.dano, bonus),
		decisivo = bonus.."d6",
		poder = {
			nome = "Arma Restritiva",
			uso = "Di",
			acao = "livre",
			origem = {},
			efeito = "Efeito: quando acertar, alvo fica imobilizado enquanto você estiver adjacente a ele.",
		},
	}
	return setmetatable (m, { __index = arma, })
end

local function traicoeira (nome, bonus)
	local arma = ArmasBasicas[nome]
	local m = {
		nome = arma.nome.." Traiçoeira",
		basica = nome,
		proficiencia = bonus + arma.proficiencia,
		dano = soma_dano ({}, arma.dano, bonus),
		decisivo = bonus.."d6",
		alcance = arma.alcance:gsub ("(%d+)%/(%d+)", function (n, e) return (n+2)..'/'..(n+4) end),
		efeito = "Sempre que acertar um at. traiçoeiro, cause +5 de dano.",
	}
	return setmetatable (m, { __index = arma, })
end

local function trovejante (nome, bonus) -- LJ1 235
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

local function vampirica (nome, bonus) -- AA 79
	local arma = ArmasBasicas[nome]
	local adicional
	if bonus == 2 then
		adicional = 1
	elseif bonus == 3 or bonus == 4 then
		adicional = 2
	elseif bonus == 5 or bonus == 6 then
		adicional = 3
	end
	local m = {
		nome = arma.nome.." Vampírica",
		basica = nome,
		proficiencia = bonus + arma.proficiencia,
		dano = soma_dano ({}, arma.dano, bonus),
		decisivo = bonus.."d4",
		efeito = "Propriedade: todo dano é necrótico.\n    Decisivo permite recuperar PV igual ao dano decisivo causado.",
		poder = {
			nome = "Arma Vamírica",
			uso = "Di",
			acao = "livre",
			origem = {},
			efeito = "Efeito: quando acertar inimigo, cause "..adicional.."d8 de dano necrótico e recupere o mesmo em PV.",
		
		},
	}
	return setmetatable (m, { __index = arma, })
end

local function unidas (nome, bonus) -- AA 80
	local arma = ArmasBasicas[nome]
	local adicional = math.floor ((bonus+1) / 2)
	local m = {
		nome = arma.nome.." Unidas",
		basica = nome,
		proficiencia = bonus + arma.proficiencia,
		dano = soma_dano ({}, arma.dano, bonus),
		decisivo = bonus.."d6",
		poder = {
			nome = "Armas Unidas",
			uso = "Di",
			acao = "mínima",
			origem = {},
			efeito = "Efeito: divida a arma em duas idênticas (mínima), portando uma em cada mão.",
		},
	}
	return setmetatable (m, { __index = arma, })
end

local armas = {
	adaga_magica_1 = magica ("adaga", 1),
	adaga_do_duelista_3 = do_duelista ("adaga", 1),
	adaga_inescapavel_8 = inescapavel ("adaga", 2),
	adaga_rapida_3 = rapida ("adaga", 1),
	adaga_traicoeira_4 = traicoeira ("adaga", 1),
	arco_longo_inescapavel_3 = inescapavel ("arco_longo", 1),
	arco_longo_da_explosao_flamejante_3 = da_explosao_flamejante ("arco_longo", 1),
	arco_longo_da_explosao_trovejante_4 = da_explosao_trovejante ("arco_longo", 1),
	arco_longo_da_transferencia_7 = da_transferencia ("arco_longo", 2),
	azagaia_magica_1 = magica ("azagaia", 1),
	espada_curta_unidas_3 = unidas ("espada_curta", 1),
	espada_longa_magica_1 = magica ("espada_longa", 1),
	espada_longa_algida_3 = algida ("espada_longa", 1),
	espada_longa_da_cancao_pungente_3 = da_cancao_pungente ("espada_longa", 1),
	espada_longa_da_cancao_pungente_8 = da_cancao_pungente ("espada_longa", 2),
	espada_longa_de_drenar_vitalidade_5 = de_drenar_vitalidade ("espada_longa", 1),
	espada_longa_dinamica_6 = dinamica ("espada_longa", 2),
	espada_bastarda_dinamica_6 = dinamica ("espada_bastarda", 2),
	espada_longa_trovejante_3 = trovejante ("espada_longa", 1),
	espada_longa_magica_6 = magica ("espada_longa", 2),
	espada_longa_lamina_do_sol_9 = lamina_do_sol ("espada_longa", 2),
	espada_grande_algida_3 = algida ("espada_grande", 1),
	espada_grande_matadora_de_dragoes_7 = matadora_dragoes ("espada_grande", 2),
	espada_grande_lamina_do_sol_9 = lamina_do_sol ("espada_grande", 2),

	manopla_shuriken_rapida_3 = rapida ("manopla_shuriken", 1),
	montante_magica_1 = magica ("montante", 1),
	montante_magico_1 = magica ("montante", 1),
	sabre_magico_1 = magica ("sabre", 1),
	shuriken_magica_1 = magica ("shuriken", 1),
	shuriken_magico_1 = magica ("shuriken", 1),
}

return setmetatable (armas, { __index = ArmasBasicas })
