local soma_dano = require"DnD.Soma".soma
local armas = require"DnD.Armas"
local classes = require"DnD.Classes"

local implemento_basico = require"DnD.Implemento_Basico"

local function amuleto (amuleto, bonus)
	amuleto.tipo = "amuleto"
	amuleto.posicao = "pescoço"
	amuleto.fortitude = bonus
	amuleto.reflexos = bonus
	amuleto.vontade = bonus
	return amuleto
end

local function escudo_leve(escudo)
	escudo.escudo = true
	escudo.tipo = "bracadeira"
	escudo.peso = "leve"
	escudo.ca = (escudo.ca or 0) + 1
	escudo.reflexos = (escudo.reflexos or 0) + 1
	return escudo
end

local function escudo_pesado(escudo)
	escudo.escudo = true
	escudo.tipo = "bracadeira"
	escudo.peso = "pesado"
	escudo.ca = (escudo.ca or 0) + 2
	escudo.reflexos = (escudo.reflexos or 0) + 2
	escudo.penalidade = (escudo.penalidade or 0) - 2
	return escudo
end

return {
	amuleto_da_protecao_1 = amuleto ({
		nome = "Amuleto da Proteção",
		preco = 360,
	}, 1),
	amuleto_da_protecao_6 = amuleto ({
		nome = "Amuleto da Proteção",
		preco = 1800,
	}, 2),
	amuleto_da_saude_3 = amuleto ({
		nome = "Amuleto da Saúde",
		preco = 680,
	}, 1),
	amuleto_da_determinacao_fisica_2 = amuleto ({
		nome = "Amuleto da Determinação Física",
		preco = 520,
		propriedade = "+2 nos TR X venenoso, enfraquecido, imobilizado ou lento.",
	}, 1),
	bandurra_fochlucana_3 = {
		nome = "Bandurra Fochlucana",
		tipo = "instrumento",
		posicao = "mochila",
		ataque = function(self, ataque, arma)
			return soma_dano(self, 1, ataque, arma)
		end,
		dano = function(self, dano, arma)
			return soma_dano(self, 1, dano, arma)
		end,
		decisivo = function(self, dano, arma)
			return soma_dano(self, "+1d6", dano, arma)
		end,
	},
	bastao_solar = {
		nome = "Bastão Solar",
		tipo = "bastao",
		posicao = "mochila",
		preco = 2,
	},
	botas_da_furtividade_3 = {
		nome = "Botas da Furtividade",
		tipo = "bota",
		posicao = "pés",
		preco = 680,
		furtividade = 2,
	},
	bracadeira_do_alivio_2 = {
		nome = "Braçadeira do Alívio",
		tipo = "bracadeira",
		posicao = "braço",
		preco = 520,
		poder = {
			nome = "Braçadeira do Alívio",
			uso = "Diário",
			origem = {},
			acao = "livre",
			efeito = "Efeito: quando um aliado adjacente recupera PV, você ou outro aliado recupera\n    1d8 PV.",
		},
	},
	bracadeira_do_golpe_poderoso_2 = {
		nome = "Braçadeira do Golpe Poderoso",
		tipo = "bracadeira",
		posicao = "braço",
		dano = function(self, dano, arma)
			local esse_poder = classes[self.classe].poderes[arma]
			--if armas[arma].tipo:match"^corpo" then
			if esse_poder and esse_poder.tipo_ataque:match"corpo" and esse_poder.tipo_ataque:match"basico" then
				return soma_dano(self, dano, 2, "Braçadeira do Golpe Poderoso")
			else
				return dano
			end
		end,
	},
	bracadeira_dos_golpes_estrategicos_6 = {
		nome = "Braçadeira dos Golpes Estratégicos",
		tipo = "bracadeira",
		posicao = "braço",
		preco = 1800,
		propriedade = "Propriedade: causa +1d6 nos AdO.",
	},
	bracadeira_do_poder_mental_6 = {
		nome = "Braçadeira do Poder Mental",
		tipo = "bracadeira",
		posicao = "braço",
		preco = 1800,
		poder = {
			nome = "Braçadeira do Poder Mental",
			uso = "Encontro",
			origem = {},
			acao = "livre",
			efeito = "Efeito: quando for realizar um ataque baseado na Força, um teste de Força ou um\n    teste de perícia baseado em Força, use outro modificador dentre\n    Inteligência, Sabedoria ou Carisma no lugar daquele.",
		},
	},
	bracadeira_do_tiro_perfeito_3 = {
		nome = "Braçadeira do Tiro Perfeito",
		tipo = "bracadeira",
		posicao = "braço",
		dano = function(self, dano, arma)
			basico = arma:match"basico"
			if arma:match"%+" then
				arma = arma:match"^(.-)%+"
			end
			local essa_arma = armas[arma]
			local esse_poder = classes[self.classe].poderes[arma]
			if esse_poder and esse_poder.tipo_ataque:match"distancia"
				and esse_poder.tipo_ataque:match"basico" then
				return soma_dano(self, dano, 2, "Braçadeira do Tiro Perfeito")
			elseif basico and essa_arma and essa_arma.tipo:match"distancia" then
				return soma_dano(self, dano, 2, "Braçadeira do Tiro Perfeito")
			else
				return dano
			end
		end,
	},
	broche_do_curandeiro_4 = {
		nome = "Broche do Curandeiro",
		tipo = "broche",
		posicao = "pescoço",
		fortitude = 1,
		reflexos = 1,
		vontade = 1,
		pv_recuperado = 1, -- Ainda não funciona!!!!!!!!!!!!!!!!!
	},
	cinto_da_resistencia_1 = {
		nome = "Cinto da Resistência", -- AA 140
		tipo = "cinto",
		posicao = "cintura",
		preco = 360,
		efeito = "Testes de Socorro para ajudar o personagem recebem +2",
	},
	cinto_do_vigor_2 = {
		nome = "Cinto do Vigor",
		tipo = "cinto",
		posicao = "cintura",
		preco = 520,
		pv_pc = 1,
	},
	elmo_da_oportunidade_4 = {
		nome = "Elmo da Oportunidade",
		tipo = "elmo",
		posicao = "cabeça",
		preco = 840,
		at_oportunidade = 1,
	},
	escudo_leve = escudo_leve{
		nome = "Escudo Leve",
		tipo = "escudo",
		posicao = "braço",
		preco = 5,
	},
	escudo_leve_da_protecao_3 = escudo_leve{
		nome = "Escudo Leve da Proteção",
		tipo = "escudo",
		posicao = "braço",
		preco = 680,
		poder = {
			nome = "Escudo Leve da Proteção",
			uso = "Diário",
			origem = {},
			acao = "padrão",
			efeito = "Efeito: você e um aliado adjacente adquirem resistência 10 contra todos os tipos\n    de dano até o FdPT.",
		},
	},
	escudo_pesado_da_protecao_3 = escudo_pesado{
		nome = "Escudo Pesado da Proteção",
		tipo = "escudo",
		posicao = "braço",
		preco = 680,
		poder = {
			nome = "Escudo Pesado da Proteção",
			uso = "Diário",
			origem = {},
			acao = "padrão",
			efeito = "Efeito: você e um aliado adjacente adquirem resistência 10 contra todos os tipos\n    de dano até o FdPT.",
		},
	},
	escudo_leve_flutuante = escudo_leve{
		nome = "Escudo Leve Flutuante",
		tipo = "escudo",
		posicao = "braço",
		preco = 360,
		efeito = "O personagem não afunda em superfícies líquidas",
	},
	escudo_leve_draconico_2 = escudo_leve{
		nome = "Escudo Leve Dracônico",
		tipo = "escudo",
		posicao = "braço",
		preco = 680,
		ca = 1,
		reflexos = 1,
	},
	escudo_leve_de_arremesso_6 = escudo_leve{
		nome = "Escudo Leve de Arremesso",
		tipo = "escudo",
		posicao = "braço",
		preco = 1800,
		poder = {
			nome = "Escudo Leve de Arremesso",
			uso = "SL",
			origem = {},
			ataque = function(self) return self.mod_for + 2 end,
			dano = function (self, dano, arma)
				return soma_dano(self, "1d8", self.mod_for)
			end,
			efeito = "Efeito: uma vez por dia, quando acertar este ataque, o alvo pode ser empurrado\n    1 quadrado.",
		},
	},
	escudo_pesado = escudo_pesado{
		nome = "Escudo Pesado",
		tipo = "escudo",
		posicao = "braço",
		preco = 10,
	},
	escudo_de_platina_9 = escudo_leve{
		nome = "Escudo Leve de Platina",
		tipo = "escudo",
		posicao = "braço",
		preco = 4200,
		--simbolo_sagrado = 1,
		ataque = implemento_basico("simbolo_sagrado", 1),
		dano = implemento_basico("simbolo_sagrado", 1),
		decisivo = implemento_basico("simbolo_sagrado", "+1d8"),
		propriedade = "Este escudo pode ser usado como símbolo sagrado.",
		poder = {
			nome = "Escudo de Platina",
			uso = "En",
			origem = {},
			efeito = "Efeito: quando pelo menos 2 aliados (ou o próprio) estiverem sangrando, o personagem e seus aliados adjacentes recebem +1 na CA e os membros que estiverem sangrando recebem +1 em Vontade.",
		},
	},
	estandarte_de_batalha_do_poder_4 = {
		nome = "Estandarte de Batalha do Poder",
		tipo = "estandarte",
		posicao = "mochila",
		preco = 840,
		poder = {
			nome = "Estandarte de Batalha do Poder",
			uso = "Encontro",
			origem = {},
			efeito = "Efeito: cria zona (explosão contígua 5) +1 no dano.",
		},
	},
	estatueta_do_cao_de_onix_4 = {
		nome = "Estatueta do Cão de Ônix",
		tipo = "estatueta",
		posicao = "mochila",
		preco = 840,
	},
	ferramentas_de_ladrao = {
		nome = "Ferramentas de Ladrão",
		tipo = "ferramenta",
		posicao = "mochila",
		preco = 20,
	},
	fogo_do_alquimista = {
		nome = "Fogo do Alquimista",
		tipo = "alquimia",
		posicao = "mochila",
		preco = 680,
	},
	gema_do_dialogo_2 = {
		nome = "Gema do Diálogo",
		tipo = "gema",
		posicao = "cabeça",
		blefe = 1,
		diplomacia = 1,
	},
	grimorio = {
		nome = "Grimório",
		tipo = "ferramenta",
		posicao = "mochila",
		preco = 50,
	},
	kit_escalar = {
		nome = "Kit de Escalar",
		tipo = "ferramenta",
		posicao = "mochila",
		preco = 2,
	},
	kit_aventureiro_padrao = {
		nome = "Kit do Aventureiro padrão",
		tipo = "ferramenta",
		posicao = "mochila",
		preco = 15,
	},
	luvas_do_gatuno = {
		nome = "Luvas do Gatuno",
		tipo = "luvas",
		posicao = "mãos",
		preco = 360,
		ladinagem = 1,
	},
	manto_da_distorcao_4 = {
		nome = "Manto da Distorção",
		tipo = "manto",
		posicao = "pescoço",
		fortitude = 1,
		reflexos = 1,
		vontade = 1,
		efeito = "Recebe +1 em todas as defesas contra AaD realizados a mais de 5 quadrados.",
	},
	manto_da_rainha_de_rapina = {
		nome = "Manto da Rainha de Rapina",
		tipo = "manto",
		posicao = "pescoço",
		fortitude = 2,
		reflexos = 2,
		vontade = 2,
		percepcao = 2,
		furtividade = 2,
	},
	manto_elfico_7 = { -- LJ1 253
		nome = "Manto Elfico",
		tipo = "manto",
		posicao = "pescoço",
		fortitude = 2,
		reflexos = 2,
		vontade = 2,
		furtividade = 2,
	},
	mochila_de_carga_5 = { -- LJ1 254
		nome = "Mochila de Carga",
		tipo = "maravilhoso",
		posicao = "costas",
		efeito = "Permite armazenar até 100kg ou meio metro cúbico de volume, mas sempre pesa meio quilo.  Retirar um item de dentro exige uma ação mínima.",
	},
	oculos_dos_olhos_de_aguia_2 = { -- AA 136
		nome = "Óculos dos Olhos de Águia",
		tipo = "oculos",
		posicao = "cabeça",
		efeito = "Ganha +1 nos ataques básicos à distância."
	},
	pocao_de_cura = {
		nome = "Poção de Cura",
		tipo = "poção",
		posicao = "mochila",
		preco = 50,
	},
	provisoes_infinitas_4 = { -- LJ1 254
		nome = "Provisões Infinitas",
		tipo = "maravilhoso",
		posicao = "mochila",
		efeito = "Após um descanso prolongado, você pode abrir a cesta e criar comida e água suficientes para alimentar até cinco criaturas médias ou pequenas (ou uma criatura grande) durante 24h.",
	},
	reagentes_alquimicos = {
		nome = "Reagentes Alquímicos",
		tipo = "reagentes",
		posicao = "mochila",
	},
}
