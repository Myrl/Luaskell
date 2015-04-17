local helper = {}

function helper.id(x)
	return function() return x end
end

return helper