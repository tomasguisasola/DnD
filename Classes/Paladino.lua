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
------- Características de Classe ----------------------------------------------
		desafio_divino = {
			nome = "Desafio Divino",
			uso = "SL",
			acao = "mínima",
			origem = set("divino", "radiante"),
			tipo_ataque = "explosão contígua 5",
			alvo = "uma criatura na explosão",
			efeito = function(self)
				local dano = 3 * (math.floor((self.nivel-1)/10)+1)
					+ self.mod_car
				return "O alvo fica marcado até trocar ou se não engajá-lo (atacar ou ficar adjacente).\n    Sofre "..dano.." de dano radiante se atacar aliado até o CdPT."
			end,
		},
		imposicao_de_maos = {
			nome = "Imposição de Mãos",
			uso = "SL",
			acao = "mínima",
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
				return "Você gasta um PC para que o alvo recupere PV como se ele tivesse gasto um PC"..bonus..".\n    Você pode usar esse poder "..self.mod_sab.." vezes por dia."
			end,
		},
		sancao_divina = {
			nome = "Sanção Divina",
			uso = "Ca",
			acao = "nenhuma",
			origem = set("divino"),
			tipo_ataque = "toque corpo",
			alvo = "uma criatura",
			efeito = function(self)
				local dano = 3 * (math.floor((self.nivel-1)/10)+1)
					+ self.mod_car
				return "Efeito: o alvo fica marcado por você e, em toda rodada, a primeira vez que ele\n    fizer um ataque que não te inclua como alvo, sofre "..dano.." de dano radiante."
			end,
		},
	},
	poderes = {
------- Poderes Sem Limite nível 1 ---------------------------------------------
		golpe_ardente = { -- PD
			nome = "Golpe Ardente",
			uso = "SL",
			acao = "padrão",
			origem = set("arma", "divino"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca_ou_carisma,
			defesa = "CA",
			dano = mod.dobra_21("[A]", "carisma", "Golpe Ardente"),
			efeito = "Sucesso: o alvo fica sob o efeito da sua sanção divina até o FdPT.",
		},
		golpe_debilitante = {
			nome = "Golpe Debilitante",
			uso = "SL",
			acao = "padrão",
			origem = set("arma", "divino"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.car,
			defesa = "CA",
			dano = mod.dobra_21("[A]", "carisma", "Golpe Debilitante"),
			efeito = "Sucesso: se tiver marcado o alvo, ele sofre -2 nos ataques até o FdPT.",
		},
		golpe_estimulante = {
			nome = "Golpe Estimulante",
			uso = "SL",
			acao = "padrão",
			origem = set("arma", "divino"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.car,
			defesa = "CA",
			dano = mod.dobra_21("[A]", "carisma", "Golpe Estimulante"),
			efeito = function (self)
				return "Sucesso: você recebe "..self.mod_sab.." PVT."
			end,
		},
		golpe_sagrado = {
			nome = "Golpe Sagrado",
			uso = "SL",
			acao = "padrão",
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
			acao = "padrão",
			origem = set("arma", "divino"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dobra_21("[A]", "forca", "Golpe Valente"),
			efeito = "O ataque tem um bônus de +1 por inimigo adjacente.",
		},
		golpe_virtuoso = { -- PD
			nome = "Golpe Virtuoso",
			uso = "SL",
			acao = "padrão",
			origem = set("arma", "divino", "radiante"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.carisma,
			defesa = "CA",
			dano = mod.dobra_21("[A]", "carisma", "Golpe Virtuoso"),
			efeito = "Você ganha +2 de bônus no PC até o CdPT.",
		},
------- Poderes por Encontro nível 1 -------------------------------------------
		chama_deslumbrante = { -- PD
			nome = "Chama Deslumbrante",
			uso = "En",
			acao = "padrão",
			origem = set("divino", "implemento", "radiante"),
			tipo_ataque = "distância 5",
			alvo = "uma criatura",
			ataque = mod.carisma,
			defesa = "Ref",
			dano = mod.dado_mod("2d8", "carisma"),
			efeito = "Sucesso: o alvo sofre -2 de penalidade nos ataques até o FdPT.",
		},
		castigo_valoroso = { -- PD
			nome = "Castigo Valoroso",
			uso = "En",
			acao = "padrão",
			origem = set("arma", "divino"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.carisma,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "carisma"),
			efeito = "Sucesso: cada inimigo a até 3 quadrados de você fica sujeito à sua sanção divina até o FdPT.",
		},
		furia_negligente = { -- PD
			nome = "Fúria Negligente",
			uso = "En",
			acao = "padrão",
			origem = set("arma", "divino"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("3[A]", "forca"),
			efeito = "Sucesso: você sofre -5 de penalidade em todas as defesas até o FdPT.",
		},
		guardiao_de_luz = { -- PD
			nome = "Guardião de Luz",
			uso = "En",
			acao = "padrão",
			origem = set("arma", "divino", "radiante"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca_ou_carisma,
			defesa = "CA",
			dano = mod.dado_mod("1[A]", "forca"),
			efeito = function(self)
				return "Sucesso: até o FdPT, você ganha +"..self.mod_sab.." em Fortitude, Reflexos e Vontade."
			end,
		},
		perseguicao_divina = { -- PD
			nome = "Perseguição Divina",
			uso = "En",
			acao = "padrão",
			origem = set("arma", "divino"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "Fort",
			dano = mod.dado_mod("2[A]", "forca"),
			efeito = function(self)
				return "Sucesso: o alvo é empurrado "..self.mod_sab.." quadrados e você pode ajustar para o quadrado\n    adjacente ao alvo mais próximo."
			end,
		},
		punicao_perfurante = {
			nome = "Punição Perfurante",
			uso = "En",
			acao = "padrão",
			origem = set("arma", "divino"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "Ref",
			dano = mod.dado_mod("2[A]", "forca"),
			efeito = function(self)
				return "Sucesso: "..self.mod_sab.." inimigos adjacentes ficam marcados até o FdPT."
			end,
		},
		punicao_protetora = {
			nome = "Punição Protetora",
			uso = "En",
			acao = "padrão",
			origem = set("arma", "divino"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.car,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "carisma"),
			efeito = function (self)
				return "Sucesso: Até o FdPT, um aliado a até 5 recebe +"..self.mod_sab.." na CA."
			end,
		},
		punicao_radiante = {
			nome = "Punição Radiante",
			uso = "En",
			acao = "padrão",
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
			nome = "Punição Temível",
			uso = "En",
			acao = "padrão",
			origem = set("arma", "divino", "medo"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.carisma,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "carisma"),
			efeito = function(self)
				return "Sucesso: o alvo sofre -"..self.mod_sab.." de penalidade nas jogadas de ataque até o FdPT."
			end,
		},
------- Poderes Diários nível 1 ------------------------------------------------
		carga_gloriosa = { -- PD
			nome = "Carga Gloriosa",
			uso = "Di",
			acao = "padrão",
			origem = set("arma", "cura", "divino"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.carisma,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "carisma", "Carga Gloriosa"),
			efeito = function (self)
				local pv = math.floor(self.nivel/2) + self.mod_sab
				return "Efeito: depois do ataque, cada aliado a até 2 quadrados recupera "..pv.."PV.\n    Você pode usar este poder como o AtBas de uma investida."
			end,
		},
		halo_majestoso = { -- PD
			nome = "Halo Majestoso",
			uso = "Di",
			acao = "padrão",
			origem = set("arma", "divino", "radiante"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.carisma,
			defesa = "CA",
			dano = mod.dado_mod("3[A]", "carisma", "Halo Majestoso"),
			efeito = "Fracasso: metade do dano.\nEfeito: até o final do encontro, qualquer inimigo que começar seu turno adjacente a você fica sujeito à sua sanção divina até o final de seu turno.",
		},
		julgamento_do_paladino = {
			nome = "Julgamento do Paladino",
			uso = "Di",
			acao = "padrão",
			origem = set("divino", "cura", "arma"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("3[A]", "forca", "Julgamento do Paladino"),
			efeito = "Um aliado a até 5 quadrados pode gastar um PC (mesmo no fracasso).",
		},
		marca_ardente = { -- PD
			nome = "Marca Ardente",
			uso = "Di",
			acao = "padrão",
			origem = set("arma", "confiável", "divino", "flamejante"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "Fort",
			dano = mod.dado_mod("2[A]", "forca", "Marca Ardente"),
			efeito = "Sucesso: o alvo sofre 5 de dano flamejante contínuo e concede VdC a qualquer\n    aliado do paladino adjacente a ele (TR encerra ambos).",
		},
		sangue_do_poderoso = { -- PD
			nome = "Sangue do Poderoso",
			uso = "Di",
			acao = "padrão",
			origem = set("confiável", "divino", "implemento"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("4[A]", "forca", "Sangue do Poderoso"),
			efeito = "Efeito: você sofre 5 de dano, que não pode ser reduzido de nenhuma forma.",
		},
		sob_pena_de_morte = {
			nome = "Sob Pena de Morte",
			uso = "Di",
			acao = "padrão",
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
------- Poderes Utilitários nível 2 --------------------------------------------
		bencao_do_martir = {
			nome = "Bênção do Mártir",
			uso = "Di",
			acao = "interrupção imediata",
			origem = set("divino"),
			tipo_ataque = "explosão contígua 1",
			gatilho = "um aliado adjacente é atingido por um ataque",
			alvo = nil,
			ataque = nil,
			defesa = nil,
			dano = nil,
			efeito = "Você se torna o alvo do ataque no lugar do aliado.",
		},
		circulo_sagrado = {
			nome = "Círculo Sagrado",
			uso = "Di",
			acao = "padrão",
			origem = set("divino", "implemento", "zona"),
			tipo_ataque = "explosão contígua 3",
			alvo = "aliados dentro da zona",
			ataque = nil,
			defesa = nil,
			dano = nil,
			efeito = "A explosão cria uma zona que, até o final do encontro, concede ao paladino\ne seus aliados dentro da zona +1 de bônus de poder na CA",
		},
------- Poderes por Encontro nível 3 -------------------------------------------
		punicao_em_cadeia = {
			nome = "Punição em Cadeia",
			uso = "En",
			acao = "padrão",
			origem = set("arma", "divino"),
			tipo_ataque = "corpo",
			alvo = "uma ou duas criaturas",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("1[A]", "forca"),
			efeito = "Sucesso: o(s) alvo(s) fica(m) marcado(s) até o FdPT.",
		},
		punicao_integra = {
			nome = "Punição Íntegra",
			uso = "En",
			acao = "padrão",
			origem = set("arma", "cura", "divino"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.car,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "carisma"),
			efeito = function(self)
				return "Sucesso: o paladino e seus aliados a até 5 quadrados recebem "..(5 + self.mod_sab).." PVT."
			end,
		},
		punicao_revigorante = {
			nome = "Punição Revigorante",
			uso = "En",
			acao = "padrão",
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
------- Poderes Diários nível 5 ------------------------------------------------
		circulo_santificado = {
			nome = "Círculo Santificado",
			uso = "Di",
			acao = "padrão",
			origem = set("divino", "implemento", "zona"),
			tipo_ataque = "explosão contígua 3",
			alvo = "inimigos na explosão",
			ataque = mod.carisma,
			defesa = "Ref",
			dano = mod.dado_mod("2d6", "carisma"),
			efeito = "Efeito: cria uma zona de luz plena que permanece ativa até o FdEn.\n    Enquanto estiverem na zona, você e seus aliados recebem +1 nas defesas.",
		},
		retribuicao_do_martir = {
			nome = "Retribuição do Mártir",
			uso = "Di",
			acao = "padrão",
			origem = set("arma", "divino", "radiante"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("4[A]", "forca"),
			efeito = "fracasso: metade do dano",
		},
------- Poderes Utilitários nível 6 --------------------------------------------
		colera_dos_deuses = {
			nome = "Cólera dos Deuses",
			uso = "Di",
			acao = "mínima",
			origem = set("divino"),
			tipo_ataque = "explosão contígua 1",
			alvo = "o personagem e seus aliados",
			efeito = function (self)
				return "Efeito: os alvos causam +"..self.mod_car.." nas jogadas de dano até o FdEn."
			end,
		},
	},
}
