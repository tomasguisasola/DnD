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
------- Características de Classe ----------------------------------------------
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
			efeito = "Só pode ser usado contra alvos marcados adjacentes que ajustem ou que ataquem\n    sem incluir o guerreiro como alvo.",
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
------- Poderes Sem Limite nível 1 ---------------------------------------------
		finta_de_atracao = {
			nome = "Finta de Atração",
			uso = "SL",
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dobra_21("1[A]", "forca", "Finta de Atração"),
			efeito = "Sucesso: ajusta 1 quadrado e o alvo é conduzido 1 quadrado para o espaço abandonado pelo personagem.",
		},
		golpe_certeiro = {
			nome = "Golpe Certeiro",
			uso = "SL",
			acao = "padrão",
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
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dobra_21("[A]", "forca", "Golpe Fulminante"),
			efeito = function (self)
				return "Fracasso: "..(self.mod_for/2).." ou "..self.mod_for.." se estiver usando uma arma de duas mãos."
			end,
		},
		golpe_precipitado = {
			nome = "Golpe Precipitado",
			uso = "SL",
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = function (self)
				return self.mod_for+2
			end,
			defesa = "CA",
			dano = mod.dobra_21("1[A]", "forca", "Golpe Precipitado"),
			efeito = "Concede VdC ao alvo até o CdPT.",
		},
		impeto_esmagador = {
			nome = "Ímpeto Esmagador",
			uso = "SL",
			acao = "padrão",
			origem = set("arma", "marcial", "revigorante"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dobra_21("[A]", "forca", "Ímpeto Esmagador"),
			efeito = function (self)
				return "Sucesso: você ganha "..self.mod_con.." PVT."
			end,
		},
		mare_de_ferro = {
			nome = "Maré de Ferro",
			uso = "SL",
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			condicao = "Deve empunhar um escudo.",
			defesa = "CA",
			dano = mod.dobra_21("[A]", "", "Maré de Ferro"),
			efeito = "O alvo é empurrado 1 quadrado se for até uma categoria maior ou menor.\nO personagem pode ajustar para o espaço antes ocupado pelo inimigo.",
		},
		trespassar = {
			nome = "Trespassar",
			uso = "SL",
			acao = "padrão",
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
------- Poderes por Encontro nível 1 -------------------------------------------
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
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "duas criaturas",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("1[A]", "forca", "Ataque de Passagem"),
			efeito = "Sucesso: pode ajustar 1 quadrado; realize um ataque secundário com +2 no ataque\n    contra outro inimigo.",
		},
		lamina_da_serpente_de_aco = {
			nome = "Lâmina da Serpente de Aço",
			uso = "En",
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "forca", "Lâmina da Serpente de Aço"),
			efeito = "O alvo fica lento e não pode ajustar até o final do próximo turno.",
		},
		rasteira_giratoria = {
			nome = "Rasteira Giratória",
			uso = "En",
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("1[A]", "forca", "Rasteira Giratória"),
			efeito = "Sucesso: alvo fica derrubado.",
		},
