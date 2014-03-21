local set = require"DnD.Set"
local soma_dano = require"DnD.Soma".soma
local armas = require"DnD.Armas"
local tipos_armas = require"DnD.TiposArmas"
local mod = require"DnD.Modificadores"

return {
	nome = "Guerreiro",
	fonte_de_poder = "marcial",
	fortitude = 2,
	armaduras = set("traje", "corselete", "gibao", "cota", "brunea", "leve", "pesado"),
	armas = tipos_armas("corpo simples", "corpo militar", "distancia simples", "distancia militar"),
	implementos = {},
	ataque = function(self, arma)
		if arma.empunhadura == self.empunhadura then
			return 1
		else
			return 0
		end
	end,
	pv = 15,
	pv_nivel = 6,
	pc_dia = 9,
	pericias = set("atletismo", "intimidacao", "manha", "socorro", "tolerancia"),
	total_pericias = 3,
	talentos = function (self)
		local c = (self.caracteristica_classe or ''):lower()
		if c:match"guerreiro tempestuoso" then
			return "defesa_com_duas_armas", true
		end
	end,
	caracteristicas_classe = {
------- Caracter�sticas de Classe ----------------------------------------------
		desafio_de_combate = {
			nome = "Desafio de Combate",
			uso = "SL",
			acao = "int. imediata",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "adjacente marcado",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("1[A]", "forca", "Desafio de Combate"),
			efeito = "S� pode ser usado contra alvos marcados adjacentes que ajustem ou que ataquem\n    sem incluir o guerreiro como alvo.",
		},
		superioridade_em_combate = {
			nome = "Superioridade em Combate",
			uso = "SL",
			acao = "oportunidade",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "adj. que se move sem ajustar",
			ataque = mod.soma_mod("for", "sab"),
			defesa = "CA",
			dano = mod.dado_mod("1[A]", "forca", "Superioridade em Combate"),
		},
	},
	poderes = {
------- Poderes Sem Limite n�vel 1 ---------------------------------------------
		finta_de_atracao = {
			nome = "Finta de Atra��o",
			uso = "SL",
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dobra_21("1[A]", "forca", "Finta de Atra��o"),
			efeito = "Sucesso: ajusta 1 quadrado e o alvo � conduzido 1 quadrado para o espa�o abandonado pelo personagem.",
		},
		golpe_certeiro = {
			nome = "Golpe Certeiro",
			uso = "SL",
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = function (self)
				return self.mod_for+2
			end,
			defesa = "CA",
			dano = mod.dobra_21("[A]", "", "Golpe Certeiro"),
		},
		golpe_fulminante = {
			nome = "Golpe Fulminante",
			uso = "SL",
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dobra_21("[A]", "forca", "Golpe Fulminante"),
			efeito = function (self)
				return "Fracasso: "..(self.mod_for/2).." ou "..self.mod_for.." se estiver usando uma arma de duas m�os."
			end,
		},
		golpe_precipitado = {
			nome = "Golpe Precipitado",
			uso = "SL",
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = function (self)
				return self.mod_for+2
			end,
			defesa = "CA",
			dano = mod.dobra_21("1[A]", "forca", "Golpe Precipitado"),
			efeito = "Concede VdC ao alvo at� o CdPT.",
		},
		impeto_esmagador = {
			nome = "�mpeto Esmagador",
			uso = "SL",
			acao = "padr�o",
			origem = set("arma", "marcial", "revigorante"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dobra_21("[A]", "forca", "�mpeto Esmagador"),
			efeito = function (self)
				return "Sucesso: voc� ganha "..self.mod_con.." PVT."
			end,
		},
		mare_de_ferro = {
			nome = "Mar� de Ferro",
			uso = "SL",
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			condicao = "Deve empunhar um escudo.",
			defesa = "CA",
			dano = mod.dobra_21("[A]", "", "Mar� de Ferro"),
			efeito = "O alvo � empurrado 1 quadrado se for at� uma categoria maior ou menor.\nO personagem pode ajustar para o espa�o antes ocupado pelo inimigo.",
		},
		trespassar = {
			nome = "Trespassar",
			uso = "SL",
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dobra_21("[A]", "forca", "Trespassar"),
			efeito = function (self)
				return "Outro inimigo adjacente sofre "..self.mod_for.." de dano."
			end,
		},
------- Poderes por Encontro n�vel 1 -------------------------------------------
		ataque_de_cobertura = {
			nome = "Ataque de Cobertura",
			uso = "En",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "forca", "Ataque de Cobertura"),
			efeito = "Um aliado adjacente pode ajustar 2 quadrados.",
		},
		ataque_de_passagem = {
			nome = "Ataque de Passagem",
			uso = "En",
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "duas criaturas",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("1[A]", "forca", "Ataque de Passagem"),
			efeito = "Sucesso: pode ajustar 1 quadrado; realize um ataque secund�rio com +2 no ataque\n    contra outro inimigo.",
		},
		lamina_da_serpente_de_aco = {
			nome = "L�mina da Serpente de A�o",
			uso = "En",
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "forca", "L�mina da Serpente de A�o"),
			efeito = "O alvo fica lento e n�o pode ajustar at� o final do pr�ximo turno.",
		},
		rasteira_giratoria = {
			nome = "Rasteira Girat�ria",
			uso = "En",
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("1[A]", "forca", "Rasteira Girat�ria"),
			efeito = "Sucesso: alvo fica derrubado.",
		},
------- Poderes Di�rios n�vel 1 ------------------------------------------------
		ameacar_o_vilao = {
			nome = "Amea�ar o Vil�o",
			uso = "Di",
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "forca", "Amea�ar o Vil�o"),
			efeito = "Sucesso: recebe +2 no ataque e +4 no dano contra esse alvo at� o FdE.\nFracasso: sem dano e recebe +1 no ataque e +2 no dano contra esse alvo at� o FdE.",
		},
		golpe_brutal = {
			nome = "Golpe Brutal",
			uso = "Di",
			acao = "padr�o",
			origem = set("arma", "confi�vel", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("3[A]", "forca", "Golpe Brutal"),
		},
		golpe_de_revinda = {
			nome = "Golpe de Revinda",
			uso = "Di",
			acao = "padr�o",
			origem = set("arma", "confi�vel", "cura", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "forca", "Golpe de Revinda"),
			efeito = "Sucesso: voc� pode gastar um PC.",
		},
		tolerancia_ilimitada = {
			nome = "Toler�ncia Ilimitada",
			uso = "Di",
			acao = "m�nima",
			origem = set("cura", "marcial", "postura"),
			tipo_ataque = "utilitario",
			alvo = "pessoal",
			efeito = function(self)
				return "Adquire regenera��o "..2+self.mod_con.." quando estiver sangrando."
			end,
		},
------- Poderes Utilit�rios n�vel 2 --------------------------------------------
		criar_abertura = {
			nome = "Criar Abertura",
			uso = "En",
			acao = "m�nima",
			origem = set("marcial"),
			tipo_ataque = "corpo 1",
			alvo = "uma criatura",
			efeito = "Efeito: o alvo fica marcado at� o FdPT e pode realizar um AtB CaC contra voc�,\n    (livre) com -2 no ataque.  Um aliado adjacente ao alvo ajusta o pr�prio\n    deslocamento (livre).",
		},
		comigo_agora = {
			nome = "Comigo, Agora!",
			uso = "En",
			acao = "movimento",
			origem = set("marcial"),
			tipo_ataque = "corpo 1",
			alvo = "aliado adjacente",
			efeito = "Efeito: o alvo � conduzido 2 quadrados para um quadrado adjacente a voc�.",
		},
		fechar_a_guarda = {
			nome = "Fechar a Guarda",
			uso = "En",
			acao = "int. imediata",
			origem = set("marcial"),
			tipo_ataque = "corpo",
			efeito = "Efeito: cancele a VdC de um ataque.",
		},
		flancos_protegidos = {
			nome = "Flancos Protegidos",
			uso = "En",
			acao = "m�nima",
			origem = set("marcial"),
			tipo_ataque = "pessoal",
			efeito = "Efeito: at� o FdPT, +2 -> CA e Reflexos e n�o concede VdC a quem o estiver\n    flanquenado.",
		},
		irrefreavel = {
			nome = "Irrefre�vel",
			uso = "Di",
			acao = "m�nima",
			origem = set("cura", "marcial"),
			tipo_ataque = "pessoal",
			efeito = function(self)
				return "Efeito: recebe 2d6+"..self.mod_con.." PVT."
			end,
		},
		passar_adiante = {
			nome = "Passar Adiante",
			uso = "SL",
			acao = "movimento",
			origem = set("marcial"),
			tipo_ataque = "pessoal",
			efeito = "Efeito: escolha um inimigo adjacente e percorra seu deslocamento.\n   Desde que termine adjacente ao mesmo inimigo, o movimento n�o provoca AdO.",
		},
		postura_defensiva = {
			nome = "Postura Defensiva",
			uso = "Di",
			acao = "m�nima",
			origem = set("marcial", "postura"),
			tipo_ataque = "pessoal",
			efeito = "Efeito: enquanto adotar esta postura, voc� fica lento e +2 -> CA.  Al�m disso,\n    voc� pode ajustar 1 (RA) sempre que um inimigo fracassar em um AtB CaC\n    contra voc�.  Use uma a��o livre para sair da postura.",
		},
		reposicionamento_perspicaz = {
			nome = "Reposicionamento Perspicaz",
			uso = "En",
			acao = "rea��o imediata",
			origem = set("marcial"),
			tipo_ataque = "pessoal",
			gatilho = "Voc� � atingido por um ataque",
			efeito = function(self)
				return "Efeito: com uma RA a um ataque, voc� ajusta "..self.mod_sab.." quadrados."
			end,
		},
		tolerancia_ilimitada = {
			nome = "Toler�ncia Ilimitada",
			uso = "Di",
			acao = "m�nima",
			origem = set("cura", "marcial", "postura"),
			tipo_ataque = "pessoal",
			efeito = function(self)
				return "Efeito: adquire regenera��o "..(2+self.mod_con).." quando estiver sangrando."
			end,
		},
------- Poderes por Encontro n�vel 3 -------------------------------------------
		chuva_de_golpes = {
			nome = "Chuva de Golpes",
			uso = "En",
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("1[A]", "forca", "Chuva de Golpes"),
			efeito = function(self)
				local extra = ""
				if self.destreza >= 15 then
					extra = "  Se usar uma l�mina leve, lan�a ou mangual,\n    realize um 3o. ataque contra o mesmo alvo ou outra criatura."
				end
				return "Efeito: dois ataques."..extra
			end,
		},
		danca_de_aco = {
			nome = "Dan�a de A�o",
			uso = "En",
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "forca", "Dan�a de A�o"),
			efeito = "Efeito: se usar uma haste ou l�mina pesada, o alvo fica imobilizado at� o FdPT.",
		},
		estocada_contra_armaduras = {
			nome = "Estocada contra Armaduras",
			uso = "En",
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = function(self, ataque, poder_arma)
				local bonus = 0
				local arma = armas[poder_arma:match"%+(.*)"]
				if arma.grupo == "leve" or arma.grupo == "lanca" then
					bonus = self.mod_des
				end
				return self.mod_for + bonus
			end,
			defesa = "Ref",
			dano = function(self, dano, poder_arma)
				local bonus = 0
				local arma = armas[poder_arma:match"%+(.*)"]
				if arma.grupo == "leve" or arma.grupo == "lanca" then
					bonus = self.mod_des
				end
				return soma_dano(self, "1[A]", self.mod_for + bonus, "Estocada contra Armaduras")
			end,
		},
		golpe_do_rinoceronte = {
			nome = "Golpe do Rinoceronte",
			uso = "En",
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "forca", "Golpe do Rinoceronte"),
			efeito = "Condi��o: voc� deve realizar uma investida e usar este poder no lugar do AtB CaC\n    Se empunhar um escudo, o movimento n�o provoca AdO.",
		},
		golpe_esmagador = {
			nome = "Golpe Esmagador",
			uso = "En",
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = function(self, dano, poder_arma)
				local bonus = 0
				local arma = armas[poder_arma:match"%+(.*)"]
				if arma.grupo == "machado" or arma.grupo == "martelo" or arma.grupo == "maca" then
					bonus = self.mod_con
				end
				return soma_dano(self, "2[A]", self.mod_for + bonus, "Golpe Esmagador")
			end,
		},
		golpe_rasteiro = {
			nome = "Golpe Rasteiro",
			uso = "En",
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "explos�o cont�gua 1",
			alvo = "inimigos na �rea e linha de vis�o",
			ataque = function(self, ataque, poder_arma)
				local bonus = 0
				local arma = armas[poder_arma:match"%+.(.*)"]
				if arma.grupo == "machado" or arma.grupo == "mangual" or arma.grupo == "pesada" or arma.grupo == "picareta" then
					bonus = math.floor(self.mod_for/2)
				end
				return soma_dano(self, "1[A]", self.mod_for + bonus, "Golpe Rasteiro")
			end,
			defesa = "CA",
			dano = mod.dado_mod("1[A]", "forca", "Golpe Rasteiro"),
		},
		golpe_preciso = {
			nome = "Golpe Preciso",
			uso = "En",
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = function(self, ataque, poder_arma)
				return self.mod_for + 4
			end,
			defesa = "CA",
			dano = mod.dado_mod("1[A]", "forca", "Golpe Preciso"),
		},
