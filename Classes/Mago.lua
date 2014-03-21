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
					return "(II) ap�s o resultado do dano que for receber, ganha +"..self.mod_con.." em uma defesa contra\n    este ataque (o que pode anul�-lo)."
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
			tipo_ataque = "explos�o 1 a at� 10",
			alvo = "uma criatura",
			ataque = mod.inteligencia,
			defesa = "Ref",
			dano = mod.dobra_21("1d6", "inteligencia", "Explos�o Incandescente"),
		},
		misseis_magicos = {
			nome = "M�sseis M�gicos",
			uso = "SL",
			origem = set("arcano", "energetico", "implemento"),
			tipo_ataque = "distancia 20",
			alvo = "uma criatura",
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
			tipo_ataque = "explos�o 1 a at� 10",
			alvo = "criaturas na �rea",
			efeito = function(self)
				local dano_implemento = implemento_maior_dano (self, "Nuvem de Adagas")
				local dano = soma_dano (self, self.mod_sab, dano_implemento, "Nuvem de Adagas")
				return "Efeito: quem ingressar/come�ar o turno dentro da �rea, sofre "..dano.." (energ�tico).\n    A nuvem permanece at� o FdPT ou at� dissip�-la (a��o m�nima)."
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
			efeito = "Sucesso: alvo fica lento at� o FdPT.",
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
			efeito = "Fracasso: metade do dano.",
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
				local dano_implemento = implemento_maior_dano (self, "Orbe de Energia")
				local dano = soma_dano (self, "1d10+"..self.mod_int, dano_implemento, "Orbe de Energia")
				return "Sucesso: ataque contra criaturas adjacentes ao prim�rio -> "..dano
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
			origem = set("arcano", "congelante", "implemento", "zona"),
			tipo_ataque = "explos�o 1 a at� 10",
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
			alvo = "criatura adj. � esfera",
			efeito = function(self)
				local dano_implemento = implemento_maior_dano (self, "Esfera Flamejante")
				local dano = soma_dano (self, "1d4+"..self.mod_int, dano_implemento, "Esfera Flamejante")
				return "Efeito: quem come�ar o turno adjacente � esfera sofre "..dano.." (flamejante).\n    Deslocamento da esfera (movimento) = 6.  Persiste at� o FdEn."
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
				local dano_implemento = implemento_maior_dano (self, "Flecha �cida")
				local dano = soma_dano (self, "1d8+"..self.mod_int, dano_implemento, "Flecha �cida")
				return "Sucesso: +5 cont�nuo (TR).\nFracasso: metade do dano e +2 cont�nuo (TR).\nEfeito: ataque criaturas adjacentes ao prim�rio -> "..dano.." +5 cont�nuo (TR)."
			end,
			ataque = mod.inteligencia,
			defesa = "Ref",
			dano = mod.dado_mod("2d8", "inteligencia", "Flecha �cida"),
		},
		nuvem_congelante = {
			nome = "Nuvem Congelante",
			uso = "Di",
			origem = set("arcano", "congelante", "implemento", "zona"),
			tipo_ataque = "explos�o 2 a at� 10",
			alvo = "criaturas na �rea",
			efeito = "Fracasso: metade do dano.\nEfeito: criaturas que ingressam/come�am o turno na �rea, sofrem 5 (congelante)\n    Persiste at� o FdPT ou at� dissip�-la (m�nima).",
			ataque = mod.inteligencia,
			defesa = "Fort",
			dano = mod.dado_mod("2d8", "inteligencia", "Nuvem Congelante"),
		},
		sono = {
			nome = "Sono",
			uso = "Di",
			origem = set("arcano", "implemento", "sono"),
			tipo_ataque = "explos�o 2 a at� 20",
			alvo = "criaturas na �rea",
			ataque = mod.inteligencia,
			defesa = "Von",
			dano = nil,
			efeito = "Sucesso: alvo fica lento (TR encerra ou deixa o alvo inconsciente;\n    2o. TR: volta a lento ou continua inconsciente)\nFracasso: alvo fica lento (TR encerra).",
		},
