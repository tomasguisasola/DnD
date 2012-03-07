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
		local c = assert(self.caracteristica_classe, "Falta definir a característica de classe"):lower()
		if c:match"guerreiro tempestuoso" then
			return "defesa_com_duas_armas", true
		end
	end,
	caracteristicas_classe = {
------- Características de Classe ----------------------------------------------
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
			tipo_ataque = "corpo", --"explosão contígua 1",
			alvo = "os inimigos adjacentes e na linha de visão",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("1[A]", "forca", "Ataque de Passagem"),
-- falta terminar
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
------- Poderes Utilitários nível 1 --------------------------------------------
		fechar_a_guarda = {
			nome = "Fechar a Guarda",
			uso = "En",
			acao = "int. imediata",
			origem = set("marcial"),
			tipo_ataque = "corpo",
			--alvo = "uma criatura",
			--ataque = mod.forca,
			--defesa = "CA",
			--dano = mod.dado_mod("1[A]", "forca", "Chuva de Golpes"),
			efeito = "Cancele a VdC de um ataque.",
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
			efeito = "Dois ataques.", -- três ataques se usar lamina leve, lanca ou mangual
		},
	},
}