------- Poderes Diários nível 1 ------------------------------------------------
		ameacar_o_vilao = {
			nome = "Ameaçar o Vilão",
			uso = "Di",
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "forca", "Ameaçar o Vilão"),
			efeito = "Sucesso: recebe +2 no ataque e +4 no dano contra esse alvo até o FdE.\nFracasso: sem dano e recebe +1 no ataque e +2 no dano contra esse alvo até o FdE.",
		},
		golpe_brutal = {
			nome = "Golpe Brutal",
			uso = "Di",
			acao = "padrão",
			origem = set("arma", "confiável", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("3[A]", "forca", "Golpe Brutal"),
		},
		golpe_de_revinda = {
			nome = "Golpe de Revinda",
			uso = "Di",
			acao = "padrão",
			origem = set("arma", "confiável", "cura", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "forca", "Golpe de Revinda"),
			efeito = "Sucesso: você pode gastar um PC.",
		},
		tolerancia_ilimitada = {
			nome = "Tolerância Ilimitada",
			uso = "Di",
			acao = "mínima",
			origem = set("cura", "marcial", "postura"),
			tipo_ataque = "utilitario",
			alvo = "pessoal",
			efeito = function(self)
				return "Adquire regeneração "..2+self.mod_con.." quando estiver sangrando."
			end,
		},
------- Poderes Utilitários nível 2 --------------------------------------------
		criar_abertura = {
			nome = "Criar Abertura",
			uso = "En",
			acao = "mínima",
			origem = set("marcial"),
			tipo_ataque = "corpo 1",
			alvo = "uma criatura",
			efeito = "Efeito: o alvo fica marcado até o FdPT e pode realizar um AtB CaC contra você,\n    (livre) com -2 no ataque.  Um aliado adjacente ao alvo ajusta o próprio\n    deslocamento (livre).",
		},
		comigo_agora = {
			nome = "Comigo, Agora!",
			uso = "En",
			acao = "movimento",
			origem = set("marcial"),
			tipo_ataque = "corpo 1",
			alvo = "aliado adjacente",
			efeito = "Efeito: o alvo é conduzido 2 quadrados para um quadrado adjacente a você.",
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
			acao = "mínima",
			origem = set("marcial"),
			tipo_ataque = "pessoal",
			efeito = "Efeito: até o FdPT, +2 -> CA e Reflexos e não concede VdC a quem o estiver\n    flanquenado.",
		},
		irrefreavel = {
			nome = "Irrefreável",
			uso = "Di",
			acao = "mínima",
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
			efeito = "Efeito: escolha um inimigo adjacente e percorra seu deslocamento.\n   Desde que termine adjacente ao mesmo inimigo, o movimento não provoca AdO.",
		},
		postura_defensiva = {
			nome = "Postura Defensiva",
			uso = "Di",
			acao = "mínima",
			origem = set("marcial", "postura"),
			tipo_ataque = "pessoal",
			efeito = "Efeito: enquanto adotar esta postura, você fica lento e +2 -> CA.  Além disso,\n    você pode ajustar 1 (RA) sempre que um inimigo fracassar em um AtB CaC\n    contra você.  Use uma ação livre para sair da postura.",
		},
		reposicionamento_perspicaz = {
			nome = "Reposicionamento Perspicaz",
			uso = "En",
			acao = "reação imediata",
			origem = set("marcial"),
			tipo_ataque = "pessoal",
			gatilho = "Você é atingido por um ataque",
			efeito = function(self)
				return "Efeito: com uma RA a um ataque, você ajusta "..self.mod_sab.." quadrados."
			end,
		},
		tolerancia_ilimitada = {
			nome = "Tolerância Ilimitada",
			uso = "Di",
			acao = "mínima",
			origem = set("cura", "marcial", "postura"),
			tipo_ataque = "pessoal",
			efeito = function(self)
				return "Efeito: adquire regeneração "..(2+self.mod_con).." quando estiver sangrando."
			end,
		},
------- Poderes por Encontro nível 3 -------------------------------------------
		chuva_de_golpes = {
			nome = "Chuva de Golpes",
			uso = "En",
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("1[A]", "forca", "Chuva de Golpes"),
			efeito = function(self)
				local extra = ""
				if self.destreza >= 15 then
					extra = "  Se usar uma lâmina leve, lança ou mangual,\n    realize um 3o. ataque contra o mesmo alvo ou outra criatura."
				end
				return "Efeito: dois ataques."..extra
			end,
		},
		danca_de_aco = {
			nome = "Dança de Aço",
			uso = "En",
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "forca", "Dança de Aço"),
			efeito = "Efeito: se usar uma haste ou lâmina pesada, o alvo fica imobilizado até o FdPT.",
		},
		estocada_contra_armaduras = {
			nome = "Estocada contra Armaduras",
			uso = "En",
			acao = "padrão",
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
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "forca", "Golpe do Rinoceronte"),
			efeito = "Condição: você deve realizar uma investida e usar este poder no lugar do AtB CaC\n    Se empunhar um escudo, o movimento não provoca AdO.",
		},
		golpe_esmagador = {
			nome = "Golpe Esmagador",
			uso = "En",
			acao = "padrão",
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
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "explosão contígua 1",
			alvo = "inimigos na área e linha de visão",
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
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = function(self, ataque, poder_arma)
				return self.mod_for + 4
			end,
			defesa = "CA",
			dano = mod.dado_mod("1[A]", "forca", "Golpe Preciso"),
		},
