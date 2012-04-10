local set = require"DnD.Set"

return {
	"traje", "corselete", "gibao", "cota", "brunea", "placas",
	traje = {
		tipo = "leve",
		bonus = 0,
	},
	corselete = {
		tipo = "leve",
		bonus = 2,
	},
	gibao = {
		tipo = "leve",
		bonus = 3,
		penalidade = -1,
	},
	cota = {
		tipo = "pesada",
		bonus = 6,
		penalidade = -1,
		deslocamento = -1,
	},
	brunea = {
		tipo = "pesada",
		bonus = 7,
		deslocamento = -1,
	},
	placas = {
		tipo = "pesada",
		bonus = 8,
		penalidade = -2,
		deslocamento = -1,
	},

	magica_1 = {
		nome = "M�gica +1",
		categoria = set("traje", "corselete", "gibao", "cota", "brunea", "placas"),
		ca = 1,
	},
	casca_de_arvore_5 = {
		nome = "Casca de �rvore +1",
		categoria = set("gibao", "brunea"),
		ca = 1,
		poder = {
			nome = "Armadura Casca de �rvore",
			uso = "Di�rio",
			acao = "m�nima",
			origem = set("armadura"),
			efeito = "Recebe +2 de b�nus de poder na CA at� o FdE.\n    Sempre que um golpe atingir sua CA, reduza este b�nus em 1 ponto at� 0.",
		},
	},
	silvestre_1 = {
		nome = "Silvestre +1",
		categoria = set("traje", "corselete", "gibao"),
		ca = 1,
		atletismo = 1,
		furtividade = 1,
	},
	do_explorador_1 = {
		nome = "do Explorador +1",
		categoria = set("traje", "corselete", "gibao", "cota", "brunea", "placas"),
		ca = 1,
		resistencia = 2, -- poder diario
		poder = {
			nome = "Armadura do Explorador",
			uso = "Di�rio",
			origem = set("armadura"),
			efeito = "Repita um teste de resist�ncia com +2 b�nus",
		},
	},
	do_sacrificio_5 = {
		nome = "do Sacrif�cio +1",
		categoria = set("cota", "brunea", "placas"),
		ca = 1,
		poder = {
			nome = "Armadura do Sacrif�cio",
			uso = "Di�rio",
			origem = set("armadura"),
			efeito = "Efeito: voc� gasta um PC (m�nima) e um aliado a at� 5 recupera PV\n    como se tivesse gasto um PC.",
		},
	},
	dos_mortos_5 = {
		nome = "dos Mortos +1",
		categoria = set("corselete", "gibao"),
		ca = 1,
		poder = {
			nome = "Armadura dos Mortos",
			uso = "Di�rio",
			origem = set("armadura"),
			gatilho = "O personagem � alvo de um poder de ataque corpo-a-corpo.",
			efeito = function (self)
				return "O inimigo que ativou o gatilho sofre 1d10+"..self.mod_car.." de dano necr�tico."
			end,
		},
	},
	invocada_6 = {
		nome = "Invocada +2",
		categoria = set("traje", "corselete", "gibao", "cota", "brunea", "placas"),
		ca = 2,
		poder = {
			nome = "Armadura Invocada",
			uso = "Sem Limite",
			origem = set("armadura"),
			efeito = "O personagem bane a armadura para um local extradimensional seguro. Em qualquer\nmomento no futuro -- a menos que esteja usando outra armadura -- ele pode usar\noutra a��o m�nima para fazer com que a armadura retorne, aparecendo no corpo do personagem como se ele a tivesse vestido normalmente.",
		},
	},
	robe_da_contingencia_4 = {
		nome = "Robe da Conting�ncia +1",
		categoria = set("traje"),
		preco = 840,
		ca = 1,
		poder = {
			nome = "Robe da Conting�ncia",
			uso = "Di�rio",
			acao = "rea��o imediata",
			origem = set("cura", "teleporte"),
			gatilho = "Estar sangrando e ser atingido por um ataque",
			efeito = "Efeito: voc� se teleporta 6 quadrados e pode gastar um PC.",
		},
	},
	sanguinea_4 = {
		nome = "Sangu�nea +1",
		categoria = set("corselete", "gibao"),
		preco = 840,
		ca = 1,
		poder = {
			nome = "Armadura Sangu�nea",
			uso = "Di�rio",
			acao = "minima",
			origem = set("armadura"),
			condicao = "O personagem precisa estar sangrando.",
			efeito = "Adquire resit�ncia 10 contra todos os tipos de dano at� o FdPT.",
		},
	},
	skald_3 = {
		nome = "de Skald +1",
		categoria = set("corselete", "cota"),
		ca = 1,
		blefe = 2,
		diplomacia = 2,
		poder = {
			nome = "Armadura de Skald",
			uso = "Di�rio",
			acao = "interrup��o imediata",
			origem = set("armadura"),
			gatilho = "O personagem � alvo de um poder de ataque CaC.",
			efeito = "O inimigo realiza o ataque contra outra criatura a escolha do personagem.",
		},
	},
}
