local set = require"DnD.Set"
local soma_dano = require"DnD.Soma".soma
local armas = require"DnD.Armas"
local tipos_armas = require"DnD.TiposArmas"
local mod = require"DnD.Modificadores"

return {
	nome = "Senhor da Guerra",
	fonte_de_poder = "marcial",
	fortitude = 1,
	vontade = 1,
	armaduras = set("traje", "corselete", "gibao", "cota", "leve", "pesado"),
	armas = tipos_armas("corpo simples", "corpo militar", "distancia simples"),
	implementos = {},
	iniciativa = 2,
	pv = 12,
	pv_nivel = 5,
	pc_dia = 7,
	pericias = set("atletismo", "diplomacia", "historia", "intimidacao", "socorro", "tolerancia"),
	total_pericias = 4,
	caracteristicas_classe = {
------- Características de Classe ----------------------------------------------
		lider_de_combate = {
			nome = "Líder de Combate",
			uso = "SL",
			acao = "nenhuma",
			origem = set("marcial"),
			tipo_ataque = nil,
			alvo = "aliados a até 10 quadrados",
			efeito = "Efeito: aliados a até 10 quadrados recebem +2 na iniciativa.",
		},
		palavra_de_inspiracao = {
			nome = "Palavra de Inspiração",
			uso = "En",
			acao = "mínima",
			origem = set("cura", "marcial"),
			tipo_ataque = "explosão contígua 5",
			alvo = "você ou um aliado na explosão",
			efeito = function(self)
				local dados_adicionais = math.floor(self.nivel/5)+1
				local pv_adicionais = ''
				if self.palavra_de_inspiracao_adicional then
					pv_adicionais = "+"..self.palavra_de_inspiracao_adicional
				end
				return "Efeito: alvo pode gastar um PC e recupera "..dados_adicionais.."d6"..pv_adicionais.." PV"
			end,
		},
		presenca_imponente = {
			nome = "Presença Imponente",
			uso = "SL",
			acao = "nenhuma",
			origem = set("marcial"),
			tipo_ataque = "linha de visão",
			alvo = "aliado na linha de visão",
			efeito = function (self)
				local c = self.caracteristica_classe:lower()
				local meio_nivel = math.floor(self.nivel/2)
				if c:match"destemida" then -- PM
					return "Efeito: quando aliado na linha de visão gasta um PdA, pode escolher o benefício:\n    se acertar ataque, pode realizar outro AtB ou ação de movimento (livre);\n    se errar, concede VdC a todos os inimigos até o FdPT."
				elseif c:match"engenhosa" then -- PM
					return "Efeito: quando aliado na linha de visão gasta um PdA, recebe +"..(meio_nivel + self.mod_int).." no dano;\n    se fracassar, recebe "..(meio_nivel + self.mod_car).." PVT."
				elseif c:match"inspiradora" then -- LJ1
					return "Efeito: quando aliado na linha de visão gasta um PdA, recupera +"..(meio_nivel + self.mod_car).." PV perdidos."
				elseif c:match"t.tica" then -- LJ1
					return "Efeito: quando aliado na linha de visão gasta um PdA, recebe +"..math.floor(self.mod_int/2).." no ataque."
				else
					warn"Sem característica de classe definida"
				end
			end,
		},
	},
	poderes = {
------- Poderes Sem Limite nível 1 ---------------------------------------------
		assalto_precipitado = {
			nome = "Assalto Precipitado",
			uso = "SL",
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dobra_21("1[A]", "forca", "Assalto Precipitado"),
			efeito = "Efeito: alvo pode realizar um AtB CaC contra você (livre) com VdC.\n    Se o fizer, aliado a até 5 pode realizar AtB contra o alvo (livre) com VdC.",
		},
		encontrao_inicial = {
			nome = "Encontrão Inicial",
			uso = "SL",
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "Ref",
			dano = nil,
			efeito = function(self)
				return "Efeito: alvo é empurrado 1 quadrado e um aliado na linha de visão ajusta "..self.mod_int.."\n    OU realiza um AtB CaC contra o alvo."
			end,
		},
		golpe_da_vibora = {
			nome = "Golpe da Víbora",
			uso = "SL",
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dobra_21("[A]", "forca", "Golpe da Víbora"),
			efeito = "Efeito: se o alvo ajustar antes do CdPT, provoca AdO a um aliado à sua escolha.",
		},
		golpe_de_comandante = {
			nome = "Golpe de Comandante",
			uso = "SL",
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = function(self)
				return 0, "um aliado realiza um ataque básico corpo-a-corpo contra o alvo."
			end,
			dano = function(self)
				return 0, "dano do aliado +"..self.mod_int
			end,
			efeito = function (self)
				return "Efeito: aliado realiza um AtB CaC contra o alvo com +"..self.mod_int.." no dano."
			end,
		},
		pancada_furiosa = {
			nome = "Pancada Furiosa",
			uso = "SL",
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "Fort",
			dano = mod.forca,
			efeito = function(self)
				local bonus = self.mod_car
				return "Sucesso: um aliado adjacente a você ou ao alvo tem +"..self.mod_car.." no ataque e no dano\n    no próximo ataque contra o alvo até o FdPT."
			end,
		},
		taticas_de_alcateia = {
			nome = "Táticas de Alcatéia",
			uso = "SL",
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dobra_21("[A]", "forca", "Táticas de Alcatéia"),
			efeito = "Efeito: antes de atacar, um aliado adjacente a você ou ao alvo pode ajustar\n    1 quadrado com uma ação livre.",
		},
------- Poderes por Encontro nível 1 -------------------------------------------
		amparo_do_senhor_da_guerra = {
			nome = "Amparo do Senhor da Guerra",
			uso = "En",
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "forca", "Amparo do Senhor da Guerra"),
			efeito = function (self)
				local bonus = 2
				if self.caracteristica_classe:match"[Tt].-tica" then
					bonus = 1 + self.mod_int
				end
				return "Sucesso: um aliado a até 5 recebe +"..bonus.." nos ataques contra o alvo até o FdPT."
			end,
		},
		ataque_acolhedor = {
			nome = "Ataque Acolhedor",
			uso = "En",
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "forca", "Ataque Acolhedor"),
			efeito = function (self)
				local bonus = 2
				if self.caracteristica_classe:match"[Ii]nspiradora" then
					bonus = 1 + self.mod_car
				end
				return "Sucesso: até o FdPT, um aliado adjacente a você ou ao alvo recebe +"..bonus.." na CA contra ataques do alvo."
			end,
		},
		finta_lepida = {
			nome = "Finta Lépida",
			uso = "En",
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "forca", "Finta Lépida"),
			efeito = "Sucesso: você ajusta 1 quadrado e um aliado a até 2 (de onde você ficou) ajusta\n    1 quadrado usando uma ação livre.",
		},
		foco_enganador = {
			nome = "Foco Enganador",
			uso = "En",
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "Fort",
			dano = mod.dado_mod("1[A]", "forca", "Foco Enganador"),
			efeito = function (self)
				local quadrados = 1
				if self.caracteristica_classe:match"[Dd]estemida" then
					quadrados = self.mod_car
				end
				return "Sucesso: outro inimigo a até 5 é puxado "..quadrados.." quadrados."
			end,
		},
		folha_ao_vento = {
			nome = "Folha ao Vento",
			uso = "En",
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "forca", "Folha ao Vento"),
			efeito = "Sucesso: você ou um aliado troca de lugar com o alvo.",
		},
		formacao_de_martelo = {
			nome = "Formação de Martelo",
			uso = "En",
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "distância",
			condicao = "Empunhar uma arma pesada de arremesso",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("1[A]", "forca", "Formação de Martelo"),
			efeito = function (self)
				local posicionamento = "adjacentes"
				if self.caracteristica_classe:match"[Ee]ngenhosa" then
					posicionamento = "a até "..self.mod_car
				end
				return "Sucesso: aliados "..posicionamento.." causam 1[A] adicional no próximo ataque até o CdPT."
			end,
		},
		formacao_mirmidone = {
			nome = "Formação Mirmídone",
			uso = "En",
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			condicao = "Empunhar um escudo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "forca", "Formação Mirmídone"),
			efeito = "Efeito: no CdPT, aliados adjacentes recebem 5 PVT.",
		},
		martelo_e_bigorna = {
			nome = "Martelo e Bigorna",
			uso = "En",
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "Ref",
			dano = mod.dado_mod("1[A]", "forca", "Martelo e Bigorna"),
			efeito = function (self)
				return "Sucesso: um aliado adjacente ao alvo realiza um At.Básico contra o alvo (livre)\n    com +"..self.mod_car.." de dano."
			end,
		},
