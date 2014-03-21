local set = require"DnD.Set"
local soma_dano = require"DnD.Soma".soma
local armas = require"DnD.Armas"
local tipos_armas = require"DnD.TiposArmas"
local mod = require"DnD.Modificadores"
local Personagem = require"DnD.Personagem"

local function implemento_maior_dano (self, poder)
	local dano = 0
	for impl, dados in pairs (self.implementos) do
		dano = math.max (dano,
			soma_dano (self, dados.dano, 0, poder))
	end
	return dano
end

return {
	nome = "Mago",
	fonte_de_poder = "arcano",
	vontade = 2,
	armaduras = set("traje"),
	ca = function (self)
		if (self.caracteristica_classe or ''):match"[Cc]ajado" then
			return 1
		else
			return 0
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
					return "(II) após o resultado do dano que for receber, ganha +"..self.mod_con.." em uma defesa contra\n    este ataque (o que pode anulá-lo)."
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
			tipo_ataque = "explosão 1 a até 10",
			alvo = "uma criatura",
			ataque = mod.inteligencia,
			defesa = "Ref",
			dano = mod.dobra_21("1d6", "inteligencia", "Explosão Incandescente"),
		},
		misseis_magicos = {
			nome = "Mísseis Mágicos",
			uso = "SL",
			origem = set("arcano", "energetico", "implemento"),
			tipo_ataque = "distancia 20",
			alvo = "uma criatura",
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
			tipo_ataque = "explosão 1 a até 10",
			alvo = "criaturas na área",
			efeito = function(self)
				local dano_implemento = implemento_maior_dano (self, "Nuvem de Adagas")
				local dano = soma_dano (self, self.mod_sab, dano_implemento, "Nuvem de Adagas")
				return "Efeito: quem ingressar/começar o turno dentro da área, sofre "..dano.." (energético).\n    A nuvem permanece até o FdPT ou até dissipá-la (ação mínima)."
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
			efeito = "Sucesso: alvo fica lento até o FdPT.",
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
			efeito = "Fracasso: metade do dano.",
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
				local dano_implemento = implemento_maior_dano (self, "Orbe de Energia")
				local dano = soma_dano (self, "1d10+"..self.mod_int, dano_implemento, "Orbe de Energia")
				return "Sucesso: ataque contra criaturas adjacentes ao primário -> "..dano
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
			origem = set("arcano", "congelante", "implemento", "zona"),
			tipo_ataque = "explosão 1 a até 10",
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
			alvo = "criatura adj. à esfera",
			efeito = function(self)
				local dano_implemento = implemento_maior_dano (self, "Esfera Flamejante")
				local dano = soma_dano (self, "1d4+"..self.mod_int, dano_implemento, "Esfera Flamejante")
				return "Efeito: quem começar o turno adjacente à esfera sofre "..dano.." (flamejante).\n    Deslocamento da esfera (movimento) = 6.  Persiste até o FdEn."
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
				local dano_implemento = implemento_maior_dano (self, "Flecha Ácida")
				local dano = soma_dano (self, "1d8+"..self.mod_int, dano_implemento, "Flecha Ácida")
				return "Sucesso: +5 contínuo (TR).\nFracasso: metade do dano e +2 contínuo (TR).\nEfeito: ataque criaturas adjacentes ao primário -> "..dano.." +5 contínuo (TR)."
			end,
			ataque = mod.inteligencia,
			defesa = "Ref",
			dano = mod.dado_mod("2d8", "inteligencia", "Flecha Ácida"),
		},
		nuvem_congelante = {
			nome = "Nuvem Congelante",
			uso = "Di",
			origem = set("arcano", "congelante", "implemento", "zona"),
			tipo_ataque = "explosão 2 a até 10",
			alvo = "criaturas na área",
			efeito = "Fracasso: metade do dano.\nEfeito: criaturas que ingressam/começam o turno na área, sofrem 5 (congelante)\n    Persiste até o FdPT ou até dissipá-la (mínima).",
			ataque = mod.inteligencia,
			defesa = "Fort",
			dano = mod.dado_mod("2d8", "inteligencia", "Nuvem Congelante"),
		},
		sono = {
			nome = "Sono",
			uso = "Di",
			origem = set("arcano", "implemento", "sono"),
			tipo_ataque = "explosão 2 a até 20",
			alvo = "criaturas na área",
			ataque = mod.inteligencia,
			defesa = "Von",
			dano = nil,
			efeito = "Sucesso: alvo fica lento (TR encerra ou deixa o alvo inconsciente;\n    2o. TR: volta a lento ou continua inconsciente)\nFracasso: alvo fica lento (TR encerra).",
		},
