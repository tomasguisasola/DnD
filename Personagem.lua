local math   = require"math"
local string = require"string"

local set = require"DnD.Set"
local soma_dano = require"DnD.Soma".soma
local mult_dano = require"DnD.Soma".mult

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
		local minha_raca = racas[self.raca]
		local racial = minha_raca[atrib] or 0
		local op = minha_raca.atributos_opcionais
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
		local minha_raca = racas[self.raca]
		local racial = minha_raca.pericias and minha_raca.pericias[pericia] or 0
		local atributo = essa_pericia.atributo
		local minha_classe = classes[self.classe]
		local pericia_classe = minha_classe.pericias[pericia]
		local treino = 0
		if ((pericia_classe == true or minha_raca.treinamento_pericia_qualquer)
			and self.pericias[pericia]) or pericia_classe == "treinada" then
			treino = 5
		elseif minha_classe.pericias.nao_treinadas then
			treino = minha_classe.pericias.nao_treinadas
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
			assert (type(meu) == "table", "Não achei a descrição de "..nome)
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
	local minha_classe = classes[self.classe]
	local classe = 0
	if type(minha_classe.ca) == "function" then
		local fim, ca = minha_classe.ca(self)
		if fim then
			return ca
		end
		classe = ca
	end
	local categoria_armadura = armaduras[self.armadura.categoria]
	local armadura_magica = armaduras[self.armadura.magica]
	local atrib = 0
	if categoria_armadura.tipo == "leve" then
		atrib = math.max(self.mod_des, self.mod_int)
	end
	local armadura = 0
	if minha_classe.armaduras[self.armadura.categoria] or
		self.talentos.proficiencia_com_armadura == self.armadura.categoria then
		armadura = categoria_armadura.bonus
	else
		Personagem.warn ("\t!!! O personagem não é proficiente com esse tipo de armadura: "..self.armadura.categoria.."!!!")
	end
	local magica = 0
	if armadura_magica then
		assert(armadura_magica.categoria[self.armadura.categoria],
			"Armadura "..armadura_magica.nome.." não serve para a categoria `"
			..self.armadura.categoria.."'")
		magica = armadura_magica.ca or 0
	end
	local item = 0
	for meu_item in pairs(self.itens) do
		local esse_item = assert (itens[meu_item], "Não achei a descrição de "..meu_item)
		if esse_item.escudo then
			if minha_classe.armaduras[esse_item.peso] then
				item = soma_dano(self, item, esse_item.ca)
			end
		else
			item = soma_dano(self, item, esse_item.ca)
		end
	end
	local cajado_mago = 0
	local implemento = 0
	for meu_implemento in pairs(self.implementos) do
		meu_implemento = implementos[meu_implemento]
		implemento = soma_dano(self, implemento, meu_implemento.ca)
		-- Magos que escolhem cajados ganham bônus na CA quando levam um
		if self.classe == "mago" and self.implemento == "cajado" and meu_implemento.tipo == "cajado" then
			cajado_mago = 1 -- esse bônus só vale uma vez
		end
	end
	local ca = 10 + math.floor(self.nivel/2) + atrib + armadura + magica + item + implemento + cajado_mago + classe
	local oportunidade = soma_dano(self, ca, racas[self.raca].ca_oportunidade, "CA oportunidade")
	oportunidade = soma_dano(self, oportunidade, minha_classe.ca_oportunidade, "CA oportunidade")
	for meu_talento in pairs(self.talentos) do
		local esse_talento = talentos[meu_talento]
		ca = soma_dano(self, ca, esse_talento.ca)
		oportunidade = soma_dano(self, oportunidade, esse_talento.ca_oportunidade)
	end
	self.ca_oportunidade = oportunidade
--!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
--Personagem.warn (string.format("10+%d(nível)+%d(leve)+%d(armadura)+%d(magica)+%d(item)+%d(implemento)+%d(cajado de mago)+%d(classe)", math.floor(self.nivel/2), atrib, armadura, magica, item, implemento, cajado_mago, classe))
	return ca
end

function Personagem:fortitude()
	local minha_classe = classes[self.classe]
	if type(minha_classe.fortitude) == "function" then
		return minha_classe.fortitude(self)
	end
	local nivel = math.floor(self.nivel/2)
	local atrib = math.max(self.mod_for, self.mod_con)
	local racial = racas[self.raca].fortitude or 0
	local classe = minha_classe.fortitude or 0
	local implemento = 0
	for meu in pairs(self.implementos) do
		implemento = soma_dano(self, implemento, implementos[meu].fortitude)
	end
	local item = 0
	for meu in pairs(self.itens) do
		item = soma_dano(self, item, itens[meu].fortitude)
	end
	return 10 + nivel + atrib + racial + classe + implemento + item