------- Poderes Di�rios n�vel 5 ------------------------------------------------
		chuva_de_aco = { -- LJ1
			nome = "Chuva de A�o",
			uso = "Di",
			acao = "m�nima",
			origem = set("arma", "marcial", "postura"),
			tipo_ataque = "corpo",
			alvo = "inimigos adjacentes",
			efeito = "Efeito: enquanto puder realizar AdO, qualquer inimigo que come�ar seu turno\n    adjacente a voc�, sofre 1[A] de dano.",
		},
		golpe_vertiginoso = { -- LJ1
			nome = "Golpe Vertiginoso",
			uso = "Di",
			acao = "padr�o",
			origem = set("arma", "confi�vel", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("3[A]", "forca", "Golpe Vertiginoso"),
			efeito = "Sucesso: o alvo fica imobilizado (TR encerra).",
		},
		quebrar_carapaca = { -- LJ1
			nome = "Quebrar Carapa�a",
			uso = "Di",
			acao = "padr�o",
			origem = set("arma", "confi�vel", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "forca", "Quebrar Carapa�a"),
			efeito = "Sucesso: o alvo sofre 5 cont�nuo e -2 na CA (TR encerra ambos).",
		},
		acossar_da_retaguarda = { -- PM
			nome = "Acossar da Retaguarda",
			uso = "Di",
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			condicao = "Deve empunhar arma de alcance",
			defesa = "Fort",
			dano = mod.dado_mod("2[A]", "forca", "Acossar da Retaguarda"),
-- dano extra se for eladrin
			efeito = "Sucesso: o alvo � empurrado 1 quadrado.\nEfeito: at� o FdEn, sempre que o alvo ajustar ou realizar um ataque que n�o\n    inclua voc�, voc� pode ajustar 1 quadrado e realizar um AtB CaC contra ele\n    (II)",
		},
		assalto_agonizante = { -- PM
			nome = "Assalto Agonizante",
			uso = "Di",
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "forca", "Assalto Agonizante"),
-- dano extra se usar mangual
			efeito = "Sucesso: o alvo fica pasmo e imobilizado (TR encerra ambos).\nFracasso: metade do dano somente."
		},
		assalto_molestador = { -- PM
			nome = "Assalto Molestador",
			uso = "Di",
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "forca", "Assalto Molestador"),
-- dano extra se usar mangual
			efeito = "Efeito: at� o FdEn, sempre que um aliado atingir o alvo com um At CaC,\n    voc� pode realizar um AtB CaC com VdC contra o alvo (livre; 1x rodada).",
		},
		corte_sutil = { -- PM
			nome = "Corte Sutil",
			uso = "Di",
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			condicao = "Deve empunhar l�mina leve",
			defesa = "CA",
			dano = function (self, dano, arma)
				if arma.grupo ~= "leve" then
					return 0
				end
				return 10 + self.mod_des
			end,
			efeito = function (self)
				return "Efeito: ajuste 1 quadrado antes E depois do ataque.\nSucesso: alvo fica lento e o dano � cont�nuo (TR encerra ambos).\nFracasso: "..self.mod_des.." de dano cont�nuo (TR encerra)."
			end,
		},
		investida_cometa = { -- PM
			nome = "Investida Cometa",
			uso = "Di",
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			condicao = "Treinado em Atletismo",
			defesa = "CA",
			dano = mod.dado_mod("3[A]", "for+con", "Investida Cometa"),
			efeito = "Fracasso: metade do dano.",
		},
		pancada_restritiva = { -- PM
			nome = "Pancada Restritiva",
			uso = "Di",
			acao = "padr�o",
			origem = set("arma", "marcial", "revigorante"),
			tipo_ataque = "corpo 1",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("1[A]", "forca", "Pancada Restritiva"),
			efeito = function (self)
				return "Sucesso: o alvo fica imobilizado enquanto estiver adjacente a voc�.\n    Se empunhar uma ma�a, machado ou martelo, causa +"..self.mod_con..".\nFracasso: metade do dano e fica imobilizado at� o FdPT."
			end,
		},