------- Poderes Diários nível 1 ------------------------------------------------
		assalto_calculado = {
			nome = "Assalto Calculado",
			uso = "Di",
			acao = "padrão",
			origem = set("arma", "confiável", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("1[A]", "forca", "Assalto Calculado"),
			efeito = function (self)
				return "Sucesso: um aliado a até 5 recebe +"..(1 + self.mod_int).." nos ataques contra o alvo até o final do encontro.\n    Usando uma ação mínima, você pode transferir o bônus a outro aliado a até 5 do primeiro."
			end,
		},
		ataque_concentrado = {
			nome = "Ataque Concentrado",
			uso = "Di",
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "forca", "Ataque Concentrado"),
			efeito = function (self)
				return "Efeito: um aliado a até 10 pode realizar um At.Básico contra o alvo (livre)\n    com +"..self.mod_int.." de bônus no ataque e no dano."
			end,
		},
		baluarte_da_defesa = {
			nome = "Baluarte da Defesa",
			uso = "Di",
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("3[A]", "forca", "Baluarte da Defesa"),
			efeito = function (self)
				return "Sucesso: aliados a até 5 recebem +1 em todas as defesas até o final do encontro.\nEfeito:  aliados a até 5 recebem "..(5 + self.mod_car).." PVT."
			end,
		},
		cingir_o_adversario = {
			nome = "Cingir o Adversário",
			uso = "Di",
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("3[A]", "forca", "Cingir o Adversário"),
			efeito = "Até o final do encontro, o alvo não pode ajustar se houver pelo menos 2 aliados\n(ou você e um aliado) adjacentes a ele.",
		},
		liderar_o_ataque = {
			nome = "Liderar o Ataque",
			uso = "Di",
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("3[A]", "forca", "Liderar o Ataque"),
			efeito = function (self)
				return "Sucesso: até o FdPT, você e seus aliados a até 5 recebem +"..(1 + self.mod_int).." nos ataques contra o alvo.\nFracasso: até o FdPT, você e seus aliados a até 5 recebem +1 nos ataques contra\no alvo."
			end,
		},
		liderar_pelo_exemplo = {
			nome = "Liderar pelo Exemplo",
			uso = "Di",
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "forca", "Liderar pelo Exemplo"),
			efeito = "Efeito: você ajusta 1 quadrado antes do ataque.\nSucesso: aliados obtém VdC contra o alvo até o CdPT.\nFracasso: dois aliados a até 5 podem ajustar 1 quadrado e realizar um ABCaC\ncontra o alvo usando uma ação livre.",
		},
		massacre_do_corvo_branco = {
			nome = "Massacre do Corvo Branco",
			uso = "Di",
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("3[A]", "forca", "Massacre do Corvo Branco"),
			efeito = "Sucesso: um aliado adjacente é conduzido 1 quadrado.  Até o final do encontro,\nsempre que você ou um aliado a até 10 acertar um ataque, um aliado adjacente ao\natacante é conduzido 1 quadrado.\nFracasso: escolha um aliado a até 10; sempre que ele acertar um ataque, um\naliado adjacente é conduzido 1 quadrado.",
		},
		reagate_audaz = {
			nome = "Resgate Audaz",
			uso = "Di",
			acao = "reação imediata",
			origem = set("arma", "cura", "marcial"),
			tipo_ataque = "corpo",
			gatilho = "um inimigo a até 5 reduz um aliado a 0 PV",
			alvo = "o inimigo que ativou o gatilho",
			ataque = function (self)
				return 1 + self.mod_forca
			end,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "forca", "Resgate Audaz"),
			efeito = "Efeito: antes do ataque, você pode se mover para o quadrado mais próximo de\nonde possa atacar o alvo.\n    O aliado gasta um PC e recupera 1d6 PV adicionais para cada AdO que você\n    sofreu ao se mover.",
		},
