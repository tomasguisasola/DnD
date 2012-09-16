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
------- Características de Classe ----------------------------------------------
		maestria_implemento_arcano = {
			nome = "Maestria em Implemento Arcano",
			uso = "En",
			--acao = "mínima",
			origem = set("arcano"),
			tipo_ataque = "pessoal",
			alvo = "você",
			--ataque = mod.destreza,
			--defesa = "CA",
			--dano
			efeito = function(self)
				local c = (self.caracteristica_classe or ''):lower()
				if c:match"ajado" then
					return "Com uma interrupção imediata, após o resultado do dano que for receber, ganhar +"..self.mod_con.." na CA contra este ataque (o que pode anulá-lo)."
				elseif c:match"orbe" then
					return "-"..self.mod_sab.." de penalidade no próximo TR contra um efeito provocado por uma de suas magias que uma criatura for fazer."
				elseif c:match"varinha" then
					return "+"..self.mod_des.." na próxima jogada de ataque."
				else
					Personagem.warn"Sem característica de classe definida."
					return "Sem efeito, pois não há característica de classe definida."
				end
			end,
		},
	},
	poderes = {
------- Poderes Sem Limite nível 1 ---------------------------------------------
		explosao_incandescente = {
			nome = "Explosão Incandescente",
			uso = "SL",
			origem = set("arcano", "flamejante", "implemento"),
			tipo_ataque = "explosão de área 1 a até 10",
			alvo = "Uma criatura",
			ataque = mod.inteligencia,
			defesa = "Ref",
			dano = mod.dobra_21("1d6", "inteligencia", "Explosão Incandescente"),
		},
		misseis_magicos = {
			nome = "Mísseis Mágicos",
			uso = "SL",
			origem = set("arcano", "energetico", "implemento"),
			tipo_ataque = "distancia 10",
			alvo = "Uma criatura",
			--ataque = "Sempre acerta",
			dano = function(self)
				if self.nivel >= 21 then
					return soma_dano(self, "4", self.mod_int, "Misseis Mágicos")
				elseif self.nivel >= 11 then
					return soma_dano(self, "3", self.mod_int, "Misseis Mágicos")
				else
					return soma_dano(self, "2", self.mod_int, "Misseis Mágicos")
				end
			end,
		},
		nuvem_de_adagas = {
			nome = "Nuvem de Adagas",
			uso = "SL",
			origem = set("arcano", "energetico", "implemento"),
			tipo_ataque = "explosão de área 1 a até 10 quadrados",
			alvo = "criaturas na área",
			efeito = function(self)
				return "Efeito: quem entrar ou começar o turno dentro da área, sofre "..math.max(self.mod_sab, 1).." (energético).\nA nuvem permanece até o final do próximo turno ou até dissipá-la (ação mínima)."
			end,
			ataque = mod.inteligencia,
			defesa = "Refl",
			dano = mod.dobra_21("1d6", "inteligencia", "Nuvem de Adagas"),
		},
		onda_trovejante = {
			nome = "Onda Trovejante",
			uso = "SL",
			origem = set("arcano", "implemento", "trovejante"),
			tipo_ataque = "rajada contígua 3",
			alvo = "criaturas na rajada",
			ataque = mod.inteligencia,
			defesa = "Fort",
			dano = mod.dobra_21("1d6", "inteligencia", "Onda Trovejante"),
			efeito = function(self)
				return "Sucesso: alvos atingidos são empurrados "..math.max(1, self.mod_sab).." quadrados."
			end,
		},
		raio_algido = {
			nome = "Raio Álgido",
			uso = "SL",
			origem = set("arcano", "congelante", "implemento"),
			tipo_ataque = "distância 10",
			alvo = "uma criatura",
			ataque = mod.inteligencia,
			defesa = "For",
			dano = mod.dobra_21("1d6", "inteligencia", "Raio Álgido"),
			efeito = "Sucesso: alvos ficam lentos até o FdPT.",
		},
------- Poderes por Encontro nível 1 -------------------------------------------
		golpe_resfriante = {
			nome = "Golpe Resfriante",
			uso = "En",
			origem = set("arcano", "congelante", "implemento"),
			tipo_ataque = "distância 10",
			alvo = "uma criatura",
			ataque = mod.inteligencia,
			defesa = "For",
			dano = mod.dado_mod("2d8", "inteligencia", "Golpe Resfriante"),
			efeito = "Sucesso: alvo fica pasmo até o FdPT.",
		},
		maos_ardentes = {
			nome = "Mãos Ardentes",
			uso = "En",
			origem = set("arcano", "flamejante", "implemento"),
			tipo_ataque = "rajada contígua 5",
			alvo = "criaturas na rajada",
			ataque = mod.inteligencia,
			defesa = "Ref",
			dano = mod.dado_mod("2d6", "inteligencia", "Mãos Ardentes"),
		},
		orbe_de_energia = {
			nome = "Orbe de Energia",
			uso = "En",
			origem = set("arcano", "energético", "implemento"),
			tipo_ataque = "distância 20",
			alvo = "uma criatura ou objeto",
			ataque = mod.inteligencia,
			defesa = "Ref",
			dano = mod.dado_mod("2d8", "inteligencia", "Orbe de Energia"),
			efeito = function(self)
				return "Sucesso: ataque secundário contra um alvo adjacente ao primário -> "..soma_dano(self, "1d10", self.mod_int, "Orbe de Energia")
			end,
		},
		raio_de_enfraquecimento = {
			nome = "Raio de Enfraquecimento",
			uso = "En",
			origem = set("arcano", "implemento", "necrótico"),
			tipo_ataque = "distância 10",
			alvo = "uma criatura",
			ataque = mod.inteligencia,
			defesa = "For",
			dano = mod.dado_mod("1d10", "inteligencia", "Raio de Enfraquecimento"),
			efeito = "Sucesso: alvo fica enfraquecido até o FdPT.",
		},
		terreno_gelido = {
			nome = "Terreno Gélido",
			uso = "En",
			origem = set("arcano", "congelante", "implemento"),
			tipo_ataque = "explosão de área 1 a até 10 quadrados",
			alvo = "criaturas na área",
			ataque = mod.inteligencia,
			defesa = "Ref",
			dano = mod.dado_mod("1d6", "inteligencia", "Terreno Gélido"),
			efeito = "Sucesso: alvos atingidos são derrubadas.\nEfeito: área torna-se terreno acidentado até o FdPT, ou até dissipá-la (mínima).",
		},
------- Poderes Diários nível 1 ------------------------------------------------
		esfera_flamejante = {
			nome = "Esfera Flamejante",
			uso = "Di",
			origem = set("arcano", "conjuracao", "flamejante", "implemento"),
			tipo_ataque = "distancia 10",
			alvo = "criatura adjacente à esfera",
			efeito = function(self)
				return "Criaturas que começarem o turno adjacente à esfera sofrem 1d4+"..self.mod_int.." (flamejante).\nDeslocamento da esfera = 6.  Persiste até o final do encontro."
			end,
			ataque = mod.inteligencia,
			defesa = "Ref",
			dano = mod.dado_mod("2d6", "inteligencia", "Esfera Flamejante"),
		},
		flecha_acida = {
			nome = "Flecha Ácida",
			uso = "Di",
			origem = set("ácido", "arcano", "implemento"),
			tipo_ataque = "distancia 20",
			alvo = "uma criatura",
			efeito = function(self)
				return "Sucesso: ataque secundário contra criaturas adjacentes ao primário.\n  1d8+INT (ácido) + 5 contínuo (ácido) (TR encerra)."
			end,
			ataque = mod.inteligencia,
			defesa = "Ref",
			dano = mod.dado_mod("2d8", "inteligencia", "Flecha Ácida"),
		},
		nuvem_congelante = {
			nome = "Nuvem Congelante",
			uso = "Di",
			origem = set("arcano", "congelante", "implemento"),
			tipo_ataque = "explosão de área 2 a até 10 quadrados",
			alvo = "criaturas na área",
			efeito = "Criaturas que entram ou começam o turno na área, são alvos de novos ataques.\nPersiste até o final do próximo turno ou até dissipá-la (mínima).",
			ataque = mod.inteligencia,
			defesa = "Fort",
			dano = mod.dado_mod("1d8", "inteligencia", "Nuvem Congelante"),
			fracasso = "metade do dano",
		},
		sono = {
			nome = "Sono",
			uso = "Di",
			origem = set("arcano", "implemento", "sono"),
			tipo_ataque = "explosão de área 2 a até 20 quadrados",
			alvo = "criaturas na área",
			ataque = mod.inteligencia,
			defesa = "Von",
			dano = nil,
			efeito = "Sucesso: alvo fica lento (TR encerra ou deixa o alvo inconsciente;\n         2o. TR: volta a lento ou continua inconsciente)\nFracasso: alvo fica lento (TR encerra).",
		},
------- Poderes Utilitários nível 2 --------------------------------------------
		escudo_arcano = {
			nome = "Escudo Arcano",
			uso = "En",
			origem = set("arcano", "energetico"),
			tipo_ataque = "pessoal",
			alvo = "O personagem",
			gatilho = "Quando o personagem é atingido por um ataque",
			efeito = "CA <- +4, Reflexos <- +4.  Até o final do próximo turno",
		},
		queda_suave = {
			nome = "Queda Suave",
			uso = "Di",
			origem = set("arcano"),
			tipo_ataque = "distancia 10",
			alvo = "O personagem ou uma criatura",
			efeito = "Ignora o dano da queda e não fica derrubado",
		},
		recuo_acelerado = {
			nome = "Recuo Acelerado",
			uso = "Di",
			origem = set("arcano"),
			tipo_ataque = "pessoal",
			alvo = "O personagem",
			efeito = function(self)
				return "Ajuste até "..(2*self.deslocamento)
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
------- Poderes por Encontro nível 3 -------------------------------------------
		esfera_de_choque = {
			nome = "Esfera de Choque",
			uso = "En",
			origem = set("arcano", "elétrico", "implemento"),
			tipo_ataque = "explosão de área 2 a até 10 quadrados",
			alvo = "criaturas na área",
			ataque = mod.inteligencia,
			defesa = "Refl",
			dano = mod.dado_mod("2d6", "inteligencia", "Esfera de Choque"),
		},
		leque_cromatico = {
			nome = "Leque Cromático",
			uso = "En",
			origem = set("arcano", "implemento", "radiante"),
			tipo_ataque = "rajada 5",
			alvo = "criaturas na rajada",
			ataque = mod.inteligencia,
			defesa = "Vont",
			dano = mod.dado_mod("1d6", "inteligencia", "Leque Cromático"),
			efeito = "Sucesso: alvos ficam pasmos até o FdPT.",
		},
		mortalha_de_fogo = {
			nome = "Mortalha de Fogo",
			uso = "En",
			origem = set("arcano", "implemento", "radiante"),
			tipo_ataque = "explosão contígua 3",
			alvo = "criaturas na rajada",
			ataque = mod.inteligencia,
			defesa = "Fort",
			dano = mod.dado_mod("1d8", "inteligencia", "Mortalha de Fogo"),
			efeito = "Sucesso: +5 de dano flamejante contínuo (TR encerra).",
		},
		raios_gelidos = {
			nome = "Raios Gélidos",
			uso = "En",
			origem = set("arcano", "implemento", "radiante"),
			tipo_ataque = "distância 10",
			alvo = "uma ou duas criaturas",
			ataque = mod.inteligencia,
			defesa = "Refl",
			dano = mod.dado_mod("1d10", "inteligencia", "Raios Gélidos"),
			efeito = "Sucesso: alvos ficam imobilizados até o FdPT.",
		},
------- Poderes Diários nível 5 ------------------------------------------------
		aperto_gelido_de_bigby = {
			nome = "Aperto Gélido de Bigby",
			uso = "Di",
			origem = set("arcano", "congelante", "conjuracao", "implemento"),
			tipo_ataque = "distância 20",
			alvo = "uma criatura adjacente à mão",
			ataque = mod.inteligencia,
			defesa = "Refl",
			dano = mod.dado_mod("2d8", "inteligencia", "Aperto Gélido de Bigby"),
			efeito = function (self)
				return "Conjura uma mão de gelo com 1,5m de altura em um quadrado desocupado no alcance.\nAção de movimento para deslocar a mão até 6 quadrados.\nSucesso: alvo fica agarrado até escapar (defesas do mago).  Sustentação mínima: 1d8+"..self.mod_int..".\nAção padrão para atacar outro alvo se não estiver agarrando nenhum."
			end,
		},
		bola_de_fogo = {
			nome = "Bola de Fogo",
			uso = "Di",
			origem = set("arcano", "flamejante", "implemento"),
			tipo_ataque = "explosão área 3 a até 20",
			alvo = "criaturas na explosão",
			ataque = mod.inteligencia,
			defesa = "Refl",
			dano = mod.dado_mod("3d6", "inteligencia", "Bola de Fogo"),
			efeito = "Fracasso: metade do dano",
		},
		nuvem_fetida = {
			nome = "Nuvem Fétida",
			uso = "Di",
			origem = set("arcano", "implemento", "venenoso", "zona"),
			tipo_ataque = "explosão área 2 a até 20",
			alvo = "criaturas na explosão",
			ataque = mod.inteligencia,
			defesa = "Fort",
			dano = mod.dado_mod("1d10", "inteligencia", "Nuvem Fétida"),
			efeito = function(self)
				return "Sucesso: gera zona de vapores nocivos que bloqueiam a visão até o FdPT.\nCriaturas que ingressam ou começam seus turnos na zona sofrem 1d10+"..self.mod_int.."\nde dano venenoso.  Sustentação mínima e ação de movimento desloca a zona 6."
			end,
		},
	},
}