------- Poderes Utilitários nível 2 --------------------------------------------
		escudo_arcano = {
			nome = "Escudo Arcano",
			uso = "En",
			origem = set("arcano", "energetico"),
			tipo_ataque = "pessoal",
			alvo = "O personagem",
			gatilho = "Quando o personagem é atingido por um ataque",
			efeito = "(II) CA <- +4, Reflexos <- +4.  Até o final do próximo turno",
		},
		queda_suave = {
			nome = "Queda Suave",
			uso = "Di",
			origem = set("arcano"),
			tipo_ataque = "distancia 10",
			alvo = "você ou uma criatura",
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
			tipo_ataque = "distância 10",
			alvo = "você ou uma criatura",
			efeito = "Efeito: realize um teste de Atletismo (livre) com +10 e considere com impulso,\n    mesmo sem deslocamento.",
		},
------- Poderes por Encontro nível 3 -------------------------------------------
		esfera_de_choque = {
			nome = "Esfera de Choque",
			uso = "En",
			origem = set("arcano", "elétrico", "implemento"),
			tipo_ataque = "explosão 2 a até 10",
			alvo = "criaturas na área",
			ataque = mod.inteligencia,
			defesa = "Refl",
			dano = mod.dado_mod("2d6", "inteligencia", "Esfera de Choque"),
			efeito = "Fracasso: metade do dano.",
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
			alvo = "inimigos na rajada",
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
			efeito = "Sucesso: alvos ficam imobilizados até o FdPT.\nFracasso: alvos ficam lentos até o FdPT.",
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
				local dano_implemento = implemento_maior_dano (self, "aperto_gelido_de_bigby")
				local dano = soma_dano (self, "1d8+"..self.mod_int, dano_implemento, "Aperto Gélido de Bigby")
				return "Efeito: conjura uma mão de gelo (1,5m de altura) em um quadrado desocupado\n    dentro do alcance.  Ação de movimento para deslocar a mão até 6 quadrados.\nSucesso: alvo fica agarrado até escapar (defesas do mago).\n    Sustentação mínima: alvo agarrado -> "..dano.." (congelante).\n    Ação padrão para atacar outro alvo se não estiver agarrando nenhum."
			end,
		},
		bola_de_fogo = {
			nome = "Bola de Fogo",
			uso = "Di",
			origem = set("arcano", "flamejante", "implemento"),
			tipo_ataque = "explosão 3 a até 20",
			alvo = "criaturas na área",
			ataque = mod.inteligencia,
			defesa = "Refl",
			dano = mod.dado_mod("3d6", "inteligencia", "Bola de Fogo"),
			efeito = "Fracasso: metade do dano",
		},
		nuvem_fetida = {
			nome = "Nuvem Fétida",
			uso = "Di",
			origem = set("arcano", "implemento", "venenoso", "zona"),
			tipo_ataque = "explosão 2 a até 20",
			alvo = "criaturas na área",
			ataque = mod.inteligencia,
			defesa = "Fort",
			dano = mod.dado_mod("1d10", "inteligencia", "Nuvem Fétida"),
			efeito = function(self)
				local dano_implemento = implemento_maior_dano(self, "nuvem_fetida")
				local dano = soma_dano (self, 5+self.mod_int, dano_implemento, "Nuvem Fétida")
				return "Sucesso: gera zona de vapores nocivos que bloqueiam a visão até o FdPT.\n    Criaturas que ingressam/começam seus turnos na zona sofrem "..dano.." (venenoso).\n    Sustentação mínima e ação de movimento desloca a zona 6."
			end,
		},
