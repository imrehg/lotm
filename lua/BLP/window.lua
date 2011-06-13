local Window, Lcl = {}, {}

-- Queue of posted window events
Lcl.MsgQueue = {}

-- Window structure
-- Parent: window object of parent
-- Id: string identifier, e.g. 1.2.5 for 5th child of 2nd child of window 1
-- Co: coroutine(Fnc) blocks until terminating event
-- ChildCount: number of active children
-- ChildSerial: used for naming new children
-- ChildList: associative array keyed by child window objects
-- Close: assigned the terminating message (usually “cancel” or “ok”)
-- User: table passed to handler to hold data that must persist from event to event

-- List of windows by id
Lcl.WindowList = {}

-- Currently active window
Lcl.WindowActive = nil

-- Message to indicate need to unblock
Lcl.MsgReturn = "\000"

-- Display all active windows
function Lcl.Show()
   local List = {}
   for Id, Wnd in pairs(Lcl.WindowList) do
      table.insert(List, Wnd.Close and (Id .. " (pending closure)") or Id)
   end
   table.sort(List)
   for J, Id in ipairs(List) do
      io.write(Id, "\n")
   end
end

-- Close window
function Lcl.Destroy(Wnd)
   if Wnd.Close and Wnd.ChildCount == 0 then
      io.write("Unblocking window ", Wnd.Id, "\n")
      table.insert(Lcl.MsgQueue, {Wnd, Lcl.MsgReturn})
   end
end

-- Help text
function Lcl.Help()
   io.write("Type 'show' to see all active windows\n")
   io.write("Type 'window_id msg' to send message to window\n")
   io.write("Standard messages are 'new', 'ok', 'cancel'\n")
end

function Lcl.EventGet()
   local Wnd, Msg
   if Lcl.MsgQueue[1] then
      local Rec = table.remove(Lcl.MsgQueue, 1)
      Wnd, Msg = Rec[1], Rec[2]
   else -- Wait for an event
      while not Msg do
	 io.write("Cmd> ")
	 local Str = io.read()
	 Str = string.gsub(Str, "^ *(.-) *$", "%1") -- removing spaces from both sides
	 Str = string.lower(Str)
	 if Str == "help" or Str == "?" then
	    Lcl.Help()
	 elseif Str == "show" then
	    Lcl.Show()
	 else
	    local IdStr, MsgStr = string.match(Str, "(%S+)%s+(%S+)") -- splitting data
	    if IdStr then
	       Wnd = Lcl.WindowList[IdStr]
	       if Wnd then
		  if not Wnd.Close then
		     Msg = MsgStr
		  else
		     io.write("Window ", IdStr, " is inactive\n")
		  end
	       else
		  io.write("Unknown window ", IdStr, "\n")
	       end
	    else
	       io.write("Expecting 'help', '?', 'show', or 'window_id message'\n")
	    end
	 end
      end
   end
   return Wnd, Msg
end

-- Main loop
function Lcl.EventLoop()
   local Wnd, Msg
   local Loop = true
   while Loop do
      Wnd, Msg = Lcl.EventGet()
      if Wnd then
	 Lcl.WindowActive = Wnd
	 if Msg == Lcl.MsgReturn then
	    if Wnd.Co then
	       coroutine.resume(Wnd.Co, Wnd.Close)
	    else
	       Loop = false
	       Msg = Wnd.Close
	    end
	 else
	    local Co = coroutine.create(Wnd.Fnc)
	    coroutine.resume(Co, Wnd.User, Msg)
	 end
      end
   end
   return Msg
end

function Window.Show(Fnc)
   local Parent = Lcl.WindowActive
   local Msg, Id
   if Parent then
      Parent.ChildSerial = Parent.ChildSerial + 1
      Id = Parent.Id .. "." .. Parent.ChildSerial
   else
      Lcl.Help()
      Id = "1"
   end
   local Co = coroutine.running()
   local Wnd = {Parent = Parent, Co = Co, Id = Id, Fnc = Fnc,
		ChildCount = 0, ChildSerial = 0, ChildList = {}, User = {Id = Id}}
   io.write("Creating window ", Wnd.Id, "\n")
   table.insert(Lcl.MsgQueue, {Wnd, "create"})
   Lcl.WindowList[Id] = Wnd
   if Parent then
      assert(Co)
      Parent.ChildList[Wnd] = true
      Parent.ChildCount = Parent.ChildCount + 1
      Msg = coroutine.yield() -- Resume here when window and all childs are destroyed
      Parent.ChildCount = Parent.ChildCount - 1
      Parent.ChildList[Wnd] = nil
      Lcl.Destroy(Parent)
   else
      assert(not Co)
      Msg = Lcl.EventLoop()
   end
   Lcl.WindowList[Id] = nil
   return Msg
end

function Window.Close(Msg)
   local Wnd = Lcl.WindowActive
   Wnd.Close = Msg or "destroy"
   Lcl.Destroy(Wnd)
end

return Window