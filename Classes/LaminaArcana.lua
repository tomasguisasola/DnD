local set = require"DnD.Set"
local soma_dano = require"DnD.Soma".soma
local armas = require"DnD.Armas"
local tipos_armas = require"DnD.TiposArmas"
local mod = require"DnD.Modificadores"

return {
	nome = "Lâmina Arcana",
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
------- Características de Classe ----------------------------------------------
	},
	poderes = {
------- Poderes Sem Limite nível 1 ---------------------------------------------
		lamina_ingente = {
			nome = "Lâmina Ingente",
			uso = "SL",
			acao = "padrão",
			origem = set("arcano", "arma", "trovejante"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.int,
			defesa = "CA",
			dano = mod.dobra_21("[A]", "inteligencia", "Lâmina Ingente"),
			efeito = function (self)
				return "Se o alvo começar seu turno adjacente ao lâmina e se afastar, sefre 1d6+"..self.mod_con.." de dano trovejante."
			end,
		},
------- Poderes por Encontro nível 1 -------------------------------------------
------- Poderes Diários nível 1 ------------------------------------------------
------- Poderes Utilitários nível 2 --------------------------------------------
------- Poderes por Encontro nível 3 -------------------------------------------
------- Poderes Diários nível 5 ------------------------------------------------
	},
}
