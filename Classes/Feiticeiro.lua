local set = require"DnD.Set"
local soma_dano = require"DnD.Soma".soma
local tipos_armas = require"DnD.TiposArmas"
local mod = require"DnD.Modificadores"

local function soma_bonus_dano (self, dado)
	local bonus = 0
	if self.caracteristica_classe:match"[Dd]rac.nic" then
		bonus = self.mod_for
	elseif self.caracteristica_classe:match"[Ss]elvagem" then
		bonus = self.mod_des
	else
		print ("Sem bônus no dano: característica de classe deve ser 'dracônica' ou 'selvagem'")
	end
	if self.nivel >= 21 then
		bonus = bonus + 4
	elseif self.nivel >= 11 then
		bonus = bonus + 2
	end
	return soma_dano(self, dado, bonus)
end

local function dobra_21 (dado, atributo, nome)
	local mod_atr = "mod_"..atributo:sub(1,3):lower()
	local dobro_dado = dado:gsub("^1", "2")
	if dobro_dado == dado then
		dobro_dado = "2"..dado
		dado = "1"..dado
	end
	return function(self)
		if self.nivel >= 21 then
			return soma_dano(self, soma_bonus_dano (self, dobro_dado), self[mod_atr], nome)
		else
			return soma_dano(self, soma_bonus_dano (self, dado), self[mod_atr], nome)
		end
	end
end

local function dado_mod (dado, poder)
	return function (self)
		dado = soma_bonus_dano (self, dado)
		return soma_dano(self, dado, self.mod_car, poder)
	end
end

