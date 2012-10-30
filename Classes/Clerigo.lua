local set = require"DnD.Set"
local tipos_armas = require"DnD.TiposArmas"
local mod = require"DnD.Modificadores"

return {
	nome = "Cl�rigo",
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
------- Caracter�sticas de Classe ----------------------------------------------
		palavra_de_cura = {
			nome = "Palavra de Cura",
			uso = "En x2",
			acao = "m�nima",
			origem = set("cura", "divino"),
			tipo_ataque = "explos�o cont�gua 5",
			alvo = "voc� ou um aliado na explos�o",
			efeito = function(self)
				local dados = math.floor((self.nivel-1)/5) + 1
				return "O alvo gasta um PC e recupera +"..dados.."d6 + "..self.mod_sab.." PV adicionais."
			end,
		},
	},
	poderes = {
------- Poderes Sem Limite n�vel 1 ---------------------------------------------
		chama_sagrada = {
			nome = "Chama Sagrada",
			uso = "SL",
			acao = "padr�o",
			origem = set("divino", "implemento", "radiante"),
			tipo_ataque = "dist�ncia 5",
			alvo = "uma criatura",
			ataque = mod.sab,
			defesa = "Ref",
			dano = mod.dobra_21("1d6", "sabedoria", "Chama Sagrada"),
			efeito = function(self)
				local extra = math.floor(self.nivel/2) + self.mod_car
				return "Sucesso: um aliado na linha de vis�o escolhe entre receber "..extra.." PVT ou realizar um TR."
			end,
		},
		escudo_do_sacerdote = {
			nome = "Escudo do Sacerdote",
			uso = "SL",
			acao = "padr�o",
			origem = set("arma", "divino"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dobra_21("1[A]", "forca", "Escudo do Sacerdote"),
			efeito = "Sucesso: voc� e um aliado adjacente recebem +1 (poder) na CA at� o FdPT.",
		},
		lanca_da_fe = {
			nome = "Lan�a da F�",
			uso = "SL",
			acao = "padr�o",
			origem = set("implemento", "primitivo", "psiquico"),
			tipo_ataque = "dist�ncia 5",
			alvo = "uma criatura",
			ataque = mod.sab,
			defesa = "Ref",
			dano = mod.dobra_21("1d8", "sabedoria", "Lan�a da F�"),
			efeito = "Aliado na linha de vis�o recebe +2 (poder) no pr�ximo ataque contra o alvo.",
		},
		marca_da_integridade = {
			nome = "Marca da Integridade",
			uso = "SL",
			acao = "padr�o",
			origem = set("arma", "divino"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dobra_21("1[A]", "forca", "Marca da Integridade"),
			efeito = "Sucesso: aliado a at� 5 recebe +3 (poder) no ataque CaC contra o alvo at� o FdPT.",
		},
		pancada_de_recuperacao = {
			nome = "Pancada de Recupera��o",
			uso = "SL",
			acao = "padr�o",
			origem = set("arma", "cura", "divino"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dobra_21 ("1[A]", "forca", "Pancada de Recupera��o"),
			efeito = function(self)
				return "Sucesso: o pr�ximo aliado que acertar o alvo at� o FdPT, recupera "..self.mod_car.." PV."
			end,
		},
		selo_astral = {
			nome = "Selo Astral",
			uso = "SL",
			acao = "padr�o",
			origem = set("cura", "divino", "implemento"),
			tipo_ataque = "dist�ncia 5",
			alvo = "uma criatura",
			ataque = function(self)
				return self.mod_sab + 2
			end,
			defesa = "Ref",
			dano = '',
			efeito = function(self)
				return "Sucesso: at� o FdPT, o alvo sofre -2 em todas as defesas\n    e o pr�ximo aliado que acertar o alvo at� o FdPT recupera "..(self.mod_car+2).." PV."
			end,
		},
------- Poderes por Encontro n�vel 1 -------------------------------------------
		elocucao_exigente = {
			nome = "Elocu��o Exigente",
			uso = "En",
			acao = "padr�o",
			origem = set("divino", "implemento"),
			tipo_ataque = "dist�ncia 5",
			alvo = "uma criatura",
			ataque = mod.sabedoria,
			defesa = "Vont",
			dano = nil,
			efeito = function(self)
				return "Sucesso: at� o FdPT o alvo adquire vulnerabilidade "..self.mod_sab.." a todo tipo de dano\n    e todo aliado que acertar o alvo ganha "..self.mod_sab.." PVT."
			end,
		},
		golpe_restaurador = {
			nome = "Golpe Restaurador",
			uso = "En",
			acao = "padr�o",
			origem = set("arma", "cura", "divino", "radiante"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "forca", "Golpe Restaurador"),
			efeito = function(self)
				return "Sucesso: o alvo fica marcado at� o FdPT e voc� ou um aliado a at� 5 pode gastar um PC e recupera "..self.mod_sab.." PV adicionais."
			end,
		},
		luminescencia_divina = {
			nome = "Luminesc�ncia Divina",
			uso = "En",
			acao = "padr�o",
			origem = set("divino", "implemento", "radiante"),
			tipo_ataque = "rajada cont�gua 3",
			alvo = "inimigos na rajada",
			ataque = mod.sabedoria,
			defesa = "Ref",
			dano = mod.dado_mod("1d8", "sabedoria", "Luminesc�ncia Divina"),
			efeito = "Os aliados dentro da �rea recebem +2 nos ataques at� o FdPT.",
		},
		perdicao = {
			nome = "Perdi��o",
			uso = "En",
			acao = "padr�o",
			origem = set("divino", "implemento"),
			tipo_ataque = "dist�ncia 10",
			alvo = "uma criatura",
			ataque = mod.sabedoria,
			defesa = "Vont",
			dano = '',
			efeito = function(self)
				return "At� o FdPT, o alvo sofre -"..(1+self.mod_car).." de penalidade nos ataques e em todas as defesas."
			end,
		},
------- Poderes Di�rios n�vel 1 ------------------------------------------------
		cascata_de_luz = {
			nome = "Cascata de Luz",
			uso = "Di",
			acao = "padr�o",
			origem = set("divino", "implemento", "radiante"),
			tipo_ataque = "dist�ncia 10",
			alvo = "uma criatura",
			ataque = mod.sab,
			defesa = "Vont",
			dano = mod.dado_mod("3d8", "sabedoria", "Cascata de Luz"),
			efeito = "Sucesso: o alvo adquide vulnerabilidade 5 a todos os ataques do cl�rigo (TR).\nFracasso: metade do dano e n�o adquire a vulnerabilidade.",
		},
		chama_vingadora = {
			nome = "Chama Vingadora",
			uso = "Di",
			acao = "padr�o",
			origem = set("arma", "divino", "flamejante"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "forca", "Chama Vingadora"),
			efeito = "Sucesso: 5 de dano flamejante cont�nuo (TR) e se atacar no seu turno, n�o pode\n    realizar o TR.\nFracasso: metade do dano e nenhum dano cont�nuo.",
		},
		farol_da_esperanca = {
			nome = "Farol da Esperan�a",
			uso = "Di",
			acao = "padr�o",
			origem = set("cura", "divino", "implemento"),
			tipo_ataque = "explos�o cont�gua 3",
			alvo = "inimigos na explos�o",
			ataque = mod.sab,
			defesa = "Vont",
			efeito = function(self)
				return "Sucesso: os alvos ficam enfraquecidos at� o FdPT.\nEfeito: voc� e seus aliados recuperam 5 PV e seus poderes de cura restauram +5 PV adicionais no encontro."
			end,
		},
		guardiao_da_fe = {
			nome = "Guardi�o da F�",
			uso = "Di",
			acao = "padr�o",
			origem = set("conjuracao", "divino", "implemento", "radiante"),
			tipo_ataque = "dist�ncia 5",
			alvo = "inimigo adjacente ao guardi�o",
			ataque = mod.sab,
			defesa = "Fort",
			dano = mod.dado_mod("1d8", "sabedoria", "Guardi�o da F�"),
			efeito = "Efeito: conjura um guardi�o que ocupa 1 quadrado dentro do alcance. A cada\n    rodada, pode deslocar 3 (movimento). Ele luta at� o FdEn. Qualquer inimigo\n    que terminar o turno adjacente ao guardi�o, sofre um ataque.\n    As criaturas podem se deslocar atrav�s do espa�o dele.",
		},
------- Poderes Utilit�rios n�vel 2 --------------------------------------------
		auxilio_divino = {
			nome = "Aux�lio Divino",
			uso = "En",
			acao = "padr�o",
			origem = set("divino"),
			tipo_ataque = "dist�ncia 5",
			alvo = "voc� ou aliado",
			efeito = function (self)
				return "Efeito: o alvo realiza um TR com +"..self.mod_sab.." de b�nus."
			end,
		},
		bencao = {
			nome = "B�n��o",
			uso = "Di",
			acao = "m�nima",
			origem = set("divino"),
			tipo_ataque = "explos�o cont�gua 20",
			alvo = "voc� e seus aliados",
			efeito = "Efeito: at� o FdEn, todos ganham +1 nos ataques.",
		},
		curar_ferimentos_leves = {
			nome = "Curar Ferimentos Leves",
			uso = "Di",
			acao = "padr�o",
			origem = set("cura", "divino"),
			tipo_ataque = "toque",
			alvo = "voc� ou outra criatura",
			efeito = "Efeito: o alvo recura PV como se tivesse gasto um PC.",
		},
		escudo_da_fe = {
			nome = "Escudo da F�",
			uso = "Di",
			acao = "m�nima",
			origem = set("divino"),
			tipo_ataque = "explos�o cont�gua 5",
			alvo = "voc� e seus aliados",
			efeito = "Efeito: at� o FdEn, todos ganham +2 na CA.",
		},
		santuario = {
			nome = "Santu�rio",
			uso = "En",
			acao = "padr�o",
			origem = set("divino"),
			tipo_ataque = "dist�ncia 10",
			alvo = "voc� ou outra criatura",
			efeito = "Efeito: o alvo recebe +5 em todas as defesas at� que ataque ou at� o FdPT.",
		},
	},
}
