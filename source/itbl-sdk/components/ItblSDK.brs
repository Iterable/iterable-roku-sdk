sub init()
    setLocals()
    SetControls()
    SetObservers()
    Initialize()
end sub

sub setLocals()
    m.exitCalled = false
    m.exitPopUpOpened = false
    m.messageCount = 100
    m.apiHostURL = ""
    m.apiKey = ""
    m.jwtToken = invalid
    m.RegistryManager = CreateRegistryManager()
    m.platform = "OTT"
    m.appPackageName = ""
    m.sdkVersion = "1.1.0"
end sub

sub SetControls()
    m.itblDialog = m.top.findNode("itblDialog")
end sub


sub SetObservers()
    m.itblDialog.observeField("messageStatus", "OnMessageStatus")
    m.itblDialog.observeField("closeDialog", "OnCloseDialog")
    m.itblDialog.observeField("clickEvent", "OnClickEvent")
    m.top.ObserveField("focusedChild", "OnFocusedChildChanged")
    getRequestDeviceInfo()
end sub

sub Initialize()
    m.itblDialog.visible = false
end sub

function OnConfigure(event as dynamic)
      data = event.getData()
      m.apiHostURL = data.apiHost
      m.apiKey = data.apiKey
      m.jwtToken = invalid
      m.appPackageName = data.packageName
end function


function ItblInitialize()
    m.top.messageStatus = { "status": "init", "count": 0, message: ""  }
    userInfo = getUserInfoFromRegistry()
    if userInfo <> invalid
        CallItblGetPriorityMessage(userInfo)
        m.top.messageStatus = { "status": "loading", "count": 0, message: ""  }
    else
        m.top.messageStatus = { "status": "waiting", "count": 0, message: "Call ItblSetEmailOrUserId to set either email or userId." }
    end if
end function

function ItblSetUserInfo(userInfo as object)
    status = {"status": "initiate", message:""}
    if userInfo <> invalid
        if userInfo.token <> invalid and userInfo.token <> ""
            m.jwtToken = userInfo.token
            userInfo.Delete("token")
        else 
            m.jwtToken = invalid
        end if
        if ((userInfo.email = invalid and userInfo.userId = invalid) or (userInfo.email = invalid and userInfo.userId = "") or (userInfo.email = "" and userInfo.userId = invalid) )
            m.RegistryManager.ClearUserInfo()
            status = { "status": "failed", "count": 0, message: "Call ItblSetEmailOrUserId with either of email or userId with proper value."}
            m.top.updateUserStatus = status
            m.top.messageStatus = status
        else if (userInfo.email <> invalid and userInfo.email <> "" and userInfo.userId <> invalid and userInfo.userId <> "")
            m.RegistryManager.ClearUserInfo()
            status = { "status": "failed", "count": 0, message: "Call ItblSetEmailOrUserId to set either email or userId with proper value."}
            m.top.updateUserStatus = status
            m.top.messageStatus = status
        else if ((userInfo.email <> invalid and userInfo.email <> "") or (userInfo.userId <> invalid and userInfo.userId <> ""))
            CallItblUpdateUser(userInfo)
            status = {"status": "started", message:"Call Api to update user."}
        end if
    end if
    return status
end function


function ItblShowInApp()
    if m.response <> invalid
        if m.response <> invalid and m.response.inAppMessages <> invalid and m.response.inAppMessages.count() > 0
            if m.itblDialog.visible = false
                messagePayload = m.response.inAppMessages[0]
                m.itblDialog.content = messagePayload
                boundingRect = m.itblDialog.boundingRect()
                m.itblDialog.translation = [(1920-boundingRect.width-90), (1080-boundingRect.height-60)]
                m.itblDialog.visible = true
                m.itblDialog.setFocus(true)
                m.top.dialogLoaded = true
                CallItblTrackInAppOpen()
                m.top.messageStatus = { "status": "displayed", "count": m.response.inAppMessages.count(), message: ""}
            else
                ItblDialogSetFocus()
                m.top.messageStatus = { "status": "displayed", "count": m.response.inAppMessages.count(), message: "Dialog is already open."}
            end if
        end if
    else
        m.top.messageStatus = { "status": "failed", "count": 0, message: "No data available to display now."  }
    end if
end function

function ItblDialogSetFocus()
    if m.itblDialog <> invalid and m.itblDialog.visible
        m.itblDialog.setFocus(true)
    end if
end function

function OnMessageStatus(event as dynamic)
    m.top.messageStatus = event.getData()
end function

function OnCloseDialog(event as dynamic)
    if m.itblDialog <> invalid and m.itblDialog.content <> invalid
        clickEvent = {"buttonText": "Back Button", "action":"back", "buttonDeepLink": "Back Button", "message": "Back Button", "isBackClick": true}
        CallItblTrackInAppClick(clickEvent)
    end if
end function

function OnClickEvent(event as dynamic)
    clickEvent = event.getData()
    if m.itblDialog <> invalid and m.itblDialog.content <> invalid
        CallItblTrackInAppClick(clickEvent)
    end if
