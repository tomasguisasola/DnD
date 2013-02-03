local soma_dano = require"DnD.Soma".soma
local armas = require"DnD.Armas"
local classes = require"DnD.Classes"

local implemento_basico = require"DnD.Implemento_Basico"

local function amuleto (amuleto, bonus)
	amuleto.tipo = "amuleto"
	amuleto.posicao = "pesco�o"
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
		nome = "Amuleto da Prote��o",
		preco = 360,
	}, 1),
	amuleto_da_protecao_6 = amuleto ({
		nome = "Amuleto da Prote��o",
		preco = 1800,
	}, 2),
	amuleto_da_saude_3 = amuleto ({
		nome = "Amuleto da Sa�de",
		preco = 680,
	}, 1),
	amuleto_da_determinacao_fisica_2 = amuleto ({
		nome = "Amuleto da Determina��o F�sica",
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
		nome = "Bast�o Solar",
		tipo = "bastao",
		posicao = "mochila",
		preco = 2,
	},
	botas_da_furtividade_3 = {
		nome = "Botas da Furtividade",
		tipo = "bota",
		posicao = "p�s",
		preco = 680,
		furtividade = 2,
	},
	bracadeira_do_alivio_2 = {
		nome = "Bra�adeira do Al�vio",
		tipo = "bracadeira",
		posicao = "bra�o",
		preco = 520,
		poder = {
			nome = "Bra�adeira do Al�vio",
			uso = "Di�rio",
			origem = {},
			acao = "livre",
			efeito = "Efeito: quando um aliado adjacente recupera PV, voc� ou outro aliado recupera\n    1d8 PV.",
		},
	},
	bracadeira_do_golpe_poderoso_2 = {
		nome = "Bra�adeira do Golpe Poderoso",
		tipo = "bracadeira",
		posicao = "bra�o",
		dano = function(self, dano, arma)
			local esse_poder = classes[self.classe].poderes[arma]
			--if armas[arma].tipo:match"^corpo" then
			if esse_poder and esse_poder.tipo_ataque:match"corpo" and esse_poder.tipo_ataque:match"basico" then
				return soma_dano(self, dano, 2, "Bra�adeira do Golpe Poderoso")
			else
				return dano
			end
		end,
	},
	bracadeira_dos_golpes_estrategicos_6 = {
		nome = "Bra�adeira dos Golpes Estrat�gicos",
		tipo = "bracadeira",
		posicao = "bra�o",
		preco = 1800,
		propriedade = "Propriedade: causa +1d6 nos AdO.",
	},
	bracadeira_do_poder_mental_6 = {
		nome = "Bra�adeira do Poder Mental",
		tipo = "bracadeira",
		posicao = "bra�o",
		preco = 1800,
		poder = {
			nome = "Bra�adeira do Poder Mental",
			uso = "Encontro",
			origem = {},
			acao = "livre",
			efeito = "Efeito: quando for realizar um ataque baseado na For�a, um teste de For�a ou um\n    teste de per�cia baseado em For�a, use outro modificador dentre\n    Intelig�ncia, Sabedoria ou Carisma no lugar daquele.",
		},
	},
	bracadeira_do_tiro_perfeito_3 = {
		nome = "Bra�adeira do Tiro Perfeito",
		tipo = "bracadeira",
		posicao = "bra�o",
		dano = function(self, dano, arma)
			basico = arma:match"basico"
			if arma:match"%+" then
				arma = arma:match"^(.-)%+"
			end
			local essa_arma = armas[arma]
			local esse_poder = classes[self.classe].poderes[arma]
			if esse_poder and esse_poder.tipo_ataque:match"distancia"
				and esse_poder.tipo_ataque:match"basico" then
				return soma_dano(self, dano, 2, "Bra�adeira do Tiro Perfeito")
			elseif basico and essa_arma and essa_arma.tipo:match"distancia" then
				return soma_dano(self, dano, 2, "Bra�adeira do Tiro Perfeito")
			else
				return dano
			end
		end,
	},
	broche_do_curandeiro_4 = {
		nome = "Broche do Curandeiro",
		tipo = "broche",
		posicao = "pesco�o",
		fortitude = 1,
		reflexos = 1,
		vontade = 1,
		pv_recuperado = 1, -- Ainda n�o funciona!!!!!!!!!!!!!!!!!
	},
	cinto_da_resistencia_1 = {
		nome = "Cinto da Resist�ncia", -- AA 140
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
		posicao = "cabe�a",
		preco = 840,
		at_oportunidade = 1,
	},
	escudo_leve = escudo_leve{
		nome = "Escudo Leve",
		tipo = "escudo",
		posicao = "bra�o",
		preco = 5,
	},
	escudo_leve_da_protecao_3 = escudo_leve{
		nome = "Escudo Leve da Prote��o",
		tipo = "escudo",
		posicao = "bra�o",
		preco = 680,
		poder = {
			nome = "Escudo Leve da Prote��o",
			uso = "Di�rio",
			origem = {},
			acao = "padr�o",
			efeito = "Efeito: voc� e um aliado adjacente adquirem resist�ncia 10 contra todos os tipos\n    de dano at� o FdPT.",
		},
	},
	escudo_pesado_da_protecao_3 = escudo_pesado{
		nome = "Escudo Pesado da Prote��o",
		tipo = "escudo",
		posicao = "bra�o",
		preco = 680,
		poder = {
			nome = "Escudo Pesado da Prote��o",
			uso = "Di�rio",
			origem = {},
			acao = "padr�o",
			efeito = "Efeito: voc� e um aliado adjacente adquirem resist�ncia 10 contra todos os tipos\n    de dano at� o FdPT.",
		},
	},
	escudo_leve_flutuante = escudo_leve{
		nome = "Escudo Leve Flutuante",
		tipo = "escudo",
		posicao = "bra�o",
		preco = 360,
		efeito = "O personagem n�o afunda em superf�cies l�quidas",
	},
	escudo_leve_draconico_2 = escudo_leve{
		nome = "Escudo Leve Drac�nico",
		tipo = "escudo",
		posicao = "bra�o",
		preco = 680,
		ca = 1,
		reflexos = 1,
	},
	escudo_leve_de_arremesso_6 = escudo_leve{
		nome = "Escudo Leve de Arremesso",
		tipo = "escudo",
		posicao = "bra�o",
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
		posicao = "bra�o",
		preco = 10,
	},
	escudo_de_platina_9 = escudo_leve{
		nome = "Escudo Leve de Platina",
		tipo = "escudo",
		posicao = "bra�o",
		preco = 4200,
		--simbolo_sagrado = 1,
		ataque = implemento_basico("simbolo_sagrado", 1),
		dano = implemento_basico("simbolo_sagrado", 1),
		decisivo = implemento_basico("simbolo_sagrado", "+1d8"),
		propriedade = "Este escudo pode ser usado como s�mbolo sagrado.",
		poder = {
			nome = "Escudo de Platina",
			uso = "En",
			origem = {},
			efeito = "Efeito: quando pelo menos 2 aliados (ou o pr�prio) estiverem sangrando, o personagem e seus aliados adjacentes recebem +1 na CA e os membros que estiverem sangrando recebem +1 em Vontade.",
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
			efeito = "Efeito: cria zona (explos�o cont�gua 5) +1 no dano.",
		},
	},
	estatueta_do_cao_de_onix_4 = {
		nome = "Estatueta do C�o de �nix",
		tipo = "estatueta",
		posicao = "mochila",
		preco = 840,
	},
	ferramentas_de_ladrao = {
		nome = "Ferramentas de Ladr�o",
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
		nome = "Gema do Di�logo",
		tipo = "gema",
		posicao = "cabe�a",
		blefe = 1,
		diplomacia = 1,
	},
	grimorio = {
		nome = "Grim�rio",
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
		nome = "Kit do Aventureiro padr�o",
		tipo = "ferramenta",
		posicao = "mochila",
		preco = 15,
	},
	luvas_do_gatuno = {
		nome = "Luvas do Gatuno",
		tipo = "luvas",
		posicao = "m�os",
		preco = 360,
		ladinagem = 1,
	},
	manto_da_distorcao_4 = {
		nome = "Manto da Distor��o",
		tipo = "manto",
		posicao = "pesco�o",
		fortitude = 1,
		reflexos = 1,
		vontade = 1,
		efeito = "Recebe +1 em todas as defesas contra AaD realizados a mais de 5 quadrados.",
	},
	manto_da_rainha_de_rapina = {
		nome = "Manto da Rainha de Rapina",
		tipo = "manto",
		posicao = "pesco�o",
		fortitude = 2,
		reflexos = 2,
		vontade = 2,
		percepcao = 2,
		furtividade = 2,
	},
	manto_elfico_7 = { -- LJ1 253
		nome = "Manto Elfico",
		tipo = "manto",
		posicao = "pesco�o",
		fortitude = 2,
		reflexos = 2,
		vontade = 2,
		furtividade = 2,
	},
	mochila_de_carga_5 = { -- LJ1 254
		nome = "Mochila de Carga",
		tipo = "maravilhoso",
		posicao = "costas",
		efeito = "Permite armazenar at� 100kg ou meio metro c�bico de volume, mas sempre pesa meio quilo.  Retirar um item de dentro exige uma a��o m�nima.",
	},
	oculos_dos_olhos_de_aguia_2 = { -- AA 136
		nome = "�culos dos Olhos de �guia",
		tipo = "oculos",
		posicao = "cabe�a",
		efeito = "Ganha +1 nos ataques b�sicos � dist�ncia."
	},
	pocao_de_cura = {
		nome = "Po��o de Cura",
		tipo = "po��o",
		posicao = "mochila",
		preco = 50,
	},
	provisoes_infinitas_4 = { -- LJ1 254
		nome = "Provis�es Infinitas",
		tipo = "maravilhoso",
		posicao = "mochila",
		efeito = "Ap�s um descanso prolongado, voc� pode abrir a cesta e criar comida e �gua suficientes para alimentar at� cinco criaturas m�dias ou pequenas (ou uma criatura grande) durante 24h.",
	},
	reagentes_alquimicos = {
		nome = "Reagentes Alqu�micos",
		tipo = "reagentes",
		posicao = "mochila",
	},
}
