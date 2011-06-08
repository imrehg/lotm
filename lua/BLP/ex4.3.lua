function Sprint(...)
   local Args = {...}
   local ArgCount = select("#", ...)
   local ret = ""
   for i = 1, ArgCount do
      if i > 1 then
	 ret = ret .. "\t"
      end
      ret = ret .. tostring(Args[i])
   end
   return ret
end

out = Sprint(nil, "Hi", nil, {}, nil)
print(out)
