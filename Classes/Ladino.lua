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
		if self.caracteristica_classe:lower():match"esquivo h.*bil" then
			return (oportunidade or 0) + self.mod_car
		else
			return (oportunidade or 0)
		end
	end,
	armas = set("adaga", "besta_mao", "shuriken", "funda", "espada_curta"),
	implementos = {},
	ataque = function (self, arma)
		if arma.nome:lower():match"adaga" then
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
			efeito = "Efeito: você pode se mover 2 quadrados antes do ataque.",
		},
		golpe_desencorajador = {
			nome = "Golpe Desencorajador",
			uso = "SL",
			acao = "padrão",
			origem = set("arma", "aturdir", "marcial"),
			tipo_ataque = "corpo/distância",
			alvo = "uma criatura",
			ataque = mod.destreza,
			defesa = "CA",
			dano = mod.dobra_21("[A]", "destreza", "Golpe Desencorajador"),
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
		ameaca_final = {
			nome = "Ameaça Final",
			uso = "En",
			acao = "padrão",
			origem = set("arma", "aturdir", "marcial"),
			tipo_ataque = "corpo/distancia",
			alvo = "uma criatura",
			ataque = mod.destreza,
			defesa = "Refl",
			dano = mod.dado_mod("1[A]", "destreza+carisma", "Ameaça Final"),
			efeito = function(self)
				if self.caracteristica_classe:lower():match"rufi.*o implac.*vel" then
					return "Efeito: se o alvo estiver sofrendo a penalidade de um ataque de ladino com a\n    palavra-chave aturdir, ele também fica imobilizado até o FdPT."
				end
			end,
 		},
		ataque_ponderado = {
			nome = "Ataque Ponderado",
			uso = "En",
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo/distancia",
			alvo = "uma criatura",
			ataque = mod.destreza,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "destreza", "Ataque Ponderado"),
			efeito = function(self)
				return "Sucesso: se o alvo realizar um AtCaC contra você antes do CdPT, você pode usar\n    uma II para atacá-lo: Força X CA -> 1[A] + "..self.mod_for.." e o alvo sofre -2 de penalidade no ataque que ativou a II."
			end,
 		},
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
		gambito_da_raposa = {
			nome = "Gambito da Raposa",
			-- condicao = treinamento em Acrobacia
			uso = "En",
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.destreza,
			defesa = "Refl",
			dano = mod.dado_mod("1[A]", "destreza", "Gambito da Raposa"),
			efeito = function(self)
				local ajuste = 1
				if self.caracteristica_classe:lower():match"esquivo h.*bil" then
					ajuste = self.mod_des
				end
				return "Sucesso: o alvo encerra todas as suas marcas e não pode marcar nenhum outro alvo\n    até o FdPT.\nEfeito: ajusta "..ajuste.." quadrado(s)."
			end,
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
				if self.caracteristica_classe:lower():match"esquivo h.*bil" then
					return "Sucesso: o alvo é conduzido "..self.mod_car.." quadrados."
				end
			end,
		},
		golpe_ofuscante = {
			nome = "Golpe Ofuscante",
			uso = "En",
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.destreza,
			defesa = "CA",
			dano = mod.dado_mod("1[A]", "destreza", "Golpe Ofuscante"),
			efeito = function(self)
				return "Sucesso: o alvo fica pasmo até o FdPT."
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
				if self.caracteristica_classe:lower():match"vigarista.brutal" then
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
			efeito = "Efeito: o alvo fica lento e concede VdC (TR encerra).\nFracasso: metade do dano + VdC até o final do próximo turno.",
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
------- Poderes Utilitários nível 2 --------------------------------------------
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
		atrair_e_comutar = {
			nome = "Atrair e Comutar",
			uso = "En",
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.destreza,
			defesa = "Von",
			dano = mod.dado_mod("2[A]", "destreza", "Atrair e Comutar"),
			efeito = function (self)
				local ajuste = 1
				if self.caracteristica_classe:lower():match"esquivo" then
					ajuste = self.mod_car
				end
				return "Sucesso: troca de lugar com o alvo e depois pode ajustar "..ajuste.." quadrado(s)."
			end,
		},
		desabar = {
			nome = "Desabar",
			uso = "En",
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = function (self, mais)
-- !!! funciona ???
				if self.caracteristica_classe:lower():match"brutal" then
					return self.mod_des + self.mod_for
				else
					return self.mod_des
				end
			end,
			defesa = "CA",
			dano = mod.dado_mod("1[A]", "destreza", "Desabar"),
			efeito = "Sucesso: o alvo fica derrubado.",
		},
		lamina_do_trapaceiro = {
			nome = "Lâmina do Trapaçeiro",
			uso = "En",
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo/distancia",
			alvo = "uma criatura",
			ataque = mod.destreza,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "destreza", "Lâmina do Trapaçeiro"),
			efeito = function (self)
				return "Sucesso: ganhe +"..self.mod_car.." na CA até o CdPT."
			end,
		},
------- Poderes Diários nível 5 ------------------------------------------------
		ferido_ambulante = {
			nome = "Ferido Ambulante",
			uso = "Di",
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo/distancia",
			alvo = "uma criatura",
			ataque = mod.destreza,
			defesa = "Fort",
			dano = mod.dado_mod("2[A]", "destreza", "Ferido Ambulante"),
			efeito = function (self)
				return "Sucesso: o alvo fica derrubado e, até o FdEn, toda vez que o alvo percorrer mais\n    da metade do deslocamento na mesma ação, ele fica derrubado no final.\nFracasso: metade do dano e o alvo não fica derrubado."
			end,
		},
------- Poderes Utilitários nível 6 --------------------------------------------
		escapar_ileso = {
			nome = "Escapar Ileso",
			uso = "En",
			acao = "movimento",
			origem = set("marcial"),
			tipo_ataque = "pessoal",
			alvo = "pessoal",
			efeito = function (self)
				return "Efeito: se estiver marcado, a marca se encerra e pode ajustar o deslocamento."
			end,
		},
------- Poderes por Encontro nível 7 -------------------------------------------
		das_sombras = {
			nome = "Das Sombras",
			uso = "En",
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo/distância",
			alvo = "uma criatura",
			ataque = mod.destreza,
			defesa = "CA",
			dano = mod.dado_mod("1[A]", "destreza", "Das Sombras"),
			efeito = function (self)
				local ajuste = 2
				if self.caracteristica_classe:lower():match"esquivo" then
					ajuste = 1 + self.mod_car
				end
				return "Efeito: ajuste "..ajuste.." antes do ataque; se estava fora da linha de visão, obtém VdC.\nSucesso: ajuste "..ajuste.."; se terminar com alguma cobertura ou ocultação, pode realizar\n    um teste de Furtividade usando uma ação livre."
			end,
		},
	},
}
