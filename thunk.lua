local thunks = {}

function thunks.makeThunk(f)
	return {f = f}
end

function thunks.getValue(t)
	t.v = t.v or t.f()
	return t.v
end

return thunks