------- Poderes Utilit�rios n�vel 2 --------------------------------------------
		escudo_arcano = {
			nome = "Escudo Arcano",
			uso = "En",
			origem = set("arcano", "energetico"),
			tipo_ataque = "pessoal",
			alvo = "O personagem",
			gatilho = "Quando o personagem � atingido por um ataque",
			efeito = "(II) CA <- +4, Reflexos <- +4.  At� o final do pr�ximo turno",
		},
		queda_suave = {
			nome = "Queda Suave",
			uso = "Di",
			origem = set("arcano"),
			tipo_ataque = "distancia 10",
			alvo = "voc� ou uma criatura",
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
			tipo_ataque = "dist�ncia 10",
			alvo = "voc� ou uma criatura",
			efeito = "Efeito: realize um teste de Atletismo (livre) com +10 e considere com impulso,\n    mesmo sem deslocamento.",
		},
------- Poderes por Encontro n�vel 3 -------------------------------------------
		esfera_de_choque = {
			nome = "Esfera de Choque",
			uso = "En",
			origem = set("arcano", "el�trico", "implemento"),
			tipo_ataque = "explos�o 2 a at� 10",
			alvo = "criaturas na �rea",
			ataque = mod.inteligencia,
			defesa = "Refl",
			dano = mod.dado_mod("2d6", "inteligencia", "Esfera de Choque"),
			efeito = "Fracasso: metade do dano.",
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
			alvo = "inimigos na rajada",
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
			efeito = "Sucesso: alvos ficam imobilizados at� o FdPT.\nFracasso: alvos ficam lentos at� o FdPT.",
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
				local dano_implemento = implemento_maior_dano (self, "aperto_gelido_de_bigby")
				local dano = soma_dano (self, "1d8+"..self.mod_int, dano_implemento, "Aperto G�lido de Bigby")
				return "Efeito: conjura uma m�o de gelo (1,5m de altura) em um quadrado desocupado\n    dentro do alcance.  A��o de movimento para deslocar a m�o at� 6 quadrados.\nSucesso: alvo fica agarrado at� escapar (defesas do mago).\n    Sustenta��o m�nima: alvo agarrado -> "..dano.." (congelante).\n    A��o padr�o para atacar outro alvo se n�o estiver agarrando nenhum."
			end,
		},
		bola_de_fogo = {
			nome = "Bola de Fogo",
			uso = "Di",
			origem = set("arcano", "flamejante", "implemento"),
			tipo_ataque = "explos�o 3 a at� 20",
			alvo = "criaturas na �rea",
			ataque = mod.inteligencia,
			defesa = "Refl",
			dano = mod.dado_mod("3d6", "inteligencia", "Bola de Fogo"),
			efeito = "Fracasso: metade do dano",
		},
		nuvem_fetida = {
			nome = "Nuvem F�tida",
			uso = "Di",
			origem = set("arcano", "implemento", "venenoso", "zona"),
			tipo_ataque = "explos�o 2 a at� 20",
			alvo = "criaturas na �rea",
			ataque = mod.inteligencia,
			defesa = "Fort",
			dano = mod.dado_mod("1d10", "inteligencia", "Nuvem F�tida"),
			efeito = function(self)
				local dano_implemento = implemento_maior_dano(self, "nuvem_fetida")
				local dano = soma_dano (self, 5+self.mod_int, dano_implemento, "Nuvem F�tida")
				return "Sucesso: gera zona de vapores nocivos que bloqueiam a vis�o at� o FdPT.\n    Criaturas que ingressam/come�am seus turnos na zona sofrem "..dano.." (venenoso).\n    Sustenta��o m�nima e a��o de movimento desloca a zona 6."
			end,
		},
