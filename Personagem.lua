local math   = require"math"
local string = require"string"

local set = require"DnD.Set"
local soma_dano = require"DnD.Soma".soma
local mult_dano = require"DnD.Soma".mult
local resolve = require"DnD.Soma".resolve

local armaduras = require"DnD.Armaduras"
local armas = require"DnD.Armas"
local implementos = require"DnD.Implementos"
local itens = require"DnD.Itens"
local pericias = require"DnD.Pericias"
local racas = require"DnD.Racas"
local classes = require"DnD.Classes"
local talentos = require"DnD.Talentos"

string.tagged = function(s, tags)
	return s:gsub("%$([%w_]+)", tags)
end

local function atributo(atrib)
	return function (self)
		local classe = classes[self.classe][atrib] or 0
		local racial = self.minha_raca[atrib] or 0
		local op = self.minha_raca.atributos_opcionais
		local racial_opcional = 0
		if op and self[op.nome] == atrib then
			racial_opcional = op[self[op.nome]]
		end
		return (self["_"..atrib] or 0) + classe + racial + racial_opcional
	end
end

local function modificador(atrib)
	return function (self)
		return math.floor(self[atrib]/2) -5
	end
end

local function pericia(pericia)
	return function (self)
		local essa_pericia = pericias[pericia]
		local racial = self.minha_raca.pericias and self.minha_raca.pericias[pericia] or 0
		local atributo = essa_pericia.atributo
		local pericia_classe = self.minha_classe.pericias[pericia]
		local treino = 0
		if ((pericia_classe == true or self.minha_raca.treinamento_pericia_qualquer)
			and self.pericias[pericia]) or pericia_classe == "treinada" then
			treino = 5
		elseif self.minha_classe.pericias.nao_treinadas then
			treino = self.minha_classe.pericias.nao_treinadas
		end
		local nivel = math.floor(self.nivel/2)
		local atributo = self["mod_"..atributo:sub(1,3)]
		local penalidade = 0
		if essa_pericia.penalidade == "armadura" then
			local categoria_armadura = armaduras[self.armadura.categoria]
			penalidade = categoria_armadura.penalidade or 0
		end
		local item = 0
		for nome, meu in pairs(self.itens) do
			meu = itens[nome] or meu
			assert (type(meu) == "table", "N�o achei a descri��o de "..nome)
			item = soma_dano(self, item, meu[pericia], nome)
			if essa_pericia.penalidade == "armadura" then
				penalidade = penalidade + (meu.penalidade or 0)
			end
		end
		local armadura = 0
		if self.armadura.magica then
			local minha_armadura = armaduras[self.armadura.magica]
			armadura = soma_dano(self, armadura, minha_armadura[pericia], self.armadura.magica)
		end
		local talento = 0
		for nome, meu in pairs(self.talentos) do
			meu = talentos[nome] or meu
			local bonus_pericia = meu[pericia]
			if type(bonus_pericia) == "function" then
				bonus_pericia = bonus_pericia(self, pericia)
			elseif bonus_pericia == "treinada" then
				treino = 5
			end
			talento = soma_dano(self, talento, bonus_pericia, nome)
		end
		self["treino_"..pericia] = (treino == 5) and '!' or ' '
		local soma = nivel + treino + racial + atributo + penalidade + item + armadura + talento
		return string.format("%2d", soma)
	end
end

