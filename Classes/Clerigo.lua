local set = require"DnD.Set"
local tipos_armas = require"DnD.TiposArmas"
local mod = require"DnD.Modificadores"

return {
	nome = "Clérigo",
	fonte_de_poder = "divino",
	vontade = 2,
	armaduras = set("traje", "corselete", "gibao", "cota"),
	armas = tipos_armas("corpo simples", "distancia simples"),
	implementos = set("simbolo_sagrado"),
	pv = 12,
	pv_nivel = 5,
	pc_dia = 7,
	pericias = {
		religiao = "treinada",
		arcanismo = true,
		diplomacia = true,
		historia = true,
		intuicao = true,
		socorro = true,
	},
	total_pericias = 3,
	caracteristicas_classe = {
------- Características de Classe ----------------------------------------------
		palavra_de_cura = {
			nome = "Palavra de Cura",
			uso = "En x2",
			acao = "mínima",
			origem = set("cura", "divino"),
			tipo_ataque = "explosão contígua 5",
			alvo = "você ou um aliado na explosão",
			efeito = function(self)
				local dados = math.floor((self.nivel-1)/5) + 1
				return "O alvo gasta um PC e recupera +"..dados.."d6 + "..self.mod_sab.." PV adicionais."
			end,
		},
	},
	poderes = {
------- Poderes Sem Limite nível 1 ---------------------------------------------
		chama_sagrada = {
			nome = "Chama Sagrada",
			uso = "SL",
			acao = "padrão",
			origem = set("divino", "implemento", "radiante"),
			tipo_ataque = "distância 5",
			alvo = "uma criatura",
			ataque = mod.sab,
			defesa = "Ref",
			dano = mod.dobra_21("1d6", "sabedoria", "Chama Sagrada"),
			efeito = function(self)
				local extra = math.floor(self.nivel/2) + self.mod_car
				return "Sucesso: um aliado na linha de visão escolhe entre receber "..extra.." PVT ou realizar um TR."
			end,
		},
		escudo_do_sacerdote = {
			nome = "Escudo do Sacerdote",
			uso = "SL",
			acao = "padrão",
			origem = set("arma", "divino"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dobra_21("1[A]", "forca", "Escudo do Sacerdote"),
			efeito = "Sucesso: você e um aliado adjacente recebem +1 (poder) na CA até o FdPT.",
		},
		lanca_da_fe = {
			nome = "Lança da Fé",
			uso = "SL",
			acao = "padrão",
			origem = set("implemento", "primitivo", "psiquico"),
			tipo_ataque = "distância 5",
			alvo = "uma criatura",
			ataque = mod.sab,
			defesa = "Ref",
			dano = mod.dobra_21("1d8", "sabedoria", "Lança da Fé"),
			efeito = "Aliado na linha de visão recebe +2 (poder) no próximo ataque contra o alvo.",
		},
		marca_da_integridade = {
			nome = "Marca da Integridade",
			uso = "SL",
			acao = "padrão",
			origem = set("arma", "divino"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dobra_21("1[A]", "forca", "Marca da Integridade"),
			efeito = "Sucesso: aliado a até 5 recebe +3 (poder) no ataque CaC contra o alvo até o FdPT.",
		},
		pancada_de_recuperacao = {
			nome = "Pancada de Recuperação",
			uso = "SL",
			acao = "padrão",
			origem = set("arma", "cura", "divino"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dobra_21 ("1[A]", "forca", "Pancada de Recuperação"),
			efeito = function(self)
				return "Sucesso: o próximo aliado que acertar o alvo até o FdPT, recupera "..self.mod_car.." PV."
			end,
		},
		selo_astral = {
			nome = "Selo Astral",
			uso = "SL",
			acao = "padrão",
			origem = set("cura", "divino", "implemento"),
			tipo_ataque = "distância 5",
			alvo = "uma criatura",
			ataque = function(self)
				return self.mod_sab + 2
			end,
			defesa = "Ref",
			dano = '',
			efeito = function(self)
				return "Sucesso: até o FdPT, o alvo sofre -2 em todas as defesas\n    e o próximo aliado que acertar o alvo até o FdPT recupera "..(self.mod_car+2).." PV."
			end,
		},
------- Poderes por Encontro nível 1 -------------------------------------------
		elocucao_exigente = {
			nome = "Elocução Exigente",
			uso = "En",
			acao = "padrão",
			origem = set("divino", "implemento"),
			tipo_ataque = "distância 5",
			alvo = "uma criatura",
			ataque = mod.sabedoria,
			defesa = "Vont",
			dano = nil,
			efeito = function(self)
				return "Sucesso: até o FdPT o alvo adquire vulnerabilidade "..self.mod_sab.." a todo tipo de dano\n    e todo aliado que acertar o alvo ganha "..self.mod_sab.." PVT."
			end,
		},
		golpe_restaurador = {
			nome = "Golpe Restaurador",
			uso = "En",
			acao = "padrão",
			origem = set("arma", "cura", "divino", "radiante"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "forca", "Golpe Restaurador"),
			efeito = function(self)
				return "Sucesso: o alvo fica marcado até o FdPT e você ou um aliado a até 5 pode gastar um PC e recupera "..self.mod_sab.." PV adicionais."
			end,
		},
		luminescencia_divina = {
			nome = "Luminescência Divina",
			uso = "En",
			acao = "padrão",
			origem = set("divino", "implemento", "radiante"),
			tipo_ataque = "rajada contígua 3",
			alvo = "inimigos na rajada",
			ataque = mod.sabedoria,
			defesa = "Ref",
			dano = mod.dado_mod("1d8", "sabedoria", "Luminescência Divina"),
			efeito = "Os aliados dentro da área recebem +2 nos ataques até o FdPT.",
		},
		perdicao = {
			nome = "Perdição",
			uso = "En",
			acao = "padrão",
			origem = set("divino", "implemento"),
			tipo_ataque = "distância 10",
			alvo = "uma criatura",
			ataque = mod.sabedoria,
			defesa = "Vont",
			dano = '',
			efeito = function(self)
				return "Até o FdPT, o alvo sofre -"..(1+self.mod_car).." de penalidade nos ataques e em todas as defesas."
			end,
		},
------- Poderes Diários nível 1 ------------------------------------------------
		cascata_de_luz = {
			nome = "Cascata de Luz",
			uso = "Di",
			acao = "padrão",
			origem = set("divino", "implemento", "radiante"),
			tipo_ataque = "distância 10",
			alvo = "uma criatura",
			ataque = mod.sab,
			defesa = "Vont",
			dano = mod.dado_mod("3d8", "sabedoria", "Cascata de Luz"),
			efeito = "Sucesso: o alvo adquide vulnerabilidade 5 a todos os ataques do clérigo (TR).\nFracasso: metade do dano e não adquire a vulnerabilidade.",
		},
		chama_vingadora = {
			nome = "Chama Vingadora",
			uso = "Di",
			acao = "padrão",
			origem = set("arma", "divino", "flamejante"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "forca", "Chama Vingadora"),
			efeito = "Sucesso: 5 de dano flamejante contínuo (TR) e se atacar no seu turno, não pode\n    realizar o TR.\nFracasso: metade do dano e nenhum dano contínuo.",
		},
		farol_da_esperanca = {
			nome = "Farol da Esperança",
			uso = "Di",
			acao = "padrão",
			origem = set("cura", "divino", "implemento"),
			tipo_ataque = "explosão contígua 3",
			alvo = "inimigos na explosão",
			ataque = mod.sab,
			defesa = "Vont",
			efeito = function(self)
				return "Sucesso: os alvos ficam enfraquecidos até o FdPT.\nEfeito: você e seus aliados recuperam 5 PV e seus poderes de cura restauram +5 PV adicionais no encontro."
			end,
		},
		guardiao_da_fe = {
			nome = "Guardião da Fé",
			uso = "Di",
			acao = "padrão",
			origem = set("conjuracao", "divino", "implemento", "radiante"),
			tipo_ataque = "distância 5",
			alvo = "inimigo adjacente ao guardião",
			ataque = mod.sab,
			defesa = "Fort",
			dano = mod.dado_mod("1d8", "sabedoria", "Guardião da Fé"),
			efeito = "Efeito: conjura um guardião que ocupa 1 quadrado dentro do alcance. A cada\n    rodada, pode deslocar 3 (movimento). Ele luta até o FdEn. Qualquer inimigo\n    que terminar o turno adjacente ao guardião, sofre um ataque.\n    As criaturas podem se deslocar através do espaço dele.",
		},
------- Poderes Utilitários nível 2 --------------------------------------------
		auxilio_divino = {
			nome = "Auxílio Divino",
			uso = "En",
			acao = "padrão",
			origem = set("divino"),
			tipo_ataque = "distância 5",
			alvo = "você ou aliado",
			efeito = function (self)
				return "Efeito: o alvo realiza um TR com +"..self.mod_sab.." de bônus."
			end,
		},
		bencao = {
			nome = "Bênção",
			uso = "Di",
			acao = "mínima",
			origem = set("divino"),
			tipo_ataque = "explosão contígua 20",
			alvo = "você e seus aliados",
			efeito = "Efeito: até o FdEn, todos ganham +1 nos ataques.",
		},
		curar_ferimentos_leves = {
			nome = "Curar Ferimentos Leves",
			uso = "Di",
			acao = "padrão",
			origem = set("cura", "divino"),
			tipo_ataque = "toque",
			alvo = "você ou outra criatura",
			efeito = "Efeito: o alvo recura PV como se tivesse gasto um PC.",
		},
		escudo_da_fe = {
			nome = "Escudo da Fé",
			uso = "Di",
			acao = "mínima",
			origem = set("divino"),
			tipo_ataque = "explosão contígua 5",
			alvo = "você e seus aliados",
			efeito = "Efeito: até o FdEn, todos ganham +2 na CA.",
		},
		santuario = {
			nome = "Santuário",
			uso = "En",
			acao = "padrão",
			origem = set("divino"),
			tipo_ataque = "distância 10",
			alvo = "você ou outra criatura",
			efeito = "Efeito: o alvo recebe +5 em todas as defesas até que ataque ou até o FdPT.",
		},
	},
}
