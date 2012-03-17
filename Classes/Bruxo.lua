local set = require"DnD.Set"
local soma_dano = require"DnD.Soma".soma
local armas = require"DnD.Armas"
local tipos_armas = require"DnD.TiposArmas"
local mod = require"DnD.Modificadores"

local categorias_dano = {
	uma_mao = {
		["1d4"] = "1d6",
		["1d6"] = "1d8",
		["1d8"] = "1d10",
		["1d10"] = "1d12",
		["1d12"] = "2d6",
		["2d6"] = "2d8",
		["2d8"] = "2d10",
	},
	duas_maos = {
		["1d8"] = "2d4",
		["2d4"] = "1d10",
		["1d10"] = "1d12",
		["1d12"] = "2d6",
		["2d6"] = "2d8",
		["2d8"] = "2d10",
	},
}

return {
	nome = "Bruxo",
	fonte_de_poder = "arcano",
	reflexos = 1,
	vontade = 1,
	armaduras = set("traje", "corselete"),
	armas = tipos_armas("corpo simples", "distancia simples"),
	implementos = set("bastao", "varinha"),
	pv = 12,
	pv_nivel = 5,
	pc_dia = 6,
	pericias = set("arcanismo", "blefe", "historia", "intimidacao", "intuicao", "ladinagem", "manha", "religiao"),
	total_pericias = 4,
	dano_adicional = function(self, dano, arma) -- Maldição do Bruxo
		return math.floor((self.nivel-1)/10).."d6"
	end,
	nome_adicional = "Maldição",
	caracteristicas_classe = {
------- Características de Classe ----------------------------------------------
	},
	poderes = {
------- Poderes Sem Limite nível 1 ---------------------------------------------
		olhar_pungente = {
			nome = "Olhar Pungente",
			uso = "SL",
			origem = set("arcano", "encanto", "implemento", "psíquico"),
			tipo_ataque = "distancia 10",
			alvo = "uma criatura",
			ataque = mod.carisma,
			defesa = "Vont",
			dano = mod.dobra_21("1d6", "carisma", "Olhar Pungente"),
			efeito = "O bruxo fica invisível para o alvo até o começo do seu próximo turno.",
		},
		radiancia_atroz = {
			nome = "Radiância Atroz",
			uso = "SL",
			acao = "padrão",
			origem = set("arcano", "implemento", "medo", "radiante"),
			tipo_ataque = "distancia 10",
			alvo = "uma criatura",
			ataque = mod.constituicao,
			defesa = "Fort",
			dano = mod.dobra_21("1d6", "constituicao", "Radiância Atroz"),
			efeito = function(self)
				local extra = soma_dano(self, "1d6", self.mod_con, "Radiância Atroz")
				return "Se o alvo se aproximar do bruxo no seu próximo turno, sofre +"..extra.."."
			end,
		},
		rajada_mistica = {
			nome = "Rajada Mística",
			uso = "SL",
			acao = "padrão",
			origem = set("arcano", "implemento"),
			tipo_ataque = "distancia 10",
			alvo = "uma criatura",
			ataque = function(self)
				return math.max (self.mod_con, self.mod_car)
			end,
			defesa = "Refl",
			dano = function(self)
				local d = (self.nivel >= 21) and "2d10" or "1d10"
				local mod = math.max (self.mod_con, self.mod_car)
				return soma_dano(self, d, mod, "Rajada Mística")
			end,
			efeito = "Pode ser usado como ataque básico à distância.",
		},
		reprimenda_infernal = {
			nome = "Reprimenda Infernal",
			uso = "SL",
			acao = "padrão",
			origem = set("arcano", "flamejante", "implemento"),
			tipo_ataque = "distancia 10",
			alvo = "uma criatura",
			ataque = mod.constituicao,
			defesa = "Refl",
			dano = mod.dobra_21("1d6", "constituicao", "Reprimenda Infernal"),
			efeito = function(self)
				local extra = soma_dano(self, "1d6", self.mod_con, "Reprimenda Infernal")
				return "Se o bruxo sofrer dano antes do FdPT, o alvo sofre +"..extra.."."
			end,
 		},
		glamour_vingativo = {
			nome = "Glamour Vingativo",
			uso = "SL",
			acao = "padrão",
			origem = set("arcano", "implemento", "psíquico"),
			tipo_ataque = "distancia 10",
			alvo = "uma criatura",
			ataque = mod.carisma,
			defesa = "Vont",
			dano = mod.dobra_21("1d8", "carisma", "Glamour Vingativo"),
			efeito = "Se o alvo estiver com o máximo de PV, o dado de dano é um d12.",
		},
------- Poderes por Encontro nível 1 -------------------------------------------
		lancar_peconha = {
			nome = "Lançar Peçonha",
			uso = "En",
			acao = "padrão",
			origem = set("arcano", "energético", "implemento", "venenoso"),
			tipo_ataque = function(self)
				if self.caracteristica_classe:match"[Oo]bscuro" then
					return "distancia 10"
				else
					return "distancia 5"
				end
			end,
			alvo = "uma criatura",
			ataque = mod.carisma,
			defesa = "Refl",
			dano = mod.dado_mod("2d8", "carisma", "Lançar Peçonha"),
			efeito = function(self)
				return "Se conceder VdC, o alvo sofre ainda "..self.mod_int.." de dano venenoso."
			end,
		},
		maldicao_pungente = {
			nome = "Maldição Pungente",
			uso = "En",
			acao = "padrão",
			origem = set("arcano", "implemento", "necrotico"),
			tipo_ataque = "explosão contígua 20",
			alvo = "criaturas dentro da explosão",
			ataque = mod.carisma,
			defesa = "Fort",
			dano = function(self)
				if self.pacto_obscuro then
					return soma_dano(self, "2d8", self.mod_int, "Maldição Pungente")
				else
					return "2d8"
				end
			end,
		},
		abraco_vampirico = {
			nome = "Abraço Vampírico",
			uso = "En",
			acao = "padrão",
			origem = set("arcano", "implemento", "necrotico"),
			tipo_ataque = "distância 5",
			alvo = "uma criatura",
			ataque = mod.carisma,
			defesa = "Vont",
			dano = mod.dado_mod("2d8", "constituicao", "Abraço Vampírico"),
			efeito = function(self)
				local pvt = 5
				if self.pacto_infernal then
					pvt = 5+self.mod_int
				end
				return "Você recebe "..pvt.." PVT."
			end
		},
		aperto_diabolico = {
			nome = "Aperto Diabólico",
			uso = "En",
			acao = "padrão",
			origem = set("arcano", "implemento"),
			tipo_ataque = "distância 10",
			alvo = "uma criatura Grande ou menor",
			ataque = mod.constituicao,
			defesa = "Fort",
			dano = mod.dado_mod("2d8", "constituicao", "Aperto Diabólico"),
			efeito = function(self)
				local q = 2
				if self.pacto_infernal then
					q = 1+self.mod_int
				end
				return "O alvo é conduzido "..q.." quadrados."
			end
		},
		fogo_das_bruxas = {
			nome = "Fogo das Bruxas",
			uso = "En",
			acao = "padrão",
			origem = set("arcano", "flamejante", "implemento"),
			tipo_ataque = "distância 10",
			alvo = "uma criatura",
			ataque = mod.carisma,
			defesa = "Refl",
			dano = mod.dado_mod("2d6", "carisma", "Fogo das Bruxas"),
			efeito = function(self)
				local p = 2
				if self.pacto_feerico then
					p = 2+self.mod_int
				end
				return "O alvo sofre -"..p.." de penalidade nos ataques, até o FdPT do bruxo."
			end
		},
		palavra_pavorosa = {
			nome = "Palavra Pavorosa",
			uso = "En",
			acao = "padrão",
			origem = set("arcano", "implemento", "medo", "psíquico"),
			tipo_ataque = "distância 5",
			alvo = "uma criatura",
			ataque = mod.carisma,
			defesa = "Vont",
			dano = mod.dado_mod("2d8", "carisma", "Palavra Pavorosa"),
			efeito = function(self)
				local p = 1
				if self.pacto_estelar then
					p = 1+self.mod_int
				end
				return "O alvo sofre -"..p.." de penalidade em Vontade, até o FdPT do bruxo."
			end
		},
------- Poderes Diários nível 1 ------------------------------------------------
		armadura_de_agathys = {
			nome = "Armadura de Agathys",
			uso = "Di",
			acao = "padrão",
			origem = set("arcano", "congelante"),
			tipo_ataque = "pessoal",
			alvo = "pessoal",
			efeito = function(self)
				return "O bruxo recebe "..(10+self.mod_int).." PVT.\nAté o final do encontro, os inimigos que começarem o turno adjacentes sofrem 1d6+"..self.mod_con.." de dano congelante."
			end
		},
		chamas_do_flegetonte = {
			nome = "Chamas do Flegetonte",
			uso = "Di",
			acao = "padrão",
			origem = set("arcano", "flamejante", "implemento"),
			tipo_ataque = "distância 10",
			alvo = "uma criatura",
			ataque = mod.constituicao,
			defesa = "Refl",
			dano = mod.dado_mod("3d10", "constituicao", "Chamas do Flegetonte"),
			efeito = "O alvo sofre 5 de dano flamejante contínuo (TR encerra).",
		},
		estrela_aterradora = {
			nome = "Estrela Aterradora",
			uso = "Di",
			acao = "padrão",
			origem = set("arcano", "implemento", "medo", "radiante"),
			tipo_ataque = "distância 10",
			alvo = "uma criatura",
			ataque = mod.carisma,
			defesa = "Vont",
			dano = mod.dado_mod("3d6", "carisma", "Chamas do Flegetonte"),
			efeito = "Se acertar, o alvo fica imobilizado até o final do próximo turno.\nO alvo sofre -2 de penalidade na defesa de Vontade (TR encerra).",
		},
		maldicao_do_sonho_obscuro = {
			nome = "Maldição do Sonho Obscuro",
			uso = "Di",
			acao = "padrão",
			origem = set("arcano", "encanto", "implemento", "psíquico"),
			tipo_ataque = "distância 10",
			alvo = "uma criatura",
			ataque = mod.carisma,
			defesa = "Vont",
			dano = mod.dado_mod("3d8", "carisma", "Chamas do Flegetonte"),
			efeito = "Se acertar, o alvo é conduzido 3 quadrados.\nCom uma ação mínima, o bruxo pode conduzir o alvo 1 quadrado por rodada (TR encerra).",
		},
		contagio = {
			nome = "Contágio",
			uso = "Di",
			acao = "padrão",
			origem = set("arcano", "implemento", "venenoso"),
			tipo_ataque = "distância 10",
			alvo = "uma criatura",
			ataque = mod.carisma,
			defesa = "Fort",
			dano = function(self)
				return 10
			end,
			efeito = function (self)
				local alcance = 2
				if self.pacto_obscuro then
					alcance = 2+self.mod_int
				end
				return "Na primeira vez que o alvo fracassar no TR, os inimigos a até "..alcance.." do alvo sofrem\n   5 de dano contínuo (TR encerra).\nFracasso: 5 de dano venenoso contínuo (TR encerra) e não se espalha."
			end,
		},
		vosso_grandioso_sacrificio = {
			nome = "Vosso Grandioso Sacrifício",
			uso = "Di",
			acao = "padrão",
			origem = set("arcano", "implemento", "necrótico", "venenoso"),
			tipo_ataque = "distância 10",
			alvo = "uma criatura",
			ataque = mod.carisma,
			defesa = "Fort",
			dano = mod.dado_mod("3d8", "carisma", "Vosso Grandioso Sacrifício"),
			efeito = function (self)
				local continuo = self.mod_car
				if self.pacto_obscuro then
					continuo = self.mod_car + self.mod_int
				end
				return "Antes do ataque, o bruxo pode causar "..self.mod_car.." de dano a um aliado adjacente, ganhando +2 de bônus no ataque e causando +"..continuo.." de dano venenoso contínuo (TR encerra)."
			end,
		},
------- Poderes Utilitários nível 2 --------------------------------------------
		efugio_da_aranha = {
			nome = "Efúgio da Aranha",
			uso = "En",
			acao = "padrão",
			origem = set("arcano"),
			tipo_ataque = "pessoal",
			alvo = "pessoal",
			efeito = "Adquire deslocamento de escalada igual ao deslocamento normal, mesmo se estiver\nderrubado, até o FdPT.",
		},
------- Poderes por Encontro nível 3 -------------------------------------------
		vossa_deliciosa_fraqueza = {
			nome = "Vossa Deliciosa Fraqueza",
			uso = "En",
			acao = "padrão",
			origem = set("arcano", "implemento", "psíquico"),
			tipo_ataque = "distância 10",
			alvo = "uma criatura",
			ataque = mod.carisma,
			defesa = "Refl",
			dano = mod.dado_mod("2d6", "carisma", "Vossa Deliciosa Fraqueza"),
			efeito = function(self)
				local adicional = ""
				if self.pacto_obscuro then
					adicional = " e +"..self.mod_int.." de dano psíquico"
				end
				return "Se o alvo for vulnerável a um tipo específico de dano, este ataque causa dano\ndeste tipo (se forem vários, o bruxo escolhe)"..adicional.."."
			end,
		},
		travessia_eterea = {
			nome = "Travessia Etérea",
			uso = "En",
			acao = "movimento",
			origem = set("arcano", "teleporte"),
			tipo_ataque = "pessoal",
			efeito = "Teleporta 3 quadrados e recebe +2 de bônus em todas as defesas até o FdPT.",
		},
		raio_igneo = {
			nome = "Raio Ígneo",
			uso = "En",
			acao = "padrão",
			origem = set("arcano", "flamejante", "implemento"),
			tipo_ataque = "distância 10",
			alvo = "uma criatura",
			ataque = mod.constituicao,
			defesa = "Refl",
			dano = mod.dado_mod("3d6", "constituicao", "Raio Ígneo"),
			efeito = function(self)
				local dano = soma_dano(self, "1d6", self.mod_con, "Raio Ígneo")
				if self.pacto_infernal then
					dano = soma_dano(self, dano, self.mod_int, "Raio Ígneo")
				end
				return "Criaturas adjacentes sofrem "..dano.." de dano flamejante."
			end,
		},
	},
}