Personagem = {
	nome = "sem nome",
	nivel = 1,
	armadura = "traje",

	forca = atributo"forca",
	constituicao = atributo"constituicao",
	destreza = atributo"destreza",
	inteligencia = atributo"inteligencia",
	sabedoria = atributo"sabedoria",
	carisma = atributo"carisma",

	mod_for = modificador"forca",
	mod_con = modificador"constituicao",
	mod_des = modificador"destreza",
	mod_int = modificador"inteligencia",
	mod_sab = modificador"sabedoria",
	mod_car = modificador"carisma",

	pv = function(self)
		local classe = classes[self.classe]
		local pv_item = 0
		for nome, item in pairs(self.itens or {}) do
			item = itens[nome] or item
			pv_item = soma_dano(self, pv_item, item.pv, nome)
		end
		local pv_nivel = (classe.pv_nivel * (self.nivel-1))
		local pv_estagio = 0
		for nome in pairs(self.talentos) do
			local meu_talento = talentos[nome]
			pv_nivel = pv_nivel + (meu_talento.pv_nivel or 0)
			pv_estagio = pv_estagio + (meu_talento.pv_estagio or 0)
		end
		return classe.pv + self.constituicao + pv_nivel + pv_item + pv_estagio
	end,
	sangrando = function(self)
		return math.floor(self.pv/2)
	end,
	pc = function(self)
		local pc_item = 0
		for nome, item in pairs(self.itens or {}) do
			item = itens[nome] or item
			pc_item = soma_dano(self, pc_item, item.pc, nome)
		end
		local pc_talento = 0
		for nome in pairs(self.talentos) do
			local talento = talentos[nome]
			if talento.pc then
				pc_talento = soma_dano(self, pc_talento, talento.pc, nome)
			end
		end
		return classes[self.classe].pc_dia + self.mod_con + pc_item + pc_talento
	end,
	pv_pc = function(self)
		local raca = 0
		if self.raca == "draconato" then
			raca = self.mod_con
		end
		local pv_pc_item = 0
		for nome, item in pairs(self.itens or {}) do
			item = itens[nome] or item
			pv_pc_item = soma_dano(self, pv_pc_item, item.pv_pc, nome)
		end
		return math.floor(self.pv/4) + raca + pv_pc_item
	end,

	deslocamento = function(self)
		local basico = 0
		local classe = classes[self.classe].deslocamento
		if classe then
			local ok
			ok, basico = classe(self)
			if ok then
				return basico
			end
		end
		local categoria_armadura = armaduras[self.armadura.categoria]
		local penalidade = categoria_armadura.deslocamento or 0
		return basico + racas[self.raca].deslocamento + penalidade
	end,
	iniciativa = function(self)
		local classe = classes[self.classe].iniciativa or 0
		local talento = 0
		for nome in pairs(self.talentos) do
			local meu_talento = talentos[nome]
			talento = talento + (meu_talento.iniciativa or 0)
		end
		return math.floor(self.nivel/2) + self.mod_des + classe + talento
	end,

	implemento = "",
	armas = {},
	implementos = {},
	itens = {},
	pericias = {},
	poderes = {},
	talentos = {},

	acrobacia = pericia"acrobacia",
	arcanismo = pericia"arcanismo",
	atletismo = pericia"atletismo",
	blefe = pericia"blefe",
	diplomacia = pericia"diplomacia",
	exploracao = pericia"exploracao",
	furtividade = pericia"furtividade",
	historia = pericia"historia",
	intimidacao = pericia"intimidacao",
	intuicao = pericia"intuicao",
	ladinagem = pericia"ladinagem",
	manha = pericia"manha",
	natureza = pericia"natureza",
	percepcao = pericia"percepcao",
	religiao = pericia"religiao",
	socorro = pericia"socorro",
	tolerancia = pericia"tolerancia",

	intuicao_passiva = function(self) return 10 + self.intuicao end,
	percepcao_passiva = function(self) return 10 + self.percepcao end,

	warn = print,
}

function Personagem:ca()
	local bonus_classe = resolve (self.minha_classe.ca, self) or 0
	local bonus_op_classe = resolve (self.minha_classe.ca_oportunidade, self) or 0
	local categoria_armadura = armaduras[self.armadura.categoria]
	local bonus_atrib = 0
	if categoria_armadura.tipo == "leve" then
		bonus_atrib = math.max(self.mod_des, self.mod_int)
	end
	local bonus_armadura = 0
	if self.minha_classe.armaduras[self.armadura.categoria] or
		self.talentos.proficiencia_com_armadura == self.armadura.categoria then
		bonus_armadura = categoria_armadura.bonus
	else
		Personagem.warn ("\t!!! O personagem n�o � proficiente com esse tipo de armadura: "..self.armadura.categoria.."!!!")
	end
	local armadura_magica = armaduras[self.armadura.magica]
	local bonus_magica = 0
	if armadura_magica then
		assert(armadura_magica.categoria[self.armadura.categoria],
			"Armadura "..armadura_magica.nome.." n�o serve para a categoria `"
			..self.armadura.categoria.."'")
		bonus_magica = armadura_magica.ca or 0
	end
	local bonus_item, bonus_op_item = 0, 0
	for meu_item in pairs(self.itens) do
		local esse_item = assert (itens[meu_item], "N�o achei a descri��o de "..meu_item)
		if esse_item.escudo then
			if self.minha_classe.armaduras[esse_item.peso] then
				bonus_item = soma_dano(self, bonus_item, esse_item.ca)
				bonus_op_item = soma_dano(self, bonus_op_item, esse_item.ca_oportunidade)
			end
		else
			bonus_item = soma_dano(self, bonus_item, esse_item.ca)
			bonus_op_item = soma_dano(self, bonus_op_item, esse_item.ca_oportunidade)
		end
	end
	local bonus_implemento, bonus_op_implemento = 0, 0
	for nome, meu_implemento in pairs(self.implementos) do
		bonus_implemento = soma_dano(self, bonus_implemento, meu_implemento.ca)
		bonus_op_implemento = soma_dano(self, bonus_op_implemento, meu_implemento.ca_oportunidade)
	end
	local bonus_talento, bonus_op_talento = 0, 0
	for meu_talento in pairs(self.talentos) do
		local esse_talento = talentos[meu_talento]
		bonus_talento = soma_dano(self, bonus_talento, esse_talento.ca)
		bonus_op_talento = soma_dano(self, bonus_op_talento, esse_talento.ca_oportunidade)
	end
	local ca = 10 + math.floor(self.nivel/2) + bonus_atrib + bonus_armadura + bonus_magica + bonus_item + bonus_implemento + bonus_classe + bonus_talento
	local bonus_op_raca = resolve (racas[self.raca].ca_oportunidade, self) or 0
	self.ca_oportunidade = ca + bonus_op_classe + bonus_op_item + bonus_op_implemento + bonus_op_talento + bonus_op_raca
