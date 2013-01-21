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
				return "O alvo fica marcado at� trocar ou se n�o engaj�-lo (atacar ou ficar adjacente).\n    Sofre "..dano.." de dano radiante se atacar aliado at� o CdPT."
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
				return "Voc� gasta um PC para que o alvo recupere PV como se ele tivesse gasto um PC"..bonus..".\n    Voc� pode usar esse poder "..self.mod_sab.." vezes por dia."
			end,
		},
		sancao_divina = {
			nome = "San��o Divina",
			uso = "Ca",
			acao = "nenhuma",
			origem = set("divino"),
			tipo_ataque = "toque corpo",
			alvo = "uma criatura",
			efeito = function(self)
				local dano = 3 * (math.floor((self.nivel-1)/10)+1)
					+ self.mod_car
				return "Efeito: o alvo fica marcado por voc� e, em toda rodada, a primeira vez que ele\n    fizer um ataque que n�o te inclua como alvo, sofre "..dano.." de dano radiante."
			end,
		},
	},
	poderes = {
------- Poderes Sem Limite n�vel 1 ---------------------------------------------
		golpe_ardente = { -- PD
			nome = "Golpe Ardente",
			uso = "SL",
			acao = "padr�o",
			origem = set("arma", "divino"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca_ou_carisma,
			defesa = "CA",
			dano = mod.dobra_21("[A]", "carisma", "Golpe Ardente"),
			efeito = "Sucesso: o alvo fica sob o efeito da sua san��o divina at� o FdPT.",
		},
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
		golpe_virtuoso = { -- PD
			nome = "Golpe Virtuoso",
			uso = "SL",
			acao = "padr�o",
			origem = set("arma", "divino", "radiante"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.carisma,
			defesa = "CA",
			dano = mod.dobra_21("[A]", "carisma", "Golpe Virtuoso"),
			efeito = "Voc� ganha +2 de b�nus no PC at� o CdPT.",
		},
------- Poderes por Encontro n�vel 1 -------------------------------------------
		chama_deslumbrante = { -- PD
			nome = "Chama Deslumbrante",
			uso = "En",
			acao = "padr�o",
			origem = set("divino", "implemento", "radiante"),
			tipo_ataque = "dist�ncia 5",
			alvo = "uma criatura",
			ataque = mod.carisma,
			defesa = "Ref",
			dano = mod.dado_mod("2d8", "carisma"),
			efeito = "Sucesso: o alvo sofre -2 de penalidade nos ataques at� o FdPT.",
		},
		castigo_valoroso = { -- PD
			nome = "Castigo Valoroso",
			uso = "En",
			acao = "padr�o",
			origem = set("arma", "divino"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.carisma,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "carisma"),
			efeito = "Sucesso: cada inimigo a at� 3 quadrados de voc� fica sujeito � sua san��o divina at� o FdPT.",
		},
		furia_negligente = { -- PD
			nome = "F�ria Negligente",
			uso = "En",
			acao = "padr�o",
			origem = set("arma", "divino"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("3[A]", "forca"),
			efeito = "Sucesso: voc� sofre -5 de penalidade em todas as defesas at� o FdPT.",
		},
		guardiao_de_luz = { -- PD
			nome = "Guardi�o de Luz",
			uso = "En",
			acao = "padr�o",
			origem = set("arma", "divino", "radiante"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca_ou_carisma,
			defesa = "CA",
			dano = mod.dado_mod("1[A]", "forca"),
			efeito = function(self)
				return "Sucesso: at� o FdPT, voc� ganha +"..self.mod_sab.." em Fortitude, Reflexos e Vontade."
			end,
		},
		perseguicao_divina = { -- PD
			nome = "Persegui��o Divina",
			uso = "En",
			acao = "padr�o",
			origem = set("arma", "divino"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "Fort",
			dano = mod.dado_mod("2[A]", "forca"),
			efeito = function(self)
				return "Sucesso: o alvo � empurrado "..self.mod_sab.." quadrados e voc� pode ajustar para o quadrado\n    adjacente ao alvo mais pr�ximo."
			end,
		},
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
			efeito = function (self)
				return "Sucesso: At� o FdPT, um aliado a at� 5 recebe +"..self.mod_sab.." na CA."
			end,
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
		carga_gloriosa = { -- PD
			nome = "Carga Gloriosa",
			uso = "Di",
			acao = "padr�o",
			origem = set("arma", "cura", "divino"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.carisma,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "carisma", "Carga Gloriosa"),
			efeito = function (self)
				local pv = math.floor(self.nivel/2) + self.mod_sab
				return "Efeito: depois do ataque, cada aliado a at� 2 quadrados recupera "..pv.."PV.\n    Voc� pode usar este poder como o AtBas de uma investida."
			end,
		},
		halo_majestoso = { -- PD
			nome = "Halo Majestoso",
			uso = "Di",
			acao = "padr�o",
			origem = set("arma", "divino", "radiante"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.carisma,
			defesa = "CA",
			dano = mod.dado_mod("3[A]", "carisma", "Halo Majestoso"),
			efeito = "Fracasso: metade do dano.\nEfeito: at� o final do encontro, qualquer inimigo que come�ar seu turno adjacente a voc� fica sujeito � sua san��o divina at� o final de seu turno.",
		},
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
		marca_ardente = { -- PD
			nome = "Marca Ardente",
			uso = "Di",
			acao = "padr�o",
			origem = set("arma", "confi�vel", "divino", "flamejante"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "Fort",
			dano = mod.dado_mod("2[A]", "forca", "Marca Ardente"),
			efeito = "Sucesso: o alvo sofre 5 de dano flamejante cont�nuo e concede VdC a qualquer\n    aliado do paladino adjacente a ele (TR encerra ambos).",
		},
		sangue_do_poderoso = { -- PD
			nome = "Sangue do Poderoso",
			uso = "Di",
			acao = "padr�o",
			origem = set("confi�vel", "divino", "implemento"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("4[A]", "forca", "Sangue do Poderoso"),
			efeito = "Efeito: voc� sofre 5 de dano, que n�o pode ser reduzido de nenhuma forma.",
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
		punicao_em_cadeia = {
			nome = "Puni��o em Cadeia",
			uso = "En",
			acao = "padr�o",
			origem = set("arma", "divino"),
			tipo_ataque = "corpo",
			alvo = "uma ou duas criaturas",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("1[A]", "forca"),
			efeito = "Sucesso: o(s) alvo(s) fica(m) marcado(s) at� o FdPT.",
		},
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
			efeito = "Efeito: cria uma zona de luz plena que permanece ativa at� o FdEn.\n    Enquanto estiverem na zona, voc� e seus aliados recebem +1 nas defesas.",
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
------- Poderes Utilit�rios n�vel 6 --------------------------------------------
		colera_dos_deuses = {
			nome = "C�lera dos Deuses",
			uso = "Di",
			acao = "m�nima",
			origem = set("divino"),
			tipo_ataque = "explos�o cont�gua 1",
			alvo = "o personagem e seus aliados",
			efeito = function (self)
				return "Efeito: os alvos causam +"..self.mod_car.." nas jogadas de dano at� o FdEn."
			end,
		},
	},
}
