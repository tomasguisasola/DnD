local function n_dado_mais(dano)
	local n, dado, mais = dano:match"(%d+)d(%d+)%+(%d+)"
	if not dado then
		n, dado = dano:match"(%d+)d(%d+)"
		mais = 0
	end
	return n, dado, mais
end

local function soma_dados(dados, dado)
	if tonumber(dado) then
		dados.constante = dados.constante + dado
	else
		local a = dado:match"(%d+)%[A%]"
		if a then
			dados.A = dados.A + a
		end
		for n, d in dado:gmatch"(%d+)d(%d+)" do
			d = tonumber(d)
			dados[d] = (dados[d] or 0) + n
			dados.max = math.max(dados.max, d)
		end
		dados.constante = dados.constante + (dado:match"%+(%d+)$" or 0)
	end
end

local function soma_dado(dn1, dn2)
	local dados = { A = 0, max = 0, constante = 0, }
	soma_dados(dados, dn1)
	soma_dados(dados, dn2)
	-- Gera o resultado
	local r = ""
	if dados.A > 0 then
		r = dados.A.."[A]+"
	end
	for dado = 1, dados.max do
		local n = dados[dado]
		if n then
			r = r..n.."d"..dado.."+"
		end
	end
	if dados.constante ~= 0 then
		r = r..dados.constante
	else
		r = r:sub(1, -2) -- remove o '+' que ficou no final
	end
	if r == "" then
		r = 0
	end
	return r
end

local function soma_dano(self, valor, mais, arma)
	valor = valor or 0
	mais = mais or 0
	local ts = type(self)
	assert(ts == "table", "bad argument #1 (table expected, got "..ts..")")
	local tm, tv = type(mais), type(valor)
	if tm == "function" then
		return mais(self, valor, arma)
	elseif tv == "function" then
		return valor(self, mais, arma)
	else
		return soma_dado(valor, mais, arma)
	end
end


local function mult_dano (self, valor, mult, arma)
	local ts = type(self)
	assert(ts == "table", "bad argument #1 (table expected, got "..ts..")")
	local tv = assert (type(valor), "bad argument #2 (value expected, got nil)")
	local tm = assert (type(mult), "bad argument #3 (multiplier expected, got nil)")
	local n = assert (mult:match"^(%d*)%[A%]", "mal-formed argument #3 (expected '?[A]')")
	if n == '' then
		n = 1
	end
	local c = mult:match"%+(%d+)$"
	local d = 0
	-- Multiplica
	for i = 1, n do
		d = soma_dano (self, d, valor, arma)
	end
	-- Soma
	return soma_dano (self, d, c, arma)
end

return {
	soma = soma_dano,
	mult = mult_dano,
	soma_dado = soma_dado,
}

