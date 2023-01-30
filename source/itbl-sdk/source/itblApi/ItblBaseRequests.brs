function getRequest(path as string, data as dynamic, headers as dynamic) as object
    req = createRoTransferInstance()
    port = CreateObject("roMessagePort")
    req.SetMessagePort(port)

    for each key in headers
        req.AddHeader(key, headers[key])
    end for

    compiledData = path
    delimeter = "?"

    for each key in data
        compiledData = compiledData + delimeter + key + "=" + req.Escape(data[key].ToStr())
        delimeter = "&"
    end for

    req.SetUrl(compiledData)
    print "BaseRequests : getRequest url : " compiledData

    started = req.AsyncGetToString()

    if (started)
        event = wait(40000, port)
        if type(event) = "roUrlEvent"
            code = event.GetResponseCode()
            if (isSuccess(code))
                successResponse = success(event.GetString())
                print "BaseRequests : postRequest : Success Response : " 'response
                return successResponse
            else
                if code < 0 then
                    print "*** BaseRequests : Get API Failed. Set cancel request *** "
                    req.asyncCancel()
                end if
                failureResponse = fail(code, event.GetFailureReason())
                ' print "*** BaseRequests : Get API Failed. *** Response : " failureResponse
                return failureResponse
            end if
        end if
    end if

    return fail(-1, "Timeout happen")
end function

function postRequest(path as string, data as dynamic, headers as dynamic) as object
    req = createRoTransferInstance()
    port = CreateObject("roMessagePort")
    req.SetMessagePort(port)
    req.RetainBodyOnError(true)
    req.SetUrl(path)
    print "BaseRequests : postRequest url : " path
    for each key in headers
        req.AddHeader(key, headers[key])
    end for

    started = req.AsyncPostFromString(FormatJson(data))
    if (started)
        event = wait(40000, port)
        if type(event) = "roUrlEvent"
            code = event.GetResponseCode()
            if (isSuccess(code))
                response = event.GetString()
                print "BaseRequests : postRequest : Success Response : " response
                successResponse = success(response)
                return successResponse
            else
                if code < 0 then
                    print "*** BaseRequests : Get API Failed. Set cancel request *** "
                    req.asyncCancel()
                end if
                failureResponse = fail(code, event.GetString())
                ' print "BaseRequests : postRequest : Fail Response : " failureResponse
                return failureResponse
            endif
        endif
    endif

    return fail(-1, "Timeout happen")
end function


function deleteRequest(path as string, data as dynamic, headers as dynamic) as object
    req = createRoTransferInstance()
    req.setRequest("DELETE")
    port = CreateObject("roMessagePort")
    req.SetMessagePort(port)

    for each key in headers
        req.AddHeader(key, headers[key])
    end for

    compiledData = path
    delimeter = "?"

    for each key in data
        compiledData = compiledData + delimeter + key + "=" + req.Escape(data[key].ToStr())
        delimeter = "&"
    end for

    req.SetUrl(compiledData)
    print "BaseRequests : deleteRequest url : " compiledData

    started = req.AsyncGetToString()

    if (started)
        event = wait(40000, port)
        if type(event) = "roUrlEvent"
            code = event.GetResponseCode()
            if (isSuccess(code))
                successResponse = success(event.GetString())
                ' print "BaseRequests : Success Response : " ' successResponse
                return successResponse
            else
                if code < 0 then
                    print "*** BaseRequests : Get API Failed. Set cancel request *** "
                    req.asyncCancel()
                end if
                failureResponse = fail(code, event.GetFailureReason())
                ' print "*** BaseRequests : Get API Failed. *** Response : " failureResponse
                return failureResponse
            end if
        end if
    end if

    return fail(-1, "Timeout happen")
end function

function createRoTransferInstance() as dynamic
    req = CreateObject("roUrlTransfer")
    req.EnablePeerVerification(false)
    req.EnableHostVerification(false)

    return req
end function

function isSuccess(code as integer) as boolean
    return code >= 200 and code < 300
end function

function success(body as string) as object
    result = {}
    result.isSuccess = true
    result.response = body
    return result
end function

function fail(code as integer, reason as string) as object
    result = {}
    result.isSuccess = false
    result.code = code
    result.reason = reason

    return result
end function


function ok(data as dynamic) as object
    result = {}
    result.ok = true
    result.data = data

    return result
end function

function error(data as string) as object
    result = {}
    result.ok = false
    result.error = data

    return result
end function

function getErrorReason(response as dynamic) as string
    unknown = "Unknown error. Please check your input, internet connection and try again"
    print "HelpFuncs : getErrorReason : ResponseError : " response
    if (response.reason.Len() = 0 )
        return unknown
    else
        if (response.code = 422 or response.code = 403 or response.code = 404)
            data = ParseJSON(response.reason)
						if data = invalid 'If, this is not json
								return response.reason
						end if

						msg = ""
						if data.message <> invalid
								msg = data.message
						else if data.detail <> invalid
								msg = data.detail
						end if

            return msg
        else
            return response.reason
        end if
    end if
end function
