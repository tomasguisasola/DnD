local set = require"DnD.Set"
local soma_dano = require"DnD.Soma".soma
local armas = require"DnD.Armas"
local tipos_armas = require"DnD.TiposArmas"
local mod = require"DnD.Modificadores"

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
------- Caracter�sticas de Classe ----------------------------------------------
		palavras_de_amizade = {
			nome = "Palavras de Amizade",
			uso = "En",
			acao = "m�nima",
			origem = set("arcano"),
			tipo_ataque = "pessoal",
			alvo = "pessoal",
			efeito = "Voc� recebe +5 no pr�ximo teste de Diplomacia at� o FdPT.",
		},
		palavra_majestosa = {
			nome = "Palavra Majestosa",
			uso = "En",
			acao = "m�nima",
			origem = set("arcano", "cura"),
			efeito = function(self)
				local adicional = self.palavra_majestosa_adicional
				if adicional then
					adicional = "e "..self.mod_car.." PVT "
				else
					adicional = ''
				end
				return "Aliado a at� 5 pode gastar um PC, recupera "..self.mod_car.." PV "..adicional.."adicionais\n    e pode ser conduzido 1 quadrado."
			end,
		},
		virtude = {
			nome = "Virtude da Ast�cia/Bravura",
			uso = "SL (1/rodada)",
			acao = "livre",
			origem = set"arcano",
			efeito = function(self)
				local c = assert(self.caracteristica_classe, "Falta definir a caracter�stica de classe"):lower()
				if c:match"ast.cia" then
					local distancia = 5 + self.mod_int
					return "Aliado a at� "..distancia..", que for alvo de ataque fracassado � conduzido 1."
				elseif c:match"bravura" then
					local pvt = 2 * math.floor((self.nivel-1)/10)
						+ 1 + self.mod_con
					return "Aliado a at� 5, que sangra ou mata inimigo recebe "..pvt.." PVT."
				end
			end,
		},
	},
	poderes = {
------- Poderes Sem Limite n�vel 1 ---------------------------------------------
		golpe_condutor = {
			nome = "Golpe Condutor",
			uso = "SL",
			acao = "padr�o",
			origem = set("arcano", "arma"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.car,
			defesa = "CA",
			dano = mod.dobra_21("[A]", "carisma", "Golpe Condutor"),
			efeito = "O alvo sofre -2 numa defesa a sua escolha at� o FdPT.",
		},
		golpe_da_cancao_de_guerra = {
			nome = "Golpe da Can��o de Guerra",
			uso = "SL",
			acao = "padr�o",
			origem = set("arcano", "arma"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.car,
			defesa = "CA",
			dano = mod.dobra_21("[A]", "carisma", "Golpe da Can��o de Guerra"),
			efeito = function(self)
				return "Os aliados que atingirem o alvo at� o FdPT recebem "..self.mod_con.." PVT."
			end,
		},
		marca_indireta = {
			nome = "Marca Indireta",
			uso = "SL",
			acao = "padr�o",
			origem = set("arcano", "implemento"),
			tipo_ataque = "dist�ncia 10",
			alvo = "uma criatura",
			ataque = mod.car,
			defesa = "Refl",
			dano = mod.dobra_21("d8", "carisma", "Marca Indireta"),
			efeito = "O alvo fica marcado por um aliado a at� 5 quadrados at� FdPT.",
		},
		zombaria_malevola = {
			nome = "Zombaria Mal�vola",
			uso = "SL",
			acao = "padr�o",
			origem = set("arcano", "encanto", "implemento", "ps�quico"),
			tipo_ataque = "dist�ncia 10",
			alvo = "uma criatura",
			ataque = mod.car,
			defesa = "Vont",
			dano = mod.dobra_21("d6", "carisma", "Zombaria Mal�vola"),
			efeito = "O alvo sofre -2 nos ataques at� o FdPT.",
		},
------- Poderes por Encontro n�vel 1 -------------------------------------------
		amigos_rapidos = {
			nome = "Amigos R�pidos",
			uso = "En",
			acao = "padr�o",
			origem = set("arcano", "encanto", "implemento"),
			tipo_ataque = "dist�ncia 5",
			alvo = "uma criatura",
			ataque = mod.car,
			defesa = "Vont",
			efeito = "O alvo n�o pode atacar o bardo ou um aliado a sua escolha at� o FdPT ou at� que o bardo ou um aliado ataque o alvo.",
		},
		gafe = {
			nome = "Gafe",
			uso = "En",
			acao = "padr�o",
			origem = set("arcano", "encanto", "implemento"),
			tipo_ataque = "dist�ncia 5",
			alvo = "uma criatura",
			ataque = mod.car,
			defesa = "Vont",
			dano = mod.dado_mod("1d6", "carisma", "Gafe"),
			efeito = function(self)
				local bonus = 2
				if self.caracteristica_classe == "virtude da ast�cia" then
					bonus = 1+self.mod_int
				end
				return "O alvo � conduzido 2 quadrados, provocando um AdO com +"..bonus.." no ataque."
			end,
		},
		grito_do_triunfo = {
			nome = "Grito do Triunfo",
			uso = "En",
			acao = "padr�o",
			origem = set("arcano", "implemento", "trovejante"),
			tipo_ataque = "rajada cont�gua 3",
			alvo = "inimigos na rajada",
			ataque = mod.car,
			defesa = "Fort",
			dano = mod.dado_mod("1d6", "carisma", "Grito do Triunfo"),
			efeito = function(self)
				local deslocamento = 1
				if self.caracteristica_classe == "virtude da bravura" then
					deslocamento = self.mod_con
				end
				return "Sucesso: alvos atingidos s�o empurrados "..deslocamento.." quadrado(s).\nEfeito: aliados na rajada s�o conduzidos "..deslocamento.." quadrado(s)."
			end,
		},
		refrao_inspirador = {
			nome = "Refr�o Inspirador",
			uso = "En",
			acao = "padr�o",
			origem = set("arcano", "arma"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.car,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "carisma", "Refr�o Inspirador"),
			efeito = "Os aliados recebem +1 nos ataques at� o FdPT do bardo.",
		},
------- Poderes Di�rios n�vel 1 ------------------------------------------------
		cancao_do_matador = {
			nome = "Can��o do Matador",
			uso = "Di",
			acao = "padr�o",
			origem = set("arcano", "arma"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.car,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "carisma", "Can��o do Matador"),
			efeito = "O alvo concede VdC ao bardo e aliados (TR encerra).\nFracasso = metade do dano.\nAt� o final do encontro, sempre que voc� acertar um alvo, este concede VdC ao\nbardo e aliados at� o FdPT do bardo.",
		},
		ecos_do_guardiao = {
			nome = "Ecos do Guardi�o",
			uso = "Di",
			acao = "padr�o",
			origem = set("arcano", "arma"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.car,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "carisma", "Ecos do Guardi�o"),
			efeito = "O alvo fica marcado por um aliado a at� 5 quadrados deste at� o FdPT.\nFracasso = metade do dano.\nAt� o final do encontro, sempre que o bardo acertar um alvo pode marc�-lo por um\naliado a at� 5 quadrados deste at� o FdPT.",
		},
		grito_inspirador = {
			nome = "Grito Inspirador",
			uso = "Di",
			acao = "padr�o",
			origem = set("arcano", "cura", "implemento", "ps�quico"),
			tipo_ataque = "dist�ncia 10",
			alvo = "uma criatura",
			ataque = mod.car,
			defesa = "Vont",
			dano = mod.dado_mod("2d6", "carisma", "Grito Inspirador"),
			efeito = function(self)
				return "At� o final do encontro, sempre que um aliado atingir o alvo, recupera "..self.mod_car.." PV."
			end,
		},
		verso_do_triunfo = {
			nome = "Verso do Triunfo",
			uso = "Di",
			acao = "padr�o",
			origem = set("arcano", "arma", "encanto"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.car,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "carisma", "Verso do Triunfo"),
			efeito = "At� o final do encontro, o bardo e aliados a at� 5 quadrados recebem +1 no dano\ne nos TR, e sempre que um membro reduzir um inimigo a 0 PV (ou menos), o bardo\ne seus aliados a at� 5 quadrados do inimigo podem ajustar 1 quadrado (livre).",
		},
------- Poderes Utilit�rios n�vel 2 --------------------------------------------
		cancao_da_coragem = {
			nome = "Can��o da Coragem",
			uso = "Di",
			acao = "m�nima",
			origem = set("arcano", "zona"),
			tipo_ataque = "explos�o cont�gua 5",
			alvo = "o bardo e aliados",
			efeito = "A zona (centralizada no bardo) concede +1 nos ataques aos membros.\nSe desloca com o bardo e persiste com uma a��o m�nima.",
		},
		cancao_da_defesa = {
			nome = "Can��o da Defesa",
			uso = "Di",
			acao = "m�nima",
			origem = set("arcano", "zona"),
			tipo_ataque = "explos�o cont�gua 5",
			alvo = "o bardo e aliados",
			efeito = "A zona (centralizada no bardo) concede +1 na CA aos membros.\nSe desloca com o bardo e persiste com uma a��o m�nima.",
		},
		inspirar_competencia = {
			nome = "Inspirar Compet�ncia",
			uso = "En",
			acao = "m�nima",
			origem = set("arcano", "zona"),
			tipo_ataque = "explos�o cont�gua 5",
			alvo = "o bardo e aliados",
			efeito = "At� o final do encontro, os alvos recebem +2 no pr�ximo teste com uma per�cia\nescolhida pelo bardo.",
		},
		melodia_do_cadador = {
			nome = "Melodia do Ca�ador",
			uso = "Di",
			acao = "m�nima",
			origem = set("arcano"),
			tipo_ataque = "dist�ncia 10",
			alvo = "um aliado",
			efeito = "At� o FdPT, o alvo recebe +5 nos testes de Furtividade e n�o\nsofre penalidade por se deslocar mais de 2 quadrados ou correr.\nUma a��o m�nima persiste o efeito, desde que o alvo continue dentro do alcance.",
		},
------- Poderes por Encontro n�vel 3 -------------------------------------------
		chamado_aos_cavalos_de_batalha = {
			nome = "Chamado aos Cavalos de Batalha",
			uso = "En",
			acao = "padr�o",
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
				return "Sucesso: aliados a at� 5 quadrados recebem +"..bonus.." nos ataques de investida at� o FdPT."
			end,
		},
		energia_impulsora = {
			nome = "Energia Impulsora",
			uso = "En",
			acao = "padr�o",
			origem = set("arcano", "energ�tico", "implemento"),
			tipo_ataque = "dist�ncia 10",
			alvo = "uma criatura",
			ataque = mod.car,
			defesa = "Fort",
			dano = mod.dado_mod("1d10", "carisma", "Energia Impulsora"),
			efeito = "Sucesso: o alvo � conduzido 5 quadrados para um espa�o adjacente a um aliado.",
		},
		estrofe_dissonante = {
			nome = "Estrofe Dissonante",
			uso = "En",
			acao = "padr�o",
			origem = set("arcano", "implemento", "ps�quico"),
			tipo_ataque = "dist�ncia 5",
			alvo = "uma criatura",
			ataque = mod.car,
			defesa = "Vont",
			dano = mod.dado_mod("2d6", "carisma", "Estrofe Dissonante"),
			efeito = "Sucesso: alvo sofre -2 nos ataques at� o FdPT e um aliado a at� 5 realiza um TR.",
		},
		ferocidade_astuta = {
			nome = "Ferocidade Astuta",
			uso = "En",
			acao = "padr�o",
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
				return "Sucesso: at� o FdPT os aliados a at� 5 recebem +"..dano.." no dano contra o alvo."
			end,
		},
------- Poderes Di�rios n�vel 5 ------------------------------------------------
		cancao_da_discordia = {
			nome = "Can��o da Disc�rdia",
			uso = "Di",
			acao = "padr�o",
			origem = set("arcano", "encanto", "implemento"),
			tipo_ataque = "dist�ncia 10",
			alvo = "uma criatura",
			ataque = mod.car,
			defesa = "Vont",
			efeito = "Sucesso: o alvo fica dominado at� o FdPT e realiza um ataque b�sico\ncontra um inimigo � sua escolha.",
		},
		melodia_do_gelo_e_do_vento = {
			nome = "Melodia do Gelo e do Vento",
			uso = "Di",
			acao = "padr�o",
			origem = set("arcano", "congelante", "implemento"),
			tipo_ataque = "�rea 1 a at� 10",
			alvo = "inimigos na �rea",
			ataque = mod.car,
			defesa = "Vont",
			dano = mod.dado_mod("2d6", "carisma", "Melodia do Gelo e do Vento"),
			efeito = "Sucesso: os alvos ficam lentos (TR encerra).\nFracasso: metade do dano e os alvos ficam lentos at� o FdPT.\nEfeito: os aliados na �rea s�o conduzidos 3 quadrados.",
		},
		palavra_de_protecao_mistica = {
			nome = "Palavra de Prote��o M�stica",
			uso = "Di",
			acao = "padr�o",
			origem = set("arcano", "arma", "ps�quico"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.car,
			defesa = "CA",
			dano = mod.dado_mod("3[A]", "carisma", "Palavra de Prote��o M�stica"),
			efeito = function(self)
				return "Sucesso: escolha um aliado a at� 5; se o alvo se aproximar deste aliado, sofre\n   "..self.mod_car.." de dano ps�quico (TR encerra).\nFracasso: metade do dano."
			end,
		},
		satira_da_bravura = {
			nome = "S�tira da Bravura",
			uso = "Di",
			acao = "padr�o",
			origem = set("arcano", "implemento", "ps�quico"),
			tipo_ataque = "rajada cont�gua 3",
			alvo = "inimigos na rajada",
			ataque = mod.car,
			defesa = "Vont",
			dano = mod.dado_mod("2d6", "carisma", "S�tira da Bravura"),
			efeito = function(self)
				return "Sucesso: os alvos ficam sob o efeito da S�tira da Bravura (TR encerra).\n    Sob este efeito, o alvo que terminar seu turno mais perto de voc� do que\n    quando come�ou, sobre 1d6+"..self.mod_car.." (ps�quico) e fica pasmo at� o FdPT.\nFracasso: metade do dano.\nEfeito: os alvos s�o empurrados 3 quadrados."
			end,
		},
	},
}