end function

sub CallItblUpdateUser(userInfo as object)
    requestData = userInfo
    requestData["dataFields"] = {
        "rokuModel":m.di.GetModel(),
        "rokuOSVersion": m.rokuOSVersion
        "rokuDeviceId":m.di.GetChannelClientId()
      }
    CallItblApi(requestData, "ItblUpdateUser", "OnItblUpdateUserAPIResponse")
end sub

sub CallItblGetPriorityMessage(userInfo as object)
    if m.itblGetmessage <> invalid
        m.itblGetmessage.control = "STOP"
    end if
    requestData = userInfo
    requestData["platform"] = m.platform
    requestData["packageName"] = m.appPackageName
    requestData["SDKVersion"] = m.sdkVersion
    m.itblGetmessage = CallItblApi(requestData, "ItblGetPriorityMessage", "OnItblGetPriorityMessageAPIResponse")
end sub

sub CallItblTrack(eventName as string, data as object)
    requestData = getUserInfoFromRegistry(true)
    if requestData <> invalid
        requestData["eventName"] = eventName
        requestData["dataFields"] = data
        requestData["deviceInfo"] = getRequestDeviceInfo()
        CallItblApi(requestData, "ItblTrack", "OnItblTrackAPIResponse")
    end if
end sub

sub CallItblTrackInAppDelivery()
    requestData = getUserInfoFromRegistry()
    if requestData <> invalid
        requestData["messageId"] = getMessageId()
        requestData["deviceInfo"] = getRequestDeviceInfo()
        CallItblApi(requestData, "ItblTrackInAppDelivery", "OnItblTrackInAppDeliveryAPIResponse")
    end if
end sub

sub CallItblTrackInAppOpen()
    requestData = getUserInfoFromRegistry()
    if requestData <> invalid
        requestData["messageId"] = getMessageId()
        requestData["deviceInfo"] = getRequestDeviceInfo()
        CallItblApi(requestData, "ItblTrackInAppOpen", "OnItblTrackInAppOpenAPIResponse")
    end if
end sub

sub CallItblTrackInAppClick(clickedEvent as object)
    requestData = getUserInfoFromRegistry()
    if requestData <> invalid
        requestData["messageId"] = getMessageId()
        requestData["clickedUrl"] = clickedEvent.buttonDeeplink
        requestData["deviceInfo"] = getRequestDeviceInfo()
        CallItblApi(requestData, "ItblTrackInAppClick", "OnItblTrackInAppClickAPIResponse", clickedEvent)
    end if
end sub

sub CallItblTrackInAppClose(clickedEvent as object)
    requestData = getUserInfoFromRegistry()
    if requestData <> invalid
        requestData["messageId"] = getMessageId()
        requestData["deviceInfo"] = getRequestDeviceInfo()
        requestData["closeAction"] = clickedEvent.action
        CallItblApi(requestData, "ItblTrackInAppClose", "OnItblTrackInAppCloseAPIResponse", clickedEvent)
    end if
end sub


sub CallItblInAppConsume(clickedEvent as object)
    requestData = getUserInfoFromRegistry()
    if requestData <> invalid
        requestData["messageId"] = getMessageId()
        requestData["deviceInfo"] = getRequestDeviceInfo()
        CallItblApi(requestData, "ItblInAppConsume", "OnItblInAppConsumeAPIResponse", clickedEvent)
    end if
end sub

function CallItblApi(requestData as object, functionName as string, callBack as string, additionalParams = invalid as object)
    itblApiTask = CreateObject("roSGNode", "ItblAPIAction")
    itblApiTask.functionName = functionName

    itblApiTask.hosturl = m.apiHostURL
    itblApiTask.apiKey = m.apiKey
    itblApiTask.jwtToken = m.jwtToken
    itblApiTask.requestData = requestData
    itblApiTask.additionalParams = additionalParams
    itblApiTask.ObserveField("result", callBack)
    itblApiTask.control = "RUN"
    return itblApiTask
end function

function SetErrorMessage(field, messageStatus, result)
    if result.error <> invalid and result.error <> "" then messageStatus["message"] = result.error
    if result.code <> invalid and result.code <> 0 then messageStatus["code"] = result.code
    m.top.setField(field,messageStatus)
end function

sub OnItblUpdateUserAPIResponse(msg as Object)
    result = msg.getData()
    task = msg.getRoSGNode()
    if (result <> invalid and result.ok)
        userInfo = getUserInfo(task.requestData)
        setUserInfo(userInfo)
        CallItblGetPriorityMessage(userInfo)
        m.top.updateUserStatus = { "status": "success", message: ""  }
        m.top.messageStatus = { "status": "loading", "count": 0, message: ""  }
    else
        m.RegistryManager.ClearUserInfo()
        messageStatus = { "status": "failed", "count": 0, message: "Failed to update user email/userId."}
        SetErrorMessage("updateUserStatus", messageStatus, result)
        SetErrorMessage("messageStatus", messageStatus, result)
    end if
