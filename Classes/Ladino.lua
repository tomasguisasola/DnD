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
------- Caracter�sticas de Classe ----------------------------------------------
	},
	poderes = {
------- Poderes Sem Limite n�vel 1 ---------------------------------------------
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
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo/distancia",
			alvo = "uma criatura",
			ataque = mod.destreza,
			defesa = "CA",
			dano = mod.dobra_21("[A]", "destreza", "Golpe Decidido"),
			efeito = "Efeito: voc� pode se mover 2 quadrados antes do ataque.",
		},
		golpe_desencorajador = {
			nome = "Golpe Desencorajador",
			uso = "SL",
			acao = "padr�o",
			origem = set("arma", "aturdir", "marcial"),
			tipo_ataque = "corpo/dist�ncia",
			alvo = "uma criatura",
			ataque = mod.destreza,
			defesa = "CA",
			dano = mod.dobra_21("[A]", "destreza", "Golpe Desencorajador"),
		},
		golpe_em_resposta = {
			nome = "Golpe em Resposta",
			uso = "SL",
			acao = "padr�o",
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
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.destreza,
			defesa = "Refl",
			dano = mod.dobra_21("[A]", "destreza", "Golpe Perfurante"),
		},
------- Poderes por Encontro n�vel 1 -------------------------------------------
		ameaca_final = {
			nome = "Amea�a Final",
			uso = "En",
			acao = "padr�o",
			origem = set("arma", "aturdir", "marcial"),
			tipo_ataque = "corpo/distancia",
			alvo = "uma criatura",
			ataque = mod.destreza,
			defesa = "Refl",
			dano = mod.dado_mod("1[A]", "destreza+carisma", "Amea�a Final"),
			efeito = function(self)
				if self.caracteristica_classe:lower():match"rufi.*o implac.*vel" then
					return "Efeito: se o alvo estiver sofrendo a penalidade de um ataque de ladino com a\n    palavra-chave aturdir, ele tamb�m fica imobilizado at� o FdPT."
				end
			end,
 		},
		ataque_ponderado = {
			nome = "Ataque Ponderado",
			uso = "En",
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo/distancia",
			alvo = "uma criatura",
			ataque = mod.destreza,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "destreza", "Ataque Ponderado"),
			efeito = function(self)
				return "Sucesso: se o alvo realizar um AtCaC contra voc� antes do CdPT, voc� pode usar\n    uma II para atac�-lo: For�a X CA -> 1[A] + "..self.mod_for.." e o alvo sofre -2 de penalidade no ataque que ativou a II."
			end,
 		},
		castelo_real = {
			nome = "Castelo Real",
			uso = "En",
			acao = "padr�o",
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
			acao = "padr�o",
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
				return "Sucesso: o alvo encerra todas as suas marcas e n�o pode marcar nenhum outro alvo\n    at� o FdPT.\nEfeito: ajusta "..ajuste.." quadrado(s)."
			end,
		},
		golpe_de_posicionamento = {
			nome = "Golpe de Posicionamento",
			uso = "En",
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.destreza,
			defesa = "Vont",
			dano = mod.dado_mod("1[A]", "destreza", "Golpe de Posicionamento"),
			efeito = function(self)
				if self.caracteristica_classe:lower():match"esquivo h.*bil" then
					return "Sucesso: o alvo � conduzido "..self.mod_car.." quadrados."
				end
			end,
		},
		golpe_ofuscante = {
			nome = "Golpe Ofuscante",
			uso = "En",
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.destreza,
			defesa = "CA",
			dano = mod.dado_mod("1[A]", "destreza", "Golpe Ofuscante"),
			efeito = function(self)
				return "Sucesso: o alvo fica pasmo at� o FdPT."
			end,
		},
		golpe_tortuoso = {
			nome = "Golpe Tortuoso",
			uso = "En",
			acao = "padr�o",
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
------- Poderes Di�rios n�vel 1 ------------------------------------------------
		alvo_facil = {
			nome = "Alvo F�cil",
			uso = "Di",
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo/distancia",
			alvo = "uma criatura",
			ataque = mod.des,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "destreza", "Alvo F�cil"),
			efeito = "Efeito: o alvo fica lento e concede VdC (TR encerra).\nFracasso: metade do dano + VdC at� o final do pr�ximo turno.",
		},
		barragem_cegante = {
			nome = "Barragem Cegante",
			uso = "Di",
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "rajada cont�gua 3",
			alvo = "inimigos na rajada e na linha de vis�o",
			ataque = mod.des,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "destreza", "Barragem Cegante"),
			efeito = "Sucesso: os alvos ficam cegos at� o FdPT.\nFracasso: metade do dano.",
		},
		golpe_traicoeiro = {
			nome = "Golpe Trai�oeiro",
			uso = "Di",
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo/distancia",
			alvo = "uma criatura",
			ataque = mod.destreza,
			defesa = "CA",
			dano = mod.dado_mod("3[A]", "destreza", "Golpe Trai�oeiro"),
			efeito = "At� o final do encontro, sempre que acertar de novo o alvo, este � conduzido 1 quadrado.",
		},
