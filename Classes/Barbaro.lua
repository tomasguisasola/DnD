local set = require"DnD.Set"
local tipos_armas = require"DnD.TiposArmas"

return {
	nome = "Bárbaro",
	fonte_de_poder = "primitivo",
	fortitude = 2,
	armaduras = set("traje", "corselete", "gibao"),
	ca = function (self)
		local cat = self.armadura.categoria
		if cat == "traje" or cat == "corselete" or cat == "gibao" then
			local bonus = math.floor((self.nivel-1)/10) + 1
			return bonus
		else
			return 0
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
