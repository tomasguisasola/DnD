#!/usr/local/bin/iuplua51
require"iuplua"

-- Tabela de dados da interface
gui = {}

--------------------------------------------------------------------------------
-- Redefinições

local function fillinbetween(box)
	local expand = box.fillexpand
	box.fillexpand = nil
	local rastersize = box.fillrastersize
	box.fillrastersize = nil
	local size = box.fillsize
	box.fillsize = nil

	for i = 1, #box+1 do
		-- Insere um novo elemento na posição 2i-1 e desloca os outros para o fim
		table.insert(box, (2*i - 1), iup.fill{
			expand = expand,
			rastersize = rastersize,
			size = size,
		})
	end
	return box
end

local function default_text_action (self, c, novo_valor)
	gui.alterado = true
	if self._action then
		return self._action(self, c, novo_valor)
	end
end
local iup_text = iup.text
function iup.text(self)
	self._action = self.action
	self.action = default_text_action
	return iup_text(self)
end

function iup.fvbox(box)
	return iup.vbox(fillinbetween(box))
end

function iup.fhbox(box)
	return iup.hbox(fillinbetween(box))
end

--------------------------------------------------------------------------------
-- Carrega dados

arquivo = ...
if arquivo and io.open(arquivo) then
	dados = assert(loadfile(arquivo))()
end
if not dados then
	dados = {}
end

--------------------------------------------------------------------------------
-- Dados

gui.Nome = iup.text{
	value = dados.Nome,
}

gui.ModForca = iup.label{ title = "", size = "20", }
gui.Forca = iup.text{
	value = dados.Forca,
	size = 20,
	valuechanged_cb = function(self)
		local val = tonumber(self.value) or 0
		local mod = math.floor(val/2) - 5
		if mod > 0 then
			mod = "+"..mod
		end
		gui.ModForca.title = mod
	end,
}
gui.Forca:valuechanged_cb()

--------------------------------------------------------------------------------
-- Persistência

variaveis = { "Nome", "Forca", }

function valor2arquivo(valor)
	local tv = type(valor)
	if tv == "string" then
		return string.format("%q", valor)
	elseif tv == "nil" then
		return "nil"
	end
end

function salva()
	if gui.alterado then
		local file = assert(io.open(arquivo, "w"))
		file:write("return {\n")
		for i = 1, #variaveis do
			local var = variaveis[i]
			file:write(var)
			file:write(" = ")
			file:write(valor2arquivo(gui[var].value))
			file:write(",\n")
		end
		file:write("}\n")
		file:close()
	end
end

--------------------------------------------------------------------------------
-- Interface

ficha = iup.dialog{
	title = arquivo,
	--size = "400x300",

	iup.vbox{
		iup.hbox{
			iup.fvbox{
				iup.label{ title = "Nome", alignment = "ARIGHT:ACENTER", },
				iup.label{ title = "Força", alignment = "ARIGHT:ACENTER", },
			},
			iup.fvbox{
				gui.Nome,
				iup.hbox{ gui.Forca, gui.ModForca, alignment="ACENTER", },
			},
		},
		iup.hbox{
			iup.fill{},
			iup.button{
				title = "Fechar",
				action = function(self)
					salva()
					return iup.CLOSE
				end,
			},
		},
	},

	close_cb = function(self)
		salva()
	end,
}
ficha:show()

iup.MainLoop()