--[==[ --!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
Personagem.warn (string.format("10+%d(n�vel)+%d(leve)+%d(armadura)+%d(magica)+%d(item)+%d(implemento)+%d(classe)+%d(talento)\n[+%d(classe)+%d(item)+%d(implemento)+%d(talento)+%d(raca)",
	math.floor(self.nivel/2), bonus_atrib, bonus_armadura, bonus_magica, bonus_item, bonus_implemento, bonus_classe, bonus_talento,
	bonus_op_classe, bonus_op_item, bonus_op_implemento, bonus_op_talento, bonus_op_raca))
--]==]
	return ca
end

function Personagem:fortitude()
	if type(self.minha_classe.fortitude) == "function" then
		return self.minha_classe.fortitude(self)
	end
	local nivel = math.floor(self.nivel/2)
	local atrib = math.max(self.mod_for, self.mod_con)
	local racial = racas[self.raca].fortitude or 0
	local classe = self.minha_classe.fortitude or 0
	local impl = 0
	for meu, implemento in pairs(self.implementos) do
		impl = soma_dano(self, impl, implemento.fortitude)
	end
	local item = 0
	for meu in pairs(self.itens) do
		item = soma_dano(self, item, itens[meu].fortitude)
	end
	return 10 + nivel + atrib + racial + classe + impl + item
end

function Personagem:reflexos()
	local classe = 0
	if type(self.minha_classe.reflexos) == "function" then
		local fim, ref = self.minha_classe.reflexos(self)
		if fim then
			return ref
		end
		classe = ref
	elseif self.minha_classe.reflexos then
		classe = self.minha_classe.reflexos
	end
	local nivel = math.floor(self.nivel/2)
	local atrib = math.max(self.mod_des, self.mod_int)
	local racial = racas[self.raca].reflexos or 0
	local impl = 0
	for meu, implemento in pairs(self.implementos) do
		impl = soma_dano(self, impl, implemento.reflexos)
	end
	local item = 0
	for meu in pairs(self.itens) do
		item = soma_dano(self, item, itens[meu].reflexos)
	end
--[[
	local escudo = 0
	if self.escudo == "leve" then
		escudo = 1
	elseif self.escudo == "pesado" then
		escudo = 2
	end
--]]
	return 10 + nivel + atrib + racial + classe + impl + item --+ escudo
end

function Personagem:vontade()
	if type(self.minha_classe.vontade) == "function" then
		return self.minha_classe.vontade(self)
	end
	local nivel = math.floor(self.nivel/2)
	local atrib = math.max(self.mod_sab, self.mod_car)
	local racial = racas[self.raca].vontade or 0
	local classe = self.minha_classe.vontade or 0
	local impl = 0
	for meu, implemento in pairs(self.implementos) do
		impl = soma_dano(self, impl, implemento.vontade)
	end
	local item = 0
	for meu in pairs(self.itens) do
		item = soma_dano(self, item, itens[meu].vontade)
	end
	return 10 + nivel + atrib + racial + classe + impl + item
end

