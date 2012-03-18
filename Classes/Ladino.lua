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
	nome = "Ladino",
	fonte_de_poder = "marcial",
	reflexos = 2,
	armaduras = set("traje", "corselete"),
	ca_oportunidade = function(self, oportunidade)
		if self.caracteristica_classe:match"[Ee]squivo" then
			return oportunidade + self.mod_car
		else
			return oportunidade
		end
	end,
	armas = set("adaga", "besta_mao", "shuriken", "funda", "espada_curta"),
	implementos = {},
	ataque = function (self, arma)
		if arma.nome == "Adaga" then
			return 1
		else
			return 0
		end
	end,
	_adaga = {
		ataque = 1,
	},
	_shuriken = {
		dano = function(self, dano, arma)
			return categorias_dano[armas.shuriken.empunhadura][dano]
		end,
	},
	dano_adicional = function(self, dano, arma) -- Ataque Furtivo
		if armas[arma].grupo == "leve" or arma == "besta_mao" or arma == "funda" then
			local af
			if self.nivel > 20 then
				af = "+5d6"
			elseif self.nivel > 10 then
				af = "+3d6"
			else
				af = "+2d6"
			end
			if self.vigarista_brutal then
				return af.."+"..self.mod_for
			else
				return af
			end
		else
			return dano
		end
	end,
	nome_adicional = "At.Furtivo",
	pv = 12,
	pv_nivel = 5,
	pc_dia = 6,
	pericias = {
		furtividade = "treinada",
		ladinagem = "treinada",
		acrobacia = true,
		atletismo = true,
		blefe = true,
		exploracao = true,
		intimidacao = true,
		intuicao = true,
		manha = true,
		percepcao = true,
	},
	total_pericias = 4,
	caracteristicas_classe = {
------- Características de Classe ----------------------------------------------
	},
	poderes = {
------- Poderes Sem Limite nível 1 ---------------------------------------------
		floreio_ardiloso = {
			nome = "Floreio Ardiloso",
			uso = "SL",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo/distancia",
			alvo = "uma criatura",
			ataque = mod.destreza,
			defesa = "CA",
			dano = function(self)
				if self.nivel >= 21 then
					return "2[A]+"..(self.mod_des + self.mod_car)
				else
					return "1[A]+"..(self.mod_des + self.mod_car)
				end
			end,
		},
		golpe_decidido = {
			nome = "Golpe Decidido",
			uso = "SL",
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo/distancia",
			alvo = "uma criatura",
			ataque = mod.destreza,
			defesa = "CA",
			dano = mod.dobra_21("[A]", "destreza", "Golpe Decidido"),
			efeito = "Você pode se mover 2 quadrados antes do ataque.",
		},
		golpe_em_resposta = {
			nome = "Golpe em Resposta",
			uso = "SL",
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.destreza,
			defesa = "CA",
			dano = mod.dobra_21("[A]", "destreza", "Golpe em Resposta"),
			contragolpe = function(self)
				if self.nivel >= 21 then
					return "+"..self.mod_for.." X CA -> 2[A]+"..self.mod_for
				else
					return "+"..self.mod_for.." X CA -> 1[A]+"..self.mod_for
				end
			end,
		},
		golpe_perfurante = {
			nome = "Golpe Perfurante",
			uso = "SL",
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.destreza,
			defesa = "Refl",
			dano = mod.dobra_21("[A]", "destreza", "Golpe Perfurante"),
		},
------- Poderes por Encontro nível 1 -------------------------------------------
		castelo_real = {
			nome = "Castelo Real",
			uso = "En",
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo/distancia",
			alvo = "uma criatura",
			ataque = mod.destreza,
			defesa = "Refl",
			dano = mod.dado_mod("2[A]", "destreza", "Castelo Real"),
 		},
		golpe_de_posicionamento = {
			nome = "Golpe de Posicionamento",
			uso = "En",
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.destreza,
			defesa = "Vont",
			dano = mod.dado_mod("1[A]", "destreza", "Golpe de Posicionamento"),
			efeito = function(self)
				return "Sucesso: o alvo é conduzido "..self.mod_car.." quadrados."
			end,
		},
		golpe_tortuoso = {
			nome = "Golpe Tortuoso",
			uso = "En",
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.destreza,
			defesa = "CA",
			dano = function(self)
				if self.vigarista_brutal then
					return "2[A]+"..self.mod_for
				else
					return "2[A]"
				end
			end,
		},
------- Poderes Diários nível 1 ------------------------------------------------
		alvo_facil = {
			nome = "Alvo Fácil",
			uso = "Di",
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo/distancia",
			alvo = "uma criatura",
			ataque = mod.des,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "destreza", "Alvo Fácil"),
			efeito = "O alvo fica lento e concede VdC (TR encerra).\nFracasso: metade do dano + VdC até o final do próximo turno.",
		},
		barragem_cegante = {
			nome = "Barragem Cegante",
			uso = "Di",
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "rajada contígua 3",
			alvo = "inimigos na rajada e na linha de visão",
			ataque = mod.des,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "destreza", "Barragem Cegante"),
			efeito = "Sucesso: os alvos ficam cegos até o FdPT.\nFracasso: metade do dano.",
		},
		golpe_traicoeiro = {
			nome = "Golpe Traiçoeiro",
			uso = "Di",
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo/distancia",
			alvo = "uma criatura",
			ataque = mod.destreza,
			defesa = "CA",
			dano = mod.dado_mod("3[A]", "destreza", "Golpe Traiçoeiro"),
			efeito = "Até o final do encontro, sempre que acertar de novo o alvo, este é conduzido 1 quadrado.",
		},
------- Poderes Utilitários nível 1 --------------------------------------------
		dedos_rapidos = {
			nome = "Dedos Rápidos",
			uso = "En",
			origem = set("marcial"),
			tipo_ataque = "pessoal",
			alvo = "uma criatura",
			efeito = "Teste de Ladinagem como ação mínima",
			ataque = "Teste de Ladinagem",
			dano = "Ação Mínima",
		},
		salto_mortal = {
			nome = "Salto Mortal",
			uso = "Di",
			origem = set("arma", "confiável", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.destreza,
			defesa = "CA",
			dano = mod.dado_mod("3[A]", "destreza", "Salto Mortal"),
			efeito = "Ajusta 2 quadrados.  Pode usar com investida.",
		},
		fantasma_fugaz = {
			nome = "Fantasma Fugaz",
			uso = "SL",
			origem = set("marcial"),
			tipo_ataque = "pessoal",
			alvo = "pessoal",
			ataque = "Teste de Furtividade",
			dano = "Ação de Movimento",
			efeito = "Não sofre penalidades no teste de Furtividade com deslocamento normal.",
		},
------- Poderes por Encontro nível 3 -------------------------------------------
	},
}