------- Poderes Utilit�rios n�vel 6 --------------------------------------------
		dissipar_magia = {
			nome = "Dissipar Magia",
			uso = "En",
			origem = set("arcano", "implemento"),
			tipo_ataque = "dist�ncia 10",
			acao = "padr�o",
			alvo = "conjura��o ou zona",
			ataque = mod.inteligencia,
			defesa = "Vont",
			efeito = "Sucesso: a conjura��o ou zona � destru�da, assim como seus efeitos, incluindo\n    aqueles que necessitam de um TR para encerrar.",
		},
		invisibilidade = {
			nome = "Invisibilidade",
			uso = "Di",
			origem = set("arcano", "ilus�o"),
			tipo_ataque = "dist�ncia 5",
			acao = "padr�o",
			alvo = "uma criatura",
			efeito = "Efeito: o alvo fica invis�vel at� o FdPT (sust. padr�o; alcance) ou at� atacar.",
		},
		levitacao = {
			nome = "Levita��o",
			uso = "Di",
			origem = set("arcano"),
			tipo_ataque = "pessoal",
			acao = "movimento",
			alvo = "pessoal",
			efeito = "Efeito: voc� pode se deslocar 4 quadrados verticalmente e permanecer flutuando.\n    Enquanto estiver assim, fica inst�vel, sofrendo -2 na CA e em Reflexos.\n    Se algum efeito obrig�-lo a ficar a mais de 4 quadrados acima do solo, voc�\n    desce suavemente at� manter este n�vel, sem sofrer dano de queda.\n    Pode usar uma a��o de movimento para sustentar o efeito e ainda se deslocar\n    para cima ou para baixo sem ultrapassar o limite de 4 quadrados de altura\n    e 1 quadrado para um dos lados.  Se n�o sustentar, aterrisa suavemente.",
		},
		porta_dimensional = {
			nome = "Porta Dimensional",
			uso = "Di",
			origem = set("arcano", "teleporte"),
			tipo_ataque = "pessoal",
			acao = "movimento",
			alvo = "pessoal",
			efeito = "Efeito: voc� teleporta 10 quadrados (n�o pode levar ningu�m consigo).",
		},
		fuga_do_mago = { -- PA -----------------------------------------------
			nome = "Fuga do Mago",
			uso = "En",
			origem = set("arcano", "teleporte"),
			tipo_ataque = "pessoal",
			acao = "II",
			alvo = "pessoal",
			efeito = "Efeito: quando um inimigo atingir voc� com um At CaC., voc� se teleporta 5 para\n    um quadrado n�o adjacente a ele.",
		},