local _modelo_pericias = [[
Acrobacia$treino_acrobacia   $acrobacia   Arcanismo$treino_arcanismo  $arcanismo   Atletismo$treino_atletismo   $atletismo   Blefe$treino_blefe    $blefe
Diplomacia$treino_diplomacia  $diplomacia   Explora��o$treino_exploracao $exploracao   Furtividade$treino_furtividade $furtividade   Hist�ria$treino_historia $historia
Intimida��o$treino_intimidacao $intimidacao   Intui��o$treino_intuicao   $intuicao   Ladinagem$treino_ladinagem   $ladinagem   Manha$treino_manha    $manha
Natureza$treino_natureza    $natureza   Percep��o$treino_percepcao  $percepcao   Religi�o$treino_religiao    $religiao   Socorro$treino_socorro  $socorro   Toler�ncia$treino_tolerancia $tolerancia
]]
local modelo_pericias = [[
Acrobacia$treino_acrobacia $acrobacia  Diplomacia$treino_diplomacia  $diplomacia  Intimida��o$treino_intimidacao $intimidacao  Natureza$treino_natureza  $natureza  Toler�ncia$treino_tolerancia $tolerancia
Arcanismo$treino_arcanismo $arcanismo  Explora��o$treino_exploracao  $exploracao  Intui��o$treino_intuicao    $intuicao  Percep��o$treino_percepcao $percepcao
Atletismo$treino_atletismo $atletismo  Furtividade$treino_furtividade $furtividade  Ladinagem$treino_ladinagem   $ladinagem  Religi�o$treino_religiao  $religiao
Blefe$treino_blefe     $blefe  Hist�ria$treino_historia    $historia  Manha$treino_manha       $manha  Socorro$treino_socorro   $socorro
]]

local modelo_geral = [[
  $nome  ($raca $classe)            n�vel $nivel  $xp XP
CA:  $ca [$ca_oportunidade]  Fortitude: $fortitude  Reflexos: $reflexos  Vontade: $vontade            $dinheiro PO
FOR: $forca (+$mod_for)  DES: $destreza (+$mod_des)  SAB: $sabedoria (+$mod_sab)    Intui��o Passiva: $intuicao_passiva
CON: $constituicao (+$mod_con)  INT: $inteligencia (+$mod_int)  CAR: $carisma (+$mod_car)    Percep��o Passiva: $percepcao_passiva
PV: $pv ($sangrando)  PC = $pc (+$pv_pc PV)  Deslocamento: $deslocamento  Iniciativa: $iniciativa
]]
..modelo_pericias..[[
$detalhes_armas$detalhes_itens$detalhes_implementos
$detalhes_poderes
	Talentos:
$efeitos_talentos
]]

local modelo_arma = [[$nome $alcance +$ataque [+$at_oportunidade] -> $dano$decisivo$adicional]]
local modelo_item = [[$nome ($posicao)]]
local _modelo_poder = [[	$nome:  $uso - $origem
alcance: $tipo_ataque     alvo: $alvo
+$ataque X $defesa -> $dano$contragolpe$efeito]]
local modelo_poder = [[	$nome:  $uso - $origem
+$ataque X $defesa -> $dano$contragolpe - $tipo_ataque - $alvo$efeito]]
local modelo_poder_titulo = [[	$nome:  $uso - $origem]]
local modelo_poder_arma_ou_implemento = [[$arma_ou_implemento: +$ataque X $defesa -> $dano$contragolpe - $tipo_ataque - $alvo]]
local modelo_poder_sem_arma = [[+$ataque X $defesa -> $dano$contragolpe - $tipo_ataque - $alvo]]
local modelo_poder_arma_nome = [[	$nome:  $uso - $origem]]
local modelo_poder_arma_ataque = [[$arma: +$ataque X $defesa -> $dano$contragolpe - $tipo_ataque - $alvo]]
--local modelo_poder_sem_ataque = [[	$nome:  $uso - $origem
--$dano$contragolpe - $tipo_ataque - $alvo$efeito]]
local modelo_poder_sem_ataque = [[-> $dano$contragolpe - $tipo_ataque - $alvo$efeito]]
--local modelo_poder_sem_dano = [[	$nome:  $uso - $origem$efeito]]
--local modelo_poder_sem_dano = [[$efeito]]
local modelo_poder_sem_dano = ''
local modelo_talento = [[$nome: $efeito]]

function Personagem:minha_classe ()
	return classes[self.classe]
end

function Personagem:minha_raca ()
	return racas[self.raca]
end

local function proficiente_arma (self, nome)
	local armas_raca = self.minha_raca.armas or {}
	local armas_classe = self.minha_classe.armas or {}
	local arma = armas[nome] or {}
	local armas_talento = self.talentos.proficiencia_com_arma or {}
	return armas_classe[nome]
		or armas_classe[arma.basica]
		or armas_raca[nome]
		or armas_raca[arma.basica]
		or armas_talento[nome]
		or armas_talento[arma.basica]
end

