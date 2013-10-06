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
------- Caracter�sticas de Classe ----------------------------------------------
		lider_de_combate = {
			nome = "L�der de Combate",
			uso = "SL",
			acao = "nenhuma",
			origem = set("marcial"),
			tipo_ataque = nil,
			alvo = "aliados a at� 10 quadrados",
			efeito = "Efeito: aliados a at� 10 quadrados recebem +2 na iniciativa.",
		},
		palavra_de_inspiracao = {
			nome = "Palavra de Inspira��o",
			uso = "En",
			acao = "m�nima",
			origem = set("cura", "marcial"),
			tipo_ataque = "explos�o cont�gua 5",
			alvo = "voc� ou um aliado na explos�o",
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
			nome = "Presen�a Imponente",
			uso = "SL",
			acao = "nenhuma",
			origem = set("marcial"),
			tipo_ataque = "linha de vis�o",
			alvo = "aliado na linha de vis�o",
			efeito = function (self)
				local c = self.caracteristica_classe:lower()
				local meio_nivel = math.floor(self.nivel/2)
				if c:match"destemida" then -- PM
					return "Efeito: quando aliado na linha de vis�o gasta um PdA, pode escolher o benef�cio:\n    se acertar ataque, pode realizar outro AtB ou a��o de movimento (livre);\n    se errar, concede VdC a todos os inimigos at� o FdPT."
				elseif c:match"engenhosa" then -- PM
					return "Efeito: quando aliado na linha de vis�o gasta um PdA, recebe +"..(meio_nivel + self.mod_int).." no dano;\n    se fracassar, recebe "..(meio_nivel + self.mod_car).." PVT."
				elseif c:match"inspiradora" then -- LJ1
					return "Efeito: quando aliado na linha de vis�o gasta um PdA, recupera +"..(meio_nivel + self.mod_car).." PV perdidos."
				elseif c:match"t.tica" then -- LJ1
					return "Efeito: quando aliado na linha de vis�o gasta um PdA, recebe +"..math.floor(self.mod_int/2).." no ataque."
				else
					warn"Sem caracter�stica de classe definida"
				end
			end,
		},
	},
	poderes = {
------- Poderes Sem Limite n�vel 1 ---------------------------------------------
		assalto_precipitado = {
			nome = "Assalto Precipitado",
			uso = "SL",
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dobra_21("1[A]", "forca", "Assalto Precipitado"),
			efeito = "Efeito: alvo pode realizar um AtB CaC contra voc� (livre) com VdC.\n    Se o fizer, aliado a at� 5 pode realizar AtB contra o alvo (livre) com VdC.",
		},
		encontrao_inicial = {
			nome = "Encontr�o Inicial",
			uso = "SL",
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "Ref",
			dano = nil,
			efeito = function(self)
				return "Efeito: alvo � empurrado 1 quadrado e um aliado na linha de vis�o ajusta "..self.mod_int.."\n    OU realiza um AtB CaC contra o alvo."
			end,
		},
		golpe_da_vibora = {
			nome = "Golpe da V�bora",
			uso = "SL",
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dobra_21("[A]", "forca", "Golpe da V�bora"),
			efeito = "Efeito: se o alvo ajustar antes do CdPT, provoca AdO a um aliado � sua escolha.",
		},
		golpe_de_comandante = {
			nome = "Golpe de Comandante",
			uso = "SL",
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = function(self)
				return 0, "um aliado realiza um ataque b�sico corpo-a-corpo contra o alvo."
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
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "Fort",
			dano = mod.forca,
			efeito = function(self)
				local bonus = self.mod_car
				return "Sucesso: um aliado adjacente a voc� ou ao alvo tem +"..self.mod_car.." no ataque e no dano\n    no pr�ximo ataque contra o alvo at� o FdPT."
			end,
		},
		taticas_de_alcateia = {
			nome = "T�ticas de Alcat�ia",
			uso = "SL",
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dobra_21("[A]", "forca", "T�ticas de Alcat�ia"),
			efeito = "Efeito: antes de atacar, um aliado adjacente a voc� ou ao alvo pode ajustar\n    1 quadrado com uma a��o livre.",
		},
------- Poderes por Encontro n�vel 1 -------------------------------------------
		amparo_do_senhor_da_guerra = {
			nome = "Amparo do Senhor da Guerra",
			uso = "En",
			acao = "padr�o",
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
				return "Sucesso: um aliado a at� 5 recebe +"..bonus.." nos ataques contra o alvo at� o FdPT."
			end,
		},
		ataque_acolhedor = {
			nome = "Ataque Acolhedor",
			uso = "En",
			acao = "padr�o",
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
				return "Sucesso: at� o FdPT, um aliado adjacente a voc� ou ao alvo recebe +"..bonus.." na CA contra ataques do alvo."
			end,
		},
		finta_lepida = {
			nome = "Finta L�pida",
			uso = "En",
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "forca", "Finta L�pida"),
			efeito = "Sucesso: voc� ajusta 1 quadrado e um aliado a at� 2 (de onde voc� ficou) ajusta\n    1 quadrado usando uma a��o livre.",
		},
		foco_enganador = {
			nome = "Foco Enganador",
			uso = "En",
			acao = "padr�o",
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
				return "Sucesso: outro inimigo a at� 5 � puxado "..quadrados.." quadrados."
			end,
		},
		folha_ao_vento = {
			nome = "Folha ao Vento",
			uso = "En",
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "forca", "Folha ao Vento"),
			efeito = "Sucesso: voc� ou um aliado troca de lugar com o alvo.",
		},
		formacao_de_martelo = {
			nome = "Forma��o de Martelo",
			uso = "En",
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "dist�ncia",
			condicao = "Empunhar uma arma pesada de arremesso",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("1[A]", "forca", "Forma��o de Martelo"),
			efeito = function (self)
				local posicionamento = "adjacentes"
				if self.caracteristica_classe:match"[Ee]ngenhosa" then
					posicionamento = "a at� "..self.mod_car
				end
				return "Sucesso: aliados "..posicionamento.." causam 1[A] adicional no pr�ximo ataque at� o CdPT."
			end,
		},
		formacao_mirmidone = {
			nome = "Forma��o Mirm�done",
			uso = "En",
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			condicao = "Empunhar um escudo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "forca", "Forma��o Mirm�done"),
			efeito = "Efeito: no CdPT, aliados adjacentes recebem 5 PVT.",
		},
		martelo_e_bigorna = {
			nome = "Martelo e Bigorna",
			uso = "En",
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "Ref",
			dano = mod.dado_mod("1[A]", "forca", "Martelo e Bigorna"),
			efeito = function (self)
				return "Sucesso: um aliado adjacente ao alvo realiza um At.B�sico contra o alvo (livre)\n    com +"..self.mod_car.." de dano."
			end,
		},