------- Poderes Utilitários nível 6 --------------------------------------------
		dissipar_magia = {
			nome = "Dissipar Magia",
			uso = "En",
			origem = set("arcano", "implemento"),
			tipo_ataque = "distância 10",
			acao = "padrão",
			alvo = "conjuração ou zona",
			ataque = mod.inteligencia,
			defesa = "Vont",
			efeito = "Sucesso: a conjuração ou zona é destruída, assim como seus efeitos, incluindo\n    aqueles que necessitam de um TR para encerrar.",
		},
		invisibilidade = {
			nome = "Invisibilidade",
			uso = "Di",
			origem = set("arcano", "ilusão"),
			tipo_ataque = "distância 5",
			acao = "padrão",
			alvo = "uma criatura",
			efeito = "Efeito: o alvo fica invisível até o FdPT (sust. padrão; alcance) ou até atacar.",
		},
		levitacao = {
			nome = "Levitação",
			uso = "Di",
			origem = set("arcano"),
			tipo_ataque = "pessoal",
			acao = "movimento",
			alvo = "pessoal",
			efeito = "Efeito: você pode se deslocar 4 quadrados verticalmente e permanecer flutuando.\n    Enquanto estiver assim, fica instável, sofrendo -2 na CA e em Reflexos.\n    Se algum efeito obrigá-lo a ficar a mais de 4 quadrados acima do solo, você\n    desce suavemente até manter este nível, sem sofrer dano de queda.\n    Pode usar uma ação de movimento para sustentar o efeito e ainda se deslocar\n    para cima ou para baixo sem ultrapassar o limite de 4 quadrados de altura\n    e 1 quadrado para um dos lados.  Se não sustentar, aterrisa suavemente.",
		},
		porta_dimensional = {
			nome = "Porta Dimensional",
			uso = "Di",
			origem = set("arcano", "teleporte"),
			tipo_ataque = "pessoal",
			acao = "movimento",
			alvo = "pessoal",
			efeito = "Efeito: você teleporta 10 quadrados (não pode levar ninguém consigo).",
		},
		fuga_do_mago = { -- PA -----------------------------------------------
			nome = "Fuga do Mago",
			uso = "En",
			origem = set("arcano", "teleporte"),
			tipo_ataque = "pessoal",
			acao = "II",
			alvo = "pessoal",
			efeito = "Efeito: quando um inimigo atingir você com um At CaC., você se teleporta 5 para\n    um quadrado não adjacente a ele.",
		},
