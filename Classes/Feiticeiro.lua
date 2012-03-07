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
		print ("Sem b�nus no dano: caracter�stica de classe deve ser 'drac�nica' ou 'selvagem'")
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
------- Caracter�sticas de Classe ----------------------------------------------
	},
	poderes = {
------- Poderes Sem Limite n�vel 1 ---------------------------------------------
		algidez_draconica = {
			nome = "Algidez Drac�nica",
			uso = "SL",
			origem = set("arcano", "congelante", "implemento"),
			tipo_ataque = "dist�ncia 10",
			alvo = "uma criatura",
			ataque = mod.car,
			defesa = "Fort",
			dano = dobra_21("1d8", "carisma", "Algidez Drac�nica"),
			efeito = "Sucesso: alvo � empurrado 1 quadrado.  Pode ser usado como ataque b�sico.",
		},
		caminhar_da_tempestade = {
			nome = "Caminhar da Tempestade",
			uso = "SL",
			origem = set("arcano", "implemento", "trovejante"),
			tipo_ataque = "dist�ncia 10",
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
					return "O pr�ximo inimigo que te atingir com um ataque CaC at� o FdPT sofre "..self.mod_for.." de dano flamejante."
				else
					return ""
				end
			end,
		},
		orbe_acido = {
			nome = "Orbe �cido",
			uso = "SL",
			origem = set("�cido", "arcano", "implemento"),
			tipo_ataque = "dist�ncia 20",
			alvo = "uma criatura",
			ataque = mod.car,
			defesa = "Ref",
			dano = dobra_21("1d10", "carisma", "Orbe �cido"),
			efeito = "Pode ser usado como um ataque b�sico � dist�ncia.",
		},
		raio_do_caos = {
			nome = "Raio do Caos",
			uso = "SL",
			origem = set("arcano", "implemento", "ps�quico"),
			tipo_ataque = "dist�ncia 10",
			alvo = "uma criatura",
			ataque = mod.car,
			defesa = "Von",
			dano = dobra_21("1d10", "carisma", "Raio do Caos"),
			efeito = "Se tirar par no ataque, realiza um ataque secund�rio contra outra criatura a at�\n5 quadrados da anterior, causando 1d6 de dano.",
		},
------- Poderes por Encontro n�vel 1 -------------------------------------------
		elo_algido = {
			nome = "Elo �lgido",
			uso = "En",
			acao = "padr�o",
			origem = set("arcano", "congelante", "implemento"),
			tipo_ataque = "dist�ncia 10",
			alvo = "uma criatura",
			ataque = mod.car,
			defesa = "Fort",
			dano = dado_mod("3d6", "carisma", "Elo �lgido"),
			efeito = "Sucesso: alvo sofre -2 em Reflexos at� o FdPT.",
		},
		explosao_molestadora = {
			nome = "Explos�o Molestadora",
			uso = "En",
			acao = "padr�o",
			origem = set("arcano", "implemento", "ps�quico"),
			tipo_ataque = "explos�o cont�gua 3",
			alvo = "uma ou duas criaturas na explos�o",
			ataque = mod.car,
			defesa = "Vont",
			dano = dado_mod("1d10", "carisma", "Explos�o Molestadora"),
			efeito = function(self)
				local movimento = self.caracteristica_classe:match"[Ss]elvagem"
					and "conduzido"
					or "empurrado"
				return "Sucesso: o alvo � "..movimento.." "..self.mod_des.." quadrados."
			end,
		},
		manto_das_chamas_draconicas = {
			nome = "Manto das Chamas Drac�nicas",
			uso = "En",
			acao = "Interrup��o Imediata",
			origem = set("arcano", "flamejante"),
			tipo_ataque = "",
			alvo = "pessoal",
			gatilho = "Voc� � atingido por um ataque",
			efeito = "At� o FdPT, voc� recebe +1 de b�nus de podes em todas as\ndefesas e qualquer criatura que ating�-lo com um ataque corpo-a-corpo sofre\n1d6 de dano flamejante.",
		},
		pancada_trovejante = {
			nome = "Pancada Trovejante",
			uso = "En",
			origem = set("arcano", "implemento", "trovejante"),
			tipo_ataque = "dist�ncia 10",
			alvo = "uma criatura",
			ataque = mod.car,
			defesa = "Fort",
			dano = dado_mod("2d10", "car", "Pancada Trovejante"),
			efeito = "O alvo � empurrado 3 quadrados.",
		},
------- Poderes Di�rios n�vel 1 ------------------------------------------------
		raio_da_presa_draconica = {
			nome = "Raio Deslumbrante",
			uso = "Di",
			origem = set("arcano", "implemento", "venenoso"),
			tipo_ataque = "dist�ncia 10",
			alvo = "uma ou duas criaturas",
			ataque = mod.car,
			defesa = "Fort",
			dano = dado_mod("2d8", "carisma", "Raio Deslumbrante"),
			efeito = "Sucesso: 5 de dano venenoso cont�nuo.\nFracasso: sem dano cont�nuo.",
		},
		raio_deslumbrante = {
			nome = "Raio Deslumbrante",
			uso = "Di",
			origem = set("arcano", "implemento", "radiante"),
			tipo_ataque = "dist�ncia 10",
			alvo = "uma criatura",
			ataque = mod.car,
			defesa = "Vont",
			dano = dado_mod("6d6", "carisma", "Raio Deslumbrante"),
			efeito = function(self)
				return "Se tirar par no ataque, o alvo sofre -"..self.mod_des.." de penalidade nos ataques contra ele\n(TR encerra).  Fracasso = metade do dano."
			end,
		},
------- Poderes por Encontro n�vel 3 -------------------------------------------
		dente_do_dragao_de_gelo = {
			nome = "Dente do Drag�o de Gelo",
			uso = "En",
			acao = "padr�o",
			origem = set("arcano", "congelante", "implemento"),
			tipo_ataque = "�rea 1 a at� 10",
			alvo = "as criaturas dentro da explos�o",
			ataque = mod.car,
			defesa = "Refl",
			dano = dado_mod("2d8", "carisma", "Dente do Drag�o de Gelo"),
			efeito = "Os alvos ficam lentos at� o FdPT.",
		},
		relampago_dancarino = {
			nome = "Rel�mpago Dan�arino",
			uso = "En",
			acao = "padrao",
			origem = set("arcano", "el�trico", "implemento", "trovejante"),
			tipo_ataque = "dist�ncia 10",
			alvo = "uma criatura",
			ataque = mod.car,
			defesa = "Refl",
			dano = dado_mod("2d10", "carisma", "Rel�mpago Dan�arino"),
			efeito = function(self)
				return "As criaturas adjacentes ao alvo sofrem "..self.mod_car.." de dano trovejante."
			end,
		},
	},
}
