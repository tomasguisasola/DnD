local set = require"DnD.Set"
local tipos_armas = require"DnD.TiposArmas"

return {
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
