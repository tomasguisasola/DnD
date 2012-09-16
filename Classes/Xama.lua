local set = require"DnD.Set"
local soma_dano = require"DnD.Soma".soma
local armas = require"DnD.Armas"
local tipos_armas = require"DnD.TiposArmas"
local mod = require"DnD.Modificadores"

return {
	nome = "Xamã",
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
------- Características de Classe ----------------------------------------------
		espirito_de_cura = {
			nome = "Espírito de Cura",
			uso = "En",
			acao = "mínima",
			origem = set("cura", "primitivo"),
			tipo_ataque = "explosão contígua 5",
			alvo = "você ou um aliado na explosão",
			efeito = function(self)
				local localizacao = self.pv_adicionais or ''
				return "O alvo gasta um PC e outro "..localizacao.."adjacente ao CE recupera 1d6 PV."
			end,
		},
		dadiva_do_espirito = {
			nome = "Dádiva do Espírito",
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
					return "Aliados adjacentes ao CE recuperam +"..self.mod_con.." PV ao retomar o fôlego ou nos poderes de cura aplicados pelo personagem."
				else
					Personagem.warn"Sem característica de classe definida."
					return "Sem efeito, pois não há característica de classe definida."
				end
			end,
		},
		oportunidade = {
			nome = "Presas/Escudo do Espírito",
			uso = "SL",
			acao = "oportunidade",
			origem = set("espírito", "implemento", "primitivo"),
			tipo_ataque = "espírito corpo 1",
			alvo = "o inimigo adjacente que não ajustou",
			ataque = mod.sabedoria,
			defesa = "Ref",
			dano = function(self)
				if (self.caracteristica_classe or ''):match"erseguidor" then
					return mod.dobra_21("1d10", "sabedoria", "Presas do Espírito")(self)
				elseif (self.caracteristica_classe or ''):match"rotetor" then
					return self.mod_sab
				else
					return 0
				end
			end,
			efeito = function(self)
				if (self.caracteristica_classe or ''):match"rotetor" then
					return "Um aliado a até 5 quadrados recupera "..self.mod_con.." PV."
				else
					return ""
				end
			end,
		},
		falar_com_os_espiritos = {
			nome = "Falar com os Espíritos",
			uso = "En",
			acao = "mínima",
			origem = set("primitivo"),
			tipo_ataque = "pessoal",
			alvo = "você",
			efeito = function(self)
				local alvo = self.alvo_falar_com_os_espiritos or "você"
				return "Durante este turno, "..alvo.." recebe +"..self.mod_sab.." de bônus no próximo teste de perícia."
			end,
		},
	},
	poderes = {
------- Poderes Sem Limite nível 1 ---------------------------------------------
		colera_do_inverno = {
			nome = "Cólera do Inverno",
			uso = "SL",
			acao = "padrão",
			origem = set("congelante", "implemento", "primitivo", "teleporte"),
			tipo_ataque = "distância 5",
			alvo = "uma criatura",
			ataque = mod.sab,
			defesa = "Fort",
			dano = mod.dobra_21("d10", "sabedoria", "Cólera do Inverno"),
			efeito = "Sucesso: pode teleportar o CE para um espaço adjacente ao alvo.",
		},
		espiritos_assombrosos = {
			nome = "Espíritos Assombrosos",
			uso = "SL",
			acao = "padrão",
			origem = set("implemento", "primitivo", "psiquico"),
			tipo_ataque = "distância 5",
			alvo = "uma criatura",
			ataque = mod.sab,
			defesa = "Vont",
			dano = mod.dobra_21("d6", "sabedoria", "Espíritos Assombrosos"),
			efeito = "Sucesso: o alvo concede VdC a um aliado (escolha!) até o FdPT.",
		},
		golpe_defensor = {
			nome = "Golpe Defensor",
			uso = "SL",
			acao = "padrão",
			origem = set("espirito", "implemento", "primitivo"),
			tipo_ataque = "espirito corpo",
			alvo = "uma criatura",
			ataque = mod.sab,
			defesa = "Refl",
			dano = mod.dobra_21("d8", "sabedoria", "Golpe Defensor"),
			efeito = "Sucesso: +1 na CA até o FdPT enquanto estiverem adjacentes ao CE.",
		},
		golpe_do_perseguidor = {
			nome = "Golpe do Perseguidor",
			uso = "SL",
			acao = "padrão",
			origem = set("espirito", "implemento", "primitivo"),
			tipo_ataque = "espirito corpo",
			alvo = "uma criatura",
			ataque = mod.sab,
			defesa = "Fort",
			dano = mod.dobra_21("d10", "sabedoria", "Golpe do Perseguidor"),
			efeito = function(self)
				return "(+"..math.floor(self.mod_int/2).." no ataque se o alvo estiver sangrando)\nSucesso: o CE pode flanquear com você ou aliados até o FdPT."
			end,
		},
		golpe_do_vigilante = {
			nome = "Golpe do Vigilante",
			uso = "SL",
			acao = "padrão",
			origem = set("espirito", "implemento", "primitivo"),
			tipo_ataque = "espirito corpo",
			alvo = "uma criatura",
			ataque = mod.sab,
			defesa = "Refl",
			dano = mod.dobra_21("d8", "sabedoria", "Golpe do Vigilante"),
			efeito = function(self)
				return "Sucesso: +1 nos ataques e +5 em Percepção aos adjacentes ao CE até o FdPT."
			end,
		},
		golpe_protetor = {
			nome = "Golpe Protetor",
			uso = "SL",
			acao = "padrão",
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
------- Poderes por Encontro nível 1 -------------------------------------------
		panteras_gemeas = {
			nome = "Panteras Gêmeas",
			uso = "En",
			acao = "padrão",
			origem = set("implemento", "primitivo"),
			tipo_ataque = "distancia 5",
			alvo = "uma ou duas criaturas",
			ataque = mod.sab,
			defesa = "Refl",
			dano = mod.dado_mod("1d8", "sabedoria", "Panteras Gêmeas"),
			efeito = "Dois ataques.  O Xamã e aliados ganham VdC contra os inimigos adjacentes ao CE.",
		},
------- Poderes Diários nível 1 ------------------------------------------------
		colera_do_mundo_espiritual = {
			nome = "Cólera do Mundo Espiritual",
			uso = "Di",
			acao = "padrão",
			origem = set("implemento", "primitivo", "psiquico"),
			tipo_ataque = "explosão contígua 5",
			alvo = "inimigos na área ou adjacentes ao CE",
			ataque = mod.sab,
			defesa = "Vont",
			dano = mod.dado_mod("3d6", "sabedoria", "Cólera do Mundo Espiritual"),
			efeito = "Os alvos ficam derrubados.",
		},
------- Poderes Utilitários nível 2 --------------------------------------------
		elos_do_cla = {
			nome = "Elos do Clã",
			uso = "Di",
			acao = "padrão",
			origem = set("cura", "primitivo"),
			tipo_ataque = "distância 10",
			gatilho = "Um aliado a até 10 sofre dano",
			efeito = "Divida o dano sofrido por um aliado.",
		},
		espirito_da_batalha = {
			nome = "Espírito da Batalha",
			uso = "Di",
			acao = "padrão",
			origem = set("primitivo", "zona"),
			tipo_ataque = "explosão área 5 a até 10",
			efeito = "A explosão cria uma zona que concede +1 de bônus no ataque dos aliados.",
		},
------- Poderes por Encontro nível 3 -------------------------------------------
		espirito_do_fogo_gelido = {
			nome = "Espírito do Fogo-Gélido",
			uso = "En",
			acao = "padrão",
			origem = set("cong.", "flam.", "implemento", "primitivo"),
			tipo_ataque = "distância 5",
			alvo = "uma criatura",
			ataque = mod.sab,
			defesa = "Vont",
			dano = mod.dado_mod("2d6", "sabedoria", "Espírito do Fogo-Gélido"),
			efeito = "Inimigos adjacentes ao CE => vulnerabilidade 5 a dano flamejante e congelante.",
		},
	},
}