------- Poderes por Encontro nível 7 -----------------------------------------
		ariete_espectral = {
			nome = "Aríete Espectral",
			uso = "En",
			origem = set("arcano", "energético", "implemento"),
			tipo_ataque = "distância 10",
			alvo = "uma criatura",
			ataque = mod.inteligencia,
			defesa = "Fort",
			dano = mod.dado_mod("2d10", "inteligencia", "Aríete Espectral"),
			efeito = "Sucesso: o alvo é empurrado 3 quadrados e fica derrubado.",
		},
		colera_invernal = {
			nome = "Cólera Invernal",
			uso = "En",
			origem = set("arcano", "congelante", "implemento"),
			tipo_ataque = "área 2 a até 10",
			alvo = "criaturas na explosão",
			ataque = mod.inteligencia,
			defesa = "Fort",
			dano = mod.dado_mod("2d8", "inteligencia", "Cólera Invernal"),
			efeito = function(self)
				local dano = self.mod_int
				return "Efeito: uma nevasca surge na área e continua até o FdPT ou dissipá-la (mínima),\n    concedendo ocultação.  Quem começar seu turno na zona sofre "..dano.." congelante."
			end,
		},
		explosao_de_fogo = {
			nome = "Explosão de Fogo",
			uso = "En",
			origem = set("arcano", "flamejante", "implemento"),
			tipo_ataque = "área 2 a até 20",
			alvo = "criaturas na explosão",
			ataque = mod.inteligencia,
			defesa = "Ref",
			dano = mod.dado_mod("3d6", "inteligencia", "Explosão de Fogo"),
		},
		relampago = {
			nome = "Relâmpago",
			uso = "En",
			origem = set("arcano", "elétrico", "implemento"),
			tipo_ataque = "distância 10",
			alvo = "uma criatura",
			ataque = mod.inteligencia,
			defesa = "Ref",
			dano = mod.dado_mod("2d6", "inteligencia", "Relâmpago"),
			efeito = "Efeito: realize um ataque secundário (igual) contra duas criaturas a até 10 do\n    alvo primário, causando 1d6+INT de dano elétrico.",
		},
		abundancia_de_inimigos = {
			nome = "Abundância de Inimigos",
			uso = "En",
			origem = set("arcano", "ilusão", "implemento", "psíquico"),
			tipo_ataque = "área 1 a até 20",
			alvo = "inimigos na área",
			ataque = mod.inteligencia,
			defesa = "Vont",
			dano = mod.dado_mod("2d8", "inteligencia", "Abundância de Inimigos"),
			efeito = "Sucesso: até o FdPT você e seus aliados tratam os alvos como aliados para efeito\n    de flanqueamento.",
		},
		eco_concussivo = {
			nome = "Eco Concussivo",
			uso = "En",
			origem = set("arcano", "encanto", "implemento", "trovejante"),
			tipo_ataque = "distância 10",
			alvo = "uma criatura",
			ataque = mod.inteligencia,
			defesa = "Vont",
			dano = mod.dado_mod("2d6", "inteligencia", "Eco Concussivo"),
			efeito = "Sucesso: a primeira vez que o alvo realizar um ataque até o FdPT, ele causa 5 de\n    dano trovejante a si próprio e a todos os aliados a até 3 dele.",
		},
		limo_acido = {
			nome = "Limo Ácido",
			uso = "En",
			origem = set("ácido", "arcano", "conjuração", "implemento"),
			tipo_ataque = "distância 10",
			alvo = "uma criatura",
			ataque = mod.inteligencia,
			defesa = "Refl",
			dano = mod.dado_mod("4d8", "inteligencia", "Limo Ácido"),
			efeito = function (self)
				local dano = self.mod_con
				local efeito = "Efeito: você conjura uma camada de limo de ocupa o espaço do alvo.  Se ele se\n    mover, o limo anda com ele, desde que fique dentro do alcance.\n"
				if self.caracteristica_classe:lower():match"tomo" then
					return efeito.."Sucesso: quando o alvo fizer o primeiro ataque até o FdPT, o limo explode e\n    causa "..dano.." de dano ácido a todos os inimigos a até 2 do alvo e o\n    efeito se encerra."
				else
					return efeito.."Sucesso: até o FdPT, toda vez que o alvo fizer um ataque, sofre "..dano.." de dano\n    ácido."
				end
			end,
		},
		dobra_no_espaco = {
			nome = "Dobra no Espaço",
			uso = "En",
			origem = set("arcano", "implemento", "teleporte"),
			tipo_ataque = "área 1 a até 10",
			alvo = "criaturas na explosão",
			ataque = mod.inteligencia,
			defesa = "Vont",
			dano = mod.dado_mod("1d6", "inteligencia", "Dobra no Espaço"),
			efeito = "Sucesso: alvos são teleportados 3 quadrados e ficam lentos até o FdPT.",
		},
		vermes_de_minauros = {
			nome = "Vermes de Minauros",
			uso = "En",
			origem = set("ácido", "arcano", "conjuração", "implemento"),
			tipo_ataque = "distância 10",
			alvo = "uma criatura",
			ataque = mod.inteligencia,
			defesa = "Fort",
			dano = mod.dado_mod("2d8", "inteligencia", "Vermes de Minauros"),
			efeito = "Efeito: você conjura um monte de vermes no espaço do inimigo até o FdPT.\nSucesso: se o alvo terminar seu turno em até 2 quadrados dos vermes, sofre 10 de\n    dano ácido.",
		},
	},
}
