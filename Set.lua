return function (...)
	local set = {}
	for i = 1, select("#", ...) do
		set[select(i, ...)] = true
	end
	return set
end

