local set = require"DnD.Set"
local tipos_armas = require"DnD.TiposArmas"
local mod = require"DnD.Modificadores"

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
		luz_vingadora = {
			nome = "Luz Vingadora",
			uso = "SL",
			acao = "padr�o",
			origem = set("divino", "implemento", "radiante"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.sabedoria,
			defesa = "Fort",
			dano = mod.dobra_21 ("1d10", "sabedoria", "Luz Vingadora"),
			efeito = function(self)
				return "Sucesso: se um aliado do invocador adjacente ao alvo estiver sangrando,\n    o ataque causa +"..self.mod_con.." de dano radiante adicional."
			end,
		},
------- Poderes por Encontro n�vel 1 -------------------------------------------
------- Poderes Di�rios n�vel 1 ------------------------------------------------
------- Poderes Utilit�rios n�vel 2 --------------------------------------------
------- Poderes por Encontro n�vel 3 -------------------------------------------
------- Poderes Di�rios n�vel 5 ------------------------------------------------
	},
}
