local set = require"DnD.Set"
local soma_dano = require"DnD.Soma".soma
local armas = require"DnD.Armas"
local tipos_armas = require"DnD.TiposArmas"
local mod = require"DnD.Modificadores"

return {
	nome = "L�mina Arcana",
	fonte_de_poder = "arcano",
	vontade = 2,
	armaduras = set("traje", "corselete"),
	armas = tipos_armas("corpo simples", "lamina_leve", "lamina_pesada", "distancia simples"),
	implementos = {
		lamina_leve = true,
		lamina_pesada = true,
	},
	pv = 15,
	pv_nivel = 6,
	pc_dia = 8,
	pericias = {
		arcanismo = "treinada",
		atletismo = true,
		diplomacia = true,
		historia = true,
		intimidacao = true,
		intuicao = true,
		tolerancia = true,
	},
	--talentos = set"conjuracao_ritual",
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
