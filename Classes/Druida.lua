local set = require"DnD.Set"
local soma_dano = require"DnD.Soma".soma
local armas = require"DnD.Armas"
local tipos_armas = require"DnD.TiposArmas"
local mod = require"DnD.Modificadores"

return {
	nome = "Druida",
	fonte_de_poder = "primitivo",
	reflexos = 1,
	vontade = 1,
	armaduras = set("traje", "corselete", "gibao"),
	ca = function (self)
		local cat = self.armadura.categoria
		if self.caracteristica_classe:match"uardi.o" and
			(cat == "traje" or cat == "corselete" or cat == "gibao") then
			local atr = math.max(self.mod_con, self.mod_des, self.mod_int)
			atr = atr - math.max(self.mod_des, self.mod_int)
			return atr
		else
			return 0
		end
	end,
	deslocamento = function (self)
		local cat = self.armadura.categoria
		if self.caracteristica_classe:match"redador" and
			(cat == "traje" or cat == "corselete" or cat == "gibao") then
			return false, 1
		else
			return false, 0
		end
	end,
	armas = tipos_armas("corpo simples", "distancia simples"),
	implementos = set("cajado", "totem"),
	pv = 12,
	pv_nivel = 5,
	pc_dia = 7,
	pericias = {
		natureza = "treinada",
		arcanismo = true,
		atletismo = true,
		diplomacia = true,
		historia = true,
		intuicao = true,
		percepcao = true,
		socorro = true,
		tolerancia = true,
	},
	total_pericias = 3,
	caracteristicas_classe = {
------- Características de Classe ----------------------------------------------
	},
	poderes = {
------- Poderes Sem Limite nível 1 ---------------------------------------------
		acometida = {
			nome = "Acometida",
			uso = "SL",
			acao = "padrão",
			origem = set("forma animal", "implemento", "primitivo"),
			tipo_ataque = "toque corpo",
			alvo = "uma criatura",
			ataque = mod.sab,
			defesa = "Ref",
			dano = mod.dobra_21("d8", "sabedoria", "Acometida"),
			efeito = "Pode ser usado como ataque básico em uma investida.",
		},
		chamado_da_fera = {
			nome = "Chamado da Fera",
			uso = "SL",
			acao = "padrão",
			origem = set("encanto", "implemento", "primitivo", "psíquico"),
			tipo_ataque = "explosão área 1 a até 10",
			alvo = "inimigos na área",
			ataque = mod.sab,
			defesa = "Vont",
			dano = '',
			efeito = function(self)
				return "Os alvos não podem adquirir VdC até o final do próximo turno do druida.\nO alvo que realizar um ataque contra um aliado que não seja o mais próximo dele recebe "..soma_dano(self, 5, self.mod_sab).." de dano psíquico."
			end,
		},
		dilaceramento_selvagem = {
			nome = "Dilaceramento Selvagem",
			uso = "SL",
			acao = "padrão",
			origem = set("forma animal", "implemento", "primitivo"),
			tipo_ataque = "toque corpo",
			alvo = "uma criatura",
			ataque = mod.sab,
			defesa = "Refl",
			dano = mod.dobra_21("d8", "sabedoria", "Dilaceramento Selvagem"),
			efeito = "O alvo é conduzido 1 quadrado.",
		},
		garras_aderentes = {
			nome = "Garras Aderentes",
			uso = "SL",
			acao = "padrão",
			origem = set("forma animal", "implemento", "primitivo"),
			tipo_ataque = "toque corpo",
			alvo = "uma criatura",
			ataque = mod.sabedoria,
			defesa = "Refl",
			dano = mod.dobra_21("d8", "sabedoria", "Garras Aderentes"),
			efeito = "O alvo fica lento até o final do próximo turno do druida.",
		},
		semente_flamejante = {
			nome = "Semente Flamejante",
			uso = "SL",
			acao = "padrão",
			origem = set("flamejante", "implemento", "primitivo", "zona"),
			tipo_ataque = "distância 10",
			alvo = "uma criatura",
			ataque = mod.sabedoria,
			defesa = "Ref",
			dano = mod.dado_mod("1d6", "sabedoria", "Semente Flamejante"),
			efeito = function(self)
				return "Sucesso: os quadrados adjacentes ao alvo tornam-se área flamejante até o FdPT,\n         causando "..self.mod_sab.." de dano."
			end,
		},
		tempestade_de_espigos = {
			nome = "Tempestade de Espigos",
			uso = "SL",
			acao = "padrão",
			origem = set("elétrico", "implemento", "primitivo"),
			tipo_ataque = "distância 10",
			alvo = "uma criatura",
			ataque = mod.sabedoria,
			defesa = "Refl",
			dano = mod.dobra_21("d8", "sabedoria", "Tempestade de Espigos"),
			efeito = function(self)
				return "Se o alvo não se mover pelo menos 2 quadrados, sofre "..self.mod_sab.." de dano elétrico."
			end,
		},
		vento_resfriante = {
			nome = "Vento Resfriante",
			uso = "SL",
			acao = "padrão",
			origem = set("congelante", "implemento", "primitivo"),
			tipo_ataque = "explosão área 1 a até 10",
			alvo = "as criaturas na explosão",
			ataque = mod.sabedoria,
			defesa = "Fort",
			dano = mod.dobra_21("d6", "", "Vento Resfriante"),
			efeito = "O alvo é conduzido 1 quadrado.",
		},
------- Poderes por Encontro nível 1 -------------------------------------------
		lampejo_algido = {
			nome = "Lampejo Álgido",
			uso = "En",
			acao = "padrão",
			origem = set("congelante", "implemento", "primitivo"),
			tipo_ataque = "distância 1",
			alvo = "uma criatura",
			ataque = mod.sabedoria,
			defesa = "Fort",
			dano = function(self, ...)
				local dano = self.mod_sab
				if self.caracteristica_classe:match"uardi.o" then
					dano = dano + self.mod_con
				end
				return soma_dano(self, "1d6", dano, "Lampejo Álgido")
			end,
			efeito = "Sucesso: o alvo fica imobilizado até o FdPT.",
		},
		convocar_relampagos = {
			nome = "Convocar Relâmpagos",
			uso = "En",
			acao = "padrão",
			origem = set("elétrico", "implemento", "primitivo", "trovejante"),
			tipo_ataque = "explosão área 1 a até 10",
			alvo = "as criaturas na explosão",
			ataque = mod.sab,
			defesa = "Refl",
			dano = mod.dado_mod("1d8", "sabedoria", "Convocar Relâmpagos"),
			efeito = "A explosão cria uma zona de trovões que persiste até o final do próximo turno.\nA zona causa -2 de penalidade no ataque dos inimigos dentro dela e quem sair da\nzona sofre 5 de dano trovejante.",
		},
		mordida_brusca = {
			nome = "Mordida Brusca",
			uso = "En",
			acao = "padrão",
			origem = set("forma animal", "implemento", "primitivo"),
			tipo_ataque = "toque corpo",
			alvo = "uma ou duas criaturas",
			ataque = mod.sabedoria,
			defesa = "Refl",
			dano = mod.dado_mod("1d10", "sabedoria", "Mordida Brusca"),
			efeito = function(self)
				return "Se acertar pelo menos um ataque, o druida ajusta "
					..self.mod_des.." quadrados."
			end,
		},
		vinhas_retorcidas = {
			nome = "Vinhas Retorcidas",
			uso = "En",
			acao = "padrão",
			origem = set("implemento", "primitivo"),
			tipo_ataque = "explosão área 1 a até 10",
			alvo = "criaturas na explosão",
			ataque = mod.sabedoria,
			defesa = "Ref",
			dano = mod.dado_mod("1d8", "sabedoria", "Vinhas Retorcidas"),
			efeito = "Sucesso: os quadrados adjacentes ao alvo tornam-se terreno acidentado até FdPT.",
		},
------- Poderes Diários nível 1 ------------------------------------------------
		fogo_das_fadas = {
			nome = "Fogo das Fadas",
			uso = "Di",
			acao = "padrão",
			origem = set("implemento", "primitivo", "radiante"),
			tipo_ataque = "explosão área 1 a até 10",
			alvo = "criaturas na explosão",
			ataque = mod.sabedoria,
			defesa = "Vont",
			dano = mod.dado_mod("3d6", "sabedoria", "Fogo das Fadas"),
			efeito = function(self)
				return "Sucesso: primeiro, os alvos ficam lentos e concedem VdC (TR encerra).\n         Só quando passarem no TR recebem o dano e ainda concedem VdC até FdPT.\nFracasso: 1d6+"..self.mod_sab.." e concede VdC até o FdPT."
			end,
		},
		fogos_da_vida = {
			nome = "Fogos da Vida",
			uso = "Di",
			acao = "padrão",
			origem = set("cura", "flamejante", "implemento", "primitivo"),
			tipo_ataque = "explosão área 1 a até 10",
			alvo = "inimigos na explosão",
			ataque = mod.sabedoria,
			defesa = "Ref",
			dano = mod.dado_mod("1d6", "sabedoria", "Fogos da Vida"),
			efeito = function (self)
				return "Sucesso: +5 contínuo flamejante (TR encerra). Uma criatura a até 5 quadrados do alvo recupera "..self.mod_con.." PV."
			end,
		},
		nevoa_da_escuridao = {
			nome = "Névoa da Escuridão",
			uso = "Di",
			acao = "padrão",
			origem = set("primitivo", "zona"),
			tipo_ataque = "explosão área 1 a até 10",
			alvo = '',
			efeito = "A zona de penumbra persiste até o final do próximo turno do druida.\nCom uma ação mínima, você pode persistir e aumentar a zona em 1 quadrado.",
		},
		prisao_de_vento = {
			nome = "Prisão de Vento",
			uso = "Di",
			acao = "padrão",
			origem = set("implemento", "primitivo"),
			tipo_ataque = "distância 10",
			alvo = "uma criatura",
			ataque = mod.sabedoria,
			defesa = "Refl",
			dano = mod.dado_mod("2d10", "sabedoria", "Prisão de Vento"),
			efeito = "O alvo concede VdC até se mover ou até o final do encontro.\nQuando o alvo se mover, os inimigos do druida a até 5 quadrados são derrubados.",
		},
------- Poderes Utilitários nível 2 --------------------------------------------
		pele_de_arvore = {
			nome = "Pele de Árvore",
			uso = "En",
			acao = "mínima",
			origem = set("primitivo"),
			tipo_ataque = "distância 5",
			alvo = "o druida ou aliado",
			efeito = function(self)
				return "+"..self.mod_con.." na CA até o FdPT."
			end,
		},
	},
}