------- Poderes Di�rios n�vel 1 ------------------------------------------------
		assalto_calculado = {
			nome = "Assalto Calculado",
			uso = "Di",
			acao = "padr�o",
			origem = set("arma", "confi�vel", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("1[A]", "forca", "Assalto Calculado"),
			efeito = function (self)
				return "Sucesso: um aliado a at� 5 recebe +"..(1 + self.mod_int).." nos ataques contra o alvo at� o final do encontro.\n    Usando uma a��o m�nima, voc� pode transferir o b�nus a outro aliado a at� 5 do primeiro."
			end,
		},
		ataque_concentrado = {
			nome = "Ataque Concentrado",
			uso = "Di",
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "forca", "Ataque Concentrado"),
			efeito = function (self)
				return "Efeito: um aliado a at� 10 pode realizar um At.B�sico contra o alvo (livre)\n    com +"..self.mod_int.." de b�nus no ataque e no dano."
			end,
		},
		baluarte_da_defesa = {
			nome = "Baluarte da Defesa",
			uso = "Di",
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("3[A]", "forca", "Baluarte da Defesa"),
			efeito = function (self)
				return "Sucesso: aliados a at� 5 recebem +1 em todas as defesas at� o final do encontro.\nEfeito:  aliados a at� 5 recebem "..(5 + self.mod_car).." PVT."
			end,
		},
		cingir_o_adversario = {
			nome = "Cingir o Advers�rio",
			uso = "Di",
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("3[A]", "forca", "Cingir o Advers�rio"),
			efeito = "At� o final do encontro, o alvo n�o pode ajustar se houver pelo menos 2 aliados\n(ou voc� e um aliado) adjacentes a ele.",
		},
		liderar_o_ataque = {
			nome = "Liderar o Ataque",
			uso = "Di",
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("3[A]", "forca", "Liderar o Ataque"),
			efeito = function (self)
				return "Sucesso: at� o FdPT, voc� e seus aliados a at� 5 recebem +"..(1 + self.mod_int).." nos ataques contra o alvo.\nFracasso: at� o FdPT, voc� e seus aliados a at� 5 recebem +1 nos ataques contra\no alvo."
			end,
		},
		liderar_pelo_exemplo = {
			nome = "Liderar pelo Exemplo",
			uso = "Di",
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "forca", "Liderar pelo Exemplo"),
			efeito = "Efeito: voc� ajusta 1 quadrado antes do ataque.\nSucesso: aliados obt�m VdC contra o alvo at� o CdPT.\nFracasso: dois aliados a at� 5 podem ajustar 1 quadrado e realizar um ABCaC\ncontra o alvo usando uma a��o livre.",
		},
		massacre_do_corvo_branco = {
			nome = "Massacre do Corvo Branco",
			uso = "Di",
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("3[A]", "forca", "Massacre do Corvo Branco"),
			efeito = "Sucesso: um aliado adjacente � conduzido 1 quadrado.  At� o final do encontro,\nsempre que voc� ou um aliado a at� 10 acertar um ataque, um aliado adjacente ao\natacante � conduzido 1 quadrado.\nFracasso: escolha um aliado a at� 10; sempre que ele acertar um ataque, um\naliado adjacente � conduzido 1 quadrado.",
		},
		reagate_audaz = {
			nome = "Resgate Audaz",
			uso = "Di",
			acao = "rea��o imediata",
			origem = set("arma", "cura", "marcial"),
			tipo_ataque = "corpo",
			gatilho = "um inimigo a at� 5 reduz um aliado a 0 PV",
			alvo = "o inimigo que ativou o gatilho",
			ataque = function (self)
				return 1 + self.mod_forca
			end,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "forca", "Resgate Audaz"),
			efeito = "Efeito: antes do ataque, voc� pode se mover para o quadrado mais pr�ximo de\nonde possa atacar o alvo.\n    O aliado gasta um PC e recupera 1d6 PV adicionais para cada AdO que voc�\n    sofreu ao se mover.",
		},