------- Poderes Utilitários nível 2 --------------------------------------------
		auxiliar_os_feridos = {
			nome = "Auxiliar os Feridos",
			uso = "En",
			acao = "padrão",
			origem = set("cura", "marcial"),
			tipo_ataque = "corpo",
			alvo = "você ou um aliado adjacente",
			--ataque = nil,
			--defesa = nil,
			--dano = nil,
			efeito = "O alvo pode gastar um PC.",
		},
		deslocamento_do_cavaleiro = {
			nome = "Deslocamento do Cavaleiro",
			uso = "En",
			acao = "movimento",
			origem = set("marcial"),
			tipo_ataque = "distância 10",
			alvo = "um aliado",
			--ataque = nil,
			--defesa = nil,
			--dano = nil,
			efeito = "O alvo realiza uma ação de movimento usando uma ação livre.",
		},
		retomada = {
			nome = "Retomada",
			uso = "En",
			acao = "mínima",
			origem = set("marcial"),
			tipo_ataque = "distância 10",
			alvo = "você ou um aliado",
			--ataque = nil,
			--defesa = nil,
			--dano = nil,
			efeito = function (self)
				return "O alvo realiza um teste de resistência com +"..self.mod_car.." de bônus."
			end,
		},
		violencia_crescente = {
			nome = "Violência Crescente",
			uso = "En",
			acao = "reação imediata",
			origem = set("marcial"),
			tipo_ataque = "distância 5",
			alvo = "um aliado obtém um Suc.Dec.",
			--ataque = nil,
			--defesa = nil,
			--dano = nil,
			efeito = function (self)
				return "O alvo recebe "..self.mod_car.." PVT."
			end,
		},
