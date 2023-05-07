function ItblInitializeSDK(itblApiKey as string, itblApiHost as string, packageName as string)
    m.lastFocusedItem = invalid
    m.itblConfig = {
        "apiKey" : itblApiKey
        "apiHost" : itblApiHost
        "packageName" : packageName
    }
    m.messageStatus = {"status": "", "count" :0 }
    m._itblSDK = createLib("ItblSDK","pkg:/source/itbl-sdk.zip")
    m.setUserInfoEmail = invalid
    m.setUserId = invalid
    m.IsItblDialogDisplayed = false
end function

function ItblSetEmailOrUserId(userInfo = invalid as object)
    if userInfo = invalid then userInfo = {}
    if m.itblDialog <> invalid
        m.top.ItblUpdateUser = invalid
        status = m.itblDialog.callFunc("ItblSetUserInfo", userInfo)
    else
        m.top.ItblUpdateUser = {"status": "waiting", "message": "Library is not yet loaded."}
    end if
    m.setUserInfoEmail = userInfo
end function

function ItblOnApplicationLoaded()
    response = {
        status : "NOT_LOADED"
        success : false,
        message : "Loading Library"
    }
    if m._itblSDK <> invalid
        if m._itblSDK.loadStatus = "failed"
            response = {
                status : "failed"
                success : false,
                message : "Failed to load SDK"
            }
        else if m._itblSDK.loadStatus = "ready"
            if m.IsItblDialogDisplayed
                response = {
                    status : "closed"
                    success : false,
                    message : "Dialog can be displayed only once"
                }
            else if m.itblDialog = invalid
                response = {
                    status : "initializing"
                    success : false,
                    message : "Pending to initiate"
                }
            else if m.itblDialog.dialogLoaded = true
                response = {
                    status : m.messageStatus.status
                    success : false,
                    message : "Dialog is already displayed on screen"
                }
            else
                if m.messageStatus.status <> "loaded"
                    if m.messageStatus.status = "loading" or m.messageStatus.status = "waiting" or m.messageStatus.status = "failed"
                        response = {
                            status : m.messageStatus.status
                            success : false,
                            message : m.messageStatus.message
                            code: m.messageStatus.code
                        }
                    else if m.messageStatus.status = "displayed"
                        response = {
                            status : m.messageStatus.status
                            success : false,
                            message : "Dialog is already displayed on screen"
                        }
                    end if
                else
                    if m.messageStatus.count = 0
                        response = {
                            status : m.messageStatus.status
                            success : false,
                            message : m.messageStatus.message
                            code: m.messageStatus.code
                        }
                    else
                        ShowDialog()
                        response = {
                          status : m.messageStatus.status
                          success : true,
                          message : m.messageStatus.message
                        }
                    end if
                end if
            end if
        end if
    end if
    return response
end function

sub ShowDialog()
    m.lastFocusedItem = FindFocusedItem(m.top)
    m.itblDialog.callFunc("ItblShowInApp")
    m.top.appendChild(m.itblDialog)
    m.itblDialog.setFocus(true)
end sub

function ItblApplicationSetFocus()
    if m.itblDialog <> invalid
      m.itblDialog.callFunc("ItblDialogSetFocus")
    end if
end function

function createLib(id as string, uri as string, isLoadStatusNeeded=true as boolean) as object
    lib = createObject("roSGNode", "ComponentLibrary")
    lib.id = id
    lib.uri = uri
    if isLoadStatusNeeded
      lib.observeField("loadStatus", "_onLoadStatusChanged")
    end if
    m.top.appendChild(lib)
    return lib
end function

sub _onLoadStatusChanged(event as dynamic)
    loadStatus = event.getData()
    if loadStatus = "ready"
        m._itblSDK.unobserveField("loadStatus")
        SetupItblDialog()
    end if
end sub

sub SetupItblDialog()
    m.itblDialog = CreateObject("roSGNode", "ItblSDK:ItblSDK")
    m.itblDialog.config = m.itblConfig
    m.itblDialog.observeField("messageStatus", "OnMessageStatus")
    m.itblDialog.observeField("updateUserStatus", "OnUpdateUserStatus")
    m.itblDialog.observeField("closeDialog", "OnCloseDialog")
    m.itblDialog.observeField("clickEvent", "OnClickEvent")
    if m.setUserInfoEmail <> invalid then
        m.top.ItblUpdateUser = invalid
        m.itblDialog.callFunc("ItblSetUserInfo", m.setUserInfoEmail)
        m.setUserInfoEmail = invalid
    else
        m.itblDialog.callFunc("ItblInitialize")
    end if
end sub

function FindFocusedItem(component as object)
    focusedItem = invalid
    if component.hasFocus()
        focusedItem = component
    else if component.isInFocusChain()
        for i=0 to component.getChildCount()-1
          subComponent = component.getChild(i)
          focusedItem = FindFocusedItem(subComponent)
          if focusedItem <> invalid
            exit for
          end if
        end for
    end if
    return focusedItem
end function

sub OnMessageStatus(event as dynamic)
    messageStatus = event.getData()
    if messageStatus <> invalid
        m.messageStatus = messageStatus
        if m.top.ItblUpdateUser <> invalid and m.top.ItblUpdateUser.status = "success"
            m.top.ItblMessageUpdate = messageStatus
        end if
    end if
end sub

sub OnUpdateUserStatus(event as dynamic)
    userUpdateStatus = event.getData()
    if userUpdateStatus <> invalid
      m.top.ItblUpdateUser = userUpdateStatus
    end if
end sub

sub OnCloseDialog(event as dynamic)
  closeDialog = event.getData()
  if m.itblDialog <> invalid and closeDialog = true
      CloseItblSDKDialog(false)
  end if
end sub

sub OnClickEvent(event as dynamic)
    clickEvent = event.getData()
    m.top.ItblClickEvent = clickEvent
    CloseItblSDKDialog(true)
end sub

sub ItblCustomEventTrack(eventName = "" as string, data = invalid as object)
    if m.itblDialog <> invalid
      m.itblDialog.callFunc("CallItblTrack", eventName, data)
    end if
end sub

sub CloseItblSDKDialog(IsClickEvent as boolean)
    m.itblDialog.unObserveField("messageStatus")
    m.itblDialog.unObserveField("updateUserStatus")
    m.itblDialog.unObserveField("closeDialog")
    m.itblDialog.unObserveField("clickEvent")
    m.top.removeChild(m.itblDialog)
    m.itblDialog = invalid
    data = {
        "ButtonClick" : IsClickEvent
        "BackClick" : not IsClickEvent
    }
    SetFocusedToLastItem()
    m.top.ItblCloseEvent = data
    m.lastFocusedItem = invalid
    m.IsItblDialogDisplayed = true
end sub

sub SetFocusedToLastItem()
    if m.lastFocusedItem  <> invalid
        m.lastFocusedItem.setFocus(true)
    end if
end sub
