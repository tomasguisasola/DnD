local set = require"DnD.Set"
local soma_dano = require"DnD.Soma".soma
local armas = require"DnD.Armas"
local tipos_armas = require"DnD.TiposArmas"
local mod = require"DnD.Modificadores"
local Personagem = require"DnD.Personagem"

return {
	nome = "Bardo",
	fonte_de_poder = "arcano",
	reflexos = 1,
	vontade = 1,
	armaduras = set("traje", "corselete", "gibao", "cota", "leve"),
	armas = tipos_armas("corpo simples", "distancia simples", "distancia militar", "cimitarra", "espada_curta", "espada_longa"),
	pv = 12,
	pv_nivel = 5,
	pc_dia = 7,
	implementos = {
		varinha = true,
		lamina_da_cancao = true,
		instrumento = true,
	},
	pericias = {
		arcanismo = "treinada",
		acrobacia = true,
		atletismo = true,
		blefe = true,
		diplomacia = true,
		exploracao = true,
		historia = true,
		intimidacao = true,
		intuicao = true,
		manha = true,
		natureza = true,
		percepcao = true,
		religiao = true,
		socorro = true,
		nao_treinadas = 1,
	},
	total_pericias = 4,
	caracteristicas_classe = {
------- Características de Classe ----------------------------------------------
		palavras_de_amizade = {
			nome = "Palavras de Amizade",
			uso = "En",
			acao = "mínima",
			origem = set("arcano"),
			tipo_ataque = "pessoal",
			alvo = "pessoal",
			efeito = "Efeito: você recebe +5 no próximo teste de Diplomacia até o FdPT.",
		},
		palavra_majestosa = {
			nome = "Palavra Majestosa",
			uso = "En",
			acao = "mínima",
			origem = set("arcano", "cura"),
			efeito = function(self)
				local adicional = self.palavra_majestosa_adicional
				if adicional then
					adicional = "+ "..self.mod_car.." PVT "
				else
					adicional = ''
				end
				return "Efeito: aliado a até 5 pode gastar um PC, recupera +"..self.mod_car.." PV "..adicional.."\n    e pode ser conduzido 1 quadrado."
			end,
		},
		virtude = {
			nome = "Virtude de Bardo",
			uso = "SL (1/rodada)",
			acao = "livre",
			origem = set"arcano",
			efeito = function(self)
				local c = (self.caracteristica_classe or ''):lower()
				if c:match"ast.cia" then
					local distancia = 5 + self.mod_int
					return "Efeito: aliado a até "..distancia..", que for alvo de ataque fracassado é conduzido 1."
				elseif c:match"bravura" then
					local pvt = 2 * math.floor((self.nivel-1)/10)
						+ 1 + self.mod_con
					return "Efeito: aliado a até 5, que sangra ou mata inimigo recebe "..pvt.." PVT."
				else
					Personagem.warn"Sem característica de classe, não tem Virtude de Bardo."
					return "Sem característica de classe, não tem Virtude de Bardo."
				end
			end,
		},
	},
	poderes = {
------- Poderes Sem Limite nível 1 ---------------------------------------------
		golpe_condutor = {
			nome = "Golpe Condutor",
			uso = "SL",
			acao = "padrão",
			origem = set("arcano", "arma"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.car,
			defesa = "CA",
			dano = mod.dobra_21("[A]", "carisma", "Golpe Condutor"),
			efeito = "Efeito: o alvo sofre -2 numa defesa a sua escolha até o FdPT.",
		},
		golpe_da_cancao_de_guerra = {
			nome = "Golpe da Canção de Guerra",
			uso = "SL",
			acao = "padrão",
			origem = set("arcano", "arma"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.car,
			defesa = "CA",
			dano = mod.dobra_21("[A]", "carisma", "Golpe da Canção de Guerra"),
			efeito = function(self)
				return "Efeito: os aliados que atingirem o alvo até o FdPT recebem "..self.mod_con.." PVT."
			end,
		},
		marca_indireta = {
			nome = "Marca Indireta",
			uso = "SL",
			acao = "padrão",
			origem = set("arcano", "implemento"),
			tipo_ataque = "distância 10",
			alvo = "uma criatura",
			ataque = mod.car,
			defesa = "Refl",
			dano = mod.dobra_21("d8", "carisma", "Marca Indireta"),
			efeito = "Efeito: o alvo fica marcado por um aliado a até 5 quadrados até FdPT.",
		},
		zombaria_malevola = {
			nome = "Zombaria Malévola",
			uso = "SL",
			acao = "padrão",
			origem = set("arcano", "encanto", "implemento", "psíquico"),
			tipo_ataque = "distância 10",
			alvo = "uma criatura",
			ataque = mod.car,
			defesa = "Vont",
			dano = mod.dobra_21("d6", "carisma", "Zombaria Malévola"),
			efeito = "Efeito: o alvo sofre -2 nos ataques até o FdPT.",
		},
------- Poderes por Encontro nível 1 -------------------------------------------
		amigos_rapidos = {
			nome = "Amigos Rápidos",
			uso = "En",
			acao = "padrão",
			origem = set("arcano", "encanto", "implemento"),
			tipo_ataque = "distância 5",
			alvo = "uma criatura",
			ataque = mod.car,
			defesa = "Vont",
			efeito = "Efeito: o alvo não pode atacar um membro a sua escolha até o FdPT ou até que\n    este membro ataque o alvo.",
		},
		gafe = {
			nome = "Gafe",
			uso = "En",
			acao = "padrão",
			origem = set("arcano", "encanto", "implemento"),
			tipo_ataque = "distância 5",
			alvo = "uma criatura",
			ataque = mod.car,
			defesa = "Vont",
			dano = mod.dado_mod("1d6", "carisma", "Gafe"),
			efeito = function(self)
				local bonus = 2
				if self.caracteristica_classe == "virtude da astúcia" then
					bonus = 1+self.mod_int
				end
				return "Efeito: o alvo é conduzido 2 quadrados, provocando AdO com +"..bonus.." no ataque."
			end,
		},
		grito_do_triunfo = {
			nome = "Grito do Triunfo",
			uso = "En",
			acao = "padrão",
			origem = set("arcano", "implemento", "trovejante"),
			tipo_ataque = "rajada contígua 3",
			alvo = "inimigos na rajada",
			ataque = mod.car,
			defesa = "Fort",
			dano = mod.dado_mod("1d6", "carisma", "Grito do Triunfo"),
			efeito = function(self)
				local deslocamento = 1
				if self.caracteristica_classe == "virtude da bravura" then
					deslocamento = self.mod_con
				end
				return "Sucesso: alvos atingidos são empurrados "..deslocamento.." quadrado(s).\nEfeito: aliados na rajada são conduzidos "..deslocamento.." quadrado(s)."
			end,
		},
		refrao_inspirador = {
			nome = "Refrão Inspirador",
			uso = "En",
			acao = "padrão",
			origem = set("arcano", "arma"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.car,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "carisma", "Refrão Inspirador"),
			efeito = "Efeito: aliados recebem +1 nos ataques até o FdPT do bardo.",
		},
------- Poderes Diários nível 1 ------------------------------------------------
		cancao_do_matador = {
			nome = "Canção do Matador",
			uso = "Di",
			acao = "padrão",
			origem = set("arcano", "arma"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.car,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "carisma", "Canção do Matador"),
			efeito = "Sucesso: o alvo concede VdC ao bardo e aliados (TR encerra).\nFracasso = metade do dano.\nEfeito: até o FdEn, sempre que você acertar um alvo, este concede VdC a você\n    e seus aliados até o FdPT (do bardo).",
		},
		ecos_do_guardiao = {
			nome = "Ecos do Guardião",
			uso = "Di",
			acao = "padrão",
			origem = set("arcano", "arma"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.car,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "carisma", "Ecos do Guardião"),
			efeito = "Sucesso: o alvo fica marcado por um aliado a até 5 quadrados deste até o FdPT.\nFracasso = metade do dano.\nEfeito: até o FdEn, sempre que você acertar um alvo, pode marcá-lo por um\n    aliado a até 5 de você até o FdPT.",
		},
		grito_inspirador = {
			nome = "Grito Inspirador",
			uso = "Di",
			acao = "padrão",
			origem = set("arcano", "cura", "implemento", "psíquico"),
			tipo_ataque = "distância 10",
			alvo = "uma criatura",
			ataque = mod.car,
			defesa = "Vont",
			dano = mod.dado_mod("2d6", "carisma", "Grito Inspirador"),
			efeito = function(self)
				return "Efeito: até o FdEn, sempre que um aliado atingir o alvo, recupera "..self.mod_car.." PV."
			end,
		},
		verso_do_triunfo = {
			nome = "Verso do Triunfo",
			uso = "Di",
			acao = "padrão",
			origem = set("arcano", "arma", "encanto"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.car,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "carisma", "Verso do Triunfo"),
			efeito = "Efeito: até o FdEn, você e seus aliados a até 5 recebem +1 no dano e nos TR,\n    e sempre que um membro reduzir um inimigo a 0 PV (ou menos), você e seus\n    aliados a até 5 quadrados do inimigo podem ajustar 1 quadrado (livre).",
		},
------- Poderes Utilitários nível 2 --------------------------------------------
		cancao_da_coragem = {
			nome = "Canção da Coragem",
			uso = "Di",
			acao = "mínima",
			origem = set("arcano", "zona"),
			tipo_ataque = "explosão contígua 5",
			alvo = "o bardo e aliados",
			efeito = "Efeito: a zona (centralizada em você) concede +1 nos ataques aos aliados.\n    Se desloca com você e persiste com uma ação mínima.",
		},
		cancao_da_defesa = {
			nome = "Canção da Defesa",
			uso = "Di",
			acao = "mínima",
			origem = set("arcano", "zona"),
			tipo_ataque = "explosão contígua 5",
			alvo = "o bardo e aliados",
			efeito = "Efeito: a zona (centralizada no bardo) concede +1 na CA aos aliados.\n    Se desloca com você e persiste com uma ação mínima.",
		},
		inspirar_competencia = {
			nome = "Inspirar Competência",
			uso = "En",
			acao = "mínima",
			origem = set("arcano", "zona"),
			tipo_ataque = "explosão contígua 5",
			alvo = "o bardo e aliados",
			efeito = "Efeito: até o FdEn, os alvos recebem +2 no próximo teste de perícia escolhida.",
		},
		melodia_do_cacador = {
			nome = "Melodia do Caçador",
			uso = "Di",
			acao = "mínima",
			origem = set("arcano"),
			tipo_ataque = "distância 10",
			alvo = "um aliado",
			efeito = "Efeito: até o FdPT, o alvo recebe +5 nos testes de Furtividade e não sofre\n    penalidade por se deslocar mais de 2 quadrados ou correr.\nUma ação mínima persiste o efeito, desde que o alvo continue dentro do alcance.",
		},
------- Poderes por Encontro nível 3 -------------------------------------------
		chamado_aos_cavalos_de_batalha = {
			nome = "Chamado aos Cavalos de Batalha",
			uso = "En",
			acao = "padrão",
			origem = set("arcano", "arma"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.car,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "carisma", "Chamado aos Cavalos de Batalha"),
			efeito = function(self)
				local bonus = 2
				if self.caracteristica_classe:match"virtude da bravura" then
					bonus = 1 + self.mod_con
				end
				return "Sucesso: aliados a até 5 quadrados recebem +"..bonus.." nos ataques de investida até o FdPT."
			end,
		},
		energia_impulsora = {
			nome = "Energia Impulsora",
			uso = "En",
			acao = "padrão",
			origem = set("arcano", "energético", "implemento"),
			tipo_ataque = "distância 10",
			alvo = "uma criatura",
			ataque = mod.car,
			defesa = "Fort",
			dano = mod.dado_mod("1d10", "carisma", "Energia Impulsora"),
			efeito = "Sucesso: o alvo é conduzido 5 quadrados para um espaço adjacente a um aliado.",
		},
		estrofe_dissonante = {
			nome = "Estrofe Dissonante",
			uso = "En",
			acao = "padrão",
			origem = set("arcano", "implemento", "psíquico"),
			tipo_ataque = "distância 5",
			alvo = "uma criatura",
			ataque = mod.car,
			defesa = "Vont",
			dano = mod.dado_mod("2d6", "carisma", "Estrofe Dissonante"),
			efeito = "Sucesso: alvo sofre -2 nos ataques até o FdPT e um aliado a até 5 realiza um TR.",
		},
		ferocidade_astuta = {
			nome = "Ferocidade Astuta",
			uso = "En",
			acao = "padrão",
			origem = set("arcano", "arma"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.car,
			defesa = "Refl",
			dano = mod.dado_mod("1[A]", "carisma", "Estrofe Dissonante"),
			efeito = function(self)
				local dano = 2
				if self.caracteristica_classe:match"virtude da ast.cia" then
					dano = 1 + self.mod_int
				end
				return "Sucesso: até o FdPT os aliados a até 5 recebem +"..dano.." no dano contra o alvo."
			end,
		},
------- Poderes Diários nível 5 ------------------------------------------------
		cancao_da_discordia = {
			nome = "Canção da Discórdia",
			uso = "Di",
			acao = "padrão",
			origem = set("arcano", "encanto", "implemento"),
			tipo_ataque = "distância 10",
			alvo = "uma criatura",
			ataque = mod.car,
			defesa = "Vont",
			efeito = "Sucesso: o alvo fica dominado até o FdPT e realiza um ataque básico\ncontra um inimigo à sua escolha.",
		},
		melodia_do_gelo_e_do_vento = {
			nome = "Melodia do Gelo e do Vento",
			uso = "Di",
			acao = "padrão",
			origem = set("arcano", "congelante", "implemento"),
			tipo_ataque = "área 1 a até 10",
			alvo = "inimigos na área",
			ataque = mod.car,
			defesa = "Vont",
			dano = mod.dado_mod("2d6", "carisma", "Melodia do Gelo e do Vento"),
			efeito = "Sucesso: os alvos ficam lentos (TR encerra).\nFracasso: metade do dano e os alvos ficam lentos até o FdPT.\nEfeito: os aliados na área são conduzidos 3 quadrados.",
		},
		palavra_de_protecao_mistica = {
			nome = "Palavra de Proteção Mística",
			uso = "Di",
			acao = "padrão",
			origem = set("arcano", "arma", "psíquico"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.car,
			defesa = "CA",
			dano = mod.dado_mod("3[A]", "carisma", "Palavra de Proteção Mística"),
			efeito = function(self)
				return "Sucesso: escolha um aliado a até 5; se o alvo se aproximar deste aliado, sofre\n   "..self.mod_car.." de dano psíquico (TR encerra).\nFracasso: metade do dano."
			end,
		},
		satira_da_bravura = {
			nome = "Sátira da Bravura",
			uso = "Di",
			acao = "padrão",
			origem = set("arcano", "implemento", "psíquico"),
			tipo_ataque = "rajada contígua 3",
			alvo = "inimigos na rajada",
			ataque = mod.car,
			defesa = "Vont",
			dano = mod.dado_mod("2d6", "carisma", "Sátira da Bravura"),
			efeito = function(self)
				return "Sucesso: os alvos ficam sob o efeito da Sátira da Bravura (TR encerra).\n    Sob este efeito, o alvo que terminar seu turno mais perto de você do que\n    quando começou, sobre 1d6+"..self.mod_car.." (psíquico) e fica pasmo até o FdPT.\nFracasso: metade do dano.\nEfeito: os alvos são empurrados 3 quadrados."
			end,
		},
	},
}