------- Poderes Diários nível 5 ------------------------------------------------
		chuva_de_aco = { -- LJ1
			nome = "Chuva de Aço",
			uso = "Di",
			acao = "mínima",
			origem = set("arma", "marcial", "postura"),
			tipo_ataque = "corpo",
			alvo = "inimigos adjacentes",
			efeito = "Efeito: enquanto puder realizar AdO, qualquer inimigo que começar seu turno\n    adjacente a você, sofre 1[A] de dano.",
		},
		golpe_vertiginoso = { -- LJ1
			nome = "Golpe Vertiginoso",
			uso = "Di",
			acao = "padrão",
			origem = set("arma", "confiável", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("3[A]", "forca", "Golpe Vertiginoso"),
			efeito = "Sucesso: o alvo fica imobilizado (TR encerra).",
		},
		quebrar_carapaca = { -- LJ1
			nome = "Quebrar Carapaça",
			uso = "Di",
			acao = "padrão",
			origem = set("arma", "confiável", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "forca", "Quebrar Carapaça"),
			efeito = "Sucesso: o alvo sofre 5 contínuo e -2 na CA (TR encerra ambos).",
		},
		acossar_da_retaguarda = { -- PM
			nome = "Acossar da Retaguarda",
			uso = "Di",
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			condicao = "Deve empunhar arma de alcance",
			defesa = "Fort",
			dano = mod.dado_mod("2[A]", "forca", "Acossar da Retaguarda"),
-- dano extra se for eladrin
			efeito = "Sucesso: o alvo é empurrado 1 quadrado.\nEfeito: até o FdEn, sempre que o alvo ajustar ou realizar um ataque que não\n    inclua você, você pode ajustar 1 quadrado e realizar um AtB CaC contra ele\n    (II)",
		},
		assalto_agonizante = { -- PM
			nome = "Assalto Agonizante",
			uso = "Di",
			acao = "padrão",
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
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "forca", "Assalto Molestador"),
-- dano extra se usar mangual
			efeito = "Efeito: até o FdEn, sempre que um aliado atingir o alvo com um At CaC,\n    você pode realizar um AtB CaC com VdC contra o alvo (livre; 1x rodada).",
		},
		corte_sutil = { -- PM
			nome = "Corte Sutil",
			uso = "Di",
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			condicao = "Deve empunhar lâmina leve",
			defesa = "CA",
			dano = function (self, dano, arma)
				if arma.grupo ~= "leve" then
					return 0
				end
				return 10 + self.mod_des
			end,
			efeito = function (self)
				return "Efeito: ajuste 1 quadrado antes E depois do ataque.\nSucesso: alvo fica lento e o dano é contínuo (TR encerra ambos).\nFracasso: "..self.mod_des.." de dano contínuo (TR encerra)."
			end,
		},
		investida_cometa = { -- PM
			nome = "Investida Cometa",
			uso = "Di",
			acao = "padrão",
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
			acao = "padrão",
			origem = set("arma", "marcial", "revigorante"),
			tipo_ataque = "corpo 1",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("1[A]", "forca", "Pancada Restritiva"),
			efeito = function (self)
				return "Sucesso: o alvo fica imobilizado enquanto estiver adjacente a você.\n    Se empunhar uma maça, machado ou martelo, causa +"..self.mod_con..".\nFracasso: metade do dano e fica imobilizado até o FdPT."
			end,
		},
------- Poderes Utilitários nível 6 --------------------------------------------
		acerto_de_contas = { -- PM
			nome = "Acerto de Contas",
			uso = "Di",
			acao = "RI",
			origem = set("marcial"),
			tipo_ataque = "pessoal",
			gatilho = "Você é atingido por um ataque",
			efeito = "Efeito: até o FdEn, você recebe +2 nos ataques contra este inimigo.",
		},
		aproximacao_agil = { -- PM
			nome = "Aproximação Ágil",
			uso = "En",
			acao = "movimento",
			origem = set("marcial"),
			tipo_ataque = "pessoal",
			efeito = "Efeito: ajusta 2 quadrados, desde que termine adjacente a um inimigo.\n    Se não estiver com uma armadura pesada, o ajuste é de 3 quadrados.",
		},
		estabilidade_rochosa = { -- PM
			nome = "Estabilidade Rochosa",
			uso = "Di",
			acao = "mínima",
			origem = set("marcial", "postura"),
			tipo_ataque = "pessoal",
			efeito = "Efeito: enquanto adotar esta postura, você não pode ser derrubado\n    e o movimento forçado imposto a você pode ser reduzido em 1 quadrado.",
		},
		foco_poderoso = { -- PM
			nome = "Foco Poderoso",
			uso = "En",
			acao = "mínima",
			origem = set("marcial"),
			tipo_ataque = "pessoal",
			efeito = function (self)
				return "Efeito: até o FdPT, receba +"..self.mod_sab.." nos testes de Atletismo e Força."
			end,
		},
		protetor_vigilante = { -- PM
			nome = "Protetor Vigilante",
			uso = "Di",
			acao = "mínima",
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
			nome = "Indestrutível",
			uso = "En",
			acao = "RI",
			origem = set("marcial"),
			tipo_ataque = "pessoal",
			gatilho = "Você é atingido por um ataque",
			efeito = function (self)
				return "Efeito: reduza o dano deste ataque em "..(5+self.mod_con)
			end,
		},
		prontidao_de_batalha = { -- LJ1
			nome = "Prontidão de Batalha",
			uso = "Di",
			acao = "-",
			origem = set("marcial"),
			tipo_ataque = "pessoal",
			efeito = "Efeito: depois de determinar a iniciativa, você pode escolher aumentar em 10 o\n    resultado da sua iniciativa.",
		},
		treinamento_defensivo = { -- LJ1
			nome = "Treinamento Defensivo",
			uso = "Di",
			acao = "mínima",
			origem = set("marcial", "postura"),
			tipo_ataque = "pessoal",
			efeito = "Efeito: enquanto adotar esta postura, receba +2 em Fortitude, Reflexos e Vontade",
		},
