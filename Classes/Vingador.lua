local set = require"DnD.Set"
local tipos_armas = require"DnD.TiposArmas"

return {
	nome = "Vingador",
	fonte_de_poder = "divino",
	ca = function(self)
		if self.armadura == "traje" or self.armadura.categoria == "traje" then
			return 3
		end
		return 0
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
