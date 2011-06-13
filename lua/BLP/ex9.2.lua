
function JoinPairs(A, B)
   local function Iter()
      local LenMin = math.min(#A, #B)
      for J = 1, LenMin do
	 coroutine.yield(A[J], B[J])
      end
   end

   return coroutine.wrap(Iter)
end

for Name, Number in JoinPairs({"Sally", "Mary", "James", "Phillip"}, {12, 32, 7, 12}) do
   print(Name, Number)
end