function Personagem:minhas_armas()
	local armas_classe = self.minha_classe.armas or {}
	local armas_raca = self.minha_raca.armas or {}
	local a = {}
	for nome in pairs(self.armas) do --{
		local arma = assert(armas[nome], "Arma n�o cadastrada: "..nome)
		if arma.implemento and arma.implemento[self.classe] then
			-- serve como implemento para a classe do personagem
			self.implementos[nome] = arma
		end
		local mod_classe = self.minha_classe[nome] or {}
		-- Alcance
		local alcance = arma.alcance or ""
		local mod_alcance = mod_classe.alcance
		if type(mod_alcance) == "function" then
			alcance = mod_alcance(arma)
		elseif type(mod_alcance) == "string" then
			alcance = alcance..mod_alcance
		end
		-- Ataque
		local ataque = math.floor(self.nivel/2)
		if proficiente_arma (self, nome) then
			ataque = soma_dano(self, ataque, arma.proficiencia, nome)
		end
		ataque = soma_dano(self, ataque, mod_classe.ataque, nome)
		ataque = soma_dano(self, ataque, arma.ataque, nome)
		if self.minha_classe.ataque then
			ataque = soma_dano(self, ataque, self.minha_classe.ataque(self, arma), nome)
		end
		-- Ataque de oportunidade
		local at_oportunidade = ataque
		-- Dano
		local dano = soma_dano(self, arma.dano, mod_classe.dano, nome)
		-- Decisivo
		local decisivo = soma_dano(self, arma.decisivo, mod_classe.decisivo, nome)
		decisivo = soma_dano(self, decisivo, arma.decisivo, nome)
		-- Dano Adicional
		local adicional = soma_dano(self, nil, self.minha_classe.dano_adicional, nome)
		local dano_oport
		-- Itens
		for nome_item, item in pairs(self.itens or {}) do --{
			item = itens[nome_item] or item
			local arma_item = nome.."+"..nome_item
			-- Ataque
			ataque = soma_dano(self, ataque, item.ataque, arma_item)
			at_oportunidade = soma_dano(self, at_oportunidade, item.at_oportunidade, arma_item)
			-- Dano
			dano = soma_dano(self, dano, item.dano, arma_item)
			dano_oport = soma_dano(self, dano_oport, item.dano, nome.."+basico")
			-- Decisivo
			decisivo = soma_dano(self, decisivo, item.decisivo, arma_item)
			-- Dano Adicional
			adicional = soma_dano(self, adicional, item.dano_adicional, arma_item)
		end --}
		-- Talentos
		for nome_talento, caracs in pairs(self.talentos) do --{
			local meu_talento = talentos[nome_talento]
			-- Alcance
			local t = meu_talento.alcance
			if type(t) == "function" then
				t = t(self, poder, arma, caracs)
			end
			alcance = soma_dano(self, alcance, t, nome)
			-- Ataque
			local t = meu_talento.ataque
			if type(t) == "function" then
				t = t(self, poder, arma, caracs)
			end
			ataque = soma_dano(self, ataque, t, nome)
			-- Ataque de Oportunidade
			local t = meu_talento.at_oportunidade
			if type(t) == "function" then
				t = t(self, poder, arma, caracs)
			end
			at_oportunidade = soma_dano(self, at_oportunidade, t, nome)
			-- Dano
			local t = meu_talento.dano
			if type(t) == "function" then
				t = t(self, poder, arma, caracs)
			end
			dano = soma_dano(self, dano, t, nome)
			-- Dano nos AdO
			local t = meu_talento.dano_oport
			if type(t) == "function" then
				t = t(self, poder, arma, caracs)
			end
			dano_oport = soma_dano(self, dano_oport, t, nome.."+basico")
			-- Dano Adicional
			local t = meu_talento.dano_adicional
			if type(t) == "function" then
				t = t(self, poder, arma, caracs)
			end
			adicional = soma_dano(self, adicional, t, nome)
		end --}
		-- Formata��o
		if adicional then
			adicional = "  "..(self.minha_classe.nome_adicional or "adicional")..": "..adicional
		else
			adicional = ""
		end
		if alcance then
			if alcance == 0 or alcance == "" then
				alcance = ""
			else
				alcance = "("..alcance..")"
			end
		end
		if decisivo then
			if type(decisivo) ~= "number" then
				decisivo = decisivo:match"%d.*"
			elseif decisivo == 0 then
				decisivo = ""
			end
		end
		if dano_oport then
			if dano_oport == 0 then
				dano_oport = ""
			else
				dano = dano.." [+"..dano_oport.."]"
			end
		end
		-- Geral
		a[#a+1] = modelo_arma:tagged{
			--nome = ("%15s"):format(basica.nome or nome),
			nome = ("%15s"):format(arma.nome or nome),
			alcance = ("%7s"):format(alcance),
			ataque = ataque,
			at_oportunidade = at_oportunidade,
			dano = ("%-10s"):format(dano),
			--dano_oportunidade = dano_oport and (" [+"..dano_oport.."]") or "",
			decisivo = decisivo and ("  decisivo +"..decisivo) or "",
			adicional = adicional,
		}
	end --}
	-- Ordem alfab�tica
	local function alfabetica (s1, s2)
		s1 = s1:match"[_%w]+"
		s2 = s2:match"[_%w]+"
		local len = math.min(s1:len(), s2:len())
		return s1:sub(1, len) < s2:sub(1, len)
	end
	-- Ordem de ataque
	local function ataque(s1, s2)
		s1 = s1:match"+(%d+)"
		s2 = s2:match"+(%d+)"
		local len = math.min(s1:len(), s2:len())
		return s1:sub(1, len) > s2:sub(1, len)
	end
	-- Ordem de dano
	local function dano(s1, s2)
		local n1, d1, m1 = s1:match"-> (%d+)d(%d+)%+(%d+)"
		if not m1 then
			n1, d1 = s1:match"-> (%d+)d(%d+)"
			m1 = 0
		end
		local n2, d2, m2 = s2:match"-> (%d+)d(%d+)%+(%d+)"
		if not m2 then
			n2, d2 = s2:match"-> (%d+)d(%d+)"
			m2 = 0
		end
		return (n1*d1+m1) > (n2*d2+m2)
	end
	table.sort(a, alfabetica)
	return a
