
function makeThunk(f)
	return {f = f}
end

function getValue(t)
	t.v = t.v or t.f()
	return t.v
end

t = makeThunk(function() return 1 end)
print(getValue(t))
