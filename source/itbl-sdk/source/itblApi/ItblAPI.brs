function ItblAPI()
    gThis = GetGlobalAA()
    if gThis.ItblAPI = invalid
        gThis.ItblAPI = ItblAPI__New()
    end if
    return gThis.ItblAPI
end function

function ItblAPI__New()
    this = {}
    this.ItblGetMessage = ItblAPI__ItblGetMessage
    this.ItblTrack = ItblAPI__ItblTrack
    this.ItblTrackInAppDelivery = ItblAPI__ItblTrackInAppDelivery
    this.ItblTrackInAppOpen = ItblAPI__ItblTrackInAppOpen
    this.ItblTrackInAppClick = ItblAPI__ItblTrackInAppClick
    this.ItblTrackInAppClose = ItblAPI__ItblTrackInAppClose
    this.ItblInAppConsume = ItblAPI__ItblInAppConsume
    this.ItblUpdateUser = ItblAPI__ItblUpdateUser
    return this
end function

function ItblAPI__ItblGetMessage(hostUrl, apiKey, body)
    path = hostUrl + "/api/inApp/getMessages"
    headers = {
        "Accept": "application/json",
        "API-KEY": apiKey,
        "Content-Type": "application/json",
    }
    data = {}
    if body <> invalid then data = body
    response = getRequest(path, data, headers)
    if (response.isSuccess)
        return ok(ParseJSON(response.response))
    else
        return error(getErrorReason(response))
    end if

    return response
end function

function ItblAPI__ItblTrack(hostUrl, apiKey, body)
    path = hostUrl + "/api/events/track"
    headers = {
        "Accept": "application/json",
        "API-KEY": apiKey,
        "Content-Type": "application/json",
    }
    data = {}
    if body <> invalid then data = body

    response = postRequest(path, data, headers)
    if (response.isSuccess)
        return ok(ParseJSON(response.response))
    else
        return error(getErrorReason(response))
    end if

    return response
end function

function ItblAPI__ItblTrackInAppDelivery(hostUrl, apiKey, body)
    path = hostUrl + "/api/events/trackInAppDelivery"
    headers = {
        "Accept": "application/json",
        "API-KEY": apiKey,
        "Content-Type": "application/json",
    }
    data = {}
    if body <> invalid then data = body

    response = postRequest(path, data, headers)
    if (response.isSuccess)
        return ok(ParseJSON(response.response))
    else
        return error(getErrorReason(response))
    end if

    return response
end function

function ItblAPI__ItblTrackInAppOpen(hostUrl, apiKey, body)
    path = hostUrl + "/api/events/trackInAppOpen"
    headers = {
        "Accept": "application/json",
        "API-KEY": apiKey,
        "Content-Type": "application/json",
    }
    data = {}
    if body <> invalid then data = body

    response = postRequest(path, data, headers)
    if (response.isSuccess)
        return ok(ParseJSON(response.response))
    else
        return error(getErrorReason(response))
    end if

    return response
end function

function ItblAPI__ItblTrackInAppClick(hostUrl, apiKey, body)
    path = hostUrl + "/api/events/trackInAppClick"
    headers = {
        "Accept": "application/json",
        "API-KEY": apiKey,
        "Content-Type": "application/json",
    }
    data = {}
    if body <> invalid then data = body

    response = postRequest(path, data, headers)
    if (response.isSuccess)
        return ok(ParseJSON(response.response))
    else
        return error(getErrorReason(response))
    end if

    return response
end function

function ItblAPI__ItblTrackInAppClose(hostUrl, apiKey, body)
    path = hostUrl + "/api/events/trackInAppClose"
    headers = {
        "Accept": "application/json",
        "API-KEY": apiKey,
        "Content-Type": "application/json",
    }
    data = {}
    if body <> invalid then data = body

    response = postRequest(path, data, headers)
    if (response.isSuccess)
        return ok(ParseJSON(response.response))
    else
        return error(getErrorReason(response))
    end if

    return response
end function

function ItblAPI__ItblInAppConsume(hostUrl, apiKey, body)
    path = hostUrl + "/api/events/inAppConsume"
    headers = {
        "Accept": "application/json",
        "API-KEY": apiKey,
        "Content-Type": "application/json",
    }
    data = {}
    if body <> invalid then data = body

    response = postRequest(path, data, headers)
    if (response.isSuccess)
        return ok(ParseJSON(response.response))
    else
        return error(getErrorReason(response))
    end if

    return response
end function

function ItblAPI__ItblUpdateUser(hostUrl, apiKey, body)
    path = hostUrl + "/api/users/update"
    headers = {
        "Accept": "application/json",
        "API-KEY": apiKey,
        "Content-Type": "application/json",
    }
    data = {}
    if body <> invalid then data = body
    response = postRequest(path, data, headers)
    if (response.isSuccess)
        return ok(ParseJSON(response.response))
    else
        return error(getErrorReason(response))
    end if

    return response
end function
