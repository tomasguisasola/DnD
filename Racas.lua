local set = require"DnD.Set"

return {
	anao = {
		constituicao = 2,
		sabedoria = 2,
		deslocamento = 5,
		armas = { martelo_de_arremesso = true, martelo_de_guerra = true, },
		pericias = {
			exploracao = 2,
			tolerancia = 2,
		},
		poderes = {},
	},
	deva = {
		inteligencia = 2,
		sabedoria = 2,
		deslocamento = 6,
		pericias = {
			historia = 2,
			religiao = 2,
		},
		poderes = {
			memorias_de_mil_vidas = {
				nome = "Mem�rias de mil vidas",
				uso = "Encontro",
				origem = {},
				tipo_ataque = "utilitario",
				alvo = "pessoal",
				efeito = function(self)
					local dado = self.dado_memorias or "d6"
					return "O personagem acrescenta o resultado de um "..dado.." � sua �ltima jogada de d20."
				end,
			},
		},
	},
	draconato = {
		forca = 2,
		carisma = 2,
		deslocamento = 6,
		poderes = {
			sopro = {
				nome = "Sopro de Drag�o",
				uso = "Encontro",
				origem = {},
				tipo_ataque = "rajada cont�gua 3",
				alvo = "criaturas na rajada",
				ataque = function(self)
					local bonus
					if self.nivel >= 21 then
						bonus = 6
					elseif self.nivel >= 11 then
						bonus = 4
					else
						bonus = 2
					end
					return bonus+self["mod_"..self.mod_sopro]
				end,
				defesa = "Ref",
				dano = function(self)
					if self.nivel >= 21 then
						return "3d6+"..self.mod_con
					elseif self.nivel >= 11 then
						return "2d6+"..self.mod_con
					else
						return "1d6+"..self.mod_con
					end
				end,
			},
		},
		pericias = {
			historia = 2,
			intimidacao = 2,
		},
	},
	drow = {
		destreza = 2,
		carisma = 2,
		deslocamento = 6,
		poderes = {
			nuvem_da_escuridao = {
				nome = "Nuvem da Escurid�o",
				uso = "Encontro",
				origem = {},
				tipo_ataque = "explos�o cont�gua 1",
--[[
				alvo = "inimigos adjacentes",
				ataque = function(self)
					local bonus
					if self.nivel >= 21 then
						bonus = 6
					elseif self.nivel >= 11 then
						bonus = 4
					else
						bonus = 2
					end
					return bonus+self["mod_"..self.mod_sopro]
				end,
				defesa = "Ref",
				dano = function(self)
					if self.nivel >= 21 then
						return "3d6+"..self.mod_con
					elseif self.nivel >= 11 then
						return "2d6+"..self.mod_con
					else
						return "1d6+"..self.mod_con
					end
				end,
--]]
				efeito = "Cria uma nuvem de escurid�o que persiste at� o final do pr�ximo turno, bloqueando a vis�o de todas as outras criaturas (que ficam cegas at� sair).",
			},
		},
		pericias = {
			furtividade = 2,
			intimidacao = 2,
		},
	},
	eladrin = {
		destreza = 2,
		inteligencia = 2,
		vontade = 1,
		deslocamento = 6,
		armas = { espada_longa = true, },
		pericias = {
			arcanismo = 2,
			historia = 2,
		},
		pericias_adicionais = 1,
		--treinamento_pericia = set("acrobacia", "arcanismo", "atletismo", "blefe", "diplomacia", "exploracao", "furtividade", "historia", "intimidacao", "intuicao", "ladinagem", "manha", "natureza", "percepcao", "religiao", "socorro", "tolerancia"),
		treinamento_pericia_qualquer = true,
		poderes = {
			passo_feerico = {
				nome = "Passo Fe�rico",
				uso = "Encontro",
				origem = {},
				tipo_ataque = "utilitario",
				efeito = function(self)
					return "O personagem se teleporta at� 5 quadrados"
				end,
			},
		},
	},
	elfo = {
		destreza = 2,
		sabedoria = 2,
		deslocamento = 7,
		armas = { arco_curto = true, arco_longo = true, },
		pericias = {
			natureza = 2,
			percepcao = 2,
		},
		poderes = {
			precisao_elfica = {
				nome = "Precis�o �lfica",
				uso = "Encontro",
				origem = {},
				tipo_ataque = "utilitario",
				alvo = "pessoal",
				efeito = function(self)
					local ataque = ''
					if self.bonus_precisao_elfica then
						ataque = " com +"..self.bonus_precisao_elfica.." de b�nus"
					end
					local dano = ''
					if self.dano_precisao_elfica then
						dano = ", causando +"..self.dano_precisao_elfica.." de dano"
					end
					return "O personagem refaz a sua jogada de ataque"..ataque..".\nUse o segundo resultado, mesmo que seja inferior"..dano.."."
				end,
			},
		},
	},
	feral_dente_alongado = {
		forca = 2,
		sabedoria = 2,
		deslocamento = 6,
		pericias = {
			atletismo = 2,
			tolerancia = 2,
		},
		poderes = {},
	},
	feral_garra_navalha = {
		destreza = 2,
		sabedoria = 2,
		deslocamento = 6,
		pericias = {
			acrobacia = 2,
			furtividade = 2,
		},
		poderes = {},
	},
	genasi = {
		forca = 2,
		inteligencia = 2,
		deslocamento = 6,
		pericias = {
			natureza = 2,
			tolerancia = 2,
		},
		poderes = {},
	},
	gnomo = {
		inteligencia = 2,
		carisma = 2,
		deslocamento = 5,
		pericias = {
			arcanismo = 2,
			furtividade = 2,
		},
		poderes = {},
	},
	golias = {
		forca = 2,
		constituicao = 2,
		deslocamento = 6,
		vontade = 1,
		pericias = {
			atletismo = 2,
			natureza = 2,
		},
		poderes = {
			resistencia_de_pedra = {
				nome = "Resist�ncia de Pedra",
				uso = "Encontro",
				origem = {},
				tipo_ataque = "utilitario",
				alvo = "pessoal",
				efeito = function (self)
					local bonus = (math.floor((self.nivel-1)/10)+1) * 5
					return "Adquire resist�ncia "..bonus.." contra todos os tipos de dano at� o final do seu pr�ximo turno."
				end,
			},
		},
	},
	halfling = {
		destreza = 2,
		carisma = 2,
		deslocamento = 6,
		poderes = {
			segunda_chance = {
				nome = "Segunda Chance",
				uso = "Encontro",
				origem = {},
				tipo_ataque = "utilitario",
				alvo = "pessoal",
				efeito = function(self)
					local penalidade = ''
					if self.penalidade_segunda_chance then
						penalidade = " com -"..self.penalidade_segunda_chance.." de penalidade"
					end
					return "Quando atingido por um ataque, voc� pode obrigar o inimigo a refazer a jogada\nde ataque"..penalidade.." e ficar com o segundo resultado."
				end,
			},
		},
		ca_oportunidade = 2,
		pericias = {
			acrobacia = 2,
			ladinagem = 2,
		},
	},
	humano = {
		deslocamento = 6,
		fortitude = 1,
		reflexos = 1,
		vontade = 1,
		pericias_adicionais = 1,
		talento_adicional = 1,
		sem_limite_adicional = 1,
		poderes = {},
	},
	meio_elfo = {
		constituicao = 2,
		carisma = 2,
		deslocamento = 6,
		poderes = {},
		pericias = {
			diplomacia = 2,
			intuicao = 2,
		},
	},
	meio_orc = {
		forca = 2,
		destreza = 2,
		deslocamento = 6,
		pericias = {
			intimidacao = 2,
			tolerancia = 2,
		},
		poderes = {},
	},
	omaticaya_cacador_com_arco = {
		destreza = 2,
		sabedoria = 2,
		deslocamento = 7,
		armas = set("arco_longo", "arco_grande"),
		pericias = {
			acrobacia = 2,
			natureza = 2,
		},
		poderes = {},
	},
	omaticaya_guerrilheiro_adagas = {
		forca = 2,
		destreza = 2,
		deslocamento = 7,
		pericias = {
			atletismo = 2,
			natureza = 2,
		},
		poderes = {},
	},
	tiefling = {
		inteligencia = 2,
		carisma = 2,
		deslocamento = 6,
		poderes = {},
		pericias = {
			blefe = 2,
			furtividade = 2,
		},
	},

	felino = {
		forca = 14,
		constituicao = 12,
		destreza = 16,
		inteligencia = 6,
		sabedoria = 14,
		carisma = 6,

		deslocamento = 7,
		poderes = {
			garra = {
				nome = "Garras",
				uso = "Sem Limite",
				tipo = "corpo",
				origem = {},
				ataque = function(self)
					return self.nivel + 4
				end,
				defesa = "CA",
				dano = function(self, dano, arma)
					return math.floor(self.nivel/2) + self.mod_des
				end,
			},
		},
	},
}