------- Poderes Utilit�rios n�vel 6 --------------------------------------------
		acerto_de_contas = { -- PM
			nome = "Acerto de Contas",
			uso = "Di",
			acao = "RI",
			origem = set("marcial"),
			tipo_ataque = "pessoal",
			gatilho = "Voc� � atingido por um ataque",
			efeito = "Efeito: at� o FdEn, voc� recebe +2 nos ataques contra este inimigo.",
		},
		aproximacao_agil = { -- PM
			nome = "Aproxima��o �gil",
			uso = "En",
			acao = "movimento",
			origem = set("marcial"),
			tipo_ataque = "pessoal",
			efeito = "Efeito: ajusta 2 quadrados, desde que termine adjacente a um inimigo.\n    Se n�o estiver com uma armadura pesada, o ajuste � de 3 quadrados.",
		},
		estabilidade_rochosa = { -- PM
			nome = "Estabilidade Rochosa",
			uso = "Di",
			acao = "m�nima",
			origem = set("marcial", "postura"),
			tipo_ataque = "pessoal",
			efeito = "Efeito: enquanto adotar esta postura, voc� n�o pode ser derrubado\n    e o movimento for�ado imposto a voc� pode ser reduzido em 1 quadrado.",
		},
		foco_poderoso = { -- PM
			nome = "Foco Poderoso",
			uso = "En",
			acao = "m�nima",
			origem = set("marcial"),
			tipo_ataque = "pessoal",
			efeito = function (self)
				return "Efeito: at� o FdPT, receba +"..self.mod_sab.." nos testes de Atletismo e For�a."
			end,
		},
		protetor_vigilante = { -- PM
			nome = "Protetor Vigilante",
			uso = "Di",
			acao = "m�nima",
			origem = set("marcial", "postura"),
			tipo_ataque = "pessoal",
			condicao = "Deve empunhar um escudo",
			efeito = function (self)
				local bonus = 2
				if self.raca == "draconato" then
					bonus = 3
				end
				return "Efeito: enquanto adotar esta postura, sofre -1 na CA e em Reflexos, mas seus\n    aliados adjacentes recebem +"..bonus.." nessas duas defesas."
			end,
		},
		indestrutivel = { -- LJ1
			nome = "Indestrut�vel",
			uso = "En",
			acao = "RI",
			origem = set("marcial"),
			tipo_ataque = "pessoal",
			gatilho = "Voc� � atingido por um ataque",
			efeito = function (self)
				return "Efeito: reduza o dano deste ataque em "..(5+self.mod_con)
			end,
		},
		prontidao_de_batalha = { -- LJ1
			nome = "Prontid�o de Batalha",
			uso = "Di",
			acao = "-",
			origem = set("marcial"),
			tipo_ataque = "pessoal",
			efeito = "Efeito: depois de determinar a iniciativa, voc� pode escolher aumentar em 10 o\n    resultado da sua iniciativa.",
		},
		treinamento_defensivo = { -- LJ1
			nome = "Treinamento Defensivo",
			uso = "Di",
			acao = "m�nima",
			origem = set("marcial", "postura"),
			tipo_ataque = "pessoal",
			efeito = "Efeito: enquanto adotar esta postura, receba +2 em Fortitude, Reflexos e Vontade",
		},
