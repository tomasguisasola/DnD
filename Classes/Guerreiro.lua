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
		comigo_agora = {
			nome = "Comigo, Agora!",
			uso = "En",
			acao = "movimento",
			origem = set("marcial"),
			tipo_ataque = "corpo 1",
			alvo = "aliado adjacente",
			efeito = "O alvo é conduzido 2 quadrados para um quadrado adjacente a você.",
		},
		fechar_a_guarda = {
			nome = "Fechar a Guarda",
			uso = "En",
			acao = "int. imediata",
			origem = set("marcial"),
			tipo_ataque = "corpo",
			efeito = "Cancele a VdC de um ataque.",
		},
		irrefreavel = {
			nome = "Irrefreável",
			uso = "Di",
			acao = "mínima",
			origem = set("cura", "marcial"),
			tipo_ataque = "pessoal",
			efeito = function(self)
				return "Você recebe 2d6+"..self.mod_con.." PVT."
			end,
		},
		passar_adiante = {
			nome = "Passar Adiante",
			uso = "SL",
			acao = "movimento",
			origem = set("marcial"),
			tipo_ataque = "pessoal",
			efeito = "Escolha um inimigo adjacente e percorra seu deslocamento.\n   Desde que termine adjacente ao mesmo inimigo, o movimento não provoca AdO.",
		},
		tolerancia_ilimitada = {
			nome = "Tolerância Ilimitada",
			uso = "Di",
			acao = "mínima",
			origem = set("cura", "marcial", "postura"),
			tipo_ataque = "pessoal",
			efeito = function(self)
				return "Você adquire regeneração "..(2+self.mod_con).." quando estiver sangrando."
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
	},
}