------- Poderes Utilit�rios n�vel 2 --------------------------------------------
		dedos_rapidos = {
			nome = "Dedos R�pidos",
			uso = "En",
			origem = set("marcial"),
			tipo_ataque = "pessoal",
			alvo = "uma criatura",
			efeito = "Teste de Ladinagem como a��o m�nima",
			ataque = "Teste de Ladinagem",
			dano = "A��o M�nima",
		},
		salto_mortal = {
			nome = "Salto Mortal",
			uso = "Di",
			origem = set("arma", "confi�vel", "marcial"),
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
			dano = "A��o de Movimento",
			efeito = "N�o sofre penalidades no teste de Furtividade com deslocamento normal.",
		},
------- Poderes por Encontro n�vel 3 -------------------------------------------
		atrair_e_comutar = {
			nome = "Atrair e Comutar",
			uso = "En",
			acao = "padr�o",
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
			acao = "padr�o",
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
			nome = "L�mina do Trapa�eiro",
			uso = "En",
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo/distancia",
			alvo = "uma criatura",
			ataque = mod.destreza,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "destreza", "L�mina do Trapa�eiro"),
			efeito = function (self)
				return "Sucesso: ganhe +"..self.mod_car.." na CA at� o CdPT."
			end,
		},
------- Poderes Di�rios n�vel 5 ------------------------------------------------
		ferido_ambulante = {
			nome = "Ferido Ambulante",
			uso = "Di",
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo/distancia",
			alvo = "uma criatura",
			ataque = mod.destreza,
			defesa = "Fort",
			dano = mod.dado_mod("2[A]", "destreza", "Ferido Ambulante"),
			efeito = function (self)
				return "Sucesso: o alvo fica derrubado e, at� o FdEn, toda vez que o alvo percorrer mais\n    da metade do deslocamento na mesma a��o, ele fica derrubado no final.\nFracasso: metade do dano e o alvo n�o fica derrubado."
			end,
		},
------- Poderes Utilit�rios n�vel 6 --------------------------------------------
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
------- Poderes por Encontro n�vel 7 -------------------------------------------
		das_sombras = {
			nome = "Das Sombras",
			uso = "En",
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo/dist�ncia",
			alvo = "uma criatura",
			ataque = mod.destreza,
			defesa = "CA",
			dano = mod.dado_mod("1[A]", "destreza", "Das Sombras"),
			efeito = function (self)
				local ajuste = 2
				if self.caracteristica_classe:lower():match"esquivo" then
					ajuste = 1 + self.mod_car
				end
				return "Efeito: ajuste "..ajuste.." antes do ataque; se estava fora da linha de vis�o, obt�m VdC.\nSucesso: ajuste "..ajuste.."; se terminar com alguma cobertura ou oculta��o, pode realizar\n    um teste de Furtividade usando uma a��o livre."
			end,
		},
	},
}