end sub

sub OnItblGetPriorityMessageAPIResponse(msg as Object)
    result = msg.getData()
    if (result <> invalid and result.ok)
        m.response = result.data
        if m.response <> invalid
          if m.response.inAppMessages <> invalid and m.response.inAppMessages.count() > 0
            m.response.inAppMessages.SortBy("priorityLevel")
            m.top.messageStatus = { "status": "loaded", "count": m.response.inAppMessages.count(), message: ""  }
            CallItblTrackInAppDelivery()
          else
            m.top.messageStatus = { "status": "loaded", "count": 0, message: "0 messages received."  }
          end if
        else
          m.top.messageStatus = { "status": "failed", "count": 0, message: "Response is invalid."  }
        end if
    else
      messageStatus = { "status": "failed", "count": 0, message: "Api failed to get meessage."  }
      SetErrorMessage("messageStatus", messageStatus, result)
    end if
    m.itblGetmessage = invalid
end sub

sub OnItblTrackAPIResponse(msg as Object)
    result = msg.getData()
    if (result <> invalid and result.ok)

    else
        ShowHideErrorMessage(true, "Failed to send Track.")
    end if
end sub

sub OnItblTrackInAppDeliveryAPIResponse(msg as Object)
    result = msg.getData()
    if (result <> invalid and result.ok)
    else
      ShowHideErrorMessage(true, "Failed to send InAppDelivery.")
    end if
end sub

sub OnItblTrackInAppOpenAPIResponse(msg as Object)
    result = msg.getData()
    if (result <> invalid and result.ok)

    else
        ShowHideErrorMessage(true, "Failed to send InAppOpen.")
    end if
end sub

sub OnItblTrackInAppClickAPIResponse(msg as Object)
    result = msg.getData()
    task = msg.getRoSGNode()
    if (result <> invalid and result.ok)
        if task.additionalParams <> invalid
            CallItblTrackInAppClose(task.additionalParams)
        end if
    else
        ShowHideErrorMessage(true, "Failed to send InAppClick.")
    end if
end sub

sub OnItblTrackInAppCloseAPIResponse(msg as Object)
    result = msg.getData()
    task = msg.getRoSGNode()
    if (result <> invalid and result.ok)
        CallItblInAppConsume(task.additionalParams)
    else
        ShowHideErrorMessage(true, "Failed to send InAppClose.")
    end if
end sub

sub OnItblInAppConsumeAPIResponse(msg as Object)
    result = msg.getData()
    task = msg.getRoSGNode()
    if (result <> invalid and result.ok)
        m.top.clickEvent = task.additionalParams
    else
        ShowHideErrorMessage(true, "Failed to send InAppConsume.")
    end if
end sub


sub ShowHideErrorMessage(show as boolean, message = "" as string)
      if m.itblDialog <> invalid
          m.itblDialog.callFunc("ShowHideErrorMessage", show, message)
      end if
end sub


function getRequestDeviceInfo()
  if m.di = invalid
      m.di = CreateObject("roDeviceInfo")
      osVersion = m.di.GetOSVersion()
      m.rokuOSVersion = osVersion.major + "." + osVersion.minor + "." + osVersion.revision
  end if
  return {
    "deviceId": m.di.GetChannelClientId(),
    "platform": m.platform,
    "appPackageName": m.appPackageName
  }
end function


function getUserInfo(userInfo, emailIdBoth = false as boolean)
      result = invalid
      if userInfo <> invalid
          if userInfo.email <> invalid
            result = {"email": userInfo.email}
          end if
          if userInfo.userId <> invalid and (emailIdBoth or result = invalid)
            if emailIdBoth and result <> invalid
              result["userId"] = userInfo.userId
            else
              result = {"userId": userInfo.userId}
            end if
          end if
      end if
      return result
end function

function getUserInfoFromRegistry(emailIdBoth = false as boolean)
      result = invalid
      userInfo = m.RegistryManager.GetUserInfo()
      if userInfo <> invalid
          result = getUserInfo(userInfo, emailIdBoth)
      end if
      return result
end function



function getMessageId()
    messageId = invalid
    if m.itblDialog <> invalid and m.itblDialog.content <> invalid
        messageId = m.itblDialog.content.messageId
    else
        messageId = m.response.inAppMessages[0].messageId
    end if
    return messageId
end function

sub setUserInfo(userInfo)
      m.RegistryManager.SaveUserInfo(userInfo)
end sub

function prepareUserInfo(data as string, isEmail as boolean)
    if isEmail
      userInfo = {"email": data}
    else
      userInfo = {"userId": data}
    end if
    return userInfo
end function


sub OnFocusedChildChanged()
    if m.top.hasFocus()
        ItblDialogSetFocus()
    end if
end sub


function OnkeyEvent(key as string, press as boolean) as boolean
    result = true
    if press
        if key = "back"
            m.top.closeDialog = true
        end if
    end if
    return result
end function
