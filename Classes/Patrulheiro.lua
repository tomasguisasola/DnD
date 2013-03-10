local set = require"DnD.Set"
local soma_dano = require"DnD.Soma".soma
local armas = require"DnD.Armas"
local tipos_armas = require"DnD.TiposArmas"
local mod = require"DnD.Modificadores"

return {
	nome = "Patrulheiro",
	fonte_de_poder = "marcial",
	fortitude = 1,
	reflexos = 1,
	armaduras = set("traje", "corselete", "gibao"),
	armas = tipos_armas("corpo simples", "corpo militar", "distancia simples", "distancia militar"),
	implementos = {},
	dano_adicional = function(self)
		if self.nivel > 20 then
			return "+3d6"
		elseif self.nivel > 10 then
			return "+2d6"
		else
			return "+1d6"
		end
	end,
	nome_adicional = "Presa",
	pv = 12,
	pv_nivel = 5,
	pc_dia = 6,
	pericias = {
		exploracao = true,
		natureza = true,
		acrobacia = true,
		atletismo = true,
		furtividade = true,
		percepcao = true,
		socorro = true,
		tolerancia = true,
	},
	talentos = function (self)
		if self.caracteristica_classe:match"arqueiro" then
			return "mobilidade_defensiva", true
		elseif self.caracteristica_classe:match"duas.armas" then
			return "vitalidade", true
		end
	end,
	total_pericias = 5,
	caracteristicas_classe = {
------- Caracter�sticas de Classe ----------------------------------------------
		tiro_primoroso = {
			nome = "Tiro Primoroso",
			uso = "SL",
			acao = "nenhuma",
			origem = set("arma", "marcial"),
			tipo_ataque = "dist�ncia",
			alvo = "uma criatura",
			ataque = 1,
			defesa = nil,
			efeito = "Efeito: se voc� for o aliado mais pr�ximo do alvo, +1 no ataque � dist�ncia contra ele."
		},
	},
	poderes = {
------- Poderes Sem Limite n�vel 1 ---------------------------------------------
		ataque_cauteloso = {
			nome = "Ataque Cauteloso",
			uso = "SL",
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo/distancia",
			alvo = "uma criatura",
			ataque = function (self, ataque, poder_arma)
				local poder, nome_arma = poder_arma:match"^([^+]*)%+(.*)$"
				local arma = armas[nome_arma]
				if arma.tipo:match"dist" then
					return soma_dano(self, self.mod_des+2, ataque, poder_arma)
				else
					return soma_dano(self, self.mod_for+2, ataque, poder_arma)
				end
			end,
			defesa = "CA",
			dano = mod.dobra_21("[A]", "forca/destreza", "Ataque Cauteloso"),
		},
		bater_e_correr = {
			nome = "Bater e Correr",
			uso = "SL",
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dobra_21("[A]", "forca", "Bater e Correr"),
			efeito = "Efeito: depois do ataque, pode se mover sem provocar AdO no primeiro quadrado.",
		},
		cercar_e_golpear = {
			nome = "Cercar e Golpear",
			uso = "SL",
			acao = "padr�o",
			origem = set("animal", "arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dobra_21("[A]", "forca", "Cercar e Golpear"),
		},
		golpes_gemeos = {
			nome = "Golpes G�meos",
			uso = "SL",
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo/distancia",
			alvo = "uma ou duas criaturas",
			ataque = mod.forca_ou_destreza,
			condicao = "Deve empunhar duas armas corpo-a-corpo ou uma � dist�ncia.",
			defesa = "CA",
			dano = mod.dobra_21("[A]", "", "Golpes G�meos"),
			efeito = "Efeito: dois ataques.",
		},
		golpe_lepido = {
			nome = "Golpe L�pido",
			uso = "SL",
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "distancia",
			alvo = "uma criatura",
			ataque = mod.destreza,
			defesa = "CA",
			dano = mod.dobra_21("[A]", "destreza", "Golpe L�pido"),
			efeito = "Efeito: ajusta um quadrado antes ou depois do ataque.",
		},
------- Poderes por Encontro n�vel 1 -------------------------------------------
		aproximar_se_da_presa = {
			nome = "Aproximar-se da Presa",
			uso = "En",
			acao = "padr�o",
			origem = set("animal", "arma", "marcial"),
			tipo_ataque = "animal 1",
			alvo = "a presa",
			efeito = function (self)
				return "Efeito: voc� e seu animal ajustam 2 quadrados antes do ataque.\n    Se o animal for uma aranha, felino ou lobo, o ataque causa +"..self.mod_sab
			end,
		},
		astucia_da_raposa = {
			nome = "Ast�cia da Raposa",
			uso = "En",
			acao = "rea��o imediata",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo/dist�ncia",
			gatilho = "um inimigo realiza um ataque CaC contra voc�",
			alvo = "uma criatura",
			efeito = function(self)
				return "Efeito: ajusta 1 quadrado e realiza um ataque b�sico contra o inimigo com +"..self.mod_sab.." no ataque."
			end,
		},
		golpe_com_a_mao_inabil = {
			nome = "Golpe com a M�o In�bil",
			uso = "En",
			acao = "m�nima",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			condicao = "voc� deve empunhar duas armas de combate CaC",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("1[A]", "forca", "Golpe com a M�o In�bil"),
			efeito = "Efeito: use o ataque e o dano da arma da m�o in�bil.",
		},
		golpe_das_duas_presas = {
			nome = "Golpe das Duas Presas",
			uso = "En",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo/distancia",
			alvo = "uma criatura",
			ataque = mod.forca_ou_destreza,
			defesa = "CA",
			dano = mod.dado_mod("1[A]", "forca/destreza", "Golpe das Duas Presas"),
			efeito = function (self)
				return "Efeito: dois ataques.  Se acertar os dois ataques, causa +"..self.mod_sab
			end,
		},
		golpe_do_carcaju_atroz = {
			nome = "Golpe do Carcaj� Atroz",
			uso = "En",
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo", --"explos�o cont�gua 1",
			alvo = "os inimigos adjacentes e na linha de vis�o",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("1[A]", "forca", "Golpe do Carcaj� Atroz"),
		},
		golpe_do_parceiro_de_caca = {
			nome = "Golpe do Parceiro de Ca�a",
			uso = "En",
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "forca", "Golpe do Parceiro de Ca�a"),
			efeito = function (self)
				return "Sucesso: se estiver flanqueando, causa +"..self.mod_sab
			end,
		},
		golpe_evasivo = { -- LJ1
			nome = "Golpe Evasivo",
			uso = "En",
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo/distancia",
			alvo = "uma criatura",
			ataque = mod.forca_ou_destreza,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "forca/destreza", "Golpe Evasivo"),
			efeito = function(self)
				return "Efeito: voc� pode ajustar "..(1+self.mod_sab).." quadrados antes ou depois do ataque."
			end,
		},
		golpe_sincronizado = { -- PM
			nome = "Golpe Sincronizado",
			uso = "En",
			acao = "padr�o",
			origem = set("animal", "arma", "marcial"),
			tipo_ataque = "animal 1",
			alvo = "uma criatura",
			--ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("1[A]", "destreza", "Golpe Sincronizado"),
			efeito = function(self)
				return "Efeito: ataque do animal X CA -> 1[C]\n        "..self.mod_for.." X Refl -> 1[A]+"..self.mod_for.."\n    Se o animal for uma ave de rapina, javali, lagarto, serpente ou urso, o at.\n    secund�rio causa +"..self.mod_sab
			end,
		},
		salva_veloz = { -- PM
			nome = "Salva Veloz",
			uso = "En",
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "dist�ncia",
			alvo = "uma ou duas criaturas",
			ataque = mod.destreza,
			defesa = "CA",
			dano = mod.dado_mod("1[A]", "destreza", "Salva Veloz"),
			efeito = function(self)
				return "Efeito: se atacar apenas uma criatura, +2 no dano;\n        se atacar duas criaturas, -2 nos ataques.\n======> N�O ESCOLHA ESTE PODER; troque pelo Golpe das Duas Presas!"
			end,
		},
		tiro_singular = { -- PM
			nome = "Tiro Singular",
			uso = "En",
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "dist�ncia",
			alvo = "uma ou duas criaturas",
			ataque = mod.destreza,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "destreza", "Tiro Singular"),
			efeito = function(self)
				return "Sucesso: se nenhuma criatura estiver adjacente ao alvo, causa +"..self.mod_sab
			end,
		},
