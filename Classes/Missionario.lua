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
------- Características de Classe ----------------------------------------------
		palavra_de_cura = {
			nome = "Palavra de Cura",
			uso = "En",
			origem = set("divino"),
			tipo_ataque = "explosão contígua 5",
			acao = "mínima",
			alvo = "o personagem ou um aliado",
			efeito = function(self)
				return "Efeito: o alvo pode gastar um PC e recupera +"..self.mod_sab.." PV adicionais.\n    O alvo também pode ser conduzido 1 quadrado."
			end,
		},
		palavra_de_conversao = {
			nome = "Palavra de Conversão",
			uso = "SL",
			origem = set("divino", "implemento"),
			tipo_ataque = "toque CaC",
			acao = "padrão",
			alvo = "uma criatura",
			ataque = mod.sab,
			defesa = "Vont",
			dano = 0,
			efeito = "Efeito: a criatura é convertida, sai de combate e o missionário acumula +1 ponto\n    na sua aura divina.",
		},
	},
	poderes = {
------- Poderes Sem Limite nível 1 ---------------------------------------------
		algemas_trovejantes = {
			nome = "Algemas Trovejantes",
			uso = "SL",
			acao = "padrão",
			origem = set("divino", "implemento", "trovejante"),
			tipo_ataque = "distância 10",
			alvo = "uma criatura",
			ataque = mod.sab,
			defesa = "Vont",
			dano = 0,
			efeito = function(self)
				local penalidade = self.mod_int
				return "Sucesso: o alvo sofre -"..penalidade.." de penalidade nas jogadas de ataque até o FdPT."
			end,
		},
		explosao_divina = {
			nome = "Explosão Divina",
			uso = "SL",
			acao = "padrão",
			origem = set("divino", "implemento", "radiante"),
			tipo_ataque = "explosão contígua 1",
			alvo = "uma criatura",
			ataque = mod.sab,
			defesa = "Fort",
			dano = 0,
			efeito = "Sucesso: alvos ficam derrubados.",
		},
		nocaute_da_fe = {
			nome = "Nocaute da Fé",
			uso = "SL",
			acao = "padrão",
			tipo_ataque = "distância 10",
			alvo = "uma criatura",
			origem = set("divino", "implemento"),
			ataque = mod.sab,
			defesa = "Vont",
			dano = 0,
			efeito = function (self)
				local penalidade = self.mod_car
				return "Sucesso: o alvo sofre -"..penalidade.." na CA até o FdPT."
			end,
		},
		palavra_congelante = {
			nome = "Palavra Congelante",
			uso = "SL",
			acao = "padrão",
			tipo_ataque = "distância 10",
			alvo = "duas criaturas até 3 uma da outra",
			origem = set("congelante", "divino", "implemento"),
			ataque = mod.sab,
			defesa = "Ref",
			dano = 0,
			efeito = "Sucesso: alvos ficam lentos até o FdPT.",
		},
		pregacao_enfraquecedora = {
			nome = "Pregação Enfraquecedora",
			uso = "SL",
			acao = "padrão",
			tipo_ataque = "toque CaC",
			alvo = "uma criatura",
			origem = set("divino", "implemento", "radiante"),
			ataque = mod.sab,
			defesa = "Vont",
			dano = 0,
			efeito = "Sucesso: alvo fica enfraquecido até o FdPT.",
		},
------- Poderes por Encontro nível 1 -------------------------------------------
		palavra_restauradora = {
			nome = "Palavra Restauradora",
			uso = "En",
			acao = "padrão",
			tipo_ataque = "distância 10",
			alvo = "uma criatura",
			origem = set("cura", "divino", "implemento", "radiante"),
			ataque = mod.sab,
			defesa = "Vont",
			dano = 0,
			efeito = "Sucesso: alvo fica atordoado até o FdPT e o personagem ou um aliado a até 5\n    pode gastar um PC.",
		},
		prece_revigorante = {
			nome = "Prece Revigorante",
			uso = "En",
			acao = "padrão",
			tipo_ataque = "toque CaC",
			alvo = "uma criatura",
			origem = set("cura", "divino", "implemento", "radiante"),
			ataque = mod.sab,
			defesa = "Vont",
			dano = 0,
			efeito = function (self)
				return "Sucesso: alvo sofre -2 de penalidade nos ataques (TR) e o personagem adquire regeneração "..self.mod_int.." enquanto o alvo sofrer a penalidade."
			end,
		},
		luz_divina = {
			nome = "Luz Divina",
			uso = "En",
			acao = "padrão",
			tipo_ataque = "distância 10",
			alvo = "uma criatura",
			origem = set("divino", "implemento", "radiante"),
			ataque = mod.sab,
			defesa = "Ref",
			dano = 0,
			efeito = "Sucesso: o alvo fica lento e enfraquecido (TR).",
		},
------- Poderes Diários nível 1 ------------------------------------------------
		dominacao = {
			nome = "Dominação",
			uso = "Di",
			acao = "mínima",
			tipo_ataque = "corpo",
			alvo = "uma criatura convertida",
			origem = set("divino", "implemento"),
			ataque = mod.sab,
			defesa = "Vont",
			dano = 0,
			efeito = "Sucesso: o alvo fica dominado até o FdPT. O personagem pode transferir uma de\n    suas ações ao alvo durante o seu turno. Sustentação mínima.",
		},
		salvação = {
			nome = "Salvação",
			uso = "Di",
			acao = "padrão",
			tipo_ataque = "distância 10",
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
				return "Sucesso: o alvo é conduzido 2 quadrados e fica impedido (TR). Aliado adjacente\n    ao alvo (antes da condução) pode gastar um PC"..bonus.."."
			end,
		},
		submissao = {
			nome = "Submissão",
			uso = "Di",
			acao = "padrão",
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			origem = set("divino", "implemento"),
			ataque = mod.sab,
			defesa = "Vont",
			dano = 0,
			efeito = "Sucesso: o alvo fica indefeso (TR).",
		},
------- Poderes Utilitários nível 2 --------------------------------------------
		aura_do_missionario = {
			nome = "Aura do Missionário",
			uso = "Di",
			acao = "mínima",
			tipo_ataque = "explosão contígua 5",
			alvo = "personagem e aliados",
			origem = set("aura", "cura", "divino"),
			efeito = function (self)
				local regeneracao = math.floor(self.mod_int / 2)
				return "Efeito: os alvos na área de efeito adquirem regeneração "..regeneracao.."."
			end,
		},
		bencao_do_missionario = {
			nome = "Bênção do Missionário",
			uso = "En",
			acao = "mínima",
			tipo_ataque = "distância 5",
			alvo = "aliado",
			origem = set("cura", "divino"),
			efeito = function (self)
				local regeneracao = self.mod_car
				return "Efeito: o alvo adquire regeneração "..regeneracao.." até o FdEn sempre que estiver sangrando."
			end,
		},
		vinganca_da_fe = {
			nome = "Vingança da Fé",
			uso = "En",
			acao = "RI",
			tipo_ataque = "pessoal",
			alvo = "pessoal",
			origem = set("divino"),
			efeito = "Efeito: (só quando o missionário for atingido por um At CaC) o inimigo que ativou o gatilho fica pasmo até o FdPT.",
		},
------- Poderes por Encontro nível 3 -------------------------------------------
------- Poderes Diários nível 5 ------------------------------------------------
	},
}
