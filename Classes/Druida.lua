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
------- Caracter�sticas de Classe ----------------------------------------------
	},
	poderes = {
------- Poderes Sem Limite n�vel 1 ---------------------------------------------
		acometida = {
			nome = "Acometida",
			uso = "SL",
			acao = "padr�o",
			origem = set("forma animal", "implemento", "primitivo"),
			tipo_ataque = "toque corpo",
			alvo = "uma criatura",
			ataque = mod.sab,
			defesa = "Ref",
			dano = mod.dobra_21("d8", "sabedoria", "Acometida"),
			efeito = "Pode ser usado como ataque b�sico em uma investida.",
		},
		chamado_da_fera = {
			nome = "Chamado da Fera",
			uso = "SL",
			acao = "padr�o",
			origem = set("encanto", "implemento", "primitivo", "ps�quico"),
			tipo_ataque = "explos�o �rea 1 a at� 10",
			alvo = "inimigos na �rea",
			ataque = mod.sab,
			defesa = "Vont",
			dano = '',
			efeito = function(self)
				return "Os alvos n�o podem adquirir VdC at� o final do pr�ximo turno do druida.\nO alvo que realizar um ataque contra um aliado que n�o seja o mais pr�ximo dele recebe "..soma_dano(self, 5, self.mod_sab).." de dano ps�quico."
			end,
		},
		dilaceramento_selvagem = {
			nome = "Dilaceramento Selvagem",
			uso = "SL",
			acao = "padr�o",
			origem = set("forma animal", "implemento", "primitivo"),
			tipo_ataque = "toque corpo",
			alvo = "uma criatura",
			ataque = mod.sab,
			defesa = "Refl",
			dano = mod.dobra_21("d8", "sabedoria", "Dilaceramento Selvagem"),
			efeito = "O alvo � conduzido 1 quadrado.",
		},
		garras_aderentes = {
			nome = "Garras Aderentes",
			uso = "SL",
			acao = "padr�o",
			origem = set("forma animal", "implemento", "primitivo"),
			tipo_ataque = "toque corpo",
			alvo = "uma criatura",
			ataque = mod.sabedoria,
			defesa = "Refl",
			dano = mod.dobra_21("d8", "sabedoria", "Garras Aderentes"),
			efeito = "O alvo fica lento at� o final do pr�ximo turno do druida.",
		},
		semente_flamejante = {
			nome = "Semente Flamejante",
			uso = "SL",
			acao = "padr�o",
			origem = set("flamejante", "implemento", "primitivo", "zona"),
			tipo_ataque = "dist�ncia 10",
			alvo = "uma criatura",
			ataque = mod.sabedoria,
			defesa = "Ref",
			dano = mod.dado_mod("1d6", "sabedoria", "Semente Flamejante"),
			efeito = function(self)
				return "Sucesso: os quadrados adjacentes ao alvo tornam-se �rea flamejante at� o FdPT,\n         causando "..self.mod_sab.." de dano."
			end,
		},
		tempestade_de_espigos = {
			nome = "Tempestade de Espigos",
			uso = "SL",
			acao = "padr�o",
			origem = set("el�trico", "implemento", "primitivo"),
			tipo_ataque = "dist�ncia 10",
			alvo = "uma criatura",
			ataque = mod.sabedoria,
			defesa = "Refl",
			dano = mod.dobra_21("d8", "sabedoria", "Tempestade de Espigos"),
			efeito = function(self)
				return "Se o alvo n�o se mover pelo menos 2 quadrados, sofre "..self.mod_sab.." de dano el�trico."
			end,
		},
		vento_resfriante = {
			nome = "Vento Resfriante",
			uso = "SL",
			acao = "padr�o",
			origem = set("congelante", "implemento", "primitivo"),
			tipo_ataque = "explos�o �rea 1 a at� 10",
			alvo = "as criaturas na explos�o",
			ataque = mod.sabedoria,
			defesa = "Fort",
			dano = mod.dobra_21("d6", "", "Vento Resfriante"),
			efeito = "O alvo � conduzido 1 quadrado.",
		},
------- Poderes por Encontro n�vel 1 -------------------------------------------
		lampejo_algido = {
			nome = "Lampejo �lgido",
			uso = "En",
			acao = "padr�o",
			origem = set("congelante", "implemento", "primitivo"),
			tipo_ataque = "dist�ncia 1",
			alvo = "uma criatura",
			ataque = mod.sabedoria,
			defesa = "Fort",
			dano = function(self, ...)
				local dano = self.mod_sab
				if self.caracteristica_classe:match"uardi.o" then
					dano = dano + self.mod_con
				end
				return soma_dano(self, "1d6", dano, "Lampejo �lgido")
			end,
			efeito = "Sucesso: o alvo fica imobilizado at� o FdPT.",
		},
		convocar_relampagos = {
			nome = "Convocar Rel�mpagos",
			uso = "En",
			acao = "padr�o",
			origem = set("el�trico", "implemento", "primitivo", "trovejante"),
			tipo_ataque = "explos�o �rea 1 a at� 10",
			alvo = "as criaturas na explos�o",
			ataque = mod.sab,
			defesa = "Refl",
			dano = mod.dado_mod("1d8", "sabedoria", "Convocar Rel�mpagos"),
			efeito = "A explos�o cria uma zona de trov�es que persiste at� o final do pr�ximo turno.\nA zona causa -2 de penalidade no ataque dos inimigos dentro dela e quem sair da\nzona sofre 5 de dano trovejante.",
		},
		mordida_brusca = {
			nome = "Mordida Brusca",
			uso = "En",
			acao = "padr�o",
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
			acao = "padr�o",
			origem = set("implemento", "primitivo"),
			tipo_ataque = "explos�o �rea 1 a at� 10",
			alvo = "criaturas na explos�o",
			ataque = mod.sabedoria,
			defesa = "Ref",
			dano = mod.dado_mod("1d8", "sabedoria", "Vinhas Retorcidas"),
			efeito = "Sucesso: os quadrados adjacentes ao alvo tornam-se terreno acidentado at� FdPT.",
		},
------- Poderes Di�rios n�vel 1 ------------------------------------------------
		fogo_das_fadas = {
			nome = "Fogo das Fadas",
			uso = "Di",
			acao = "padr�o",
			origem = set("implemento", "primitivo", "radiante"),
			tipo_ataque = "explos�o �rea 1 a at� 10",
			alvo = "criaturas na explos�o",
			ataque = mod.sabedoria,
			defesa = "Vont",
			dano = mod.dado_mod("3d6", "sabedoria", "Fogo das Fadas"),
			efeito = function(self)
				return "Sucesso: primeiro, os alvos ficam lentos e concedem VdC (TR encerra).\n         S� quando passarem no TR recebem o dano e ainda concedem VdC at� FdPT.\nFracasso: 1d6+"..self.mod_sab.." e concede VdC at� o FdPT."
			end,
		},
		fogos_da_vida = {
			nome = "Fogos da Vida",
			uso = "Di",
			acao = "padr�o",
			origem = set("cura", "flamejante", "implemento", "primitivo"),
			tipo_ataque = "explos�o �rea 1 a at� 10",
			alvo = "inimigos na explos�o",
			ataque = mod.sabedoria,
			defesa = "Ref",
			dano = mod.dado_mod("1d6", "sabedoria", "Fogos da Vida"),
			efeito = function (self)
				return "Sucesso: +5 cont�nuo flamejante (TR encerra). Uma criatura a at� 5 quadrados do alvo recupera "..self.mod_con.." PV."
			end,
		},
		nevoa_da_escuridao = {
			nome = "N�voa da Escurid�o",
			uso = "Di",
			acao = "padr�o",
			origem = set("primitivo", "zona"),
			tipo_ataque = "explos�o �rea 1 a at� 10",
			alvo = '',
			efeito = "A zona de penumbra persiste at� o final do pr�ximo turno do druida.\nCom uma a��o m�nima, voc� pode persistir e aumentar a zona em 1 quadrado.",
		},
		prisao_de_vento = {
			nome = "Pris�o de Vento",
			uso = "Di",
			acao = "padr�o",
			origem = set("implemento", "primitivo"),
			tipo_ataque = "dist�ncia 10",
			alvo = "uma criatura",
			ataque = mod.sabedoria,
			defesa = "Refl",
			dano = mod.dado_mod("2d10", "sabedoria", "Pris�o de Vento"),
			efeito = "O alvo concede VdC at� se mover ou at� o final do encontro.\nQuando o alvo se mover, os inimigos do druida a at� 5 quadrados s�o derrubados.",
		},
------- Poderes Utilit�rios n�vel 2 --------------------------------------------
		pele_de_arvore = {
			nome = "Pele de �rvore",
			uso = "En",
			acao = "m�nima",
			origem = set("primitivo"),
			tipo_ataque = "dist�ncia 5",
			alvo = "o druida ou aliado",
			efeito = function(self)
				return "+"..self.mod_con.." na CA at� o FdPT."
			end,
		},
	},
}
