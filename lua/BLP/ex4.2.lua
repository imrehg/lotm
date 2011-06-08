function mixcompare(x, y)
   --[[--
   Comparison function for mixed types.
   Order everything by type-name first, then within there order as

   string: as default
   number: as default
   table: by length
   boolean: false first
   function: by address
   --]]--
   local ret
   if (type(x) == type(y)) then
      if type(x) == "string" or type(x) == "number" then
	 ret = x < y
      elseif type(x) == "table" then
	 ret = #x < #y
      elseif type(x) == "boolean" then
	 ret = not(x) and y
      elseif type(x) == "function" then
	 ret = tostring(x) < tostring(y)
      end
   else
      ret = type(x) < type(y)
   end
   return ret
end

function mixsort(data)
   -- In place sorting. Since I have no clue how to do in place functions manually
   table.sort(data, mixcompare)
end

data = {1, "x", {}, {}, {}, "", "a", "b", "c", 1, 2, 3, -100, 1.1, function() end, function() end, true, true, false, false, true, function() return 10 end, function() end}
print("====== Original")
for i, val in ipairs(data) do
   print(val)
end
mixsort(data)
print()
print("====== Sorted")
for i, val in ipairs(data) do
   print(val)
end