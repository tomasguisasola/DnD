local set = require"DnD.Set"
local soma_dano = require"DnD.Soma".soma
local armas = require"DnD.Armas"
local tipos_armas = require"DnD.TiposArmas"
local mod = require"DnD.Modificadores"

return {
	nome = "Paladino",
	fonte_de_poder = "divino",
	fortitude = 1,
	reflexos = 1,
	vontade = 1,
	armaduras = set("traje", "corselete", "gibao", "cota", "brunea", "placas", "leve", "pesado"),
	armas = tipos_armas("corpo simples", "corpo militar", "distancia simples"),
	implementos = set("simbolo_sagrado"),
	pv = 15,
	pv_nivel = 6,
	pc_dia = 10,
	pericias = {
		religiao = "treinada",
		diplomacia = true,
		historia = true,
		intimidacao = true,
		intuicao = true,
		socorro = true,
		tolerancia = true,
	},
	total_pericias = 3,
	caracteristicas_classe = {
------- Caracter�sticas de Classe ----------------------------------------------
		desafio_divino = {
			nome = "Desafio Divino",
			uso = "SL",
			acao = "m�nima",
			origem = set("divino", "radiante"),
			tipo_ataque = "explos�o cont�gua 5",
			alvo = "uma criatura na explos�o",
			efeito = function(self)
				local dano = 3 * (math.floor((self.nivel-1)/10)+1)
					+ self.mod_car
				return "O alvo fica marcado at� trocar ou se n�o engaj�-lo (atacar ou ficar adjacente).\nSofre "..dano.." de dano radiante se atacar aliado at� o CdPT."
			end,
		},
		imposicao_de_maos = {
			nome = "Imposi��o de M�os",
			uso = "SL",
			acao = "m�nima",
			origem = set("cura", "divino"),
			tipo_ataque = "toque corpo",
			alvo = "uma criatura",
			efeito = function(self)
				local bonus = self.bonus_imposicao_de_maos
				if bonus then
					bonus = " +"..bonus
				else
					bonus = ''
				end
				return "Voc� gasta um PC para que o alvo recupere PV como se ele tivesse gasto um PC"..bonus..".\nVoc� pode usar esse poder "..self.mod_sab.." vezes por dia."
			end,
		},
	},
	poderes = {
------- Poderes Sem Limite n�vel 1 ---------------------------------------------
		golpe_debilitante = {
			nome = "Golpe Debilitante",
			uso = "SL",
			acao = "padr�o",
			origem = set("arma", "divino"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.car,
			defesa = "CA",
			dano = mod.dobra_21("[A]", "carisma", "Golpe Debilitante"),
			efeito = "Sucesso: se tiver marcado o alvo, ele sofre -2 nos ataques at� o FdPT.",
		},
		golpe_estimulante = {
			nome = "Golpe Estimulante",
			uso = "SL",
			acao = "padr�o",
			origem = set("arma", "divino"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.car,
			defesa = "CA",
			dano = mod.dobra_21("[A]", "carisma", "Golpe Estimulante"),
			efeito = function (self)
				return "Sucesso: voc� recebe "..self.mod_sab.." PVT."
			end,
		},
		golpe_sagrado = {
			nome = "Golpe Sagrado",
			uso = "SL",
			acao = "padr�o",
			origem = set("arma", "divino", "radiante"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dobra_21("[A]", "forca", "Golpe Sagrado"),
			efeito = function (self)
				return "Sucesso: se tiver marcado o alvo, este ataque causa +"..self.mod_sab.." de dano."
			end,
		},
		golpe_valente = {
			nome = "Golpe Valente",
			uso = "SL",
			acao = "padr�o",
			origem = set("arma", "divino"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dobra_21("[A]", "forca", "Golpe Valente"),
			efeito = "O ataque tem um b�nus de +1 por inimigo adjacente.",
		},
------- Poderes por Encontro n�vel 1 -------------------------------------------
		punicao_perfurante = {
			nome = "Puni��o Perfurante",
			uso = "En",
			acao = "padr�o",
			origem = set("arma", "divino"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "Ref",
			dano = mod.dado_mod("2[A]", "forca"),
			efeito = function(self)
				return "Sucesso: "..self.mod_sab.." inimigos adjacentes ficam marcados at� o FdPT."
			end,
		},
		punicao_protetora = {
			nome = "Puni��o Protetora",
			uso = "En",
			acao = "padr�o",
			origem = set("arma", "divino"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.car,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "carisma"),
		},
		punicao_radiante = {
			nome = "Puni��o Radiante",
			uso = "En",
			acao = "padr�o",
			origem = set("arma", "divino", "radiante"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = function(self)
				return "2[A]+"..(self.mod_for+self.mod_sab)
			end,
		},
		punicao_temivel = {
			nome = "Puni��o Tem�vel",
			uso = "En",
			acao = "padr�o",
			origem = set("arma", "divino", "medo"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.carisma,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "carisma"),
			efeito = function(self)
				return "Sucesso: o alvo sofre -"..self.mod_sab.." de penalidade nas jogadas de ataque at� o FdPT."
			end,
		},
------- Poderes Di�rios n�vel 1 ------------------------------------------------
		julgamento_do_paladino = {
			nome = "Julgamento do Paladino",
			uso = "Di",
			acao = "padr�o",
			origem = set("divino", "cura", "arma"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("3[A]", "forca", "Julgamento do Paladino"),
			efeito = "Um aliado a at� 5 quadrados pode gastar um PC (mesmo no fracasso).",
		},
		sob_pena_de_morte = {
			nome = "Sob Pena de Morte",
			uso = "Di",
			acao = "padr�o",
			origem = set("divino", "implemento"),
			tipo_ataque = "distancia 5",
			alvo = "uma criatura",
			ataque = mod.car,
			defesa = "Vont",
			dano = mod.dado_mod("3d8", "carisma", "Sob Pena de Morte"),
			adicional = function(self)
				return "+1d8 por ataque (TR encerra)"
			end,
			efeito = "Sucesso: o alvo sofre 1d8 de dano se atacar no seu turno (TR encerra).\nFracasso: 1/2 dano e 1d4 de dano se atacar no seu turno (TR encerra).",
		},
------- Poderes Utilit�rios n�vel 2 --------------------------------------------
		bencao_do_martir = {
			nome = "B�n��o do M�rtir",
			uso = "Di",
			acao = "interrup��o imediata",
			origem = set("divino"),
			tipo_ataque = "explos�o cont�gua 1",
			gatilho = "um aliado adjacente � atingido por um ataque",
			alvo = nil,
			ataque = nil,
			defesa = nil,
			dano = nil,
			efeito = "Voc� se torna o alvo do ataque no lugar do aliado.",
		},
		circulo_sagrado = {
			nome = "C�rculo Sagrado",
			uso = "Di",
			acao = "padr�o",
			origem = set("divino", "implemento", "zona"),
			tipo_ataque = "explos�o cont�gua 3",
			alvo = "aliados dentro da zona",
			ataque = nil,
			defesa = nil,
			dano = nil,
			efeito = "A explos�o cria uma zona que, at� o final do encontro, concede ao paladino\ne seus aliados dentro da zona +1 de b�nus de poder na CA",
		},
------- Poderes por Encontro n�vel 3 -------------------------------------------
		punicao_integra = {
			nome = "Puni��o �ntegra",
			uso = "En",
			acao = "padr�o",
			origem = set("arma", "cura", "divino"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.car,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "carisma"),
			efeito = function(self)
				return "Sucesso: o paladino e seus aliados a at� 5 quadrados recebem "..(5 + self.mod_sab).." PVT."
			end,
		},
		punicao_revigorante = {
			nome = "Puni��o Revigorante",
			uso = "En",
			acao = "padr�o",
			origem = set("arma", "cura", "divino"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.car,
			defesa = "Vont",
			dano = mod.dado_mod("2[A]", "carisma"),
			efeito = function(self)
				return "Sucesso: o paladino e os aliados que estiverem sangrando recebem "..(5 + self.mod_sab).." PV."
			end,
		},
------- Poderes Di�rios n�vel 5 ------------------------------------------------
		circulo_santificado = {
			nome = "C�rculo Santificado",
			uso = "Di",
			acao = "padr�o",
			origem = set("divino", "implemento", "zona"),
			tipo_ataque = "explos�o cont�gua 3",
			alvo = "inimigos na explos�o",
			ataque = mod.carisma,
			defesa = "Ref",
			dano = mod.dado_mod("2d6", "carisma"),
			efeito = "Cria uma zona de luz plena que permanece ativa at� o final do encontro.\nEnquanto estiverem na zona, o paladino e seus aliados recebem +1 nas defesas.",
		},
		retribuicao_do_martir = {
			nome = "Retribui��o do M�rtir",
			uso = "Di",
			acao = "padr�o",
			origem = set("arma", "divino", "radiante"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("4[A]", "forca"),
			efeito = "fracasso: metade do dano",
		},
	},
}
