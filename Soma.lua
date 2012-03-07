local function n_dado_mais(dano)
	local n, dado, mais = dano:match"(%d+)d(%d+)%+(%d+)"
	if not dado then
		n, dado = dano:match"(%d+)d(%d+)"
		mais = 0
	end
	return n, dado, mais
end

local function soma_dado1(dn1, dn2, arma)
	local t1, t2 = tonumber(dn1), tonumber(dn2)
	if t1 and t2 then
		return dn1+dn2
	elseif t1 then
		local n2, d2, m2 = n_dado_mais(dn2)
		return n2..'d'..d2..'+'..(m2+dn1)
	elseif t2 then
		local n1, d1, m1 = n_dado_mais(dn1)
		return n1..'d'..d1..'+'..(m1+dn2)
	else
		local n1, d1, m1 = n_dado_mais(dn1)
		local n2, d2, m2 = n_dado_mais(dn2)
		assert(d1 == d2, "Nao sei somar danos com dados diferentes ("..d1.." x "..d2..") para a arma "..tostring(arma))
		return (n1+n2)..'d'..d1..(m1+m2)
	end
end

local function soma_dados(dados, dado)
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

local function soma_dado2(dn1, dn2, arma)
	local dados = { A = 0, max = 0, constante = 0, }
	if tonumber(dn1) then
		dados.constante = dn1
	else
		soma_dados(dados, dn1)
	end
	if tonumber(dn2) then
		dados.constante = dados.constante + dn2
	else
		soma_dados(dados, dn2)
	end
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

local soma_dado = soma_dado2

function soma_dano(self, valor, mais, arma)
	local ts = type(self)
	assert(ts == "table", "bad argument #1 (table expected, got "..ts..")")
	local tm = type(mais)
	if not mais then
		return valor
	elseif not valor then
		if tm == "function" then
			return mais(self, valor, arma)
		else
			return mais
		end
	else
		if tm == "function" then
			return mais(self, valor, arma)
		elseif tm == "number" then
			return soma_dado(valor, mais, arma)
		elseif tm == "string" then
			if mais:sub(1,1) == '+' then
				mais = mais:sub(2)
			end
				--return soma_dado(valor, mais:sub(2), arma)
			--else
				--return mais
				return soma_dado(valor, mais, arma)
			--end
		end
	end
end


function mult_dano (self, valor, mult, arma)
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

