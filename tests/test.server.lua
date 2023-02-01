local Narrator = require(script.Parent.Packages.Narrator)

function Test1(Proceed, Trove)

    Proceed(1, 2, 3)

    return function()
    
        print("Proceed to Test2")
        
    end

end

function Test2(Proceed, Trove, ...)

    print("Test2 started")
    print(...)

    return function()
        
        print("Ended")

    end
    
end

Narrator.Narrate({Test1, Test2})