local set = require"DnD.Set"
local soma_dano = require"DnD.Soma".soma
local armas = require"DnD.Armas"
local tipos_armas = require"DnD.TiposArmas"
local mod = require"DnD.Modificadores"

return {
	nome = "Monge",
	fonte_de_poder = "psionico",
	ca = 2,
	fortitude = 1,
	reflexos = 1,
	vontade = 1,
	armaduras = set("traje"),
	armas = set("clava", "adaga", "bordao", "shuriken", "funda", "lanca"),
	pv = 12,
	pv_nivel = 5,
	pc_dia = 7,
	implementos = {
		ki_focus = true,
		-- armas que tiver proficiencia
	},
	pericias = {
		acrobacia = true,
		atletismo = true,
		diplomacia = true,
		furtividade = true,
		ladinagem = true,
		intuicao = true,
		percepcao = true,
		religiao = true,
		socorro = true,
		tolerancia = true,
	},
	total_pericias = 4,
	caracteristicas_classe = {},
	poderes = {
	},
}
