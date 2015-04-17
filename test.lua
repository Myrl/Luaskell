thunk = require "thunk"
helper = require "helper"

local table = table
function table.empty(t)
	return next(thunk.getValue(t)) == nil
end

function incFrom(x)
	local id = helper.id
	local makeThunk = thunk.makeThunk
	return makeThunk(id({makeThunk(id(x)), makeThunk(function () return incFrom(x + 1) end)}))
end

function head(l)
	return thunk.getValue(thunk.getValue(l)[1])
end

function tail(l)
	return thunk.getValue(thunk.getValue(l)[2])
end

function take(n, l)
	local id = helper.id
	local makeThunk = thunk.makeThunk
	if (n == 0 or thunk.getValue(l) == {}) then return makeThunk(id({})) end
	return makeThunk(id{makeThunk(id(head(l))), makeThunk(function () return take(n-1, tail(l)) end)})
end

function map(l, f)
	local t = l
	while (not table.empty(t)) do
		x = head(t)
		f(x)
		t = tail(t)
	end
end

x = incFrom(1)
print(map(take(100, x), print))