------- Poderes por Encontro nível 7 -----------------------------------------
		colera_do_grifo = {
			nome = "Cólera do Grifo",
			uso = "En",
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "forca", "Cólera do Grifo"),
			efeito = function (self)
				return "Sucesso: o alvo sofre -2 na CA até o FdPT.",
			end,
		},
		golpe_temerario = {
			nome = "Golpe Temerário",
			uso = "En",
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = function(self) return self.mod_for - 2 end,
			defesa = "CA",
			dano = mod.dado_mod("3[A]", "forca", "Golpe Temerário"),
		},
		impeto_subito = {
			nome = "Ímpeto Súbito",
			uso = "En",
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "forca", "Ímpeto Súbito"),
			efeito = function(self)
				return "Efeito: você se desloca "..math.max(self.mod_des, 1).." quadrados."
			end,
		},
		reduto_de_ferro = {
			nome = "Reduto de Ferro",
			uso = "En",
			acao = "padrão",
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
				return "Efeito: você recebe +"..bonus.." na CA até o FdPT."
			end,
		},
		vem_buscar = {
			nome = "Vem Buscar",
			uso = "En",
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "explosão contígua 3",
			alvo = "criaturas na explosão",
			ataque = mod.forca
			defesa = "Vont",
			dano = mod.dado_mod("1[A]", "forca", "Vem Buscar"),
			efeito = function(self)
				return "Sucesso: alvos são puxados 2 quadrados até um quadrado adjacente (se não puder,\n    não se move) e então sofrem o dano."
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
				return "Gatilho: um aliado é atingido por um AtCaC.\nSucesso: o aliado sofre metade do dano.\n    Se estiver usando uma maça, machado ou martelo, causa +"..dano.." de dano."
			end,
		},
		nao_tao_rapido = {
			nome = "Não Tão Rápido",
			uso = "En",
			acao = "II",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "quem ativou o gatilho",
			ataque = mod.forca
			defesa = "CA",
			dano = mod.dado_mod("1[A]", "forca", "Não Tão Rápido"),
			efeito = "Gatilho: um inimigo adjacente se afasta de você.\nSucesso: até o FdPT o alvo\n    fica lento (ou imobilizado, se você usar um mangual ou picareta)."
		},
		no_chao = {
			nome = "No Chão!",
			uso = "En",
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "forca", "No Chão!"),
			efeito = function(self)
				return "Sucesso: se o alvo estiver derrubado, sofre +"..self.mod_des.." de dano e não pode\n    se levantar até o FdPT."
			end,
		},
		rajada_restritiva = {
			nome = "Rajada Restritiva",
			uso = "En",
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca
			defesa = "CA",
			dano = mod.dado_mod("1[A]", "forca", "Rajada Restritiva"),
			efeito = function(self)
				return "Condição: empunhar duas armas de combate CaC.\nEfeito: um ataque com cada arma.\nSucesso: alvo fica lento até o FdPT. Se acertar os dois ataques, causa +"..self.mod_des
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
				return "Gatilho: você atinge um inimigo com um AtB CaC.\nSucesso: alvo fica lento até o FdPT. Se usar lança ou arma de haste, fica\n    derrubado ao invés de lento."
			end,
		},
		tormento_duplo = {
			nome = "Tormento Duplo",
			uso = "En",
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "duas criaturas",
			ataque = mod.forca
			defesa = "CA",
			dano = mod.dado_mod("1[A]", "forca", "Tormento Duplo"),
			efeito = function(self)
				return "Condição: empunhar duas armas de combate CaC.\nEfeito: um ataque por alvo.\nSucesso: alvo é empurrado "..(1+self.mod_des).." quadrados. Se tiver VdC, causa +"..self.mod_des
			end,
		},
	},
}
