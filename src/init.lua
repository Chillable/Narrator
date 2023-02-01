local Signal = require(script.Parent.Signal)
local t = require(script.Parent.t)

local Trove = require(script.Parent.Trove).new()

local Acts 

local ActStarted = Signal.new()
local ActEnded = Signal.new()

local currentIndex: number
local currentAct

local onEndCallback

function Proceed(...)

    currentAct:End()

    ActEnded:Fire(currentAct)

    Trove:Clean()

    if currentIndex == #Acts then
        
        return if typeof(onEndCallback) == "function" then onEndCallback() else nil 

    end

    local nextAct = Acts[currentIndex + 1]

    currentIndex += 1
    currentAct = nextAct

    ActStarted:Fire(currentAct)
    
    nextAct:Start(Proceed, Trove, ...)

end

function SkipTo(index: number, ...)

    currentAct:End()

    ActEnded:Fire(currentAct)

    Trove:Clean()

    if currentIndex == #Acts then
        
        return if typeof(onEndCallback) == "function" then onEndCallback() else nil 

    end

    local nextAct = Acts[index]

    currentIndex = index
    currentAct = nextAct

    ActStarted:Fire(currentAct)
    
    nextAct:Start(Proceed, Trove, ...)

end

function WaitForAct(name: string)
    
    t.strict(t.string)(name)

    repeat
        
        task.wait()

    until currentAct.Name == name

end

function Narrate(acts: table, onEnd: (any?))
    
    t.strict(t.table)(acts)
    t.strict(t.optional(t.callback))(onEnd)

    for i, act in pairs(acts) do
    
        t.strictInterface({

            Name = t.string,

            Start = t.callback,
            End = t.callback,

        })(act)

    end
    
    local act = acts[1]

    Acts = acts

    currentIndex = 1
    currentAct = act

    onEndCallback = onEnd

    act:Start(Proceed, Trove)

end

return {

    Narrate = Narrate,
    WaitForAct = WaitForAct,

    ActStarted = ActStarted,
    ActEnded = ActEnded

}