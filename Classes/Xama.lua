local set = require"DnD.Set"
local soma_dano = require"DnD.Soma".soma
local armas = require"DnD.Armas"
local tipos_armas = require"DnD.TiposArmas"
local mod = require"DnD.Modificadores"

return {
	nome = "Xam�",
	fonte_de_poder = "primitivo",
	fortitude = 1,
	vontade = 1,
	armaduras = set("traje", "corselete"),
	armas = tipos_armas("corpo simples", "lanca_longa"),
	implementos = set("totem"),
	pv = 12,
	pv_nivel = 5,
	pc_dia = 7,
	pericias = {
		natureza = "treinada",
		arcanismo = true,
		atletismo = true,
		historia = true,
		intuicao = true,
		percepcao = true,
		religiao = true,
		socorro = true,
		tolerancia = true,
	},
	total_pericias = 3,
	caracteristicas_classe = {
------- Caracter�sticas de Classe ----------------------------------------------
		espirito_de_cura = {
			nome = "Esp�rito de Cura",
			uso = "En",
			acao = "m�nima",
			origem = set("cura", "primitivo"),
			tipo_ataque = "explos�o cont�gua 5",
			alvo = "voc� ou um aliado na explos�o",
			efeito = function(self)
				local localizacao = self.pv_adicionais or ''
				return "O alvo gasta um PC e outro "..localizacao.."adjacente ao CE recupera 1d6 PV."
			end,
		},
		dadiva_do_espirito = {
			nome = "D�diva do Esp�rito",
			uso = "SL",
			acao = "nenhuma",
			origem = set("primitivo"),
			tipo_ataque = "aliados",
			alvo = "adjacentes ao CE",
			dano = function(self)
				return "+"..self.mod_int.." no dano contra inimigos sangrando."
			end,
			efeito = function(self)
				local c = (self.caracteristica_classe or ''):lower()
				if c:match"erseguidor" then
					return "Aliados adjacentes ao CE recebem +"..self.mod_int.." no dano contra inimigos sangrando."
				elseif c:match"rotetor" then
					return "Aliados adjacentes ao CE recuperam +"..self.mod_con.." PV ao retomar o f�lego ou nos poderes de cura aplicados pelo personagem."
				else
					Personagem.warn"Sem caracter�stica de classe definida."
					return "Sem efeito, pois n�o h� caracter�stica de classe definida."
				end
			end,
		},
		oportunidade = {
			nome = "Presas/Escudo do Esp�rito",
			uso = "SL",
			acao = "oportunidade",
			origem = set("esp�rito", "implemento", "primitivo"),
			tipo_ataque = "esp�rito corpo 1",
			alvo = "o inimigo adjacente que n�o ajustou",
			ataque = mod.sabedoria,
			defesa = "Ref",
			dano = function(self)
				if (self.caracteristica_classe or ''):match"erseguidor" then
					return mod.dobra_21("1d10", "sabedoria", "Presas do Esp�rito")(self)
				elseif (self.caracteristica_classe or ''):match"rotetor" then
					return self.mod_sab
				else
					return 0
				end
			end,
			efeito = function(self)
				if (self.caracteristica_classe or ''):match"rotetor" then
					return "Um aliado a at� 5 quadrados recupera "..self.mod_con.." PV."
				else
					return ""
				end
			end,
		},
		falar_com_os_espiritos = {
			nome = "Falar com os Esp�ritos",
			uso = "En",
			acao = "m�nima",
			origem = set("primitivo"),
			tipo_ataque = "pessoal",
			alvo = "voc�",
			efeito = function(self)
				local alvo = self.alvo_falar_com_os_espiritos or "voc�"
				return "Durante este turno, "..alvo.." recebe +"..self.mod_sab.." de b�nus no pr�ximo teste de per�cia."
			end,
		},
	},
	poderes = {
------- Poderes Sem Limite n�vel 1 ---------------------------------------------
		colera_do_inverno = {
			nome = "C�lera do Inverno",
			uso = "SL",
			acao = "padr�o",
			origem = set("congelante", "implemento", "primitivo", "teleporte"),
			tipo_ataque = "dist�ncia 5",
			alvo = "uma criatura",
			ataque = mod.sab,
			defesa = "Fort",
			dano = mod.dobra_21("d10", "sabedoria", "C�lera do Inverno"),
			efeito = "Sucesso: pode teleportar o CE para um espa�o adjacente ao alvo.",
		},
		espiritos_assombrosos = {
			nome = "Esp�ritos Assombrosos",
			uso = "SL",
			acao = "padr�o",
			origem = set("implemento", "primitivo", "psiquico"),
			tipo_ataque = "dist�ncia 5",
			alvo = "uma criatura",
			ataque = mod.sab,
			defesa = "Vont",
			dano = mod.dobra_21("d6", "sabedoria", "Esp�ritos Assombrosos"),
			efeito = "Sucesso: o alvo concede VdC a um aliado (escolha!) at� o FdPT.",
		},
		golpe_defensor = {
			nome = "Golpe Defensor",
			uso = "SL",
			acao = "padr�o",
			origem = set("espirito", "implemento", "primitivo"),
			tipo_ataque = "espirito corpo",
			alvo = "uma criatura",
			ataque = mod.sab,
			defesa = "Refl",
			dano = mod.dobra_21("d8", "sabedoria", "Golpe Defensor"),
			efeito = "Sucesso: +1 na CA at� o FdPT enquanto estiverem adjacentes ao CE.",
		},
		golpe_do_perseguidor = {
			nome = "Golpe do Perseguidor",
			uso = "SL",
			acao = "padr�o",
			origem = set("espirito", "implemento", "primitivo"),
			tipo_ataque = "espirito corpo",
			alvo = "uma criatura",
			ataque = mod.sab,
			defesa = "Fort",
			dano = mod.dobra_21("d10", "sabedoria", "Golpe do Perseguidor"),
			efeito = function(self)
				return "(+"..math.floor(self.mod_int/2).." no ataque se o alvo estiver sangrando)\nSucesso: o CE pode flanquear com voc� ou aliados at� o FdPT."
			end,
		},
		golpe_do_vigilante = {
			nome = "Golpe do Vigilante",
			uso = "SL",
			acao = "padr�o",
			origem = set("espirito", "implemento", "primitivo"),
			tipo_ataque = "espirito corpo",
			alvo = "uma criatura",
			ataque = mod.sab,
			defesa = "Refl",
			dano = mod.dobra_21("d8", "sabedoria", "Golpe do Vigilante"),
			efeito = function(self)
				return "Sucesso: +1 nos ataques e +5 em Percep��o aos adjacentes ao CE at� o FdPT."
			end,
		},
		golpe_protetor = {
			nome = "Golpe Protetor",
			uso = "SL",
			acao = "padr�o",
			origem = set("espirito", "implemento", "primitivo"),
			tipo_ataque = "espirito corpo",
			alvo = "uma criatura",
			ataque = mod.sab,
			defesa = "Vont",
			dano = mod.dobra_21("d8", "sabedoria", "Golpe Protetor"),
			efeito = function(self)
				return "Aliados adjacentes ao CE recebem +"..self.mod_con.."PVT."
			end,
		},
------- Poderes por Encontro n�vel 1 -------------------------------------------
		panteras_gemeas = {
			nome = "Panteras G�meas",
			uso = "En",
			acao = "padr�o",
			origem = set("implemento", "primitivo"),
			tipo_ataque = "distancia 5",
			alvo = "uma ou duas criaturas",
			ataque = mod.sab,
			defesa = "Refl",
			dano = mod.dado_mod("1d8", "sabedoria", "Panteras G�meas"),
			efeito = "Dois ataques.  O Xam� e aliados ganham VdC contra os inimigos adjacentes ao CE.",
		},
------- Poderes Di�rios n�vel 1 ------------------------------------------------
		colera_do_mundo_espiritual = {
			nome = "C�lera do Mundo Espiritual",
			uso = "Di",
			acao = "padr�o",
			origem = set("implemento", "primitivo", "psiquico"),
			tipo_ataque = "explos�o cont�gua 5",
			alvo = "inimigos na �rea ou adjacentes ao CE",
			ataque = mod.sab,
			defesa = "Vont",
			dano = mod.dado_mod("3d6", "sabedoria", "C�lera do Mundo Espiritual"),
			efeito = "Os alvos ficam derrubados.",
		},
------- Poderes Utilit�rios n�vel 2 --------------------------------------------
		elos_do_cla = {
			nome = "Elos do Cl�",
			uso = "Di",
			acao = "padr�o",
			origem = set("cura", "primitivo"),
			tipo_ataque = "dist�ncia 10",
			gatilho = "Um aliado a at� 10 sofre dano",
			efeito = "Divida o dano sofrido por um aliado.",
		},
		espirito_da_batalha = {
			nome = "Esp�rito da Batalha",
			uso = "Di",
			acao = "padr�o",
			origem = set("primitivo", "zona"),
			tipo_ataque = "explos�o �rea 5 a at� 10",
			efeito = "A explos�o cria uma zona que concede +1 de b�nus no ataque dos aliados.",
		},
------- Poderes por Encontro n�vel 3 -------------------------------------------
		espirito_do_fogo_gelido = {
			nome = "Esp�rito do Fogo-G�lido",
			uso = "En",
			acao = "padr�o",
			origem = set("cong.", "flam.", "implemento", "primitivo"),
			tipo_ataque = "dist�ncia 5",
			alvo = "uma criatura",
			ataque = mod.sab,
			defesa = "Vont",
			dano = mod.dado_mod("2d6", "sabedoria", "Esp�rito do Fogo-G�lido"),
			efeito = "Inimigos adjacentes ao CE => vulnerabilidade 5 a dano flamejante e congelante.",
		},
	},
}
