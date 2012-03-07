local set = require"DnD.Set"
local soma_dano = require"DnD.Soma".soma
local armas = require"DnD.Armas"
local tipos_armas = require"DnD.TiposArmas"
local mod = require"DnD.Modificadores"

return {
	nome = "L�mina Arcana",
	fonte_de_poder = "arcano",
	vontade = 2,
	armaduras = set("traje", "corselete"),
	armas = tipos_armas("corpo simples", "lamina_leve", "lamina_pesada", "distancia simples"),
	implementos = {
		lamina_leve = true,
		lamina_pesada = true,
	},
	pv = 15,
	pv_nivel = 6,
	pc_dia = 8,
	pericias = {
		arcanismo = "treinada",
		atletismo = true,
		diplomacia = true,
		historia = true,
		intimidacao = true,
		intuicao = true,
		tolerancia = true,
	},
	--talentos = set"conjuracao_ritual",
	total_pericias = 3,
	caracteristicas_classe = {},
	poderes = {
		misseis_magicos = {
			nome = "M�sseis M�gicos",
			uso = "SL",
			origem = set("arcano", "energetico", "implemento"),
			tipo_ataque = "distancia 20",
			alvo = "Uma criatura",
			--ataque = "Sempre acerta",
			dano = function(self)
				if self.nivel >= 21 then
					return soma_dano(self, "4", self.mod_int, "Misseis M�gicos")
				elseif self.nivel >= 11 then
					return soma_dano(self, "3", self.mod_int, "Misseis M�gicos")
				else
					return soma_dano(self, "2", self.mod_int, "Misseis M�gicos")
				end
			end,
		},
		nuvem_de_adagas = {
			nome = "Nuvem de Adagas",
			uso = "SL",
			origem = set("arcano", "energetico", "implemento"),
			tipo_ataque = "explos�o de �rea 1 a at� 10 quadrados",
			alvo = "criaturas na �rea",
			efeito = function(self)
				return "Quem entrar ou come�ar o turno dentro da �rea, sofre dano energ�tico "..math.max(self.mod_sab, 1)..".\nA nuvem permanece at� o final do pr�ximo turno ou at� dissip�-la (a��o m�nima)."
			end,
			ataque = mod.inteligencia,
			defesa = "Refl",
			dano = mod.dobra_21("1d6", "inteligencia", "Nuvem de Adagas"),
		},
		onda_trovejante = {
			nome = "Onda Trovejante",
			uso = "SL",
			origem = set("arcano", "implemento", "trovejante"),
			tipo_ataque = "rajada cont�gua 3",
			alvo = "criaturas na rajada",
			ataque = mod.inteligencia,
			defesa = "For",
			dano = mod.dobra_21("1d6", "inteligencia", "Onda Trovejante"),
			efeito = function(self)
				return "Alvos atingidos s�o empurrados "..math.max(1, self.mod_sab).." quadrados."
			end,
		},
		orbe_de_energia = {
			nome = "Orbe de Energia",
			uso = "En",
			origem = set("arcano", "energ�tico", "implemento"),
			tipo_ataque = "dist�ncia 20",
			alvo = "uma criatura ou objeto",
			efeito = function(self)
				return "Ataque secund�rio contra um alvo adjacente ao prim�rio (Reflexos) -> "..soma_dano(self, "1d10", self.mod_int, "Orbe de Energia")
			end,
			ataque = mod.inteligencia,
			defesa = "Ref",
			dano = mod.dado_mod("2d8", "inteligencia", "Orbe de Energia"),
		},
		terreno_gelido = {
			nome = "Terreno G�lido",
			uso = "En",
			origem = set("arcano", "congelante", "implemento"),
			tipo_ataque = "explos�o de �rea 1 a at� 10 quadrados",
			alvo = "criaturas na �rea",
			efeito = "Alvos atingidos s�o derrubadas.\nTerreno acidentado at� o final do pr�ximo turno, ou at� dissip�-la (m�nima).",
			ataque = function(self) return self.mod_int end,
			defesa = "Ref",
			dano = function(self)
				return soma_dano(self, "1d6", self.mod_int, "Terreno G�lido")
			end,
		},
		esfera_flamejante = {
			nome = "Esfera Flamejante",
			uso = "Di",
			origem = set("arcano", "conjuracao", "flamejante", "implemento"),
			tipo_ataque = "distancia 10",
			alvo = "criatura adjacente � esfera",
			efeito = function(self)
				return "Criaturas que come�arem o turno adjacente � esfera sofrem 1d4+"..self.mod_int.." (flamejante).\nDeslocamento da esfera = 6.  Persiste at� o final do encontro."
			end,
			ataque = function(self) return self.mod_int end,
			defesa = "Ref",
			dano = function(self)
				return soma_dano(self, "2d6", self.mod_int, "Esfera Flamejante")
			end,
		},
		nuvem_congelante = {
			nome = "Nuvem Congelante",
			uso = "Di",
			origem = set("arcano", "congelante", "implemento"),
			tipo_ataque = "explos�o de �rea 2 a at� 10 quadrados",
			alvo = "criaturas na �rea",
			efeito = "Criaturas que entram ou come�am o turno na �rea, s�o alvos de novos ataques.\nPersiste at� o final do pr�ximo turno ou at� dissip�-la (m�nima).",
			ataque = function(self) return self.mod_int end,
			defesa = "Fort",
			dano = function(self)
				return soma_dano(self, "1d8", self.mod_int, "Nuvem Congelante")
			end,
			fracasso = "metade do dano",
		},
		sono = {
			nome = "Sono",
			uso = "Di",
			origem = set("arcano", "implemento", "sono"),
			tipo_ataque = "explos�o de �rea 2 a at� 20 quadrados",
			alvo = "criaturas na �rea",
			efeito = "Alvo fica lento (TR encerra ou deixa o alvo inconsciente; 2o. TR volta a lento)",
			ataque = function(self) return self.mod_int end,
			defesa = "Von",
			dano = nil,
			fracasso = "Alvo fica lento (TR encerra)",
		},
		escudo_arcano = {
			nome = "Escudo Arcano",
			uso = "En",
			origem = set("arcano", "energetico"),
			tipo_ataque = "pessoal",
			alvo = "O personagem",
			gatilho = "Quando o personagem � atingido por um ataque",
			efeito = "CA <- +4, Reflexos <- +4.  At� o final do pr�ximo turno",
		},
		queda_suave = {
			nome = "Queda Suave",
			uso = "Di",
			origem = set("arcano"),
			tipo_ataque = "distancia 10",
			alvo = "O personagem ou uma criatura",
			efeito = "Ignora o dano da queda e n�o fica derrubado",
		},
		recuo_acelerado = {
			nome = "Recuo Acelerado",
			uso = "Di",
			origem = set("arcano"),
			tipo_ataque = "pessoal",
			alvo = "O personagem",
			efeito = function(self)
				return "Ajuste at� "..(2*self.deslocamento)
			end,
		},
		salto = {
			nome = "Salto",
			uso = "En",
			origem = set("arcano"),
			tipo_ataque = "distancia 10",
			alvo = "O personagem ou uma criatura",
			efeito = "Realize um teste de Atletismo com +10 e considere com impulso, mesmo sem deslocamento.",
		},
		esfera_de_choque = {
			nome = "Esfera de Choque",
			uso = "En",
			origem = set("arcano", "el�trico", "implemento"),
			tipo_ataque = "explos�o de �rea 2 a at� 10 quadrados",
			alvo = "criaturas na �rea",
			ataque = function(self) return self.mod_int end,
			defesa = "Refl",
			dano = function(self)
				return soma_dano(self, "2d6", self.mod_int, "Esfera de Choque")
			end,
		},
		leque_cromatico = {
			nome = "Leque Crom�tico",
			uso = "En",
			origem = set("arcano", "implemento", "radiante"),
			tipo_ataque = "rajada 5",
			alvo = "criaturas na rajada",
			ataque = function(self) return self.mod_int end,
			defesa = "Vont",
			dano = function(self)
				return soma_dano(self, "1d6", self.mod_int, "Leque Crom�tico")
			end,
			efeito = "Alvos ficam pasmos at� o final do pr�ximo turno.",
		},
	},
}
