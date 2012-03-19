local set = require"DnD.Set"
local tipos_armas = require"DnD.TiposArmas"

return {
	nome = "Invocador",
	fonte_de_poder = "divino",
	fortitude = 1,
	reflexos = 1,
	vontade = 1,
	armaduras = set("traje", "corselete", "gib�o", "cota"),
	armas = tipos_armas("corpo simples", "distancia simples"),
	implementos = set("bast�o", "cajado"),
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
	caracteristicas_classe = {
------- Caracter�sticas de Classe ----------------------------------------------
	},
	poderes = {
------- Poderes Sem Limite n�vel 1 ---------------------------------------------
------- Poderes por Encontro n�vel 1 -------------------------------------------
------- Poderes Di�rios n�vel 1 ------------------------------------------------
------- Poderes Utilit�rios n�vel 2 --------------------------------------------
------- Poderes por Encontro n�vel 3 -------------------------------------------
------- Poderes Di�rios n�vel 5 ------------------------------------------------
	},
}