------- Poderes Utilit�rios n�vel 2 --------------------------------------------
		auxiliar_os_feridos = {
			nome = "Auxiliar os Feridos",
			uso = "En",
			acao = "padr�o",
			origem = set("cura", "marcial"),
			tipo_ataque = "corpo",
			alvo = "voc� ou um aliado adjacente",
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
			tipo_ataque = "dist�ncia 10",
			alvo = "um aliado",
			--ataque = nil,
			--defesa = nil,
			--dano = nil,
			efeito = "O alvo realiza uma a��o de movimento usando uma a��o livre.",
		},
		retomada = {
			nome = "Retomada",
			uso = "En",
			acao = "m�nima",
			origem = set("marcial"),
			tipo_ataque = "dist�ncia 10",
			alvo = "voc� ou um aliado",
			--ataque = nil,
			--defesa = nil,
			--dano = nil,
			efeito = function (self)
				return "O alvo realiza um teste de resist�ncia com +"..self.mod_car.." de b�nus."
			end,
		},
		violencia_crescente = {
			nome = "Viol�ncia Crescente",
			uso = "En",
			acao = "rea��o imediata",
			origem = set("marcial"),
			tipo_ataque = "dist�ncia 5",
			alvo = "um aliado obt�m um Suc.Dec.",
			--ataque = nil,
			--defesa = nil,
			--dano = nil,
			efeito = function (self)
				return "O alvo recebe "..self.mod_car.." PVT."
			end,
		},
------- Poderes por Encontro n�vel 3 -------------------------------------------
		golpe_do_senhor_da_guerra = {
			nome = "Golpe do Senhor da Guerra",
			uso = "En",
			acao = "padr�o",
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
				return "Sucesso: at� o FdPT, seus aliados recebem +"..bonus.." no dano contra o alvo."
			end,
		},
		grito_de_guerra_inspirador = {
			nome = "Grito de Guerra Inspirador",
			uso = "En",
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "forca", "Grito de Guerra Inspirador"),
			efeito = "Efeito: um aliado a at� 5 e que possa ouv�-lo realiza um teste de resist�ncia.",
		},
		linha_de_frente = {
			nome = "Linha de Frente",
			uso = "En",
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("1[A]", "forca", "Linha de Frente"),
			efeito = "Efeito: at� o FdPT, seus aliados adjacentes recebem +2 na CA e n�o podem ser\n    puxados, empurrados nem conduzidos.",
		},
		moncao_de_aco = {
			nome = "Mon��o de A�o",
			uso = "En",
			acao = "padr�o",
			origem = set("arma", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("2[A]", "forca", "Mon��o de A�o"),
			efeito = function (self)
				local naliados = 1
				if self.caracteristica_classe:match"[Tt].-tica" then
					naliados = self.mod_int
				end
				return "Sucesso: "..naliados.." aliado(s) a at� 5 podem ajustar 1 quadrado."
			end,
		},
------- Poderes Di�rios n�vel 5 ------------------------------------------------
		levantar_os_caidos = {
			nome = "Levantar os Ca�dos",
			uso = "Di",
			acao = "padr�o",
			origem = set("arma", "cura", "marcial"),
			tipo_ataque = "corpo",
			alvo = "uma criatura",
			ataque = mod.forca,
			defesa = "CA",
			dano = mod.dado_mod("3[A]", "forca", "Mon��o de A�o"),
			efeito = function (self)
				return "Efeito: os aliados a at� 10 quadrados podem gastar um PC e recuperar +"..self.mod_car.." PV."
			end,
		},
------- Poderes Utilit�rios n�vel 6 --------------------------------------------
		palavras_instigantes = { -- PM
			nome = "Palavras Instigantes",
			uso = "En",
			acao = "m�nima",
			origem = set("cura", "marcial"),
			tipo_ataque = "explos�o cont�gua 5",
			alvo = "voc� e um aliado",
			efeito = function (self)
				local bonus = ''
				if self.caracteristica_classe:match"[Ii]nspiradora" then
					bonus = " e recebem + "..self.mod_car.." PV"
				end
				return "Efeito: voc� e um aliado a at� 5 podem gastar 2 PC"..bonus.."."
			end,
		},
	},
}