------- Poderes por Encontro nível 3 -------------------------------------------
		golpe_do_senhor_da_guerra = {
			nome = "Golpe do Senhor da Guerra",
			uso = "En",
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "forca", "Golpe do Senhor da Guerra"),
			efeito = function (self)
				local bonus = 2
				if self.caracteristica_classe:match"[Ii]nspiradora" then
					bonus = 1 + self.mod_car
				end
				return "Sucesso: até o FdPT, seus aliados recebem +"..bonus.." no dano contra o alvo."
			end,
		},
		grito_de_guerra_inspirador = {
			nome = "Grito de Guerra Inspirador",
			uso = "En",
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "forca", "Grito de Guerra Inspirador"),
			efeito = "Efeito: um aliado a até 5 e que possa ouví-lo realiza um teste de resistência.",
		},
		linha_de_frente = {
			nome = "Linha de Frente",
			uso = "En",
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("1[A]", "forca", "Linha de Frente"),
			efeito = "Efeito: até o FdPT, seus aliados adjacentes recebem +2 na CA e não podem ser\n    puxados, empurrados nem conduzidos.",
		},
		moncao_de_aco = {
			nome = "Monção de Aço",
			uso = "En",
			acao = "padrão",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "forca", "Monção de Aço"),
			efeito = function (self)
				local naliados = 1
				if self.caracteristica_classe:match"[Tt].-tica" then
					naliados = self.mod_int
				end
				return "Sucesso: "..naliados.." aliado(s) a até 5 podem ajustar 1 quadrado."
			end,
		},
------- Poderes Diários nível 5 ------------------------------------------------
		levantar_os_caidos = {
			nome = "Levantar os Caídos",
			uso = "Di",
			acao = "padrão",
			origem = set("arma", "cura", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("3[A]", "forca", "Monção de Aço"),
			efeito = function (self)
				return "Efeito: os aliados a até 10 quadrados podem gastar um PC e recuperar +"..self.mod_car.." PV."
			end,
		},
------- Poderes Utilitários nível 6 --------------------------------------------
		palavras_instigantes = { -- PM
			nome = "Palavras Instigantes",
			uso = "En",
			acao = "mínima",
			origem = set("cura", "marcial"),
			tipo_ataque = "explosão contígua 5",
			alvo = "você e um aliado",
			efeito = function (self)
				local bonus = ''
				if self.caracteristica_classe:match"[Ii]nspiradora" then
					bonus = " e recebem + "..self.mod_car.." PV"
				end
				return "Efeito: você e um aliado a até 5 podem gastar 2 PC"..bonus.."."
			end,
		},
	},
}
