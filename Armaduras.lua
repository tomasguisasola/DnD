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
		nome = "Mágica +1",
		categoria = set("traje", "corselete", "gibao", "cota", "brunea", "placas"),
		ca = 1,
	},
	casca_de_arvore_5 = {
		nome = "Casca de Árvore +1",
		categoria = set("gibao", "brunea"),
		ca = 1,
		poder = {
			nome = "Armadura Casca de Árvore",
			uso = "Diário",
			acao = "mínima",
			origem = set("armadura"),
			efeito = "Recebe +2 de bônus de poder na CA até o FdE.\n    Sempre que um golpe atingir sua CA, reduza este bônus em 1 ponto até 0.",
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
			uso = "Diário",
			origem = set("armadura"),
			efeito = "Repita um teste de resistência com +2 bônus",
		},
	},
	do_sacrificio_5 = {
		nome = "do Sacrifício +1",
		categoria = set("cota", "brunea", "placas"),
		ca = 1,
		poder = {
			nome = "Armadura do Sacrifício",
			uso = "Diário",
			origem = set("armadura"),
			efeito = "Efeito: você gasta um PC (mínima) e um aliado a até 5 recupera PV\n    como se tivesse gasto um PC.",
		},
	},
	dos_mortos_5 = {
		nome = "dos Mortos +1",
		categoria = set("corselete", "gibao"),
		ca = 1,
		poder = {
			nome = "Armadura dos Mortos",
			uso = "Diário",
			origem = set("armadura"),
			gatilho = "O personagem é alvo de um poder de ataque corpo-a-corpo.",
			efeito = function (self)
				return "O inimigo que ativou o gatilho sofre 1d10+"..self.mod_car.." de dano necrótico."
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
			efeito = "O personagem bane a armadura para um local extradimensional seguro. Em qualquer\nmomento no futuro -- a menos que esteja usando outra armadura -- ele pode usar\noutra ação mínima para fazer com que a armadura retorne, aparecendo no corpo do personagem como se ele a tivesse vestido normalmente.",
		},
	},
	robe_da_contingencia_4 = {
		nome = "Robe da Contingência +1",
		categoria = set("traje"),
		preco = 840,
		ca = 1,
		poder = {
			nome = "Robe da Contingência",
			uso = "Diário",
			acao = "reação imediata",
			origem = set("cura", "teleporte"),
			gatilho = "Estar sangrando e ser atingido por um ataque",
			efeito = "Efeito: você se teleporta 6 quadrados e pode gastar um PC.",
		},
	},
	sanguinea_4 = {
		nome = "Sanguínea +1",
		categoria = set("corselete", "gibao"),
		preco = 840,
		ca = 1,
		poder = {
			nome = "Armadura Sanguínea",
			uso = "Diário",
			acao = "minima",
			origem = set("armadura"),
			condicao = "O personagem precisa estar sangrando.",
			efeito = "Adquire resitência 10 contra todos os tipos de dano até o FdPT.",
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
			uso = "Diário",
			acao = "interrupção imediata",
			origem = set("armadura"),
			gatilho = "O personagem é alvo de um poder de ataque CaC.",
			efeito = "O inimigo realiza o ataque contra outra criatura a escolha do personagem.",
		},
	},
}