------- Poderes por Encontro n�vel 7 -----------------------------------------
		ariete_espectral = {
			nome = "Ar�ete Espectral",
			uso = "En",
			origem = set("arcano", "energ�tico", "implemento"),
			tipo_ataque = "dist�ncia 10",
			alvo = "uma criatura",
			ataque = mod.inteligencia,
			defesa = "Fort",
			dano = mod.dado_mod("2d10", "inteligencia", "Ar�ete Espectral"),
			efeito = "Sucesso: o alvo � empurrado 3 quadrados e fica derrubado.",
		},
		colera_invernal = {
			nome = "C�lera Invernal",
			uso = "En",
			origem = set("arcano", "congelante", "implemento"),
			tipo_ataque = "�rea 2 a at� 10",
			alvo = "criaturas na explos�o",
			ataque = mod.inteligencia,
			defesa = "Fort",
			dano = mod.dado_mod("2d8", "inteligencia", "C�lera Invernal"),
			efeito = function(self)
				local dano = self.mod_int
				return "Efeito: uma nevasca surge na �rea e continua at� o FdPT ou dissip�-la (m�nima),\n    concedendo oculta��o.  Quem come�ar seu turno na zona sofre "..dano.." congelante."
			end,
		},
		explosao_de_fogo = {
			nome = "Explos�o de Fogo",
			uso = "En",
			origem = set("arcano", "flamejante", "implemento"),
			tipo_ataque = "�rea 2 a at� 20",
			alvo = "criaturas na explos�o",
			ataque = mod.inteligencia,
			defesa = "Ref",
			dano = mod.dado_mod("3d6", "inteligencia", "Explos�o de Fogo"),
		},
		relampago = {
			nome = "Rel�mpago",
			uso = "En",
			origem = set("arcano", "el�trico", "implemento"),
			tipo_ataque = "dist�ncia 10",
			alvo = "uma criatura",
			ataque = mod.inteligencia,
			defesa = "Ref",
			dano = mod.dado_mod("2d6", "inteligencia", "Rel�mpago"),
			efeito = "Efeito: realize um ataque secund�rio (igual) contra duas criaturas a at� 10 do\n    alvo prim�rio, causando 1d6+INT de dano el�trico.",
		},
		abundancia_de_inimigos = {
			nome = "Abund�ncia de Inimigos",
			uso = "En",
			origem = set("arcano", "ilus�o", "implemento", "ps�quico"),
			tipo_ataque = "�rea 1 a at� 20",
			alvo = "inimigos na �rea",
			ataque = mod.inteligencia,
			defesa = "Vont",
			dano = mod.dado_mod("2d8", "inteligencia", "Abund�ncia de Inimigos"),
			efeito = "Sucesso: at� o FdPT voc� e seus aliados tratam os alvos como aliados para efeito\n    de flanqueamento.",
		},
		eco_concussivo = {
			nome = "Eco Concussivo",
			uso = "En",
			origem = set("arcano", "encanto", "implemento", "trovejante"),
			tipo_ataque = "dist�ncia 10",
			alvo = "uma criatura",
			ataque = mod.inteligencia,
			defesa = "Vont",
			dano = mod.dado_mod("2d6", "inteligencia", "Eco Concussivo"),
			efeito = "Sucesso: a primeira vez que o alvo realizar um ataque at� o FdPT, ele causa 5 de\n    dano trovejante a si pr�prio e a todos os aliados a at� 3 dele.",
		},
		limo_acido = {
			nome = "Limo �cido",
			uso = "En",
			origem = set("�cido", "arcano", "conjura��o", "implemento"),
			tipo_ataque = "dist�ncia 10",
			alvo = "uma criatura",
			ataque = mod.inteligencia,
			defesa = "Refl",
			dano = mod.dado_mod("4d8", "inteligencia", "Limo �cido"),
			efeito = function (self)
				local dano = self.mod_con
				local efeito = "Efeito: voc� conjura uma camada de limo de ocupa o espa�o do alvo.  Se ele se\n    mover, o limo anda com ele, desde que fique dentro do alcance.\n"
				if self.caracteristica_classe:lower():match"tomo" then
					return efeito.."Sucesso: quando o alvo fizer o primeiro ataque at� o FdPT, o limo explode e\n    causa "..dano.." de dano �cido a todos os inimigos a at� 2 do alvo e o\n    efeito se encerra."
				else
					return efeito.."Sucesso: at� o FdPT, toda vez que o alvo fizer um ataque, sofre "..dano.." de dano\n    �cido."
				end
			end,
		},
		dobra_no_espaco = {
			nome = "Dobra no Espa�o",
			uso = "En",
			origem = set("arcano", "implemento", "teleporte"),
			tipo_ataque = "�rea 1 a at� 10",
			alvo = "criaturas na explos�o",
			ataque = mod.inteligencia,
			defesa = "Vont",
			dano = mod.dado_mod("1d6", "inteligencia", "Dobra no Espa�o"),
			efeito = "Sucesso: alvos s�o teleportados 3 quadrados e ficam lentos at� o FdPT.",
		},
		vermes_de_minauros = {
			nome = "Vermes de Minauros",
			uso = "En",
			origem = set("�cido", "arcano", "conjura��o", "implemento"),
			tipo_ataque = "dist�ncia 10",
			alvo = "uma criatura",
			ataque = mod.inteligencia,
			defesa = "Fort",
			dano = mod.dado_mod("2d8", "inteligencia", "Vermes de Minauros"),
			efeito = "Efeito: voc� conjura um monte de vermes no espa�o do inimigo at� o FdPT.\nSucesso: se o alvo terminar seu turno em at� 2 quadrados dos vermes, sofre 10 de\n    dano �cido.",
		},
	},
}