------- Poderes Di�rios n�vel 1 ------------------------------------------------
		armadilha_do_cacador_de_ursos = {
			nome = "Armadilha do Ca�ador de Ursos",
			uso = "Di",
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo/dist�ncia",
			alvo = "uma criatura",
			ataque = mod.forca_ou_destreza,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "forca/destreza", "Armadilha do Ca�ador de Ursos"),
			efeito = "Sucesso: alvo fica lento e sofre 5 de dano cont�nuo (TR encerra ambos).\nFracasso: metade do dano e lento at� o FdPT.",
		},
		assalto_do_javali = {
			nome = "Assalto do Javali",
			uso = "Di",
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo/dist�ncia",
			alvo = "uma criatura",
			ataque = mod.forca_ou_destreza,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "forca/destreza", "Assalto do Javali"),
			efeito = function (self)
				return "Sucesso: voc� recebe "..self.mod_sab.." PVT.\nFracasso: metade do dano.\nEfeito: at� que o alvo caia a 0 PV, voc� recebe "..self.mod_sab.." PVT sempre que acert�-lo."
			end,
		},
		fim_da_cacada = {
			nome = "Fim da Ca�ada",
			uso = "Di",
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo/dist�ncia",
			alvo = "uma criatura sangrando",
			ataque = mod.forca_ou_destreza,
			defesa = "CA",
			dano = mod.dado_mod("3[A]", "forca/destreza", "Fim da Ca�ada"),
			efeito = "Fracasso: metade do dano.\nEfeito: se o alvo for a presa, 19 ou 20 no dado resultam em um sucesso decisivo.",
		},
		golpe_subito = {
			nome = "Golpe S�bito",
			uso = "Di",
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("1[A]", "forca", "Golpe S�bito"),
			efeito = "Efeito: ajusta 1 quadrado e realiza um ataque secund�rio.\n    For�a X CA -> 2[A]+For�a e fica enfraquecido at� o FdPT.",
		},
		mandibulas_do_lobo = {
			nome = "Mand�bulas do Lobo",
			uso = "Di",
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "forca", "Mand�bulas do Lobo"),
			efeito = "Efeito: dois ataques.",
		},
		repartir_disparo = {
			nome = "Repartir Disparo",
			uso = "Di",
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "distancia",
			alvo = "duas criaturas, 3 quadrados entre si",
			ataque = mod.destreza,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "destreza", "Repartir Disparo"),
			efeito = "Efeito: jogue dois d20 e fique com o melhor contra os dois alvos.",
		},