end

function Personagem:meus_itens()
	local i = {}
	for nome, implemento in pairs(self.implementos) do
		if implemento == true then
			implemento = assert(implementos[nome], "N�o achei o implemento "..nome)
			self.implementos[nome] = implemento -- guarda c�pia da descri��o do implemento
		end
		i[#i+1] = modelo_item:tagged(implemento)
	end
	for nome, item in pairs(self.itens) do
		local esse_item = itens[nome] or item
		i[#i+1] = modelo_item:tagged(esse_item)
	end
	return i
end

function Personagem:importa_poderes()
	-- Importa os poderes selecionados (da classe ou dos talentos)
	for poder, esse_poder in pairs(self.poderes) do
		if esse_poder == true then -- importa o poder
			self.poderes[poder] = assert(self.minha_classe.poderes[poder]
				or (talentos[poder] and talentos[poder].poder),
				poder..": poder n�o cadastrado!")
		end
	end
	-- Copia os poderes raciais
	for poder, meu_poder in pairs(self.minha_raca.poderes) do
		self.poderes[poder] = meu_poder
	end
	-- Copia as caracteristicas de classe
	for poder, meu_poder in pairs(self.minha_classe.caracteristicas_classe) do
		self.poderes[poder] = meu_poder
	end
	-- Copia os poderes dos implementos
	for nome, implemento in pairs(self.implementos) do
		if implemento == true then
			implemento = assert(implementos[nome], "N�o achei o implemento "..nome)
			self.implementos[nome] = implemento -- guarda c�pia da descri��o do implemento
		end
		local esse_poder = implemento.poder
		if esse_poder then
			self.poderes[nome] = esse_poder
		end
	end
	-- Copia os poderes das armaduras
	local minha_armadura = armaduras[self.armadura.magica or self.armadura.categoria]
	if minha_armadura.poder then
		self.poderes[minha_armadura.poder.nome] = minha_armadura.poder
	end
	-- Copia os poderes das armas
	for nome in pairs(self.armas) do
		local arma = assert (armas[nome], "N�o achei a arma "..nome)
		self.armas[nome] = arma -- guarda c�pia da descri��o da arma
		local esse_poder = arma.poder
		if esse_poder then
			self.poderes[nome] = esse_poder
		end
	end
	-- Copia os poderes dos itens
	for nome in pairs(self.itens) do
		local item = assert(itens[nome], "N�o achei o item "..nome)
		self.itens[nome] = item -- guarda c�pia da descri��o do item
		local esse_poder = item.poder
		if esse_poder then
			self.poderes[nome] = esse_poder
		end
	end
end

local function serializa_origem (origem, nome)
	local res = {}
	local i = 0
	for o in pairs(assert (origem, "Poder `"..nome.."' sem origem!")) do
		i = i+1
		res[i] = o
	end
	table.sort(res)
	return table.concat(res, ", ")
end

-- Ordem de uso
local ordem_uso = {
	["Ca"] = 0, -- Caracter�stica
	["SL"] = 1, -- Sem Limite
	["Se"] = 1, -- Sem Limite
	["En"] = 2, -- Encontro
	["Ma"] = 2, -- Marco
	["Di"] = 3, -- Di�rio
	["Ut"] = 4, -- Utilit�rio
}
-- Fun��o de ordena��o de poderes
local function uso (s1, s2)
	if s2 == nil then
		return nil
	end
	--local u1 = s1:match"%:%s+([^%-]*) %-"
	--local u2 = s2:match"%:%s+([^%-]*) %-"
	local u1 = s1:match"%:%s+(..)"
	local u2 = s2:match"%:%s+(..)"
	if ordem_uso[u1] == ordem_uso[u2] then
		return s1 < s2
	else
		return ordem_uso[u1] < ordem_uso[u2]
	end
end

local caracteristicas = set("tipo_ataque", "alvo", "ataque", "defesa", "dano", "contragolpe")
function Personagem:meus_poderes()
	local meio_nivel = math.floor(self.nivel/2)
	_ = self.importa_poderes
	local ac = {}
	for chave, poder in pairs(self.poderes) do
		local linhas = { (modelo_poder_titulo:tagged {
			nome = poder.nome,
			uso = poder.uso,
			origem = serializa_origem (poder.origem, poder.nome),
		})}
		local modelo_basico, itens_linha
		if poder.origem.arma then
			modelo_basico = modelo_poder_arma_ou_implemento
			itens_linha = self.armas
		elseif poder.origem.implemento then
			modelo_basico = modelo_poder_arma_ou_implemento
			itens_linha = self.implementos
		else -- poderes raciais ou de classe
			modelo_basico = modelo_poder_sem_arma
			itens_linha = { nada = {} }
		end
		-- armas ou implementos
		for arma_ou_implemento, dados in pairs(itens_linha) do
			local poder_arma_ou_implemento = chave..'+'..arma_ou_implemento
			local at = soma_dano (self, poder.ataque, 0, poder_arma_ou_implemento)
			local da = soma_dano (self, poder.dano, 0, poder_arma_ou_implemento)
			local at_arma = soma_dano (self, dados.ataque, 0, poder_arma_ou_implemento)
			local da_arma = 0
			if string.match (da, 'A') then
				da = mult_dano (self, dados.dano, da, poder_arma_ou_implemento)
			end
			-- proficiencia
			local proficiencia = 0
			if poder.origem.arma and proficiente_arma (self, arma_ou_implemento) then
				proficiencia = dados.proficiencia
			end
			-- itens
			local at_itens, da_itens = 0, 0
			for it, dados in pairs (self.itens) do
				at_itens = soma_dano (self, dados.ataque, at_itens, poder_arma_ou_implemento)
				da_itens = soma_dano (self, dados.dano, da_itens, poder_arma_ou_implemento)
			end
			-- talentos
			local at_talentos, da_talentos = 0, 0
			-- output
			local modelo = poder.defesa and modelo_basico
				or (poder.dano and modelo_poder_sem_ataque)
				or modelo_poder_sem_dano
			linhas[#linhas+1] = modelo:tagged{
				--nome = esse_poder.nome,
				--uso = esse_poder.uso,
				--origem = origem,
				arma_ou_implemento = dados.nome,
				tipo_ataque = poder.tipo_ataque,
				alvo = poder.alvo,
				defesa = poder.defesa,
				ataque = meio_nivel + at + proficiencia + at_arma + at_talentos + at_itens,
				--dano = da + da_arma + da_talentos + da_itens,
				dano = soma_dano (self,
					soma_dano (self, da, da_arma, poder_arma_ou_implemento),
					soma_dano (self, da_talentos, da_itens, poder_arma_ou_implemento),
					poder_arma_ou_implemento),
				contragolpe = poder.contragolpe or '',
				--efeito = poder.efeito,
			}
		end
		local efeito = ''
		if poder.efeito then
			if modelo_basico ~= modelo_poder_sem_arma then
				efeito = '\n'
			end
			efeito = efeito..resolve (poder.efeito, self)
		end
		ac[#ac+1] = table.concat (linhas, '\n')..efeito
	end
	table.sort(ac, uso)
	return ac
end

function Personagem:meus_talentos()
	local r = {}
	for nome_talento, valor in pairs(self.talentos) do
		if valor == false then
			self.talentos[nome_talento] = nil
		else
			local t = talentos[nome_talento]
			local efeito
			if type(t.efeito) == "function" then
				efeito = t.efeito(self, valor)
			else
				efeito = t.efeito or ''
			end
			r[#r+1] = modelo_talento:tagged{
				nome = t.nome,
				efeito = efeito,
			}
		end
	end
	table.sort(r)
	return r
end

function Personagem:minhas_pericias()
	local total_pericias = self.minha_classe.total_pericias
		+ (self.minha_raca.pericias_adicionais or 0)
	local total = 0
	for nome, valor in pairs(self.pericias) do
		local treinamento_pericia_qualquer = self.minha_raca.treinamento_pericia_qualquer
		local pericia_classe = self.minha_classe.pericias[nome]
		local talento_pericia
		if pericia_classe == "treinada" then
		elseif pericia_classe == true or treinamento_pericia_qualquer then
			total = total+1
		elseif talento_pericia then
		else
			Personagem.warn ("A per�cia '"..nome.."' n�o � da classe "..self.classe)
			self.pericias[nome] = nil
		end
	end
	for pericia in pairs(pericias) do
		local _ = self[pericia]
	end
	if total > total_pericias then
		Personagem.warn"Mais per�cias do que o poss�vel!"
		for i = 1, (total-total_pericias) do
			local p = next(self.pericias)
			Personagem.warn ("	apagando "..p)
			self.pericias[p] = nil
		end
	elseif total < total_pericias then
		Personagem.warn"Menos per�cias do que o poss�vel!"
	end
	return true
end

function Personagem:mostra_pericias()
	for pericia in pairs(pericias) do
		local _ = self[pericia]
	end
	return modelo_pericias:tagged(self)
end

local meta = {
	__index = function(self, key)
		local v = Personagem[key]
		if type(v) == "function" then
			return v(self)
		else
			return v
		end
	end,
	__tostring = function(self)
		if self.raca == "humano" then
			assert(self.mod_humano, "B�nus de atributo (mod_humano) n�o definido!")
		end
		local pericias = self.minhas_pericias
		assert(type(pericias) == "boolean", pericias)
		self.detalhes_armas = table.concat(self.minhas_armas, '\n')
		self.detalhes_itens = table.concat(self.meus_itens, '\n')
		--self.detalhes_implementos = table.concat(self.meus_implementos, '\n')
		if (self.detalhes_armas and self.detalhes_armas ~= '')
			and (self.detalhes_itens and self.detalhes_itens ~= '') then
			self.detalhes_itens = '\n'..self.detalhes_itens
		end
		if (self.detalhes_itens and self.detalhes_itens ~= '')
			and (self.detalhes_implementos and self.detalhes_implementos ~= '') then
			self.detalhes_implementos = '\n'..self.detalhes_implementos
		end
		self.detalhes_poderes = table.concat(self.meus_poderes, '\n')
		self.efeitos_talentos = table.concat(self.meus_talentos, '\n')
		local s = modelo_geral:tagged(self)
		return s
	end,
}
setmetatable(Personagem, {
	__call = function (self, obj)
		for _, nome in ipairs{ "forca", "constituicao", "destreza", "inteligencia", "sabedoria", "carisma", } do
			obj['_'..nome] = obj[nome]
			obj[nome] = nil
		end
		obj = setmetatable(obj, meta)
		-- copia as proficienias com armaduras
		local classe = assert (classes[obj.classe], "N�o foi definida uma classe para o personagem")
		local p = {}
		for armadura in pairs(classe.armaduras) do
			p[armadura] = true
		end
		obj.proficiencia_com_armaduras = p
		-- copia as proficienias com armas e os poderes
		local p = {}
		for arma in pairs(classe.armas) do
			p[arma] = true
		end
		obj.proficiencia_com_armas = p
		-- checa os talentos
		local tt = type(classe.talentos)
		if tt == "table" then
			local talento_classe, valor = next(classe.talentos)
			obj.talentos[talento_classe] = valor
			if obj.talentos[1] then
				table.insert (obj.talentos, 1, valor)
			end
		elseif tt == "function" then
			local talento_classe, valor = classe.talentos(obj)
			if talento_classe then
				obj.talentos[talento_classe] = valor
				if obj.talentos[1] then
					table.insert (obj.talentos, 1, valor)
				end
			end
		end
		local t = {}
		if obj.talentos[1] then
			-- Se existe uma ordem especificada, remove-a da tabela e
			-- copia-a para a tabela t
			for i = 1, #obj.talentos do
				t[i] = obj.talentos[i]
				obj.talentos[i] = nil
			end
		else
			-- Se n�o existe ordem, copia todos os nomes dos talentos para t
			for talento in pairs(obj.talentos) do
				t[#t+1] = talento
			end
		end
		for i = 1, #t do
			local nome_talento = t[i]
			local esse_talento = assert(talentos[nome_talento], "N�o achei o talento '"..nome_talento.."'")
			local variacao_talento = obj.talentos[nome_talento]
			local requisitos = esse_talento.requisito or {}
			for atrib, esperado in pairs(requisitos) do
				local err_msg = "Seu personagem n�o cumpre o requisito '%s' para usar o talento "..nome_talento.."."
				local valor = obj[atrib] or classes[obj.classe][atrib]
				if type(esperado) == "function" then
					assert(esperado(obj, variacao_talento, err_msg, valor))
				elseif type(esperado) == "number" then
					assert(valor >= esperado, err_msg:format (atrib..'>='..esperado))
				else
					assert(valor == esperado, err_msg:format (atrib..'='..tostring(esperado)))
				end
			end
			if esse_talento.poder then
				obj.poderes[nome_talento] = true
			end
		end
		return obj
	end,
})

return Personagem