end

function Personagem:reflexos()
	local minha_classe = classes[self.classe]
	local classe = 0
	if type(minha_classe.reflexos) == "function" then
		local fim, ref = minha_classe.reflexos(self)
		if fim then
			return ref
		end
		classe = ref
	elseif minha_classe.reflexos then
		classe = minha_classe.reflexos
	end
	local nivel = math.floor(self.nivel/2)
	local atrib = math.max(self.mod_des, self.mod_int)
	local racial = racas[self.raca].reflexos or 0
	local implemento = 0
	for meu in pairs(self.implementos) do
		implemento = soma_dano(self, implemento, implementos[meu].reflexos)
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
	return 10 + nivel + atrib + racial + classe + implemento + item --+ escudo
end

function Personagem:vontade()
	local minha_classe = classes[self.classe]
	if type(minha_classe.vontade) == "function" then
		return minha_classe.vontade(self)
	end
	local nivel = math.floor(self.nivel/2)
	local atrib = math.max(self.mod_sab, self.mod_car)
	local racial = racas[self.raca].vontade or 0
	local classe = minha_classe.vontade or 0
	local implemento = 0
	for meu in pairs(self.implementos) do
		implemento = soma_dano(self, implemento, implementos[meu].vontade)
	end
	local item = 0
	for meu in pairs(self.itens) do
		item = soma_dano(self, item, itens[meu].vontade)
	end
	return 10 + nivel + atrib + racial + classe + implemento + item
end

local _modelo_pericias = [[
Acrobacia$treino_acrobacia   $acrobacia   Arcanismo$treino_arcanismo  $arcanismo   Atletismo$treino_atletismo   $atletismo   Blefe$treino_blefe    $blefe
Diplomacia$treino_diplomacia  $diplomacia   Exploração$treino_exploracao $exploracao   Furtividade$treino_furtividade $furtividade   História$treino_historia $historia
Intimidação$treino_intimidacao $intimidacao   Intuição$treino_intuicao   $intuicao   Ladinagem$treino_ladinagem   $ladinagem   Manha$treino_manha    $manha
Natureza$treino_natureza    $natureza   Percepção$treino_percepcao  $percepcao   Religião$treino_religiao    $religiao   Socorro$treino_socorro  $socorro   Tolerância$treino_tolerancia $tolerancia
]]
local modelo_pericias = [[
Acrobacia$treino_acrobacia $acrobacia  Diplomacia$treino_diplomacia  $diplomacia  Intimidação$treino_intimidacao $intimidacao  Natureza$treino_natureza  $natureza  Tolerância$treino_tolerancia $tolerancia
Arcanismo$treino_arcanismo $arcanismo  Exploração$treino_exploracao  $exploracao  Intuição$treino_intuicao    $intuicao  Percepção$treino_percepcao $percepcao
Atletismo$treino_atletismo $atletismo  Furtividade$treino_furtividade $furtividade  Ladinagem$treino_ladinagem   $ladinagem  Religião$treino_religiao  $religiao
Blefe$treino_blefe     $blefe  História$treino_historia    $historia  Manha$treino_manha       $manha  Socorro$treino_socorro   $socorro
]]