------- Poderes Utilit�rios n�vel 2 --------------------------------------------
		bloqueio_desequilibrante = {
			nome = "Bloqueio Desequilibrante",
			uso = "En",
			acao = "rea��o imediata",
			origem = set("marcial"),
			tipo_ataque = "corpo 1",
			gatilho = "Inimigo fracassa em um ataque CaC contra voc�",
			alvo = "um inimigo",
			efeito = "Efeito: alvo � conduzido 3 quadrados para um quadrado adjacente a voc�,\n    que ganha VdC contra ele at� o FdPT.",
		},
		conselho_crucial = {
			nome = "Conselho Crucial",
			uso = "En",
			acao = "Rea��o Imediata",
			origem = set("marcial"),
			tipo_ataque = "dist�ncia 5",
			gatilho = "Aliado no alcance (tem que ver e ouv�-lo) realiza um teste de per�cia treinada pelo patrulheiro",
			alvo = "aliado",
			efeito = function (self)
				return "Efeito: aliado refaz o teste com +"..self.mod_sab.." de b�nus de poder."
			end,
		},
		servir_se_do_solo = {
			nome = "Servir-se do Solo",
			uso = "En",
			acao = "Rea��o Imediata",
			origem = set("marcial"),
			tipo_ataque = "utilitario",
			alvo = "pessoal",
			efeito = function(self)
				return "Efeito: quando um inimigo lhe causar dano, pode ajustar at� "..self.mod_sab.." quadrados\n    e recebe +2 em todas as defesas at� o FdPT."
			end,
		},
------- Poderes por Encontro n�vel 3 -------------------------------------------
		cortar_e_correr = {
			nome = "Cortar e Correr",
			uso = "En",
			acao = "padrao",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo/distancia",
			alvo = "uma ou duas criaturas",
			ataque = mod.forca_ou_destreza,
			defesa = "CA",
			dano = mod.dado_mod("1[A]", "forca/destreza", "Cortar e Correr"),
			efeito = function(self)
				return "Efeito: dois ataques; depois de qualquer um deles, voc� pode ajustar "..(1+self.mod_sab)
			end,
		},
		golpe_de_distracao = {
			nome = "Golpe de Distra��o",
			uso = "En",
			acao = "interrup��o imediata",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo/distancia",
			gatilho = "Voc� ou aliado � atacado",
			alvo = "o atacante",
			ataque = mod.forca_ou_destreza,
			defesa = "CA",
			dano = mod.dado_mod("1[A]", "forca/destreza", "Golpe de Distra��o"),
			efeito = function(self)
				return "Sucesso: o alvo sofre -"..(3+self.mod_sab).." neste ataque."
			end,
		},
		golpe_da_vespa_das_sombras = {
			nome = "Golpe da Vespa das Sombras",
			uso = "En",
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo/distancia",
			alvo = "a Presa",
			ataque = mod.forca_ou_destreza,
			defesa = "Refl",
			dano = mod.dado_mod("2[A]", "forca/destreza", "Golpe da Vespa das Sombras"),
		},
		golpe_do_javali_presa_do_trovao = {
			nome = "Golpe do Javali Presa do Trov�o",
			uso = "En",
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo/distancia",
			alvo = "uma ou duas criaturas",
			ataque = mod.forca_ou_destreza,
			defesa = "CA",
			dano = mod.dado_mod("1[A]", "forca/destreza", "Golpe do Javali Presa do Trov�o"),
			efeito = function (self)
				return "Efeito: Dois ataques.\nSucesso: a cada sucesso, o alvo � empurrado 1 quadrado.  Se os dois golpes\n    atingirem o mesmo alvo, ele � empurrado "..(1+self.mod_sab).." quadrados."
			end,
		},
