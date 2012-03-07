local set = require"DnD.Set"
local soma_dano = require"DnD.Soma".soma
local armas = require"DnD.Armas"
local tipos_armas = require"DnD.TiposArmas"

return {
	barbaro = {
		nome = "Bárbaro",
		fonte_de_poder = "primitivo",
		fortitude = 2,
		armaduras = set("traje", "corselete", "gibao"),
		ca = function (self)
			local cat = self.armadura.categoria
			if cat == "traje" or cat == "corselete" or cat == "gibao" then
				local bonus = math.floor((self.nivel-1)/10) + 1
				return false, bonus
			else
				return false, 0
			end
		end,
		reflexos = function (self)
			local cat = self.armadura.categoria
			if cat == "traje" or cat == "corselete" or cat == "gibao" then
				local bonus = math.floor((self.nivel-1)/10) + 1
				return false, bonus
			else
				return false, 0
			end
		end,
		armas = tipos_armas("corpo simples", "corpo militar"),
		pv = 15,
		pv_nivel = 6,
		pc_dia = 8,
		pericias = set("acrobacia", "atletismo", "intimidacao", "natureza", "percepcao", "socorro", "tolerancia"),
		total_pericias = 3,
		caracteristicas_classe = {},
		poderes = {},
	},
	bardo = require"DnD.Classes.Bardo",
	bruxo = require"DnD.Classes.Bruxo",
	clerigo = require"DnD.Classes.Clerigo",
	druida = require"DnD.Classes.Druida",
	feiticeiro = require"DnD.Classes.Feiticeiro",
	guardiao = {
		nome = "Guardião",
		fonte_de_poder = "primitivo",
		fortitude = 1,
		vontade = 1,
		armaduras = set("traje", "corselete", "gibão", "leve", "pesado"),
		armas = tipos_armas("corpo simples", "corpo militar", "distancia simples"),
		pv = 17,
		pv_nivel = 7,
		pc_dia = 9,
		pericias = {
			natureza = "treinada",
			atletismo = true,
			exploracao = true,
			intimidacao = true,
			natureza = true,
			percepcao = true,
			socorro = true,
			tolerancia = true,
		},
		total_pericias = 3,
		caracteristicas_classe = {},
	},
	guerreiro = require"DnD.Classes.Guerreiro",
	invocador = {
		nome = "Invocador",
		fonte_de_poder = "divino",
		fortitude = 1,
		reflexos = 1,
		vontade = 1,
		armaduras = set("traje", "corselete", "gibão", "cota"),
		armas = tipos_armas("corpo simples", "distancia simples"),
		implementos = set("bastão", "cajado"),
		pv = 10,
		pv_nivel = 4,
		pc_dia = 6,
		pericias = {
			religiao = "treinada",
			arcanismo = true,
			diplomacia = true,
			historia = true,
			intimidacao = true,
			intuicao = true,
			tolerancia = true,
		},
		total_pericias = 3,
		caracteristicas_classe = {},
	},
	ladino = require"DnD.Classes.Ladino",
	lamina_arcana = require"DnD.Classes.LaminaArcana",
	mago = require"DnD.Classes.Mago",
	monge = require"DnD.Classes.Monge",
	paladino = require"DnD.Classes.Paladino",
	patrulheiro = require"DnD.Classes.Patrulheiro",
	senhor_da_guerra = require"DnD.Classes.SenhorDaGuerra",
	vingador = {
		nome = "Vingador",
		fonte_de_poder = "divino",
		ca = function(self)
			if self.armadura == "traje" or self.armadura.categoria == "traje" then
				return false, 3
			end
			return false, 0
		end,
		fortitude = 1,
		reflexos = 1,
		vontade = 1,
		armaduras = set("traje"),
		armas = tipos_armas("corpo simples", "corpo militar", "distancia simples"),
		implementos = set("simbolo_sagrado"),
		pv = 14,
		pv_nivel = 6,
		pc_dia = 7,
		pericias = {
			religiao = "treinada",
			acrobacia = true,
			atletismo = true,
			furtividade = true,
			intimidacao = true,
			manha = true,
			percepcao = true,
			socorro = true,
			tolerancia = true,
		},
		total_pericias = 3,
		caracteristicas_classe = {},
	},
	xama = require"DnD.Classes.Xama",

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
}
