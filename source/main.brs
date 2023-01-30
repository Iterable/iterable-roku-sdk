function Main(args as Dynamic)
    m.screen = CreateObject("roSGScreen")
    m.port = CreateObject("roMessagePort")
    m.screen.setMessagePort(m.port)

    m.scene = m.screen.CreateScene("MainScene")
    m.scene.id = "MainScene"

    m.screen.show()
    m.scene.observeField("outRequest", m.port)

    while(true)
        msg = wait(0, m.port)
        msgType = type(msg)

        if msgType = "roSGScreenEvent"
            if msg.isScreenClosed()
                exit while
            end if
        else if msgType = "roSGNodeEvent"
            print "Main : showSGScreen : Message Type : " msgType
            print "Main : showSGScreen : Message Field : " msg.GetField()
            ' When The AppManager want to send command back to Main
            if (msg.GetField() = "outRequest")
                request = msg.GetData()
                print "Main : showSGScreen : Request : " request
                if (request <> invalid)
                    if (request.DoesExist("ExitApp") AND (request.ExitApp = true))
                        print "Main : showSGScreen : Closing Screen."
                        m.screen.close()
                    end if
                end if
            end if
        end if
    end while
end function