------- Poderes Di�rios n�vel 5 ------------------------------------------------
		assalto_adaptavel = { -- PM
			nome = "Assalto Adapt�vel",
			uso = "Di",
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo/distancia",
			alvo = "uma ou duas criaturas",
			ataque = mod.forca_ou_destreza,
			defesa = "CA",
			dano = mod.dado_mod("1[A]", "destreza", "Assalto Adapt�vel"),
			efeito = "Sucesso: se obtiver sucesso nos dois ataques contra o mesmo alvo, ele sofre\n    5 cont�nuo (TR) ou fica pasmo (TR).\nFracasso: metade do dano por ataque.",
		},
		postura_da_cobra_cuspideira = { -- PM
			nome = "Postura da Cobra Cuspideira",
			uso = "Di",
			acao = "m�nima",
			origem = set("arma", "marcial", "postura"),
			tipo_ataque = "distancia",
			alvo = "distancia 5",
			ataque = mod.destreza,
			defesa = "CA",
			dano = mod.dado_mod("1[A]", "destreza", "Postura da Cobra Cuspideira"),
			efeito = "Efeito: enquanto adotar esta postura, voc� pode realizar um AtBaD (RA) contra\n    qualquer inimigo a at� 5 que se aproximar.",
		},
		tiro_corpo_a_corpo = { -- PM
			nome = "Tiro Corpo a Corpo",
			uso = "Di",
			acao = "RA",
			origem = set("arma", "marcial"),
			tipo_ataque = "distancia",
			alvo = "uma criatura adjacente",
			ataque = mod.destreza,
			defesa = "CA",
			dano = mod.dado_mod("3[A]", "destreza", "Tiro Corpo a Corpo"),
			efeito = "Fracasso: metade do dano.\nEfeito: n�o provoca AdO do alvo.",
		},
		tiro_estilhacador = { -- LJ1
			nome = "Tiro Estilha�ador",
			uso = "Di",
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "distancia",
			alvo = "uma criatura",
			ataque = mod.destreza,
			defesa = "CA",
			dano = mod.dado_mod("3[A]", "destreza", "Tiro Estilha�ador"),
			efeito = "Sucesso: o alvo sofre -2 nos ataques at� o FdEn.\nFracasso: metade do dano e sofre -1 nos ataques at� o FdEn.",
		},
		tiro_excruciante = { -- LJ1
			nome = "Tiro Excruciante",
			uso = "Di",
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "distancia",
			alvo = "uma criatura",
			ataque = mod.destreza,
			defesa = "CA",
			dano = mod.dado_mod("3[A]", "destreza", "Tiro Excruciante"),
			efeito = "Sucesso: o alvo fica enfraquecido (TR encerra).\nFracasso: metade do dano (n�o fica enfraquecido).",
		},
------- Poderes Utilit�rios n�vel 6 --------------------------------------------
		ajudar_companheiro = { -- LJ1
			nome = "Ajudar Companheiro",
			uso = "Di",
			acao = "m�nima",
			origem = set("marcial"),
			alvo = "um aliado a at� 10",
			efeito = function (self)
				return "Efeito: um aliado a at� 10 recebe +"..self.mod_sab.." de b�nus nos testes de uma per�cia\n    treinada por voc� at� o FdEn."
			end
		},
		deslocar_pela_turba = { -- LJ1
			nome = "Deslocar pela Turba",
			uso = "En",
			acao = "int. imediata",
			origem = set("marcial"),
			alvo = "pessoal",
			efeito = function (self)
				return "Efeito: quando um inimigo ficar adjacente, voc� pode ajustar "..self.mod_sab
			end
		},
	},
}
