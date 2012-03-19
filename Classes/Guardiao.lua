local set = require"DnD.Set"
local tipos_armas = require"DnD.TiposArmas"

return {
	nome = "Guardi�o",
	fonte_de_poder = "primitivo",
	fortitude = 1,
	vontade = 1,
	armaduras = set("traje", "corselete", "gib�o", "leve", "pesado"),
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
