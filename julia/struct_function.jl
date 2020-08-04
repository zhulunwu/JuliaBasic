struct UNet
    block
end

function UNet()
    block=println
    UNet(block)
end

function (u::UNet)(x)
    u.block(x)
    u.block(string(x,"world"))
end

model=UNet(println)