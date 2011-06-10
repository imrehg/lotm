function Unm(A)
   local ret = {}
   local LenA = #A
   for i = 1, LenA do
      ret[LenA - i + 1] = A[i]
   end
   return ret
end

Meta = { __unm = Unm }

Arr = setmetatable({"one", "two", "three"}, Meta)
for I, Val in ipairs(-Arr) do print(I, Val) end
