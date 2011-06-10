function Protect(Tbl)
   local OrigTable = {}
   for Key, Val in pairs(Tbl) do
      OrigTable[Key] = Val
      Tbl[Key] = nil
   end

   local _Meta = {
      __newindex = function()
		      error("Bummer")
		   end,
      __index = OrigTable,
      __metatable = true  -- I think it works without this line as well...
   }
   return setmetatable(Tbl, _Meta)
end

Tbl = {"Hello", "Not!"}
Protect(Tbl)
print(Tbl[1])
Tbl[2] = "Goodbye"
print(Tbl[2])