return {
	nome = "Feiticeiro",
	fonte_de_poder = "arcano",
	vontade = 2,
	armaduras = set("traje"),
	armas = tipos_armas("corpo simples", "distancia simples"),
	implementos = set("adaga", "cajado"),
	pv = 12,
	pv_nivel = 5,
	pc_dia = 6,
	ca = function (self)
		local cat = self.armadura.categoria
		if self.caracteristica_classe:match"[Dd]rac.nic" and
			(cat == "traje" or cat == "corselete" or cat == "gibao") then
			local atr = math.max(self.mod_for, self.mod_des, self.mod_int)
			atr = atr - math.max(self.mod_des, self.mod_int)
			return false, atr
		else
			return false, 0
		end
	end,
	pericias = {
		arcanismo = "treinada",
		atletismo = true,
		blefe = true,
		diplomacia = true,
		exploracao = true,
		historia = true,
		intimidacao = true,
		intuicao = true,
		natureza = true,
		tolerancia = true,
	},
	total_pericias = 3,
	caracteristicas_classe = {
------- Características de Classe ----------------------------------------------
	},
	poderes = {
------- Poderes Sem Limite nível 1 ---------------------------------------------
		algidez_draconica = {
			nome = "Algidez Dracônica",
			uso = "SL",
			origem = set("arcano", "congelante", "implemento"),
			tipo_ataque = "distância 10",
			alvo = "uma criatura",
			ataque = mod.car,
			defesa = "Fort",
			dano = dobra_21("1d8", "carisma", "Algidez Dracônica"),
			efeito = "Sucesso: alvo é empurrado 1 quadrado.  Pode ser usado como ataque básico.",
		},
		caminhar_da_tempestade = {
			nome = "Caminhar da Tempestade",
			uso = "SL",
			origem = set("arcano", "implemento", "trovejante"),
			tipo_ataque = "distância 10",
			alvo = "uma criatura",
			ataque = mod.car,
			defesa = "Fort",
			dano = dobra_21("1d8", "carisma", "Caminhar da Tempestade"),
			efeito = "Ajusta 1 quadrado antes ou depois do ataque.",
		},
		jorro_ardente = {
			nome = "Jorro Ardente",
			uso = "SL",
			origem = set("arcano", "flamejante", "implemento"),
			tipo_ataque = "rajada 3",
			alvo = "criaturas na rajada",
			ataque = mod.car,
			defesa = "Ref",
			dano = dobra_21("1d8", "carisma", "Jorro Ardente"),
			efeito = function(self)
				if self.caracteristica_classe:match"[Dd]rac.nic" then
					return "O próximo inimigo que te atingir com um ataque CaC até o FdPT sofre "..self.mod_for.." de dano flamejante."
				else
					return ""
				end
			end,
		},
		orbe_acido = {
			nome = "Orbe Ácido",
			uso = "SL",
			origem = set("ácido", "arcano", "implemento"),
			tipo_ataque = "distância 20",
			alvo = "uma criatura",
			ataque = mod.car,
			defesa = "Ref",
			dano = dobra_21("1d10", "carisma", "Orbe Ácido"),
			efeito = "Pode ser usado como um ataque básico à distância.",
		},
		raio_do_caos = {
			nome = "Raio do Caos",
			uso = "SL",
			origem = set("arcano", "implemento", "psíquico"),
			tipo_ataque = "distância 10",
			alvo = "uma criatura",
			ataque = mod.car,
			defesa = "Von",
			dano = dobra_21("1d10", "carisma", "Raio do Caos"),
			efeito = "Se tirar par no ataque, realiza um ataque secundário contra outra criatura a até\n5 quadrados da anterior, causando 1d6 de dano.",
		},
------- Poderes por Encontro nível 1 -------------------------------------------
		elo_algido = {
			nome = "Elo Álgido",
			uso = "En",
			acao = "padrão",
			origem = set("arcano", "congelante", "implemento"),
			tipo_ataque = "distância 10",
			alvo = "uma criatura",
			ataque = mod.car,
			defesa = "Fort",
			dano = dado_mod("3d6", "carisma", "Elo Álgido"),
			efeito = "Sucesso: alvo sofre -2 em Reflexos até o FdPT.",
		},
		explosao_molestadora = {
			nome = "Explosão Molestadora",
			uso = "En",
			acao = "padrão",
			origem = set("arcano", "implemento", "psíquico"),
			tipo_ataque = "explosão contígua 3",
			alvo = "uma ou duas criaturas na explosão",
			ataque = mod.car,
			defesa = "Vont",
			dano = dado_mod("1d10", "carisma", "Explosão Molestadora"),
			efeito = function(self)
				local movimento = self.caracteristica_classe:match"[Ss]elvagem"
					and "conduzido"
					or "empurrado"
				return "Sucesso: o alvo é "..movimento.." "..self.mod_des.." quadrados."
			end,
		},
		manto_das_chamas_draconicas = {
			nome = "Manto das Chamas Dracônicas",
			uso = "En",
			acao = "Interrupção Imediata",
			origem = set("arcano", "flamejante"),
			tipo_ataque = "",
			alvo = "pessoal",
			gatilho = "Você é atingido por um ataque",
			efeito = "Até o FdPT, você recebe +1 de bônus de podes em todas as\ndefesas e qualquer criatura que atingí-lo com um ataque corpo-a-corpo sofre\n1d6 de dano flamejante.",
		},
		pancada_trovejante = {
			nome = "Pancada Trovejante",
			uso = "En",
			origem = set("arcano", "implemento", "trovejante"),
			tipo_ataque = "distância 10",
			alvo = "uma criatura",
			ataque = mod.car,
			defesa = "Fort",
			dano = dado_mod("2d10", "car", "Pancada Trovejante"),
			efeito = "O alvo é empurrado 3 quadrados.",
		},
------- Poderes Diários nível 1 ------------------------------------------------
		raio_da_presa_draconica = {
			nome = "Raio Deslumbrante",
			uso = "Di",
			origem = set("arcano", "implemento", "venenoso"),
			tipo_ataque = "distância 10",
			alvo = "uma ou duas criaturas",
			ataque = mod.car,
			defesa = "Fort",
			dano = dado_mod("2d8", "carisma", "Raio Deslumbrante"),
			efeito = "Sucesso: 5 de dano venenoso contínuo.\nFracasso: sem dano contínuo.",
		},
		raio_deslumbrante = {
			nome = "Raio Deslumbrante",
			uso = "Di",
			origem = set("arcano", "implemento", "radiante"),
			tipo_ataque = "distância 10",
			alvo = "uma criatura",
			ataque = mod.car,
			defesa = "Vont",
			dano = dado_mod("6d6", "carisma", "Raio Deslumbrante"),
			efeito = function(self)
				return "Se tirar par no ataque, o alvo sofre -"..self.mod_des.." de penalidade nos ataques contra ele\n(TR encerra).  Fracasso = metade do dano."
			end,
		},
------- Poderes por Encontro nível 3 -------------------------------------------
		dente_do_dragao_de_gelo = {
			nome = "Dente do Dragão de Gelo",
			uso = "En",
			acao = "padrão",
			origem = set("arcano", "congelante", "implemento"),
			tipo_ataque = "área 1 a até 10",
			alvo = "as criaturas dentro da explosão",
			ataque = mod.car,
			defesa = "Refl",
			dano = dado_mod("2d8", "carisma", "Dente do Dragão de Gelo"),
			efeito = "Os alvos ficam lentos até o FdPT.",
		},
		relampago_dancarino = {
			nome = "Relâmpago Dançarino",
			uso = "En",
			acao = "padrao",
			origem = set("arcano", "elétrico", "implemento", "trovejante"),
			tipo_ataque = "distância 10",
			alvo = "uma criatura",
			ataque = mod.car,
			defesa = "Refl",
			dano = dado_mod("2d10", "carisma", "Relâmpago Dançarino"),
			efeito = function(self)
				return "As criaturas adjacentes ao alvo sofrem "..self.mod_car.." de dano trovejante."
			end,
		},
	},
}
