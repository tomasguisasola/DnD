local mod = require"DnD.Modificadores"
local set = require"DnD.Set"
local tipos_armas = require"DnD.TiposArmas"

return {
	nome = "Missionario",
	fonte_de_poder = "divino",
	vontade = 2,
	armaduras = set("traje", "corselete"),
	armas = { adaga = true, bordao = true, },
	implementos = { cajado = true, simbolo_sagrado = true, },
	pv = 12,
	pv_nivel = 5,
	pc_dia = 7,
	pericias = {
		religiao = "treinada",
		arcanismo = true,
		blefe = true,
		diplomacia = true,
		historia = true,
		intuicao = true,
		religiao = true,
		socorro = true,
	},
	total_pericias = 3,
	caracteristicas_classe = {
------- Caracter�sticas de Classe ----------------------------------------------
		palavra_de_cura = {
			nome = "Palavra de Cura",
			uso = "En",
			origem = set("divino"),
			tipo_ataque = "explos�o cont�gua 5",
			acao = "m�nima",
			alvo = "o personagem ou um aliado",
			efeito = function(self)
				return "Efeito: o alvo pode gastar um PC e recupera +"..self.mod_sab.." PV adicionais.\n    O alvo tamb�m pode ser conduzido 1 quadrado."
			end,
		},
		palavra_de_conversao = {
			nome = "Palavra de Convers�o",
			uso = "SL",
			origem = set("divino", "implemento"),
			tipo_ataque = "toque CaC",
			acao = "padr�o",
			alvo = "uma criatura",
			ataque = mod.sab,
			defesa = "Vont",
			dano = 0,
			efeito = "Efeito: a criatura � convertida, sai de combate e o mission�rio acumula +1 ponto\n    na sua aura divina.",
		},
	},
	poderes = {
------- Poderes Sem Limite n�vel 1 ---------------------------------------------
		algemas_trovejantes = {
			nome = "Algemas Trovejantes",
			uso = "SL",
			acao = "padr�o",
			origem = set("divino", "implemento", "trovejante"),
			tipo_ataque = "dist�ncia 10",
			alvo = "uma criatura",
			ataque = mod.sab,
			defesa = "Vont",
			dano = 0,
			efeito = function(self)
				local penalidade = self.mod_int
				return "Sucesso: o alvo sofre -"..penalidade.." de penalidade nas jogadas de ataque at� o FdPT."
			end,
		},
		explosao_divina = {
			nome = "Explos�o Divina",
			uso = "SL",
			acao = "padr�o",
			origem = set("divino", "implemento", "radiante"),
			tipo_ataque = "explos�o cont�gua 1",
			alvo = "uma criatura",
			ataque = mod.sab,
			defesa = "Fort",
			dano = 0,
			efeito = "Sucesso: alvos ficam derrubados.",
		},
		nocaute_da_fe = {
			nome = "Nocaute da F�",
			uso = "SL",
			acao = "padr�o",
			tipo_ataque = "dist�ncia 10",
			alvo = "uma criatura",
			origem = set("divino", "implemento"),
			ataque = mod.sab,
			defesa = "Vont",
			dano = 0,
			efeito = function (self)
				local penalidade = self.mod_car
				return "Sucesso: o alvo sofre -"..penalidade.." na CA at� o FdPT."
			end,
		},
		palavra_congelante = {
			nome = "Palavra Congelante",
			uso = "SL",
			acao = "padr�o",
			tipo_ataque = "dist�ncia 10",
			alvo = "duas criaturas at� 3 uma da outra",
			origem = set("congelante", "divino", "implemento"),
			ataque = mod.sab,
			defesa = "Ref",
			dano = 0,
			efeito = "Sucesso: alvos ficam lentos at� o FdPT.",
		},
		pregacao_enfraquecedora = {
			nome = "Prega��o Enfraquecedora",
			uso = "SL",
			acao = "padr�o",
			tipo_ataque = "toque CaC",
			alvo = "uma criatura",
			origem = set("divino", "implemento", "radiante"),
			ataque = mod.sab,
			defesa = "Vont",
			dano = 0,
			efeito = "Sucesso: alvo fica enfraquecido at� o FdPT.",
		},
------- Poderes por Encontro n�vel 1 -------------------------------------------
		palavra_restauradora = {
			nome = "Palavra Restauradora",
			uso = "En",
			acao = "padr�o",
			tipo_ataque = "dist�ncia 10",
			alvo = "uma criatura",
			origem = set("cura", "divino", "implemento", "radiante"),
			ataque = mod.sab,
			defesa = "Vont",
			dano = 0,
			efeito = "Sucesso: alvo fica atordoado at� o FdPT e o personagem ou um aliado a at� 5\n    pode gastar um PC.",
		},
		prece_revigorante = {
			nome = "Prece Revigorante",
			uso = "En",
			acao = "padr�o",
			tipo_ataque = "toque CaC",
			alvo = "uma criatura",
			origem = set("cura", "divino", "implemento", "radiante"),
			ataque = mod.sab,
			defesa = "Vont",
			dano = 0,
			efeito = function (self)
				return "Sucesso: alvo sofre -2 de penalidade nos ataques (TR) e o personagem adquire regenera��o "..self.mod_int.." enquanto o alvo sofrer a penalidade."
			end,
		},
		luz_divina = {
			nome = "Luz Divina",
			uso = "En",
			acao = "padr�o",
			tipo_ataque = "dist�ncia 10",
			alvo = "uma criatura",
			origem = set("divino", "implemento", "radiante"),
			ataque = mod.sab,
			defesa = "Ref",
			dano = 0,
			efeito = "Sucesso: o alvo fica lento e enfraquecido (TR).",
		},
------- Poderes Di�rios n�vel 1 ------------------------------------------------
		dominacao = {
			nome = "Domina��o",
			uso = "Di",
			acao = "m�nima",
			tipo_ataque = "corpo",
			alvo = "uma criatura convertida",
			origem = set("divino", "implemento"),
			ataque = mod.sab,
			defesa = "Vont",
			dano = 0,
			efeito = "Sucesso: o alvo fica dominado at� o FdPT. O personagem pode transferir uma de\n    suas a��es ao alvo durante o seu turno. Sustenta��o m�nima.",
		},
		salva��o = {
			nome = "Salva��o",
			uso = "Di",
			acao = "padr�o",
			tipo_ataque = "dist�ncia 10",
			alvo = "uma criatura",
			origem = set("cura", "divino", "implemento"),
			ataque = mod.sab,
			defesa = "Vont",
			dano = 0,
			efeito = function(self)
				local bonus = ''
				if self.caracteristica_classe:lower()match"carism" then
					bonus = " e recupera "..self.mod_car.." PV adicionais"
				end
				return "Sucesso: o alvo � conduzido 2 quadrados e fica impedido (TR). Aliado adjacente\n    ao alvo (antes da condu��o) pode gastar um PC"..bonus.."."
			end,
		},
		submissao = {
			nome = "Submiss�o",
			uso = "Di",
			acao = "padr�o",
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			origem = set("divino", "implemento"),
			ataque = mod.sab,
			defesa = "Vont",
			dano = 0,
			efeito = "Sucesso: o alvo fica indefeso (TR).",
		},
------- Poderes Utilit�rios n�vel 2 --------------------------------------------
		aura_do_missionario = {
			nome = "Aura do Mission�rio",
			uso = "Di",
			acao = "m�nima",
			tipo_ataque = "explos�o cont�gua 5",
			alvo = "personagem e aliados",
			origem = set("aura", "cura", "divino"),
			efeito = function (self)
				local regeneracao = math.floor(self.mod_int / 2)
				return "Efeito: os alvos na �rea de efeito adquirem regenera��o "..regeneracao.."."
			end,
		},
		bencao_do_missionario = {
			nome = "B�n��o do Mission�rio",
			uso = "En",
			acao = "m�nima",
			tipo_ataque = "dist�ncia 5",
			alvo = "aliado",
			origem = set("cura", "divino"),
			efeito = function (self)
				local regeneracao = self.mod_car
				return "Efeito: o alvo adquire regenera��o "..regeneracao.." at� o FdEn sempre que estiver sangrando."
			end,
		},
		vinganca_da_fe = {
			nome = "Vingan�a da F�",
			uso = "En",
			acao = "RI",
			tipo_ataque = "pessoal",
			alvo = "pessoal",
			origem = set("divino"),
			efeito = "Efeito: (s� quando o mission�rio for atingido por um At CaC) o inimigo que ativou o gatilho fica pasmo at� o FdPT.",
		},
------- Poderes por Encontro n�vel 3 -------------------------------------------
------- Poderes Di�rios n�vel 5 ------------------------------------------------
	},
}
