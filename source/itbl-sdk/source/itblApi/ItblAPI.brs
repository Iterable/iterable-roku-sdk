function ItblAPI()
    gThis = GetGlobalAA()
    if gThis.ItblAPI = invalid
        gThis.ItblAPI = ItblAPI__New()
    end if
    return gThis.ItblAPI
end function

function ItblAPI__New()
    this = {}
    this.ItblGetPriorityMessage = ItblAPI__ItblGetPriorityMessage
    this.ItblTrack = ItblAPI__ItblTrack
    this.ItblTrackInAppDelivery = ItblAPI__ItblTrackInAppDelivery
    this.ItblTrackInAppOpen = ItblAPI__ItblTrackInAppOpen
    this.ItblTrackInAppClick = ItblAPI__ItblTrackInAppClick
    this.ItblTrackInAppClose = ItblAPI__ItblTrackInAppClose
    this.ItblInAppConsume = ItblAPI__ItblInAppConsume
    this.ItblUpdateUser = ItblAPI__ItblUpdateUser
    return this
end function

function ItblAPI__ItblGetPriorityMessage(hostUrl, apiKey, body, token)
    path = hostUrl + "/api/inApp/getPriorityMessage"
    headers = getHeaders(apiKey, token)
    data = {}
    if body <> invalid then data = body
    response = getRequest(path, data, headers)
    if (response.isSuccess)
        return ok(ParseJSON(response.response))
    else
        return error(response.code, getErrorReason(response))
    end if

    return response
end function

function ItblAPI__ItblTrack(hostUrl, apiKey, body, token)
    path = hostUrl + "/api/events/track"
    headers = getHeaders(apiKey, token)
    data = {}
    if body <> invalid then data = body

    response = postRequest(path, data, headers)
    if (response.isSuccess)
        return ok(ParseJSON(response.response))
    else
        return error(response.code, getErrorReason(response))
    end if

    return response
end function

function ItblAPI__ItblTrackInAppDelivery(hostUrl, apiKey, body, token)
    path = hostUrl + "/api/events/trackInAppDelivery"
    headers = getHeaders(apiKey, token)
    data = {}
    if body <> invalid then data = body

    response = postRequest(path, data, headers)
    if (response.isSuccess)
        return ok(ParseJSON(response.response))
    else
        return error(response.code, getErrorReason(response))
    end if

    return response
end function

function ItblAPI__ItblTrackInAppOpen(hostUrl, apiKey, body, token)
    path = hostUrl + "/api/events/trackInAppOpen"
    headers = getHeaders(apiKey, token)
    data = {}
    if body <> invalid then data = body

    response = postRequest(path, data, headers)
    if (response.isSuccess)
        return ok(ParseJSON(response.response))
    else
        return error(response.code, getErrorReason(response))
    end if

    return response
end function

function ItblAPI__ItblTrackInAppClick(hostUrl, apiKey, body, token)
    path = hostUrl + "/api/events/trackInAppClick"
    headers = getHeaders(apiKey, token)
    data = {}
    if body <> invalid then data = body

    response = postRequest(path, data, headers)
    if (response.isSuccess)
        return ok(ParseJSON(response.response))
    else
        return error(response.code, getErrorReason(response))
    end if

    return response
end function

function ItblAPI__ItblTrackInAppClose(hostUrl, apiKey, body, token)
    path = hostUrl + "/api/events/trackInAppClose"
    headers = getHeaders(apiKey, token)
    data = {}
    if body <> invalid then data = body

    response = postRequest(path, data, headers)
    if (response.isSuccess)
        return ok(ParseJSON(response.response))
    else
        return error(response.code, getErrorReason(response))
    end if

    return response
end function

function ItblAPI__ItblInAppConsume(hostUrl, apiKey, body, token)
    path = hostUrl + "/api/events/inAppConsume"
    headers = getHeaders(apiKey, token)
    data = {}
    if body <> invalid then data = body

    response = postRequest(path, data, headers)
    if (response.isSuccess)
        return ok(ParseJSON(response.response))
    else
        return error(response.code, getErrorReason(response))
    end if

    return response
end function

function ItblAPI__ItblUpdateUser(hostUrl, apiKey, body, token)
    path = hostUrl + "/api/users/update"
    headers = getHeaders(apiKey, token)
    data = {}
    if body <> invalid then data = body
    response = postRequest(path, data, headers, 3)
    if (response.isSuccess)
        return ok(ParseJSON(response.response))
    else
        return error(response.code, getErrorReason(response))
    end if

    return response
end function


function getHeaders(apiKey, token) as object
    headers = {
        "Accept": "application/json",
        "API-KEY": apiKey,
        "Content-Type": "application/json",
    }
    if token <> invalid and token <> ""
        headers["Authorization"] = "Bearer "+token
    end if
    return headers
end function
