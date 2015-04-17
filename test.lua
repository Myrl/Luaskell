thunk = require "thunk"
helper = require "helper"

local table = table
function table.empty(t)
	return next(t) == nil
end

function incFrom(x, d)
	d = d or 1
	local id = helper.id
	local makeThunk = thunk.makeThunk
	return makeThunk(id({makeThunk(id(x)), makeThunk(function () return incFrom(x + d, d) end)}))
end

function takeWhile(f, l)
	local id = helper.id
	local makeThunk = thunk.makeThunk
	if ((not f(head(l))) or table.empty(thunk.getValue(l))) then return makeThunk(id({})) end
	return makeThunk(id({makeThunk(id(head(l))), makeThunk(function() return takeWhile(f, tail(l)) end)}))
end

function incFromTo(x, y, d)
	y = y or math.huge
	d = d or 1

	return takeWhile(function (z) return z <= y end, incFrom(x, d))
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
	local id = helper.id
	local makeThunk = thunk.makeThunk
	if table.empty(thunk.getValue(l)) then return end
	return makeThunk(id({makeThunk(function () return f(head(l)) end), makeThunk(function () return map(tail(l), f) end)}))
end

function map_(l, f)
	if table.empty(thunk.getValue(l)) then return end
	f(head(l))
	return map_(tail(l), f)
end

function rep(x)
	local id = helper.id
	local makeThunk = thunk.makeThunk
	return makeThunk(id({makeThunk(id(x)), makeThunk(function () return rep(x) end)}))
end

map_(map(incFrom(1), function (x) return x*2 end), print)
