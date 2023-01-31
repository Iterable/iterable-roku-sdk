sub init()
end sub

function ItblGetMessage() as void
    response = ItblAPI().ItblGetMessage(m.top.hostUrl, m.top.apiKey, m.top.requestData)
    m.top.result = response
end function

function ItblTrack() as void
    response = ItblAPI().ItblTrack(m.top.hostUrl, m.top.apiKey, m.top.requestData)
    m.top.result = response
end function

function ItblTrackInAppDelivery() as void
    response = ItblAPI().ItblTrackInAppDelivery(m.top.hostUrl, m.top.apiKey, m.top.requestData)
    m.top.result = response
end function

function ItblTrackInAppOpen() as void
    response = ItblAPI().ItblTrackInAppOpen(m.top.hostUrl, m.top.apiKey, m.top.requestData)
    m.top.result = response
end function

function ItblTrackInAppClick() as void
    response = ItblAPI().ItblTrackInAppClick(m.top.hostUrl, m.top.apiKey, m.top.requestData)
    m.top.result = response
end function

function ItblTrackInAppClose() as void
    response = ItblAPI().ItblTrackInAppClose(m.top.hostUrl, m.top.apiKey, m.top.requestData)
    m.top.result = response
end function

function ItblInAppConsume() as void
    response = ItblAPI().ItblInAppConsume(m.top.hostUrl, m.top.apiKey, m.top.requestData)
    m.top.result = response
end function

function ItblUpdateUser() as void
    response = ItblAPI().ItblUpdateUser(m.top.hostUrl, m.top.apiKey, m.top.requestData)
    m.top.result = response
end function