local modelo_geral = [[
  $nome  ($raca $classe)            nível $nivel  $xp XP
CA:  $ca [$ca_oportunidade]  Fortitude: $fortitude  Reflexos: $reflexos  Vontade: $vontade            $dinheiro PO
FOR: $forca (+$mod_for)  DES: $destreza (+$mod_des)  SAB: $sabedoria (+$mod_sab)    Intuição Passiva: $intuicao_passiva
CON: $constituicao (+$mod_con)  INT: $inteligencia (+$mod_int)  CAR: $carisma (+$mod_car)    Percepção Passiva: $percepcao_passiva
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
local modelo_poder_arma_nome = [[	$nome:  $uso - $origem]]
local modelo_poder_arma_ataque = [[$arma: +$ataque X $defesa -> $dano$contragolpe - $tipo_ataque - $alvo]]
local modelo_poder_sem_ataque = [[	$nome:  $uso - $origem
$dano$contragolpe - $tipo_ataque - $alvo$efeito]]
local modelo_poder_sem_dano = [[	$nome:  $uso - $origem$efeito]]
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
	local arma = armas[nome]
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
	local minha_raca = racas[self.raca]
	local armas_raca = minha_raca.armas or {}
	local a = {}
	for nome in pairs(self.armas) do --{
		local arma = assert(armas[nome], "Arma não cadastrada: "..nome)
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
		-- Formatação
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
	-- Ordem alfabética
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
	for nome, item in pairs(self.itens) do
		local esse_item = itens[nome] or item
		i[#i+1] = modelo_item:tagged(esse_item)
	end
	return i
end

function Personagem:meus_poderes()
	local meio_nivel = math.floor(self.nivel/2)
	local minha_classe = classes[self.classe]
	-- Copia os poderes raciais
	local minha_raca = racas[self.raca]
	for poder, meu_poder in pairs(minha_raca.poderes) do
		self.poderes[poder] = meu_poder
	end
	-- Copia as caracteristicas de classe
	for poder, meu_poder in pairs(minha_classe.caracteristicas_classe) do
		self.poderes[poder] = meu_poder
	end
	-- Copia os poderes dos implementos
	for nome in pairs(self.implementos) do
		local implemento = assert(implementos[nome], "Não achei o implemento "..nome)
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
		local arma = armas[nome]
		local esse_poder = arma.poder
		if esse_poder then
			self.poderes[arma] = esse_poder
		end
	end
	-- Copia os poderes dos itens
	for nome in pairs(self.itens) do
		local item = assert(itens[nome], "Não achei o item "..nome)
		local esse_poder = item.poder
		if esse_poder then
			self.poderes[nome] = esse_poder
		end
	end

	local a = {}
	for poder, esse_poder in pairs(self.poderes) do
		if esse_poder == true then
			esse_poder = assert(minha_classe.poderes[poder]
				or (talentos[poder] and talentos[poder].poder),
				poder..": poder não cadastrado!")
		end
		if esse_poder then
			local caracs = {
				alvo = esse_poder.alvo,
				ataque = esse_poder.ataque,
				contragolpe = contragolpe,
				dano = esse_poder.dano,
				defesa = esse_poder.defesa,
				tipo_ataque = esse_poder.tipo_ataque,
			}
			if type(caracs.contragolpe) == "function" then
				caracs.contragolpe = caracs.contragolpe(self)
			end
			for nome_item, item in pairs(self.itens or {}) do
				local item = itens[nome_item] or item
				if esse_poder.origem.implemento then
					caracs.ataque = soma_dano(self, caracs.ataque, item.ataque, poder)
					caracs.dano = soma_dano(self, caracs.dano, item.dano, poder)
				end
			end
			for nome_talento, valor in pairs(self.talentos or {}) do
				local talento = talentos[nome_talento]
				local poder = talento[poder]
				if poder then
					for car in pairs(set("tipo_ataque", "alvo", "ataque", "defesa", "dano", "contragolpe")) do
						if poder[car] then
							local bonus = poder[car] (self, poder, arma, valor)
							caracs[car] = soma_dano (self, caracs[car], bonus, esse_poder.nome)
						end
					end
				end
			end
			if caracs.contragolpe then
				caracs.contragolpe = "\n       CG:"..caracs.contragolpe
			else
				caracs.contragolpe = ""
			end
			local origem = {}
			local i = 0
			for o in pairs(assert (esse_poder.origem, "Poder `"..esse_poder.nome.."' sem origem!")) do
				i = i+1
				origem[i] = o
			end
			table.sort(origem)
			origem = table.concat(origem, ", ")
			local efeito = esse_poder.efeito
			if type(efeito) == "function" then
				efeito = "\n"..efeito(self)
			elseif type(efeito) == "string" or type(efeito) == "number" then
				efeito = "\n"..efeito
			else
				--efeito = nil
				efeito = ''
			end
			caracs.nome = esse_poder.nome
			caracs.uso = esse_poder.uso
			caracs.origem = origem
			caracs.efeito = efeito
			if esse_poder.origem.arma then
				local ataque_poder = caracs.ataque
				local dano_poder = caracs.dano
				local linhas = { (modelo_poder_arma_nome:tagged (caracs)) }
				for nome_arma in pairs(self.armas) do --{
					local arma = armas[nome_arma]
					local poder_arma = poder.."+"..nome_arma
					local tipo = arma.tipo:match"^%w+" -- primeira palavra
					if esse_poder.tipo_ataque:match(tipo) then --{
						caracs.arma = arma.nome
						local at = soma_dano (self, arma.ataque, ataque_poder, poder_arma)
						if minha_classe.ataque then
							at = soma_dano(self, at, minha_classe.ataque(self, arma), nome)
						end
						if proficiente_arma (self, nome_arma) then
							caracs.ataque = soma_dano (self, at, arma.proficiencia, poder)
						end
						if type(dano_poder) == "string" and dano_poder:match"A" then
							caracs.dano = mult_dano (self, arma.dano, dano_poder, poder)
						else
							caracs.dano = dano_poder
						end
						caracs.tipo_ataque = arma.tipo
						-- bônus de talentos
						for nome_talento, valor in pairs(self.talentos) do --{
							local talento = talentos[nome_talento]
							for car in pairs(set("tipo_ataque", "alvo", "ataque", "defesa", "dano", "contragolpe")) do --{
								if talento[car] then
									local bonus = talento[car] (self, esse_poder, arma, valor)
									caracs[car] = soma_dano (self, bonus, caracs[car], poder)
								end
							end --}
						end --}
						caracs.ataque = soma_dano (self, meio_nivel, caracs.ataque, poder_arma)
						if type(caracs.dano) == "function" then
							caracs.dano = caracs.dano (self, nil, poder_arma)
						end
						linhas[#linhas+1] = modelo_poder_arma_ataque:tagged (caracs)
					end --}
				end --}
				a[#a+1] = table.concat (linhas, '\n')..efeito
			elseif esse_poder.origem.implemento then
				for nome_impl, implemento in pairs(self.implementos or {}) do
					local implemento = implementos[nome_impl] or implemento
					if minha_classe.implementos[implemento.tipo] then
						caracs.ataque = soma_dano(self, implemento.ataque, caracs.ataque, poder)
						caracs.dano = soma_dano(self, implemento.dano, caracs.dano, poder)
					else
						Personagem.warn (nome_impl.." ("..implemento.tipo..") não é implemento da classe "..minha_classe.nome)
					end
				end
				caracs.ataque = soma_dano (self, meio_nivel, caracs.ataque, poder)
				if type(caracs.dano) == "function" then
					caracs.dano = caracs.dano (self)
				end
				local modelo = caracs.defesa and modelo_poder
					or (caracs.dano and modelo_poder_sem_ataque or modelo_poder_sem_dano)
				a[#a+1] = modelo:tagged{
					nome = esse_poder.nome,
					uso = esse_poder.uso,
					origem = origem,
					tipo_ataque = caracs.tipo_ataque,
					alvo = caracs.alvo,
					ataque = caracs.ataque,
					defesa = caracs.defesa,
					dano = caracs.dano,
					contragolpe = caracs.contragolpe,
					efeito = efeito,
				}
			else -- poderes raciais ou de classe
				caracs.ataque = soma_dano (self, meio_nivel, caracs.ataque, poder)
				if type(caracs.dano) == "function" then
					caracs.dano = caracs.dano (self)
				end
				local modelo = caracs.defesa and modelo_poder
					or (caracs.dano and modelo_poder_sem_ataque or modelo_poder_sem_dano)
				a[#a+1] = modelo:tagged{
					nome = esse_poder.nome,
					uso = esse_poder.uso,
					origem = origem,
					tipo_ataque = caracs.tipo_ataque,
					alvo = caracs.alvo,
					ataque = caracs.ataque,
					defesa = caracs.defesa,
					dano = caracs.dano,
					contragolpe = caracs.contragolpe,
					efeito = efeito,
				}
			end
			if not caracs.ataque and #a > 0 then
				a[#a] = a[#a]:gsub("\n%+%$ataque[^\n]*", "")
			end
		end
	end
	-- Ordem de uso
	local ordem_uso = {
		["Ca"] = 0, -- Característica
		["SL"] = 1, -- Sem Limite
		["Se"] = 1, -- Sem Limite
		["En"] = 2, -- Encontro
		["Ma"] = 2, -- Marco
		["Di"] = 3, -- Diário
		["Ut"] = 4, -- Utilitário
	}
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
	table.sort(a, uso)
	return a
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
--[[
	local minha_raca = racas[self.raca]
	for poder, meu_poder in pairs(minha_raca.poderes) do
		self.poderes[poder] = meu_poder
	end
	local minha_classe = classes[self.classe]
	local a = {}
	for poder in pairs(self.poderes) do
		local esse_poder = assert(minha_classe.poderes[poder] or minha_raca.poderes[poder], "Poder não cadastrado: "..poder)
		local caracs = {
			alvo = esse_poder.alvo,
			ataque = esse_poder.ataque,
			contragolpe = contragolpe,
			dano = esse_poder.dano,
			defesa = esse_poder.defesa,
			tipo_ataque = esse_poder.tipo_ataque,
		}
		if type(caracs.ataque) == "function" then
			caracs.ataque = caracs.ataque(self)
		end
		if type(caracs.dano) == "function" then
			caracs.dano = caracs.dano(self)
		end
		if type(caracs.contragolpe) == "function" then
			caracs.contragolpe = caracs.contragolpe(self)
		end
		for nome_impl, implemento in pairs(self.implementos or {}) do
			local implemento = implementos[nome_impl] or implemento
			if esse_poder.origem.implemento then
				caracs.ataque = soma_dano(self, caracs.ataque, implemento.ataque, poder)
				caracs.dano = soma_dano(self, caracs.dano, implemento.dano, poder)
			end
		end
		for nome_talento in pairs(self.talentos or {}) do
			local talento = talentos[nome_talento]
			local poder = talento[poder]
			if poder then
				for car in pairs(set("tipo_ataque", "alvo", "ataque", "defesa", "dano", "contragolpe")) do
					if poder[car] then
						caracs[car] = poder[car] (caracs[car], poder)
					end
				end
			end
		end
		if caracs.contragolpe then
			caracs.contragolpe = "\n       CG:"..caracs.contragolpe
		else
			caracs.contragolpe = ""
		end
		local origem = {}
		local i = 0
		for o in pairs(esse_poder.origem) do
			i = i+1
			origem[i] = o
		end
		table.sort(origem)
		origem = table.concat(origem, ", ")
		local efeito = esse_poder.efeito
		if type(efeito) == "function" then
			efeito = "\n\t"..efeito(self)
		elseif type(efeito) == "string" or type(efeito) == "number" then
			efeito = "\n\t"..efeito
		else
			--efeito = nil
			efeito = ''
		end
		a[#a+1] = modelo_poder:tagged{
			nome = esse_poder.nome,
			uso = esse_poder.uso,
			origem = origem,
			tipo_ataque = caracs.tipo_ataque,
			alvo = caracs.alvo,
			ataque = caracs.ataque,
			defesa = caracs.defesa,
			dano = caracs.dano,
			contragolpe = caracs.contragolpe,
			efeito = efeito,
		}
	end
	-- Ordem de uso
	local function uso (s1, s2)
		if s2 == nil then
			return nil
		end
		local u1 = s1:match"%: ([^%-]*) %-"
		local u2 = s2:match"%: ([^%-]*) %-"
		if u1 == u2 then
			return s1 < s2
		elseif u1 == "Sem Limite" then
			return true
		elseif u2 == "Sem Limite" then
			return false
		elseif u1 == "Encontro" then
			return true
		elseif u2 == "Encontro" then
			return false
		elseif u1 == "Diário" then
			return true
		elseif u2 == "Diário" then
			return false
		end
	end
	table.sort(a, uso)
	return a
--]]
end

function Personagem:minhas_pericias()
	local minha_classe = classes[self.classe]
	local minha_raca = racas[self.raca]
	local total_pericias = minha_classe.total_pericias
		+ (minha_raca.pericias_adicionais or 0)
	local total = 0
	for nome, valor in pairs(self.pericias) do
		local treinamento_pericia_qualquer = minha_raca.treinamento_pericia_qualquer
		local pericia_classe = minha_classe.pericias[nome]
		local talento_pericia
		if pericia_classe == "treinada" then
		elseif pericia_classe == true or treinamento_pericia_qualquer then
			total = total+1
		elseif talento_pericia then
		else
			Personagem.warn ("A perícia '"..nome.."' não é da classe "..self.classe)
			self.pericias[nome] = nil
		end
	end
	for pericia in pairs(pericias) do
		local _ = self[pericia]
	end
	if total > total_pericias then
		Personagem.warn"Mais perícias do que o possível!"
		for i = 1, (total-total_pericias) do
			local p = next(self.pericias)
			Personagem.warn ("	apagando "..p)
			self.pericias[p] = nil
		end
	elseif total < total_pericias then
		Personagem.warn"Menos perícias do que o possível!"
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
			assert(self.mod_humano, "Bônus de atributo (mod_humano) não definido!")
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
		local classe = assert (classes[obj.classe], "Não foi definida uma classe para o personagem")
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
			-- Se não existe ordem, copia todos os nomes dos talentos para t
			for talento in pairs(obj.talentos) do
				t[#t+1] = talento
			end
		end
		for i = 1, #t do
			local nome_talento = t[i]
			local esse_talento = assert(talentos[nome_talento], "Não achei o talento '"..nome_talento.."'")
			local variacao_talento = obj.talentos[nome_talento]
			local requisitos = esse_talento.requisito or {}
			for atrib, esperado in pairs(requisitos) do
				local err_msg = "Seu personagem não cumpre o requisito '%s' para usar o talento "..nome_talento.."."
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
