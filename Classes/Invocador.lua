local set = require"DnD.Set"
local tipos_armas = require"DnD.TiposArmas"

return {
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
	caracteristicas_classe = {
------- Características de Classe ----------------------------------------------
	},
	poderes = {
------- Poderes Sem Limite nível 1 ---------------------------------------------
------- Poderes por Encontro nível 1 -------------------------------------------
------- Poderes Diários nível 1 ------------------------------------------------
------- Poderes Utilitários nível 2 --------------------------------------------
------- Poderes por Encontro nível 3 -------------------------------------------
------- Poderes Diários nível 5 ------------------------------------------------
	},
}
