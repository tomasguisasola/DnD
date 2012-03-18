local set = require"DnD.Set"
local soma_dano = require"DnD.Soma".soma
local armas = require"DnD.Armas"
local tipos_armas = require"DnD.TiposArmas"
local mod = require"DnD.Modificadores"

return {
	nome = "Patrulheiro",
	fonte_de_poder = "marcial",
	fortitude = 1,
	reflexos = 1,
	armaduras = set("traje", "corselete", "gibao"),
	armas = tipos_armas("corpo simples", "corpo militar", "distancia simples", "distancia militar"),
	implementos = {},
	dano_adicional = function(self)
		if self.nivel > 20 then
			return "+3d6"
		elseif self.nivel > 10 then
			return "+2d6"
		else
			return "+1d6"
		end
	end,
	nome_adicional = "Presa",
	pv = 12,
	pv_nivel = 5,
	pc_dia = 6,
	pericias = {
		exploracao = true,
		natureza = true,
		acrobacia = true,
		atletismo = true,
		furtividade = true,
		percepcao = true,
		socorro = true,
		tolerancia = true,
	},
	talentos = function (self)
		if self.caracteristica_classe:match"arqueiro" then
			return "mobilidade_defensiva", true
		elseif self.caracteristica_classe:match"duas.armas" then
			return "vitalidade", true
		end
	end,
	total_pericias = 5,
	caracteristicas_classe = {
------- Características de Classe ----------------------------------------------
		tiro_primoroso = {
			nome = "Tiro Primoroso",
			uso = "SL",
			acao = "nenhuma",
			origem = set("arma", "marcial"),
			tipo_ataque = "distância",
			alvo = "uma criatura",
			ataque = 1,
			defesa = nil,
			efeito = "Se você for o aliado mais próximo do alvo, +1 no ataque à distância contra ele."
		},
	},
	poderes = {
------- Poderes Sem Limite nível 1 ---------------------------------------------
		ataque_cauteloso = {
			nome = "Ataque Cauteloso",
			uso = "SL",
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo/distancia",
			alvo = "uma criatura",
			ataque = function (self,...)
print("!",...)
				return self.mod_des+2
			end,
			defesa = "CA",
			dano = mod.dobra_21("[A]", "destreza", "Ataque Cauteloso"),
		},
		bater_e_correr = {
			nome = "Bater e Correr",
			uso = "SL",
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dobra_21("[A]", "forca", "Bater e Correr"),
			efeito = "Depois desse ataque, pode se mover sem provocar AdO no primeiro quadrado.",
		},
		cercar_e_golpear = {
			nome = "Cercar e Golpear",
			uso = "SL",
			acao = "padrão",
			origem = set("animal", "arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dobra_21("[A]", "forca", "Cercar e Golpear"),
		},
		golpes_gemeos = {
			nome = "Golpes Gêmeos",
			uso = "SL",
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo/distancia",
			alvo = "uma ou duas criaturas",
			ataque = mod.destreza,
			condicao = "Deve empunhar duas armas corpo-a-corpo ou uma à distância.",
			defesa = "CA",
			dano = mod.dobra_21("[A]", "", "Golpes Gêmeos"),
			efeito = "Dois ataques.",
		},
		golpe_lepido = {
			nome = "Golpe Lépido",
			uso = "SL",
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "distancia",
			alvo = "uma criatura",
			ataque = mod.destreza,
			defesa = "CA",
			dano = mod.dobra_21("[A]", "destreza", "Golpe Lépido"),
			efeito = "Ajusta um quadrado antes ou depois do ataque.",
		},
------- Poderes por Encontro nível 1 -------------------------------------------
		aproximar_se_da_presa = {
			nome = "Aproximar-se da Presa",
			uso = "En",
			acao = "padrão",
			origem = set("animal", "arma", "marcial"),
			tipo_ataque = "animal 1",
			alvo = "a presa",
			efeito = function (self)
				return "Efeito: você e seu animal ajustam 2 quadrados antes do ataque.\n    Se o animal for uma aranha, felino ou lobo, o ataque causa +"..self.mod_sab
			end,
		},
		astucia_da_raposa = {
			nome = "Astúcia da Raposa",
			uso = "En",
			acao = "reação imediata",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo/distância",
			gatilho = "um inimigo realiza um ataque CaC contra você",
			alvo = "uma criatura",
			efeito = "Efeito: você ajusta 1 quadrado e realiza um ataque básico contra o inimigo.",
		},
		golpe_com_a_mao_inabil = {
			nome = "Golpe com a Mão Inábil",
			uso = "En",
			acao = "mínima",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			condicao = "você deve empunhar duas armas de combate CaC",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("1[A]", "forca", "Golpe com a Mão Inábil"),
			efeito = "Efeito: use o ataque e o dano da arma da mão inábil.",
		},
		golpe_das_duas_presas = {
			nome = "Golpe das Duas Presas",
			uso = "En",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo/distancia",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("1[A]", "destreza", "Golpe das Duas Presas"),
			efeito = function (self)
				return "Dois ataques.  Se acertar os dois ataques, causa +"..self.mod_sab
			end,
		},
		golpe_do_carcaju_atroz = {
			nome = "Golpe do Carcajú Atroz",
			uso = "En",
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo", --"explosão contígua 1",
			alvo = "os inimigos adjacentes e na linha de visão",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("1[A]", "forca", "Golpe do Carcajú Atroz"),
		},
		golpe_do_parceiro_de_caca = {
			nome = "Golpe do Parceiro de Caça",
			uso = "En",
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "forca", "Golpe do Parceiro de Caça"),
			efeito = function (self)
				return "Sucesso: se estiver flanqueando, causa +"..self.mod_sab
			end,
		},
		golpe_evasivo = {
			nome = "Golpe Evasivo",
			uso = "En",
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "distancia",
			alvo = "uma criatura",
			ataque = mod.destreza,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "destreza", "Golpe Evasivo"),
			efeito = function(self)
				return "Efeito: você pode ajustar "..(1+self.mod_sab).." quadrados antes ou depois do ataque."
			end,
		},
		golpe_sincronizado = {
			nome = "Golpe Sincronizado",
			uso = "En",
			acao = "padrão",
			origem = set("animal", "arma", "marcial"),
			tipo_ataque = "animal 1",
			alvo = "uma criatura",
			--ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("1[A]", "destreza", "Golpe Sincronizado"),
			efeito = function(self)
				return "Efeito: ataque do animal X CA -> 1[C]\n        "..self.mod_for.." X Refl -> 1[A]+"..self.mod_for.."\n    Se o animal for uma ave de rapina, javali, lagarto, serpente ou urso, o at.\n    secundário causa +"..self.mod_sab
			end,
		},
		salva_veloz = {
			nome = "Salva Veloz",
			uso = "En",
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "distância",
			alvo = "uma ou duas criaturas",
			ataque = mod.destreza,
			defesa = "CA",
			dano = mod.dado_mod("1[A]", "destreza", "Salva Veloz"),
			efeito = function(self)
				return "Efeito: se atacar apenas uma criatura, +2 no dano;\n        se atacar duas criaturas, -2 nos ataques.\n======> NÃO ESCOLHA ESTE PODER; troque pelo Golpe das Duas Presas!"
			end,
		},
		tiro_singular = {
			nome = "Tiro Singular",
			uso = "En",
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "distância",
			alvo = "uma ou duas criaturas",
			ataque = mod.destreza,
			defesa = "CA",
			dano = mod.dado_mod("1[A]", "destreza", "Tiro Singular"),
			efeito = function(self)
				return "Sucesso: se nenhuma criatura estiver adjacente ao alvo, causa +"..self.mod_sab
			end,
		},
------- Poderes Diários nível 1 ------------------------------------------------
		armadilha_do_cacador_de_ursos = {
			nome = "Armadilha do Caçador de Ursos",
			uso = "Di",
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "distância",
			alvo = "uma criatura",
			ataque = mod.destreza,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "destreza", "Armadilha do Caçador de Ursos"),
			efeito = "Sucesso: o alvo fica lento e sofre +5 de dano contínuo (TR encerra).\nFracasso: metade do dano e lento até o final do próximo turno.",
		},
		assalto_do_javali = {
			nome = "Assalto do Javali",
			uso = "Di",
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo/distância",
			alvo = "uma criatura",
			ataque = mod.destreza, -- ou mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "destreza", "Assalto do Javali"),
			efeito = function (self)
				return "Sucesso: você recebe "..self.mod_sab.." PVT.\nFracasso: metade do dano.\nEfeito: até que o alvo caia a 0 PV, você recebe "..self.mod_sab.." PVT sempre que acertá-lo."
			end,
		},
		fim_da_cacada = {
			nome = "Fim da Caçada",
			uso = "Di",
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo/distância",
			alvo = "uma criatura sangrando",
			ataque = mod.destreza, -- ou mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("3[A]", "destreza", "Fim da Caçada"),
			efeito = "Fracasso: metade do dano.\nEfeito: se o alvo for a presa, 19 ou 20 no dado resultam em um sucesso decisivo.",
		},
		golpe_subito = {
			nome = "Golpe Súbito",
			uso = "Di",
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("1[A]", "destreza", "Golpe Súbito"),
			efeito = function(self)
				return "Ataque secundário" -- falta cadastrar direito
			end,
		},
		mandibulas_do_lobo = {
			nome = "Mandíbulas do Lobo",
			uso = "Di",
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "forca", "Mandíbulas do Lobo"),
			efeito = "Dois ataques.",
		},
		repartir_disparo = {
			nome = "Repartir Disparo",
			uso = "Di",
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "distancia",
			alvo = "duas criaturas, 3 quadrados entre si",
			ataque = mod.destreza,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "destreza", "Repartir Disparo"),
			efeito = "Jogue dois d20 e fique com o melhor contra os dois alvos.",
		},