------- Poderes por Encontro n�vel 7 -----------------------------------------
		colera_do_grifo = {
			nome = "C�lera do Grifo",
			uso = "En",
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "forca", "C�lera do Grifo"),
			efeito = function (self)
				return "Sucesso: o alvo sofre -2 na CA at� o FdPT.",
			end,
		},
		golpe_temerario = {
			nome = "Golpe Temer�rio",
			uso = "En",
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = function(self) return self.mod_for - 2 end,
			defesa = "CA",
			dano = mod.dado_mod("3[A]", "forca", "Golpe Temer�rio"),
		},
		impeto_subito = {
			nome = "�mpeto S�bito",
			uso = "En",
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "forca", "�mpeto S�bito"),
			efeito = function(self)
				return "Efeito: voc� se desloca "..math.max(self.mod_des, 1).." quadrados."
			end,
		},
		reduto_de_ferro = {
			nome = "Reduto de Ferro",
			uso = "En",
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "forca", "Reduto de Ferro"),
			efeito = function(self)
				local bonus = 1
				for nome, item in pairs(self.itens) do
					if item.escudo then
						bonus = 2
						break
					end
				end
				return "Efeito: voc� recebe +"..bonus.." na CA at� o FdPT."
			end,
		},
		vem_buscar = {
			nome = "Vem Buscar",
			uso = "En",
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "explos�o cont�gua 3",
			alvo = "criaturas na explos�o",
			ataque = mod.forca
			defesa = "Vont",
			dano = mod.dado_mod("1[A]", "forca", "Vem Buscar"),
			efeito = function(self)
				return "Sucesso: alvos s�o puxados 2 quadrados at� um quadrado adjacente (se n�o puder,\n    n�o se move) e ent�o sofrem o dano."
			end,
		},
		bloqueio_selvagem = {
			nome = "Bloqueio Selvagem",
			uso = "En",
			acao = "II",
			origem = set("arma", "marcial", "revigorante"),
			tipo_ataque = "corpo",
			alvo = "quem ativou o gatilho",
			ataque = mod.forca
			defesa = "CA",
			dano = mod.dado_mod("0", "forca", "Bloqueio Selvagem"),
			efeito = function(self)
				local dano = self.mod_con
				return "Gatilho: um aliado � atingido por um AtCaC.\nSucesso: o aliado sofre metade do dano.\n    Se estiver usando uma ma�a, machado ou martelo, causa +"..dano.." de dano."
			end,
		},
		nao_tao_rapido = {
			nome = "N�o T�o R�pido",
			uso = "En",
			acao = "II",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "quem ativou o gatilho",
			ataque = mod.forca
			defesa = "CA",
			dano = mod.dado_mod("1[A]", "forca", "N�o T�o R�pido"),
			efeito = "Gatilho: um inimigo adjacente se afasta de voc�.\nSucesso: at� o FdPT o alvo\n    fica lento (ou imobilizado, se voc� usar um mangual ou picareta)."
		},
		no_chao = {
			nome = "No Ch�o!",
			uso = "En",
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "forca", "No Ch�o!"),
			efeito = function(self)
				return "Sucesso: se o alvo estiver derrubado, sofre +"..self.mod_des.." de dano e n�o pode\n    se levantar at� o FdPT."
			end,
		},
		rajada_restritiva = {
			nome = "Rajada Restritiva",
			uso = "En",
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca
			defesa = "CA",
			dano = mod.dado_mod("1[A]", "forca", "Rajada Restritiva"),
			efeito = function(self)
				return "Condi��o: empunhar duas armas de combate CaC.\nEfeito: um ataque com cada arma.\nSucesso: alvo fica lento at� o FdPT. Se acertar os dois ataques, causa +"..self.mod_des
			end,
		},
		tombar = {
			nome = "Tombar",
			uso = "En",
			acao = "livre",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "quem ativou o gatilho",
			ataque = mod.forca
			defesa = "Ref",
			dano = mod.dado_mod("1[A]", "forca", "Tombar"),
			efeito = function(self)
				return "Gatilho: voc� atinge um inimigo com um AtB CaC.\nSucesso: alvo fica lento at� o FdPT. Se usar lan�a ou arma de haste, fica\n    derrubado ao inv�s de lento."
			end,
		},
		tormento_duplo = {
			nome = "Tormento Duplo",
			uso = "En",
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "duas criaturas",
			ataque = mod.forca
			defesa = "CA",
			dano = mod.dado_mod("1[A]", "forca", "Tormento Duplo"),
			efeito = function(self)
				return "Condi��o: empunhar duas armas de combate CaC.\nEfeito: um ataque por alvo.\nSucesso: alvo � empurrado "..(1+self.mod_des).." quadrados. Se tiver VdC, causa +"..self.mod_des
			end,
		},
	},
}
