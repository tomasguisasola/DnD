local soma_dano = require"DnD.Soma".soma
local set = require"DnD.Set"
local armas = require"DnD.Armas"
local classes = require"DnD.Classes"

--------------------------------------------------------------------------------
local atributos = set("forca", "constituicao", "destreza", "inteligencia", "sabedoria", "carisma")

--------------------------------------------------------------------------------
local function OU(...)
	local opcoes = { ... }
	return function (self, variacao, err_msg, valor)
		for i = 1, #opcoes do
			if valor == opcoes[i] then
				return true
			end
		end
		return false, err_msg:format(valor)
	end
end

--------------------------------------------------------------------------------
local function treinamento(...)
	local op = "E"
	local pericias = set(...)
	if select('#', ...) > 1 then
		op = select (1, ...)
		pericias[op] = nil
	end
	assert (op == "E" or op == "OU", "É necessário especificar a combinação de treinamento em várias perícias!")
	return function (self, variacao, err_msg)
		local ok
		if op == "E" then
			ok = true
		else
			ok = false
		end
		local minha_classe = classes[self.classe]
		local p = {}
		for pericia in pairs(pericias) do
			if op == "E" then
				ok = ok and (self.pericias[pericia] or (minha_classe.pericias[pericia] == "treinada"))
			else
				ok = ok or (self.pericias[pericia] or (minha_classe.pericias[pericia] == "treinada"))
			end
			p[#p+1] = pericia
		end
		return ok, err_msg:format ("treinamento="..table.concat(p,','))
	end
end

--------------------------------------------------------------------------------
local function possui (talento)
	return function (self, variacao, err_msg)
		return self.talentos[talento], err_msg:format ("possuir talento "..talento)
	end
end

--------------------------------------------------------------------------------
local function treinada_escolhida (pericia)
	return function(self, escolhida)
		return (escolhida == pericia) and 3 or 0
	end
end

--------------------------------------------------------------------------------
local function nao_treinada (pericia)
	return function (self)
		local p = self.pericias[pericia] == true
		local c = classes[self.classe].pericias[pericia] == "treinada"
		if p or c then
			return 0
		else
			return 2
		end
	end
end

--------------------------------------------------------------------------------
return {
	acao_predatoria = { -- PM --------------------------------------------------
		nome = "Ação Predatória",
		requisito = {
			classe = "patrulheiro",
		},
		efeito = "Pode aplicar o dano da Presa quando usar um PdA.",
	},

	adepto_do_espirito_perseguidor = { -- LJ2 ----------------------------------
		nome = "Adepto do Espírito Perseguidor",
		requisito = {
			classe = "xama",
		},
		efeito = "Aliados adjacentes ao CE podem ajustar 1\n   quadrado usando uma ação livre como primeira ação de seus turnos.",
	},

	adepto_do_espirito_protetor = { -- LJ2 -------------------------------------
		nome = "Adepto do Espírito Protetor",
		requisito = {
			classe = "xama",
		},
		efeito = "Aliados ganham +1 nas defesas Fortitude, Reflexos e Vontade enquanto estiverem adjacentes ao companheiro espiritual.",
	},

	agarrar_aprimorado = { -- LJ1 ----------------------------------------------
		nome = "Agarrar Aprimorado",
		requisito = {
			forca = 13,
		},
		efeito = function (self)
			local bonus
			if self.nivel >= 21 then
				bonus = 8
			elseif self.nivel >= 11 then
				bonus = 6
			else
				bonus = 4
			end
			return "Recebe +"..bonus.." no ataque ao agarrar."
		end,
	},

	agilidade_dos_halflings = { -- LJ1 -----------------------------------------
		nome = "Agilidade dos Halflings",
		requisito = {
			raca = "halfling",
			caracteristica_classe = function(self)
				self.penalidade_segunda_chance = 2
				return true
			end,
		},
		efeito = "Quando usar o poder 'segunda chance', o atacante\n   sofre -2 de penalidade na nova jogada de ataque.",
	},

	alma_draconica_aprimorada = { -- LJ2 ---------------------------------------
		nome = "Alma Dracônica Aprimorada",
		requisito = {
			classe = "feiticeiro",
			caracteristica_classe = "magia draconica",
		},
		efeito = function (self)
			local bonus
			if self.nivel >= 21 then
				bonus = 10
			elseif self.nivel >= 11 then
				bonus = 5
			else
				bonus = 2
			end
			return "A resistência concedida pela Alma Dracônica aumenta em "
				..bonus.."."
		end,
	},

	alma_selvagem_disciplinada = { -- LJ2 --------------------------------------
		nome = "Alma Selvagem Disciplinada",
		requisito = {
			classe = "feiticeiro",
			caracteristica_classe = "magia_selvagem",
		},
		efeito = "Quando for determinar o tipo de dano de sua Alma Selvagem, o personagem joga duas vezes o dado e escolhe um resultado.",
	},

	alpinista = { -- LJ1 -------------------------------------------------------
		nome = "Alpinista",
		requisito = {
			pericias = treinamento("atletismo"),
		},
		atletismo = 1,
		efeito = "Usa o deslocamento normal para escalar, se passar no teste de Atletismo.  Recebe +1 de bônus de talento nos testes de Atletismo.",
	},

	ameacar_com_duas_armas = { -- LJ2 ------------------------------------------
		nome = "Ameaçar com Duas Armas",
		requisito = {
			destreza = 13,
			talentos = possui"combater_com_duas_armas",
		},
		dano_oport = function (self, dano, arma)
			if arma:match"%+" then
				arma = arma:match"^(.-)%+"
			end
			local essa_arma = assert(armas[arma], "Não achei a arma '"..tostring(arma).."'")
			if essa_arma.tipo:match"corpo" then
				return soma_dano(self, dano, 3, arma)
			else
				return dano
			end
		end,
		efeito = "Enquanto estiver empunhando duas armas de combate corpo-a-corpo, o personagem recebe +3 de bônus nas jogadas de dano dos ataques de oportunidade.",
	},

	amparo_de_kord = { -- LJ1 --------------------------------------------------
		nome = "Amparo de Kord",
		requisito = set("canalizar_divindade", "kord"),
		efeito = "Ganha o Amparo de Kord.",
		poder = {
			nome = "Amparo de Kord",
			uso = "Encontro",
			origem = set("cura", "divino"),
			tipo_ataque = "distância 5",
			alvo = "o personagem ou um aliado",
			efeito = "O alvo pode gastar um PC quando obtém um SD.",
		},
	},

	animal_treinado = { -- PM --------------------------------------------------
		nome = "Animal Treinado",
		requisito = {
			classe = "patrulheiro",
		},
		efeito = "O companheiro animal recebe treinamento em uma perícia.",
	},

	aproximacao_da_tempestade = { -- LJ2 ---------------------------------------
		nome = "Aproximação da Tempestade",
		efeito = "+1 de bônus nos ataques trovejantes depois de sucesso com poder elétrico.",
		_efeito = "Quando obtém sucesso num ataque com a palavra-chave elétrico, o personagem recebe +1 de bônus nas jogadas de ataque dos poderes com a palavra-chave trovejante até o final do seu próximo turno.",
	},

	apunhalador = { -- LJ1 -----------------------------------------------------
		nome = "Apunhalador",
		requisito = {
			classe = "ladino",
		},
		dano_adicional = function(self, dano, arma)
			if type(dano) == "string" then
				return dano:gsub("d6", "d8")
			else
				return dano
			end
		end,
		efeito = "Aumenta o dado do At.Furtivo de d6 para d8.",
	},

	armadura_de_bahamut = { -- LJ1 ---------------------------------------------
		nome = "Armadura de Bahamut",
		requisito = set("canalizar_divindade", "bahamut"),
		efeito = "Ganha o poder Armadura de Bahamut",
		poder = {
			nome = "Armadura de Bahamut",
			uso = "Encontro",
			origem = set("divino"),
			tipo_ataque = "distância 5",
			alvo = "o personagem ou um aliado",
			efeito = "Quando o alvo é atingido por um SD, você pode transformá-lo em um sucesso comum.",
		}
	},

	arremessar_sopro = { -- D --------------------------------------------------
		nome = "Arremessar Sopro",
		requisito = {
			raca = "draconato",
		},
		sopro = {
			tipo_ataque = function(self, caracs)
				local tipo_ataque = "rajada contígua 3"
				if caracs and type(caracs.tipo_ataque) == "function" then
					tipo_ataque = caracs.tipo_ataque(self)
				end
				return tipo_ataque.." ou área 2 a até 10"
			end,
		},
		efeito = "O alcance do sopro pode ser trocado por uma explosão de área\n   2 a até 10 quadrados.",
	},

	arremesso_longo = { -- LJ1 -------------------------------------------------
		nome = "Arremesso Longo",
		requisito = {
			forca = 13,
		},
		alcance = function(self, alcance, arma)
			if armas[arma].leve_arremesso then
				return alcance:gsub("(%d+)%/(%d+)", function(a1, a2)
					return (a1+2).."/"..(a2+2)
				end)
			else
				return alcance
			end
		end,
		efeito = "Aumenta o alcance de arma de arremesso em 2 quadrados.",
	},

	artista_de_fuga = { -- LJ1 -------------------------------------------------
		nome = "Artista de Fuga",
		requisito = {
			pericias = treinamento"acrobacia",
		},
		acrobacia = 2,
		efeito = "Escapa de agarrar usando ação mínima, +2 em Acrobacia",
	},

	assalto_tatico = { -- LJ1 --------------------------------------------------
		nome = "Assalto Tático",
		requisito = {
			classe = "senhor_da_guerra",
		},
		dano_aliado = function(self, dano, arma)
			return soma_dano(self, dano, self.mod_inteligencia, arma)
		end,
		efeito = function(self)
			return "Aliados recebem +"..self.mod_int.." como bônus no dano."
		end,
	},

	assegurar_acampamento = { -- PM --------------------------------------------
		nome = "Assegurar Acampamento",
		requisito = {
			classe = "patrulheiro",
			pericias = treinamento("E", "natureza", "percepcao", "furtividade"),
		},
		efeito = function(self)
			return "Você e aliados recebem +"..self.mod_sab.." de bônus nos testes de Furtividade e Percepção durante o descanso prolongado."
		end,
	},

	ataque_poderoso = { -- LJ1 -------------------------------------------------
		nome = "Ataque Poderoso",
		requisito = {
			forca = 15,
		},
		dano_adicional = function(self, dano, arma)
			if penalidade_ataque then
				local estagio = math.floor((self.nivel-1)/10) + 1
				if armas[arma].empunhadura == "uma_mao" then
					return soma_dano(self, dano, 2*estagio, arma)
				else
					return soma_dano(self, dano, 3*estagio, arma)
				end
			else
				return dano
			end
		end,
		efeito = "+2 no dano em troca de -2 no ataque.",
	},

	bencao_do_obscuro_aprimorada = { -- LJ1 ------------------------------------
		nome = "Bênção do Obscuro Aprimorada",
		requisito = {
			classe = "bruxo",
			constituicao = 15,
			caracteristica_classe = "pacto infernal",
		},
		pv_temporario = 3,
		efeito = "Dádiva do Pacto concede 3 PV adicionais.",
	},

	bencao_da_rainha_de_rapina = { -- LJ1 --------------------------------------
		nome = "Bênção da Rainha de Rapina",
		requisito = set("canalizar_divindade", "rainha_rapina"),
		efeito = "Ganha a Bênção da Rainha de Rapina.",
	},

	cacador_agil = { -- LJ1 ----------------------------------------------------
		nome = "Caçador Ágil",
		requisito = {
			classe = "patrulheiro",
			destreza = 15,
			--caracteristica_classe = "presa_do_cacador",
		},
		efeito = "Usando uma ação livre, ajusta após um sucesso decisivo.",
	},

	cacador_draconico = { -- D -------------------------------------------------
		nome = "Caçador Dracônico",
		requisito = {
			raca = "draconato",
			classe = "patrulheiro",
		},
		efeito = "Quando atinge sua presa com o sopro, recebe +2 de bônus no ataque até o final do seu próximo turno.",
	},

	cacador_letal = { -- LJ1 ---------------------------------------------------
		nome = "Caçador Letal",
		requisito = {
			classe = "patrulheiro",
			--presa_do_cacador = true,
		},
		dano_adicional = function(self, dano, arma)
			if type(dano) == "string" then
				return dano:gsub("d6", "d8")
			else
				return dano
			end
		end,
		efeito = "Aumenta o dano da Presa de 1d6 para 1d8.",
	},

	cacador_preciso = { -- LJ1 -------------------------------------------------
		nome = "Caçador Preciso",
		requisito = {
			classe = "patrulheiro",
			sabedoria = 15,
			--presa_do_cacador = true,
		},
		efeito = "Aliados recebem +1 contra alvo de sucesso decisivo.",
	},

	caca_em_grupo = { -- PM ----------------------------------------------------
		nome = "Caça em Grupo",
		requisito = {
			classe = "patrulheiro",
			raca = "meio_elfo",
		},
		efeito = "Aliados causam +1 de dano contra a Presa.",
	},

	camuflagem = { -- PM -------------------------------------------------------
		nome = "Camuflagem",
		requisito = {
			classe = "patrulheiro",
			pericias = treinamento"furtividade",
		},
		efeito = "Se tiver cobertura ou ocultação em campo aberto, recebe +5 em furtividade.",
	},

	canalizar_lamina_feiticeira = { -- LJ2 -------------------------------------
		nome = "Canalizar Lâmina Feiticeira",
		requisito = {
			classe = "feiticeiro",
		},
		efeito = "Quando utiliza um poder de feiticeiro de ataque à distância usando uma adaga, o feiticeiro pode fazer com que o poder seja um ataque corpo-a-corpo. Se o fizer, o alcance do poder será igual ao alcance do combate corpo-a-corpo do personagem.",
	},

	certeza_de_ioun = { -- LJ1 -------------------------------------------------
		nome = "Certeza de Ioun",
		requisito = set("canalizar_divindade", "ioun"),
		efeito = "Ganha o poder Certeza de Ioun.",
		poder = {
			nome = "Certeza de Ioun",
			uso = "Encontro",
			origem = set("divino"),
			tipo_ataque = "distância 5",
			alvo = "o personagem ou um aliado",
			efeito = "O alvo recebe +5 em Vontade até o começo do próximo turno do personagem.",
		},
	},

	chama_impetuosa = { -- LJ2 -------------------------------------------------
		nome = "Chama Impetuosa",
		efeito = "Quando o personagem atinge um alvo com resistência vs. flamejante com um poder flamejante, os poderes flamejantes causam 5 de dano flamejante adicional contra o alvo até o final do próximo turno do personagem.",
	},

	combate_montado = { -- LJ1 -------------------------------------------------
		nome = "Combate Montado",
		efeito = "Recebe acesso às habilidades especiais de montaria.",
	},

	combater_com_duas_armas = { -- LJ1 -----------------------------------------
		nome = "Combater com Duas Armas",
		requisito = {
			destreza = 13,
		},
		dano = function(self, poder, arma, valor) --1, -- arma principal
			if arma:match"%+" then
				arma = arma:match"^(.-)%+"
			end
			local essa_arma = assert(armas[arma], "Não achei a arma '"..tostring(arma).."'")
			if essa_arma.tipo:match"corpo" then
				return 1
			else
				return 0
			end
		end,
		efeito = "+1 no dano combatendo com duas armas.",
	},

	conhecimento_de_bardo = { -- LJ2 -------------------------------------------
		nome = "Conhecimento de Bardo",
		requisito = {
			classe = "bardo",
		},
		arcanismo = 2,
		exploracao = 2,
		historia = 2,
		manha = 2,
		natureza = 2,
		religiao = 2,
		efeito = "+2 em várias perícias.",
	},

	conjuracao_ritual = { -- LJ1 -----------------------------------------------
		nome = "Conjuração Ritual",
		requisito = {
			pericias = treinamento("OU", "arcanismo", "religiao"),
		},
		efeito = "Domina e realiza rituais.",
	},

	cura_repousante = { -- LJ2 -------------------------------------------------
		nome = "Cura Repousante",
		efeito = "Depois de realizar um descanso breve ou prolongado, quaisquer poderes de cura que o personagem utilizar até o começo do próximo encontro recuperam o número máximo de pontos de vida.",
	},

	defesa_com_duas_armas = { -- LJ1 -------------------------------------------
		nome = "Defesa com Duas Armas",
		requisito = {
			destreza = 13,
			combater_com_duas_armas = true,
		},
		ca = 1,
		reflexos = 1,
		efeito = "+1 na CA e em Ref ao combater com duas armas.",
	},

	desafio_de_io = { -- D -----------------------------------------------------
		nome = "Desafio de Io",
		requisito = {
			raca = "draconato",
			classe = "paladino",
		},
		efeito = function(self)
			return "Aumente o dano do Desafio Divino em +"..self.mod_con.." quando estiver sangrando."
		end,
	},

	desafio_potente = { -- LJ1 -------------------------------------------------
		nome = "Desafio Potente",
		requisito = {
			classe = "guerreiro",
			constituicao = 15,
			desafio_de_combate = true,
		},
		dano_adicional = function(self, dano, arma)
			if armas[arma].empunhadura == "duas_maos" and desafio_de_combate then
				return soma_dano(self, dano, self.constituicao, arma)
			else
				return dano
			end
		end,
		efeito = function(self)
			return "Some +"..self.mod_con.." no dano do Desafio Potente."
		end,
	},

	destino_do_vacuo_aprimorada = { -- LJ1 -------------------------------------
		nome = "Destino do Vácuo Aprimorado",
		requisito = {
			classe = "bruxo",
			-- constituicao 13 ou carisma 13
			pacto_estelar = true,
		},
		--ataque = 1,
		efeito = "Destino do Vácuo concede +1 de bônus na próxima jogada de d20.",
	},

	determinacao_de_moradin = { -- LJ1 -----------------------------------------
		nome = "Determinação de Moradin",
		requisito = set("canalizar_divindade", "moradin"),
		efeito = "Ganha o poder Determinação de Moradin.",
		poder = {
			nome = "Determinação de Moradin",
			uso = "Encontro",
			origem = set("divino"),
			tipo_ataque = "pessoal",
			alvo = "pessoal",
			efeito = "Recebe +2 no ataque contra criaturas maiores até o final do seu próximo turno.",
		},
	},

	distrair_com_escudo = { -- LJ1 ---------------------------------------------
		nome = "Distrair com Escudo",
		requisito = {
			classe = "guerreiro",
			sabedoria = 15,
			desafio_de_combate = true,
		},
		efeito = "Alvo do Desafio de Combate sofre -2 nos ataques até o final do seu próximo turno.",
	},

	dominio_da_escuridao = { -- FR ---------------------------------------------
		nome = "Domínio da Escuridão",
		requisito = {
			raca = "drow",
		},
		efeito = "Aumenta a área de explosão 1 para explosão 2.",
	},

	duravel = { -- LJ1 ---------------------------------------------------------
		nome = "Durável",
		pc = 2,
		efeito = "Ganha +2 PC.",
	},

	ecos_do_trovao = { -- LJ2 --------------------------------------------------
		nome = "Ecos do Trovão",
		efeito = function(self)
			local bonus
			if self.nivel >= 21 then
				bonus = 3
			elseif self.nivel >= 11 then
				bonus = 2
			else
				bonus = 1
			end
			return "Quando obtém sucesso com um poder de ataque trovejante, o personagem recebe +"..bonus.." de bônus nas jogadas de dano até o final do seu próximo turno."
		end,
	},

	empurrao_com_escudo = { -- LJ1 ---------------------------------------------
		nome = "Empurrão com Escudo",
		requisito = {
			classe = "guerreiro",
			desafio_de_combate = true,
		},
		efeito = "Alvo do Desafio de Combate é empurrado 1 quadrado.",
	},

	encontrao_aprimorado = { -- LJ2 --------------------------------------------
		nome = "Encontrão Aprimorado",
		requisito = {
			forca = 13,
			constituicao = 13,
		},
		efeito = function(self)
			local bonus
			if self.nivel >= 21 then
				bonus = 8
			elseif self.nivel >= 11 then
				bonus = 6
			else
				bonus = 4
			end
			return "Quando realiza um encontrão, o personagem recebe +"..bonus.." de bônus de talento na jogada de ataque."
		end,
	},

	engenhosidade_aprimorada = { -- PM -----------------------------------------
		nome = "Engenhosidade Aprimorada",
		requisito = {
			classe = "senhor_da_guerra",
			caracteristica_classe = function(self)
				return self.caracteristica_classe:match"presen.a.engenhosa"
			end,
		},
		efeito = function(self)
			local meio_nivel = math.floor(self.nivel/2)
			return "+"..meio_nivel+self.mod_int.." de bônus no dano dos ataques de PdA dos aliados ou "..meio_nivel+self.mod_car.." PVT (se fracassar)"
		end,
	},

	especialidade_com_armas = { -- LJ2 -----------------------------------------
		nome = "Especialidade com Armas",
		ataque = function(self, poder, arma, grupo)
			assert(type(arma)=="table", "Descrição inválida da arma")
			assert(arma.grupo, "Descrição da arma não tem grupo")
			if arma.grupo == grupo then
				if self.nivel >= 25 then
					return 3
				elseif self.nivel >= 15 then
					return 2
				else
					return 1
				end
			else
				return 0
			end
		end,
		efeito = function(self)
			local bonus
			if self.nivel >= 25 then
				bonus = 3
			elseif self.nivel >= 15 then
				bonus = 2
			else
				bonus = 1
			end
			return "O personagem escolhe um grupo de armas. Ele recebe +"..bonus.."\n   de bônus de talento nas jogadas de ataque dos poderes com a palavra-chave\n   'arma' que utilizar usando uma arma do grupo escolhido."
		end,
	},

	especialidade_com_implementos = { -- LJ2 -----------------------------------
		nome = "Especialidade com Implementos",
		ataque = function(self, poder, implemento, grupo)
-- Isso não está funcionando direito !!!
			if implemento.grupo == grupo then
				if self.nivel >= 25 then
					return 3
				elseif self.nivel >= 15 then
					return 2
				else
					return 1
				end
			else
				return 0
			end
		end,
		efeito = function(self)
			local bonus
			if self.nivel >= 25 then
				bonus = 3
			elseif self.nivel >= 15 then
				bonus = 2
			else
				bonus = 1
			end
			return "O personagem escolhe um tipo de implemento. Ele recebe +"..bonus.." de bônus de talento nas jogadas de ataque dos poderes com a palavra-chave implemento que utilizar através de um implemento do tipo escolhido."
		end,
	},

	espirito_de_cura_compartilhado = { -- LJ2 ----------------------------------
		nome = "Espírito de Cura Compartilhado",
		requisito = {
			classe = "xama",
		},
		espirito_de_cura = {
			alvo = function(self, alvo, poder)
				self.pv_adicionais = "a 2 do alvo ou "
				return alvo
			end,
		},
		efeito = "Altera o alvo dos PV adicionais.",
	},

	esquivar_de_gigantes = { -- LJ1 --------------------------------------------
		nome = "Esquivar de Gigantes",
		requisito = {
			raca = "anao",
		},
		ca = 1, -- contra oponentes grandes ou maiores
		reflexos = 1, -- contra oponentes grandes ou maiores
		efeito = "+1 na CA e Ref contra criaturas maiores.",
	},

	exatidao_elfica = { -- LJ1 -------------------------------------------------
		nome = "Exatidão Élfica",
		requisito = {
			raca = "elfo",
		},
		precisao_elfica = {
			ataque = function(self, ataque, poder)
				self.bonus_precisao_elfica = 2
				return 2
			end,
		},
		efeito = "+2 no ataque da Precisão Élfica.",
	},

	explosao_coordenada = { -- LJ2 ---------------------------------------------
		nome = "Explosão Coordenada",
		efeito = "Quando utiliza um poder de implemento que cria uma explosão ou rajada, o personagem recebe +1 de bônus nas jogadas de ataque contra os alvos do poder se pelo menos um de seus aliados estiver dentro da área da explosão ou rajada.",
	},

	foco_em_arma = { -- LJ1 ----------------------------------------------------
		nome = "Foco em Arma",
		dano = function(self, poder, arma, grupo)
			if (poder and poder.origem.arma and arma.grupo:match(grupo))
				or (poder==nil and arma.grupo:match(grupo)) then
				return math.floor((self.nivel-1)/10) + 1
			else
				return 0
			end
		end,
		efeito = "+1 no dano com o grupo de armas escolhido.",
	},

	foco_em_pericia = { -- LJ1 -------------------------------------------------
		requisito = {
			pericia = function (self, pericia, err_msg)
				local de_classe = classes[self.classe].pericias[pericia] == "treinada"
				local treinada = self.pericias[pericia]
				return treinada or de_classe,
					err_msg:format ("treinamento="..pericia)
			end,
		},
		nome = "Foco em Perícia",
		acrobacia = treinada_escolhida"acrobacia",
		arcanismo = treinada_escolhida"arcanismo",
		atletismo = treinada_escolhida"atletismo",
		blefe = treinada_escolhida"blefe",
		diplomacia = treinada_escolhida"diplomacia",
		exploracao = treinada_escolhida"exploracao",
		furtividade = treinada_escolhida"furtividade",
		historia = treinada_escolhida"historia",
		intimidacao = treinada_escolhida"intimidacao",
		intuicao = treinada_escolhida"intuicao",
		ladinagem = treinada_escolhida"ladinagem",
		manha = treinada_escolhida"manha",
		natureza = treinada_escolhida"natureza",
		percepcao = treinada_escolhida"percepcao",
		religiao = treinada_escolhida"religiao",
		socorro = treinada_escolhida"socorro",
		tolerancia = treinada_escolhida"tolerancia",
		efeito = function(self, escolhida)
			return "+3 em "..escolhida
		end,
	},

	fogo_astral = { -- LJ1 -----------------------------------------------------
		nome = "Fogo Astral",
		requisito = {
			destreza = 13,
			carisma = 13,
		},
		dano = function(self, poder, arma, valor)
			--local minha_arma = self.armas[arma]
			--if minha_arma.flamejante  or minha_arma.radiante then
			if poder.origem.flamejante or poder.origem.radiante then
				return math.floor((self.nivel-1)/10) + 1
			else
				return 0
			end
		end,
		efeito = function(self)
			local bonus = math.floor((self.nivel-1)/10) + 1
			return "+"..bonus.." no dano de poderes flamejantes ou radiantes."
		end,
	},

	forca_da_bravura = { -- LJ2 ------------------------------------------------
		nome = "Força da Bravura",
		requisito = {
			classe = "bardo",
			caracteristica_classe = "virtude da bravura",
		},
		efeito = "+2 de dano com Virtude da Bravura.",
	},

	forma_do_javali_enraivecido = { -- LJ2 -------------------------------------
		nome = "Forma do Javali Enraivecido",
		requisito = {
			classe = "druida",
		},
		efeito = "+1 no ataque e +2 no dano das investidas na forma\n   animal.",
	},

	forma_do_tigre_feroz = { -- LJ2 --------------------------------------------
		nome = "Forma do Tigre Feroz",
		requisito = {
			classe = "druida",
		},
		efeito = "+2 no dano quando tiver VdC na forma animal",
	},

	frenesi_dos_draconatos = { -- LJ1 ------------------------------------------
		nome = "Frenesi dos Draconatos",
		requisito = {
			raca = "draconato",
		},
--[[
		dano = function(self, poder, arma, valor)
			if sangrando then
				return 2
			else
				return 0
			end
		end,
--]]
		efeito = "+2 no dano enquanto estiver sangrando.",
	},

	fulgor_marcial = { -- PM ---------------------------------------------------
		nome = "Fulgor Marcial",
		requisito = {
			classe = function(self)
				return classes[self.classe].fonte_de_poder == "marcial"
			end,
		},
		efeito = "Você recebe +2 de bônus de talento na Iniciativa.\nNo primeiro turno, pode ajustar usando uma ação mínima.",
	},

	furia_obscura = { -- LJ1 ---------------------------------------------------
		nome = "Fúria Obscura",
		requisito = {
			constituicao = 13,
			sabedoria = 13,
		},
		dano = function(self, poder, arma, valor)
			--local minha_arma = self.armas[arma]
			--if minha_arma.necrotico  or minha_arma.psiquico then
			if poder.origem.necrotico or poder.origem.psiquico then
				return math.floor((self.nivel-1)/10) + 1
			else
				return 0
			end
		end,
		efeito = function(self)
			local bonus = math.floor((self.nivel-1)/10) + 1
			return "+"..bonus.." no dano de poderes necróticos ou psíquicos."
		end,
	},

	furia_primitiva = { -- LJ2 -------------------------------------------------
		nome = "Fúria Primitiva",
		requisito = {
			classe = "druida",
			caracteristica_classe = "predador_primitivo",
		},
		efeito = "O druida recebe +1 de bônus nas jogadas de ataque dos poderes primitivos contra inimigos sangrando.",
	},

	golpe_primoroso = { -- PM --------------------------------------------------
		nome = "Golpe Primoroso",
		requisito = {
			classe = "patrulheiro",
		},
		efeito = "+1 nos At. corpo-a-corpo quando não houver outras criaturas a até 3 quadrados.",
	},

	graca_de_corellon = { -- LJ1 -----------------------------------------------
		nome = "Graça de Corellon",
		requisito = set("canalizar_divindade", "corellon"),
		efeito = "Ganha o poder Graça de Corellon.",
		poder = {
			nome = "Graça de Corellon",
			uso = "Encontro",
			origem = set("divino"),
			tipo_ataque = "distancia 10",
			alvo = "pessoal",
			gatilho = "Aliado dentro do alcance gasta um PdA.",
			efeito = "Você pode realizar uma ação de movimento.",
		},
	},

	grimorio_expandido = { -- LJ1 ----------------------------------------------
		nome = "Grimório Expandido",
		requisito = {
			classe = "mago",
			sabedoria = 13,
		},
		efeito = "Acrescente uma magia diária de ataque dentre as conhecidas em cada nível.",
	},

	harmonia_de_erathis = { -- LJ1 ---------------------------------------------
		nome = "Harmonia de Erathis",
		requisito = set("canalizar_divindade", "erathis"),
		efeito = "Ganha o poder Harmonia de Erathis.",
		poder = {
			nome = "Harmonia de Erathis",
			uso = "Encontro",
			origem = set("divino"),
			tipo_ataque = "distancia 10",
			alvo = "um aliado",
			efeito = "Um dentre 3 aliados dentro do alcance recebe +2 no proximo ataque.",
		},
	},

	impeto_de_acao = { -- LJ1 --------------------------------------------------
		nome = "Ímpeto de Ação",
		requisito = {
			raca = OU("humano", "meio_elfo"),
		},
--[[
		ataque = function(self, ataque, arma)
			if ponto_de_acao then
				return ataque + 3
			else
				return ataque
			end
		end,
--]]
		efeito = "+3 de bônus no ataque ao usar um PdA.",
	},

	iniciativa_aprimorada = { -- LJ1 -------------------------------------------
		nome = "Iniciativa Aprimorada",
		iniciativa = 4,
		efeito = "+4 na iniciativa.",
	},

	inspiracao_aprimorada = { -- PM --------------------------------------------
		nome = "Inspirar Aprimorada",
		requisito = {
			classe = "senhor_da_guerra",
			caracteristica_classe = "presenca_inspiradora",
		},
		presenca = {
			dano = function(self)
				self.pv_adicionais = 2
				return 2
			end,
		},
		efeito = function(self)
			return "A característica Presença Inspiradora concede 2 PV adicionais."
		end,
	},

	inspirar_recuperacao = { -- LJ1 --------------------------------------------
		nome = "Inspirar Recuperação",
		requisito = {
			classe = "senhor_da_guerra",
			caracteristica_classe = "presenca_inspiradora",
		},
		efeito = function(self)
			return "Aliado que gasta um PdA para atacar pode fazer um TR com +"..self.mod_car.."."
		end,
	},

	instinto_primitivo = { -- LJ2 ----------------------------------------------
		nome = "Instinto Primitivo",
		requisito = {
			classe = "druida",
			caracteristica_classe = "guardiao_primitivo",
		},
		efeito = "Quando o druida realiza um teste de iniciativa no começo do encontro, um de seus aliados a até 5 quadrados pode refazer seu teste de iniciativa.",
	},

	intuicao_coletiva = { -- LJ1 -----------------------------------------------
		nome = "Intuição Coletiva",
		requisito = {
			raca = "meio_elfo",
		},
		intuicao = 1, -- aos aliados a até 10 quadrados
		iniciativa = 1, -- aos aliados a até 10 quadrados
		efeito = "+1 na Intuição e na Iniciativa de seus aliados a até 10 quadrados.",
	},

	investida_poderosa = { -- LJ1 ----------------------------------------------
		nome = "Investida Poderosa",
		requisito = {
			forca = 13,
		},
--[[
		dano = function(self, poder, arma, valor)
			if investida then
				return 2
			else
				return 0
			end
		end,
--]]
		efeito = "+2 no dano e nas tentativas de encontrão ao realizar uma investida.",
	},

	lamina_lepida = { -- LJ1 ---------------------------------------------------
		nome = "Lâmina Lépida",
		requisito = {
			destreza = 15,
		},
--[[
		ataque = function(self, ataque, arma)
			if armas[arma].grupo == "leve" and self.vantagem_combate then
				return ataque + 1
			else
				return ataque
			end
		end,
--]]
		efeito = "+1 nos ataques com VdC usando lâmina leve.",
	},

	lamina_oportunista = { -- LJ1 ----------------------------------------------
		nome = "Lâmina Oportunista",
		requisito = {
			forca = 13,
			destreza = 13,
		},
		at_oportunidade = function(self, ataque, arma)
			local grupo_arma = armas[arma].grupo
			if (grupo_arma == "leve" or grupo_arma == "pesada") then
				return ataque + 2
			else
				return ataque
			end
		end,
		efeito = "+2 nos AdO usando lâminas leves ou pesadas.",
	},

	liberdade_marcial = { -- PM ------------------------------------------------
		nome = "Liberdade Marcial",
		requisito = {
			classe = function(self)
				return classes[self.classe].fonte_de_poder == "marcial"
			end,
			pericias = treinamento"tolerancia",
		},
		efeito = "+5 nos TR contra lento e imobilizado.",
	},

	linguistica = { -- LJ1 -----------------------------------------------------
		nome = "Linguística",
		requisito = {
			inteligencia = 13,
		},
		efeito = "Fluente em mais 3 idiomas.",
	},

	linhagem_auspiciosa = { -- LJ2 ---------------------------------------------
		nome = "Linhagem Auspiciosa",
		requisito = {
			raca = "deva",
			caracteristica_classe = function(self)
				self.dado_memorias = "d8"
				return true
			end,
		},
		efeito = "Troca o d6 pelo d8 no Memórias de Mil Vidas.",
	},

	magia_furiosa_arcana = { -- LJ2 --------------------------------------------
		nome = "Magia Furiosa Arcana",
		requisito = {
			classe = "feiticeiro",
		},
		efeito = "Quando atinge um inimigo com um poder de ataque sem\n   limite, recebe +1 de bônus nas jogadas de ataque contra ele até o final\n   do seu próximo turno.",
	},

	majestade_draconica = { -- D -----------------------------------------------
		nome = "Majestade Dracônica",
		requisito = {
			raca = "draconato",
			--classe = set("clerigo", "paladino", "invocador", "vingador"),
			classe = function(self)
				return classes[self.classe].fonte_de_poder == "divino"
			end,
		},
		efeito = "Quando utiliza um poder de Canalizar Divindade, os inimigos a até 5 quadrados que estiverem sangrando sofrem -2 de penalidade em todas as defesas até o final do próximo turno.",
	},

	manter_a_vantagem = { -- LJ1 -----------------------------------------------
		nome = "Manter a Vantagem",
		requisito = {
			classe = "ladino",
			carisma = 15,
		},
		efeito = "Se obtiver um Suc.Dec. em ataque com VdC, você conserva a VdC até o final do seu próximo turno.",
	},

	maos_restauradoras = { -- LJ1 ----------------------------------------------
		nome = "Mãos Restauradoras",
		requisito = {
			classe = "paladino",
			--imposicao_de_maos = true,
			caracteristica_classe = function(self)
				self.bonus_imposicao_de_maos = self.mod_car
				return true
			end,
		},
		efeito = function(self)
			return "Os aliados alvos de Imposição de Mãos recebem +"..self.mod_car.." PV."
		end,
	},

	mare_de_melora = { -- LJ1 --------------------------------------------------
		nome = "Maré de Melora",
		requisito = set("canalizar_divindade", "melora"),
		efeito = "Ganha o poder Maré de Melora",
		poder = {
			nome = "Maré de Melora",
			uso = "Encontro",
			origem = set("cura", "divino"),
			tipo_ataque = "distancia 5",
			alvo = "uma criatura sangrando",
			efeito = function(self)
				local bonus
				if self.nivel >= 21 then
					bonus = 6
				elseif self.nivel >= 11 then
					bonus = 4
				else
					bonus = 2
				end
				return "O alvo adquire regeneração "..bonus
					.." até o final do encontro ou não estar mais sangrando."
			end,
		},
	},

	medico_de_combate = { -- LJ2 -----------------------------------------------
		nome = "Médico de Combate",
		requisito = {
			pericias = treinamento("socorro"),
		},
		socorro = 2,
		efeito = "Ação mínima (ao invés da padrão) para estabilizar criatura morrendo.\n+2 nos testes de socorro.",
	},

	mira_do_cacador = { -- PM --------------------------------------------------
		nome = "Mira do Caçador",
		requisito = {
			classe = "patrulheiro",
		},
		efeito = "Não sofre penalidade de cobertura ou ocultação contra a Presa.",
	},

	mobilidade_defensiva = { -- LJ1 --------------------------------------------
		nome = "Mobilidade Defensiva",
		ca_oportunidade = 2, -- contra ataques de oportunidade
		efeito = "Concede +2 de bônus de talento na CA contra AdO.",
	},

	nevasca_ardente = { -- LJ1 -------------------------------------------------
		nome = "Nevasca Ardente",
		requisito = {
			inteligencia = 13,
			sabedoria = 13,
		},
		efeito = function(self)
			local bonus = math.floor((self.nivel-1)/10)+1
			return "+"..bonus.." de dano com poderes ácidos ou congelantes."
		end,
	},

	nocaute_surpresa = { -- LJ1 ------------------------------------------------
		nome = "Nocaute Surpresa",
		requisito = {
			forca = 15,
			classe = "ladino",
		},
		efeito = "O alvo fica derrubado com Suc.Dec. com VdC.",
	},

	orador_dos_espiritos = { -- LJ2 --------------------------------------------
		nome = "Orador dos Espíritos",
		requisito = {
			classe = "xama",
		},
		falar_com_os_espiritos = {
			alvo = function(self, alvo)
				self.alvo_falar_com_os_espiritos = "você ou um aliado a até 5 quadrados"
				return alvo
			end,
		},
		efeito = "Concede o benefício de Falar com os Espíritos a um aliado.",
	},

	palavra_de_inspiracao_aprimorada = { -- PM ---------------------------------
		nome = "Palavra de Inspiração Aprimorada",
		requisito = {
			classe = "senhor_da_guerra",
		},
		palavra_de_inspiracao = {
			dano = function(self)
				self.palavra_de_inspiracao_adicional = self.mod_car
				return self.mod_car
			end,
		},
		efeito = function(self)
			return "O alvo da Palavra de Inspiração recebe +"..self.mod_car.." PV."
		end,
	},
	palavra_majestosa_aprimorada = { -- LJ2 ------------------------------------
		nome = "Palavra Majestosa Aprimorada",
		requisito = {
			classe = "bardo",
		},
		palavra_majestosa = {
			ataque = function(self)
				self.palavra_majestosa_adicional = self.mod_car
				return self.mod_car
			end,
		},
		efeito = function(self)
			return "O alvo da Palavra Majestosa recebe "..self.mod_car.." PVT."
		end,
	},

	passo_leve = { -- LJ1 ------------------------------------------------------
		nome = "Passo Leve",
		requisito = {
			raca = OU("elfo", "meio_elfo"),
		},
		acrobacia = 1,
		furtividade = 1,
		efeito = "+1 no deslocamento de viagem do grupo; +5 para encontrar e seguir os rastros do grupo.",
	},

	passo_nebuloso_aprimorado = { -- LJ1 ---------------------------------------
		nome = "Passo Nebuloso Aprimorado",
		requisito = {
			classe = "bruxo",
			caracteristica_classe = function(self)
				self.adicional_passo_nebuloso = 2
				return true
			end,
		},
		efeito = "Teleporta +2 quadrados usando o Passo Nebuloso.",
	},

	pau_pra_toda_obra = { -- LJ1 -----------------------------------------------
		nome = "Pau Pra Toda Obra",
		requisito = {
			inteligencia = 13,
		},
		acrobacia = nao_treinada"acrobacia",
		arcanismo = nao_treinada"arcanismo",
		atletismo = nao_treinada"atletismo",
		blefe = nao_treinada"blefe",
		diplomacia = nao_treinada"diplomacia",
		exploracao = nao_treinada"exploracao",
		furtividade = nao_treinada"furtividade",
		historia = nao_treinada"historia",
		intimidacao = nao_treinada"intimidacao",
		intuicao = nao_treinada"intuicao",
		ladinagem = nao_treinada"ladinagem",
		manha = nao_treinada"manha",
		natureza = nao_treinada"natureza",
		percepcao = nao_treinada"percepcao",
		religiao = nao_treinada"religiao",
		socorro = nao_treinada"socorro",
		tolerancia = nao_treinada"tolerancia",
		efeito = "+2 nos testes de perícias não-treinadas.",
	},

	perseveranca_dos_humanos = { -- LJ1 ----------------------------------------
		nome = "Perseverança dos Humanos",
		requisito = {
			raca = OU("humano", "meio_elfo"),
		},
		efeito = "+1 de bônus de talento nos TR.",
	},

	poder_radiante = { -- LJ2 --------------------------------------------------
		nome = "Poder Radiante",
		requisito = {
			classe = "deva",
		},
		efeito = function(self)
			local dano = 2 * (math.floor((self.nivel-1)/10)+1)
			return "+"..dano.." no dano radiante adicional em troca de -2 no ataque."
		end,
	},

	precisao_brutal = { -- PM --------------------------------------------------
		nome = "Precisão Brutal",
		requisito = {
			classe = "patrulheiro",
			raca = "elfo",
		},
		precisao_elfica = {
			dano = function(self, poder)
				self.dano_precisao_elfica = self.mod_sab
				return self.mod_sab
			end,
		},
		efeito = function(self)
			return "+"..self.mod_sab.." ao atingir sua Presa usando a Precisão Élfica."
		end,
	},

	primor_com_armas_grandes_dos_golias = { -- LJ2 -----------------------------
		nome = "Primor com Armas Grandes dos Golias",
		requisito = {
			raca = "golias",
		},
		efeito = function(self)
			local bonus = math.floor((self.nivel-1)/10)+2
			return "+"..bonus.." no dano."
		end,
	},

	proficiencia_com_arma = { -- LJ1 -------------------------------------------
		nome = "Proficiência com Arma",
		proficiencia = function(self, arma)
			if self.talentos.proficiencia_com_arma == armas[arma] then
				return true
			end
		end,
	},

	proficiencia_com_armadura = { -- LJ1 ---------------------------------------
		nome = "Proficiência com Armadura",
		requisito = {
			armadura = function (self, categoria, err_msg)
				local armaduras = require"DnD.Armaduras"
				for i = 1, #armaduras do
					if armaduras[i] == categoria then
						local req = armaduras[i-1]
						return self.proficiencia_com_armaduras[req],
							err_msg:format ("armadura="..req, "proficiencia_com_armadura")
					end
				end
			end,
		},
		efeito = function (self, armadura)
			return "Adquire proficiência com "..armadura.."."
		end,
	},

	proficiencia_com_escudo_leve = { -- LJ1 ------------------------------------
		nome = "Proficiência com Escudo Leve",
		requisito = {
			forca = 13,
		},
		efeito = "O personagem adquire proficiência com escudos leves.",
	},

	proficiencia_com_escudo_pesado = { -- LJ1 ----------------------------------
		nome = "Proficiência com Escudo Pesado",
		requisito = {
			forca = 15,
			-- proficiencia com escudo leve
		},
		efeito = "O personagem adquire proficiência com escudos pesados.",
	},

	prontidao = { -- LJ1 -------------------------------------------------------
		nome = "Prontidão",
		percepcao = 2,
		efeito = "O personagem não concede VdC quando é surpreendido.",
	},

	radiancia_de_pelor = { -- LJ1 ----------------------------------------------
		nome = "Radiância de Pelor",
		requisito = {
			-- canalizar_divindade = true,
			-- divindade = "pelor",
		},
		efeito = "Ganha o poder Radiância de Pelor",
		poder = {
			nome = "Radiância de Pelor",
			uso = "Encontro",
			origem = set("divino", "implemento", "radiante"),
			tipo_ataque = "explosão contígua 1",
			alvo = "os mortos-vivos na explosão",
			ataque = function(self)
				return self.mod_sab
			end,
			defesa = "Von",
			dano = function(self, dano, arma)
				local n = math.floor((self.nivel-1)/5)+1
				return soma_dano(self, dano, n.."d12", arma)
			end,
		},
	},

	rajada_draconica = { -- D --------------------------------------------------
		nome = "Rajada Dracônica",
		requisito = {
			raca = "draconato",
			classe = "bruxo",
		},
		efeito = "O poder Rajada Mística pode causar o mesmo dano do Sopro.",
	},

	rastreador_experiente = { -- PM --------------------------------------------
		nome = "Rastreador Experiente",
		requisito = {
			classe = "patrulheiro",
			pericias = treinamento"natureza",
			sabedoria = 13,
		},
		efeito = "+5 em Percepção para rastrear (você e aliados).",
	},

	reflexos_de_combate = { -- LJ1 ---------------------------------------------
		nome = "Reflexos de Combate",
		requisito = {
			destreza = 13,
		},
		at_oportunidade = 1,
		efeito = "+1 nos AdO.",
	},

	renascimento_potente = { -- LJ2 --------------------------------------------
		nome = "Renascimento Potente",
		requisito = {
			classe = "deva",
		},
		efeito = "+2 nos ataques e danos até o final do encontro, se chegar a 0 ou menos PV.",
	},

	reprimenda_feroz = { -- LJ1 ------------------------------------------------
		nome = "Reprimenda Feroz",
		requisito = {
			classe = "tiefling",
			-- colera_infernal = true,
		},
		efeito = "Quando obtiver sucesso em um ataque usando Cólera Infernal, o alvo também é empurrado 1 quadrado.",
	},

	resgate_de_avandra = { -- LJ1 ----------------------------------------------
		nome = "Resgate de Avandra",
		requisito = {
			-- canalizar_divindade = true,
			-- divindade = "avandra",
		},
		efeito = "Ganha o poder Resgate de Avandra",
		poder = {
			nome = "Resgate de Avandra",
			uso = "Encontro",
			origem = set("divino"),
			tipo_ataque = "corpo",
			alvo = "um aliado",
			efeito = "Troca de lugar com um aliado adjacente.",
		},
	},

	reversao_de_sehanine = { -- LJ1 --------------------------------------------
		nome = "Reversão de Sehanine",
		requisito = {
			-- canalizar_divindade = true,
			-- divindade = "sehanine",
		},
		efeito = "Ganha o poder Reversão de Sehanine",
		poder = {
			nome = "Reversão de Sehanine",
			uso = "Encontro",
			origem = set("divino"),
			tipo_ataque = "distancia 5",
			alvo = "Inimigo adquire condição do personagem, quando obtém 20 natural no TR.",
		},
	},

	saltador_em_distancia = { -- LJ1 -------------------------------------------
		nome = "Saltador em Distância",
		requisito = {
			pericias = treinamento"atletismo",
		},
		atletismo = 1,
		efeito = "Pode realizar saltos em distância como se tivesse tomado impulso.",
	},

	sangue_do_fogo_infernal = { -- LJ1 -----------------------------------------
		nome = "Sangue do Fogo Infernal",
		requisito = {
			classe = "tiefling",
		},
		efeito = "O personagem recebe +1 no ataque e +1 no dano quando usar poderes com a palavra-chave flamejante ou medo.",
	},

	saque_rapido = { -- LJ1 ----------------------------------------------------
		nome = "Saque Rápido",
		requisito = {
			destreza = 13,
		},
		iniciativa = 2,
		efeito = "O personagem consegue sacar uma arma, ou objeto que carregue no cinto, como parte da mesma ação exigida para atacar com a arma ou usar o objeto.",
	},

	sentido_dos_draconatos = { -- LJ1 ------------------------------------------
		nome = "Sentido dos Draconatos",
		requisito = {
			raca = "draconato",
		},
		efeito = "Adquire visão na penumbra.",
		percepcao = 1,
	},

	soldado_eladrin = { -- LJ1 -------------------------------------------------
		nome = "Soldado Eladrin",
		requisito = {
			raca = "eladrin",
		},
		efeito = "Proficiência com todas as lanças, +2 de bônus com espadas longas e lanças.",
	},

	sopro_adaptavel = { -- D ---------------------------------------------------
		nome = "Sopro Adaptável",
		requisito = {
			raca = "draconato",
		},
		efeito = "Permite escolher mais um tipo de dano do Sopro.",
	},

	sopro_amedrontador = { -- D ------------------------------------------------
		nome = "Sopro Amedrontador",
		requisito = {
			raca = "draconato",
			pericias = treinamento"intimidacao",
		},
		efeito = "As criaturas atingidas pelo Sopro ficam marcadas até o final do próximo turno do personagem.",
	},

	sopro_de_dragao_ampliado = { -- LJ1 ----------------------------------------
		nome = "Sopro de Dragão Ampliado",
		requisito = {
			raca = "draconato",
		},
		sopro = {
			tipo_ataque = function (self, tipo_ataque, poder)
				return "rajada contígua 5"
			end,
		},
		efeito = "A rajada do sopro passa de 3 para 5.",
	},

	sopro_estimulante = { -- D -------------------------------------------------
		nome = "Sopro Estimulante",
		requisito = {
			raca = "draconato",
		},
		efeito = "Só atinge os inimigos com o Sopro e os aliados dentro da área recebem +1 de bônus no ataque até o final do próximo turno do personagem.",
	},

	sopro_focalizado = { -- D --------------------------------------------------
		nome = "Sopro Focalizado",
		requisito = {
			raca = "draconato",
		},
		efeito = function(self)
			local bonus
			if self.nivel >= 21 then
				bonus = 6
			elseif self.nivel >= 11 then
				bonus = 4
			else
				bonus = 2
			end
			return "Permite transformar a área de efeito em rajada contígua 1, causando "..bonus.." de dano adicional."
		end,
	},

	sopro_poderoso = { -- D ----------------------------------------------------
		nome = "Sopro Poderoso",
		requisito = {
			raca = "draconato",
		},
		efeito = function(self, modificador)
			return "Troca o modificador de atributo do ataque e do dano do Sopro para "..modificador.."."
		end,
	},

	sopro_surpreendente = { -- D -----------------------------------------------
		nome = "Sopro Surpreendente",
		requisito = {
			raca = "draconato",
		},
		efeito = "Recebe VdC contra as criaturas atingidas pelo Sopro até o final do próximo turno.",
	},

	treinamento_corpo_a_corpo = { -- LJ2 ---------------------------------------
		nome = "Treinamento Corpo-a-corpo",
		efeito = function (self, atributo)
			assert(atributos[atributo], "Atributo inválido ("..tostring(atributo)..")")
			return "Usa o modificador de "..atributo.." no lugar da Força nos At.Básicos CaC."
		end,
	},

	vantagem_a_distancia = { -- LJ2 --------------------------------------------
		nome = "Vantagem à Distância",
		efeito = "Obtém VdC contra inimigos flanqueados por seus aliados.",
	},

	vantagem_da_astucia = { -- LJ2 ---------------------------------------------
		nome = "Vantagem da Astúcia",
		requisito = {
			classe = "bardo",
			caracteristica_classe = "virtude da astúcia",
		},
		efeito = "Pode conduzir um inimigo para espaço do aliado conduzido pela Virtude da Astúcia.",
	},

	vitalidade = { -- LJ1 ------------------------------------------------------
		nome = "Vitalidade",
		efeito = "Aumenta a quantidade de pontos de vida em 5 por estágio.",
		pv_estagio = 5,
	},

	ajuste_largo = { -----------------------------------------------------------
		nome = "Ajuste Largo",
		requisito = {
			raca = "omaticaya",
		},
		efeito = "Ganha o Ajuste Largo.",
		poder = {
			nome = "Ajuste Largo",
			uso = "Encontro",
			origem = {},
			tipo_ataque = "pessoal",
			alvo = "próprio",
			efeito = function(self)
				return "Você pode ajustar "..self.mod_des.." quadrados."
			end,
		},
	},

	arma_de_eua = { ------------------------------------------------------------
		nome = "Arma de Eua",
		requisito = {
			raca = "omaticaya",
		},
		efeito = "O tipo de arma escolhido passa a poder ser usado como implemento para poderes com a palavra-chave primitivo.",
	},

	marca_dos_ancestrais = { ---------------------------------------------------
		nome = "Marca dos Ancestrais",
		requisito = {
			raca = "omaticaya_guerrilheito_das_adagas",
		},
		efeito = "Ganha o poder Marca dos Ancestrais",
		poder = {
			nome = "Marca dos Ancestrais",
			uso = "Encontro",
			origem = set("primitivo"),
			tipo_ataque = "distancia",
			alvo = "um inimigo",
			efeito = "Você fica inconsciente por uma rodada e o alvo fica marcado.",
		},
	},

	passo_largo = { -----------------------------------------------------------
		nome = "Passo Largo",
		requisito = {
			raca = "omaticaya",
		},
		efeito = "Ajuste passa a ser de 2 quadrados.",
	},

	raizes_sugadoras = { -------------------------------------------------------
		nome = "Raízes Sugadoras",
		requisito = {
			raca = "omaticaya_cacador_com_arco",
		},
		efeito = "Ganha o poder Raízes Sugadoras.",
		poder = {
			nome = "Raízes Sugadoras",
			uso = "Encontro",
			origem = set("cura", "primitivo"),
			tipo_ataque = "distancia",
			alvo = "um inimigo",
			efeito = "Recebe PVT igual aos PV de dano causados ao inimigo.",
		},
	},

	maldicao_aprimorada = { ----------------------------------------------------
		nome = "Maldição Aprimorada",
		requisito = {
			classe = "bruxo",
		},
		dano_adicional = function(self, dano, arma)
			if type(dano) == "string" then
				return dano:gsub("d6", "d8")
			else
				return dano
			end
		end,
		efeito = "Aumenta o dado da Maldição do Bruxo de d6 para d8.",
	},

	furtividade_das_sombras = {
		nome = "Furtividade das Sombras",
		requisito = {
			classe = function(self)
				return self.classe ~= "ladino"
			end,
			destreza = 13,
		},
		ladinagem = "treinada",
		efeito = "Adquire treinamento em Ladinagem e pode usar o At.Furtivo 1/encontro.",
	},
}