------- Poderes Utilitários nível 1 --------------------------------------------
		bloqueio_desequilibrante = {
			nome = "Bloqueio Desequilibrante",
			uso = "En",
			acao = "??",
			origem = set("marcial"),
			tipo_ataque = "utilitario",
			alvo = "pessoal",
			efeito = "??",
		},
		servir_se_do_solo = {
			nome = "Servir-se do Solo",
			uso = "En",
			acao = "Reação Imediata",
			origem = set("arma", "marcial"),
			tipo_ataque = "utilitario",
			alvo = "pessoal",
			efeito = function(self)
				return "Quando um inimigo lhe causar dano, pode ajustar até "..self.mod_sab.." quadrados e recebe +2 em\ntodas as defesas até o final do próximo turno."
			end,
		},
------- Poderes por Encontro nível 3 -------------------------------------------
		golpe_da_vespa_das_sombras = {
			nome = "Golpe da Vespa das Sombras",
			uso = "En",
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo/distancia",
			alvo = "a Presa do patrulheiro",
			ataque = mod.destreza,
			defesa = "Refl",
			dano = mod.dado_mod("2[A]", "destreza", "Golpe da Vespa das Sombras"),
		},
		golpe_do_javali_presa_do_trovao = {
			nome = "Golpe do Javali Presa do Trovão",
			uso = "En",
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo/distancia",
			alvo = "uma ou duas criaturas",
			ataque = mod.destreza,
			defesa = "CA",
			dano = mod.dado_mod("1[A]", "destreza", "Golpe da Vespa das Sombras"),
			efeito = "Dois ataques e o alvo é empurrado 1 quadrado.",
		},
	},
}
