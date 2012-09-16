local set = require"DnD.Set"
local soma_dano = require"DnD.Soma".soma
local armas = require"DnD.Armas"
local tipos_armas = require"DnD.TiposArmas"
local mod = require"DnD.Modificadores"
local Personagem = require"DnD.Personagem"

return {
	nome = "Mago",
	fonte_de_poder = "arcano",
	vontade = 2,
	armaduras = set("traje"),
	ca = function (self)
		if (self.caracteristica_classe or ''):match"[Cc]ajado" then
			return false, 1
		else
			return false, 0
		end
	end,
	armas = set("adaga", "bordao"),
	implementos = {
		orbe = true,
		varinha = true,
		cajado = {
			ca = 1,
		},
	},
	pv = 10,
	pv_nivel = 4,
	pc_dia = 6,
	pericias = {
		arcanismo = "treinada",
		diplomacia = true,
		exploracao = true,
		historia = true,
		intuicao = true,
		natureza = true,
		religiao = true,
	},
	talentos = set"conjuracao_ritual",
	total_pericias = 3,
	caracteristicas_classe = {
------- Caracter�sticas de Classe ----------------------------------------------
		maestria_implemento_arcano = {
			nome = "Maestria em Implemento Arcano",
			uso = "En",
			--acao = "m�nima",
			origem = set("arcano"),
			tipo_ataque = "pessoal",
			alvo = "voc�",
			--ataque = mod.destreza,
			--defesa = "CA",
			--dano
			efeito = function(self)
				local c = (self.caracteristica_classe or ''):lower()
				if c:match"ajado" then
					return "Com uma interrup��o imediata, ap�s o resultado do dano que for receber, ganhar +"..self.mod_con.." na CA contra este ataque (o que pode anul�-lo)."
				elseif c:match"orbe" then
					return "-"..self.mod_sab.." de penalidade no pr�ximo TR contra um efeito provocado por uma de suas magias que uma criatura for fazer."
				elseif c:match"varinha" then
					return "+"..self.mod_des.." na pr�xima jogada de ataque."
				else
					Personagem.warn"Sem caracter�stica de classe definida."
					return "Sem efeito, pois n�o h� caracter�stica de classe definida."
				end
			end,
		},
	},
	poderes = {
------- Poderes Sem Limite n�vel 1 ---------------------------------------------
		explosao_incandescente = {
			nome = "Explos�o Incandescente",
			uso = "SL",
			origem = set("arcano", "flamejante", "implemento"),
			tipo_ataque = "explos�o de �rea 1 a at� 10",
			alvo = "Uma criatura",
			ataque = mod.inteligencia,
			defesa = "Ref",
			dano = mod.dobra_21("1d6", "inteligencia", "Explos�o Incandescente"),
		},
		misseis_magicos = {
			nome = "M�sseis M�gicos",
			uso = "SL",
			origem = set("arcano", "energetico", "implemento"),
			tipo_ataque = "distancia 10",
			alvo = "Uma criatura",
			--ataque = "Sempre acerta",
			dano = function(self)
				if self.nivel >= 21 then
					return soma_dano(self, "4", self.mod_int, "Misseis M�gicos")
				elseif self.nivel >= 11 then
					return soma_dano(self, "3", self.mod_int, "Misseis M�gicos")
				else
					return soma_dano(self, "2", self.mod_int, "Misseis M�gicos")
				end
			end,
		},
		nuvem_de_adagas = {
			nome = "Nuvem de Adagas",
			uso = "SL",
			origem = set("arcano", "energetico", "implemento"),
			tipo_ataque = "explos�o de �rea 1 a at� 10 quadrados",
			alvo = "criaturas na �rea",
			efeito = function(self)
				return "Efeito: quem entrar ou come�ar o turno dentro da �rea, sofre "..math.max(self.mod_sab, 1).." (energ�tico).\nA nuvem permanece at� o final do pr�ximo turno ou at� dissip�-la (a��o m�nima)."
			end,
			ataque = mod.inteligencia,
			defesa = "Refl",
			dano = mod.dobra_21("1d6", "inteligencia", "Nuvem de Adagas"),
		},
		onda_trovejante = {
			nome = "Onda Trovejante",
			uso = "SL",
			origem = set("arcano", "implemento", "trovejante"),
			tipo_ataque = "rajada cont�gua 3",
			alvo = "criaturas na rajada",
			ataque = mod.inteligencia,
			defesa = "Fort",
			dano = mod.dobra_21("1d6", "inteligencia", "Onda Trovejante"),
			efeito = function(self)
				return "Sucesso: alvos atingidos s�o empurrados "..math.max(1, self.mod_sab).." quadrados."
			end,
		},
		raio_algido = {
			nome = "Raio �lgido",
			uso = "SL",
			origem = set("arcano", "congelante", "implemento"),
			tipo_ataque = "dist�ncia 10",
			alvo = "uma criatura",
			ataque = mod.inteligencia,
			defesa = "For",
			dano = mod.dobra_21("1d6", "inteligencia", "Raio �lgido"),
			efeito = "Sucesso: alvos ficam lentos at� o FdPT.",
		},
------- Poderes por Encontro n�vel 1 -------------------------------------------
		golpe_resfriante = {
			nome = "Golpe Resfriante",
			uso = "En",
			origem = set("arcano", "congelante", "implemento"),
			tipo_ataque = "dist�ncia 10",
			alvo = "uma criatura",
			ataque = mod.inteligencia,
			defesa = "For",
			dano = mod.dado_mod("2d8", "inteligencia", "Golpe Resfriante"),
			efeito = "Sucesso: alvo fica pasmo at� o FdPT.",
		},
		maos_ardentes = {
			nome = "M�os Ardentes",
			uso = "En",
			origem = set("arcano", "flamejante", "implemento"),
			tipo_ataque = "rajada cont�gua 5",
			alvo = "criaturas na rajada",
			ataque = mod.inteligencia,
			defesa = "Ref",
			dano = mod.dado_mod("2d6", "inteligencia", "M�os Ardentes"),
		},
		orbe_de_energia = {
			nome = "Orbe de Energia",
			uso = "En",
			origem = set("arcano", "energ�tico", "implemento"),
			tipo_ataque = "dist�ncia 20",
			alvo = "uma criatura ou objeto",
			ataque = mod.inteligencia,
			defesa = "Ref",
			dano = mod.dado_mod("2d8", "inteligencia", "Orbe de Energia"),
			efeito = function(self)
				return "Sucesso: ataque secund�rio contra um alvo adjacente ao prim�rio -> "..soma_dano(self, "1d10", self.mod_int, "Orbe de Energia")
			end,
		},
		raio_de_enfraquecimento = {
			nome = "Raio de Enfraquecimento",
			uso = "En",
			origem = set("arcano", "implemento", "necr�tico"),
			tipo_ataque = "dist�ncia 10",
			alvo = "uma criatura",
			ataque = mod.inteligencia,
			defesa = "For",
			dano = mod.dado_mod("1d10", "inteligencia", "Raio de Enfraquecimento"),
			efeito = "Sucesso: alvo fica enfraquecido at� o FdPT.",
		},
		terreno_gelido = {
			nome = "Terreno G�lido",
			uso = "En",
			origem = set("arcano", "congelante", "implemento"),
			tipo_ataque = "explos�o de �rea 1 a at� 10 quadrados",
			alvo = "criaturas na �rea",
			ataque = mod.inteligencia,
			defesa = "Ref",
			dano = mod.dado_mod("1d6", "inteligencia", "Terreno G�lido"),
			efeito = "Sucesso: alvos atingidos s�o derrubadas.\nEfeito: �rea torna-se terreno acidentado at� o FdPT, ou at� dissip�-la (m�nima).",
		},
------- Poderes Di�rios n�vel 1 ------------------------------------------------
		esfera_flamejante = {
			nome = "Esfera Flamejante",
			uso = "Di",
			origem = set("arcano", "conjuracao", "flamejante", "implemento"),
			tipo_ataque = "distancia 10",
			alvo = "criatura adjacente � esfera",
			efeito = function(self)
				return "Criaturas que come�arem o turno adjacente � esfera sofrem 1d4+"..self.mod_int.." (flamejante).\nDeslocamento da esfera = 6.  Persiste at� o final do encontro."
			end,
			ataque = mod.inteligencia,
			defesa = "Ref",
			dano = mod.dado_mod("2d6", "inteligencia", "Esfera Flamejante"),
		},
		flecha_acida = {
			nome = "Flecha �cida",
			uso = "Di",
			origem = set("�cido", "arcano", "implemento"),
			tipo_ataque = "distancia 20",
			alvo = "uma criatura",
			efeito = function(self)
				return "Sucesso: ataque secund�rio contra criaturas adjacentes ao prim�rio.\n  1d8+INT (�cido) + 5 cont�nuo (�cido) (TR encerra)."
			end,
			ataque = mod.inteligencia,
			defesa = "Ref",
			dano = mod.dado_mod("2d8", "inteligencia", "Flecha �cida"),
		},
		nuvem_congelante = {
			nome = "Nuvem Congelante",
			uso = "Di",
			origem = set("arcano", "congelante", "implemento"),
			tipo_ataque = "explos�o de �rea 2 a at� 10 quadrados",
			alvo = "criaturas na �rea",
			efeito = "Criaturas que entram ou come�am o turno na �rea, s�o alvos de novos ataques.\nPersiste at� o final do pr�ximo turno ou at� dissip�-la (m�nima).",
			ataque = mod.inteligencia,
			defesa = "Fort",
			dano = mod.dado_mod("1d8", "inteligencia", "Nuvem Congelante"),
			fracasso = "metade do dano",
		},
		sono = {
			nome = "Sono",
			uso = "Di",
			origem = set("arcano", "implemento", "sono"),
			tipo_ataque = "explos�o de �rea 2 a at� 20 quadrados",
			alvo = "criaturas na �rea",
			ataque = mod.inteligencia,
			defesa = "Von",
			dano = nil,
			efeito = "Sucesso: alvo fica lento (TR encerra ou deixa o alvo inconsciente;\n         2o. TR: volta a lento ou continua inconsciente)\nFracasso: alvo fica lento (TR encerra).",
		},
------- Poderes Utilit�rios n�vel 2 --------------------------------------------
		escudo_arcano = {
			nome = "Escudo Arcano",
			uso = "En",
			origem = set("arcano", "energetico"),
			tipo_ataque = "pessoal",
			alvo = "O personagem",
			gatilho = "Quando o personagem � atingido por um ataque",
			efeito = "CA <- +4, Reflexos <- +4.  At� o final do pr�ximo turno",
		},
		queda_suave = {
			nome = "Queda Suave",
			uso = "Di",
			origem = set("arcano"),
			tipo_ataque = "distancia 10",
			alvo = "O personagem ou uma criatura",
			efeito = "Ignora o dano da queda e n�o fica derrubado",
		},
		recuo_acelerado = {
			nome = "Recuo Acelerado",
			uso = "Di",
			origem = set("arcano"),
			tipo_ataque = "pessoal",
			alvo = "O personagem",
			efeito = function(self)
				return "Ajuste at� "..(2*self.deslocamento)
			end,
		},
		salto = {
			nome = "Salto",
			uso = "En",
			origem = set("arcano"),
			tipo_ataque = "distancia 10",
			alvo = "O personagem ou uma criatura",
			efeito = "Realize um teste de Atletismo com +10 e considere com impulso, mesmo sem deslocamento.",
		},
------- Poderes por Encontro n�vel 3 -------------------------------------------
		esfera_de_choque = {
			nome = "Esfera de Choque",
			uso = "En",
			origem = set("arcano", "el�trico", "implemento"),
			tipo_ataque = "explos�o de �rea 2 a at� 10 quadrados",
			alvo = "criaturas na �rea",
			ataque = mod.inteligencia,
			defesa = "Refl",
			dano = mod.dado_mod("2d6", "inteligencia", "Esfera de Choque"),
		},
		leque_cromatico = {
			nome = "Leque Crom�tico",
			uso = "En",
			origem = set("arcano", "implemento", "radiante"),
			tipo_ataque = "rajada 5",
			alvo = "criaturas na rajada",
			ataque = mod.inteligencia,
			defesa = "Vont",
			dano = mod.dado_mod("1d6", "inteligencia", "Leque Crom�tico"),
			efeito = "Sucesso: alvos ficam pasmos at� o FdPT.",
		},
		mortalha_de_fogo = {
			nome = "Mortalha de Fogo",
			uso = "En",
			origem = set("arcano", "implemento", "radiante"),
			tipo_ataque = "explos�o cont�gua 3",
			alvo = "criaturas na rajada",
			ataque = mod.inteligencia,
			defesa = "Fort",
			dano = mod.dado_mod("1d8", "inteligencia", "Mortalha de Fogo"),
			efeito = "Sucesso: +5 de dano flamejante cont�nuo (TR encerra).",
		},
		raios_gelidos = {
			nome = "Raios G�lidos",
			uso = "En",
			origem = set("arcano", "implemento", "radiante"),
			tipo_ataque = "dist�ncia 10",
			alvo = "uma ou duas criaturas",
			ataque = mod.inteligencia,
			defesa = "Refl",
			dano = mod.dado_mod("1d10", "inteligencia", "Raios G�lidos"),
			efeito = "Sucesso: alvos ficam imobilizados at� o FdPT.",
		},
------- Poderes Di�rios n�vel 5 ------------------------------------------------
		aperto_gelido_de_bigby = {
			nome = "Aperto G�lido de Bigby",
			uso = "Di",
			origem = set("arcano", "congelante", "conjuracao", "implemento"),
			tipo_ataque = "dist�ncia 20",
			alvo = "uma criatura adjacente � m�o",
			ataque = mod.inteligencia,
			defesa = "Refl",
			dano = mod.dado_mod("2d8", "inteligencia", "Aperto G�lido de Bigby"),
			efeito = function (self)
				return "Conjura uma m�o de gelo com 1,5m de altura em um quadrado desocupado no alcance.\nA��o de movimento para deslocar a m�o at� 6 quadrados.\nSucesso: alvo fica agarrado at� escapar (defesas do mago).  Sustenta��o m�nima: 1d8+"..self.mod_int..".\nA��o padr�o para atacar outro alvo se n�o estiver agarrando nenhum."
			end,
		},
		bola_de_fogo = {
			nome = "Bola de Fogo",
			uso = "Di",
			origem = set("arcano", "flamejante", "implemento"),
			tipo_ataque = "explos�o �rea 3 a at� 20",
			alvo = "criaturas na explos�o",
			ataque = mod.inteligencia,
			defesa = "Refl",
			dano = mod.dado_mod("3d6", "inteligencia", "Bola de Fogo"),
			efeito = "Fracasso: metade do dano",
		},
		nuvem_fetida = {
			nome = "Nuvem F�tida",
			uso = "Di",
			origem = set("arcano", "implemento", "venenoso", "zona"),
			tipo_ataque = "explos�o �rea 2 a at� 20",
			alvo = "criaturas na explos�o",
			ataque = mod.inteligencia,
			defesa = "Fort",
			dano = mod.dado_mod("1d10", "inteligencia", "Nuvem F�tida"),
			efeito = function(self)
				return "Sucesso: gera zona de vapores nocivos que bloqueiam a vis�o at� o FdPT.\nCriaturas que ingressam ou come�am seus turnos na zona sofrem 1d10+"..self.mod_int.."\nde dano venenoso.  Sustenta��o m�nima e a��o de movimento desloca a zona 6."
			end,
		},
	},
}
