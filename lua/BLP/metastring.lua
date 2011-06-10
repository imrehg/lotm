function StrMul(Str, rep)
   assert(type(rep) == "number", "Needs to have number!")
   local out = ""
   for i = 1, rep do
      out = out .. Str
   end
   return out
end


name = "Greg"
debug.setmetatable(name, { __mul = StrMul })
print(name*10)
