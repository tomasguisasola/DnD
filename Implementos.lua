local set = require"DnD.Set"
local soma_dano = require"DnD.Soma".soma
local classes = require"DnD.Classes"

local implemento_basico = require"DnD.Implemento_Basico"

return {
	bastao = {
		nome = "Bastão",
		tipo = "bastao",
	},
	bastao_magico_1 = {
		nome = "Bastão Mágico",
		tipo = "bastao",
		ataque = implemento_basico("bastao", 1),
		dano = implemento_basico("bastao", 1),
		decisivo = implemento_basico("bastao", "+1d6"),
		preco = 360,
	},
	bastao_da_corrupcao_3 = {
		nome = "Bastão da Corrupção",
		tipo = "bastao",
		ataque = implemento_basico("bastao", 1),
		dano = implemento_basico("bastao", 1),
		decisivo = implemento_basico("bastao", "+1d6"),
		preco = 640,
	},
	cajado = {
		nome = "Cajado",
		tipo = "cajado",
	},
	cajado_das_tempestades_5 = {
		nome = "Cajado das Tempestades",
		tipo = "cajado",
		ataque = implemento_basico("cajado", 1),
		dano = implemento_basico("cajado", 1),
		decisivo = implemento_basico("cajado", "+1d6"),
		preco = 1000,
		poder = {
			nome = "Cajado das Tempestades",
			uso = "Diário",
			origem = set("eletrico", "trovejante"),
			tipo_ataque = "rajada contígua 3",
			alvo = "criaturas na rajada",
			restricao = "juntamente com outro poder elétrico ou trovejante",
			dano = "1d8 elétrico ou trovejante",
			efeito = "Com uma ação livre, afeta todos na rajada.",
		},
	},
	cajado_defensivo_2 = {
		nome = "Cajado Defensivo",
		tipo = "cajado",
		ataque = implemento_basico("cajado", 1),
		dano = implemento_basico("cajado", 1),
		decisivo = implemento_basico("cajado", "+1d8"),
		preco = 520,
		fortitude = 1,
		reflexos = 1,
		vontade = 1,
		ca = function(self)
			if self.caracteristica_classe == "cajado" then
				return 1
			end
		end,
	},
	cajado_defensivo_7 = {
		nome = "Cajado Defensivo",
		tipo = "cajado",
		ataque = implemento_basico("cajado", 2),
		dano = implemento_basico("cajado", 2),
		decisivo = implemento_basico("cajado", "+1d8"),
		preco = 2600,
		fortitude = 1,
		reflexos = 1,
		vontade = 1,
		ca = function(self)
			if self.caracteristica_classe == "cajado" then
				return 1
			end
		end,
	},
	cajado_magico_1 = {
		nome = "Cajado Mágico",
		tipo = "cajado",
		ataque = implemento_basico("cajado", 1),
		dano = implemento_basico("cajado", 1),
		decisivo = implemento_basico("cajado", "+1d6"),
	},
	cajado_magico_6 = {
		nome = "Cajado Mágico",
		tipo = "cajado",
		ataque = implemento_basico("cajado", 2),
		dano = implemento_basico("cajado", 2),
		decisivo = implemento_basico("cajado", "+2d6"),
	},
	lamina_da_cancao_pungente_3 = { -- LJ2 204
		nome = "Lâmina da Canção Pungente",
		tipo = "lamina_da_cancao",
		ataque = implemento_basico("lamina_da_cancao", 1),
		dano = implemento_basico("lamina_da_cancao", 1),
		decisivo = implemento_basico("lamina_da_cancao", "+1d6"),
	},
	simbolo_sagrado = {
		nome = "Símbolo Sagrado",
		tipo = "simbolo_sagrado",
		ataque = 0,
		dano = 0,
	},
	simbolo_da_vida_2 = {
		nome = "Símbolo da Vida",
		tipo = "simbolo_sagrado",
		ataque = implemento_basico("simbolo_sagrado", 1),
		dano = implemento_basico("simbolo_sagrado", 1),
		decisivo = implemento_basico("simbolo_sagrado", "+1d6"),
	},
	simbolo_da_esperanca_3 = {
		nome = "Símbolo da Esperança",
		tipo = "simbolo_sagrado",
		ataque = implemento_basico("simbolo_sagrado", 1),
		dano = implemento_basico("simbolo_sagrado", 1),
		decisivo = implemento_basico("simbolo_sagrado", "+1d6"),
		preco = 680,
	},
	simbolo_da_batalha_5 = {
		nome = "Símbolo da Batalha",
		tipo = "simbolo_sagrado",
		ataque = implemento_basico("simbolo_sagrado", 1),
		dano = implemento_basico("simbolo_sagrado", 1),
		decisivo = implemento_basico("simbolo_sagrado", "+1d8"),
	},
	totem = {
		nome = "Totem",
		tipo = "totem",
	},
	totem_magico_1 = {
		nome = "Totem Mágico",
		tipo = "totem",
		ataque = implemento_basico("totem", 1),
		dano = implemento_basico("totem", 1),
		decisivo = implemento_basico("totem", "+1d6"),
	},
	totem_do_crescimento_de_verao_3 = {
		nome = "Totem do Crescimento do Verão",
		tipo = "totem",
		ataque = implemento_basico("totem", 1),
		dano = implemento_basico("totem", 1),
		decisivo = implemento_basico("totem", "+1d6"), -- e o alvo fica imobilizado até o final do préximo turno
		poder = {
			nome = "Totem do Crescimento de Verão",
			uso = "Diário",
			efeito = "Até o final do próximo turno do personagem, os quadrados a até 5 quadrados de distância dele são considerados terreno acidentado para seus inimigos.",
		},
	},
	totem_da_renovacao_da_primavera_5 = {
		nome = "Totem da Renovação da Primavera",
		tipo = "totem",
		ataque = implemento_basico("totem", 1),
		dano = implemento_basico("totem", 1),
		decisivo = implemento_basico("totem", "+1d6"), -- e um aliado a até 5 quadrados do inimigo recupera 2 PV
		poder = {
			nome = "Totem da Renovação da Primavera",
			uso = "Diário",
			acao = "livre",
			origem = set("cura"),
			tipo_ataque = "explosão contígua 5",
			alvo = "um aliado",
			dano = "regeneração +2 (encontro)",
			efeito = "Quando acertar um inimigo, aliado a 5 adquire regeneração 2 (encontro).",
		},
	},
	varinha = {
		nome = "Varinha",
		tipo = "varinha",
	},
	varinha_magica_1 = {
		nome = "Varinha Mágica",
		tipo = "varinha",
		ataque = implemento_basico("varinha", 1),
		dano = implemento_basico("varinha", 1),
		decisivo = implemento_basico("varinha", "+1d6"),
	},
}
