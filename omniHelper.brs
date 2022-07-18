function OmniInitializeSDK(omniApiKey as string, omniApiHost as string, packageName as string)
    m.lastFocusedItem = invalid
    m.omniConfig = {
        "apiKey" : omniApiKey
        "apiHost" : omniApiHost
        "packageName" : packageName
    }
    m.messageStatus = {"status": "", "count" :0 }
    m._omniSDK = createLib("OmniSDK","pkg:/source/omni-sdk.zip")
    m.setUserInfoEmail = invalid
    m.setUserId = invalid
    m.IsOmniDialogDisplayed = false
end function

function OmniSetEmailOrUserId(userInfo = invalid as object)
    if userInfo = invalid then userInfo = {}
    if m.omniDialog <> invalid
        status = m.omniDialog.callFunc("OmniSetUserInfo", userInfo)
    else
        status = {"status": "waiting", "message": "Library is not yet loaded."}
    end if
    m.setUserInfoEmail = userInfo
    return status
end function

function OmniOnApplicationLoaded()
    print "OmniOnApplicationLoaded "
    response = {
        status : "NOT_LOADED"
        success : false,
        message : "Loading Library"
    }
    if m._omniSDK <> invalid
        if m._omniSDK.loadStatus = "failed"
            response = {
                status : "failed"
                success : false,
                message : "Failed to load sdk"
            }
        else if m._omniSDK.loadStatus = "ready"
            if m.IsOmniDialogDisplayed
                response = {
                    status : "closed"
                    success : false,
                    message : "Dialog can be displayed only once."
                }
            else if m.omniDialog = invalid
                response = {
                    status : "initilizing"
                    success : false,
                    message : "Pending to initiate"
                }
            else if m.omniDialog.dialogLoaded = true
                response = {
                    status : m.messageStatus.status
                    success : false,
                    message : "Dialog is already display on screen."
                }
            else
                if m.messageStatus.status <> "loaded"
                    if m.messageStatus.status = "loading" or m.messageStatus.status = "waiting" or m.messageStatus.status = "failed"
                        response = {
                            status : m.messageStatus.status
                            success : false,
                            message : m.messageStatus.message
                        }
                    else if m.messageStatus.status = "displayed"
                        response = {
                            status : m.messageStatus.status
                            success : false,
                            message : "Dialog is already display on screen."
                        }
                    end if
                else
                    if m.messageStatus.count = 0
                        response = {
                            status : m.messageStatus.status
                            success : false,
                            message : m.messageStatus.message
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
    m.omniDialog.callFunc("OmniShowInApp")
    m.top.appendChild(m.omniDialog)
    m.omniDialog.setFocus(true)
end sub

function OmniApplicationSetFocus()
    if m.omniDialog <> invalid
      m.omniDialog.callFunc("OmniDialogSetFocus")
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
    print "[ omni SDK ] - load status " loadStatus
    if loadStatus = "ready"
        m._omniSDK.unobserveField("loadStatus")
        SetupOmniDialog()
    end if
end sub

sub SetupOmniDialog()
    print "SetupOmniDialog"
    m.omniDialog = CreateObject("roSGNode", "OmniSDK:OmniSDK")
    m.omniDialog.config = m.omniConfig
    m.omniDialog.observeField("messageStatus", "OnMessageStatus")
    m.omniDialog.observeField("closeDialog", "OnCloseDialog")
    m.omniDialog.observeField("clickEvent", "OnClickEvent")
    if m.setUserInfoEmail <> invalid then
        m.omniDialog.callFunc("OmniSetUserInfo", m.setUserInfoEmail)
        m.setUserInfoEmail = invalid
    else
        m.omniDialog.callFunc("OmniInitialize")
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
      print "OnOmniMessage LoadStatus "messageStatus
    end if
end sub

sub OnCloseDialog(event as dynamic)
  closeDialog = event.getData()
  print "OnCloseDialog "
  if m.omniDialog <> invalid and closeDialog = true
      CloseOmniSDKDialog(false)
  end if
end sub

sub OnClickEvent(event as dynamic)
    clickEvent = event.getData()
    m.top.OmniClickEvent = clickEvent
    CloseOmniSDKDialog(true)
end sub

sub CloseOmniSDKDialog(IsClickEvent as boolean)
    m.omniDialog.unObserveField("messageStatus")
    m.omniDialog.unObserveField("closeDialog")
    m.omniDialog.unObserveField("clickEvent")
    m.top.removeChild(m.omniDialog)
    m.omniDialog = invalid
    data = {
        "ButtonClick" : IsClickEvent
        "BackClick" : not IsClickEvent
    }
    SetFocusedToLastItem()
    m.top.OmniCloseEvent = data
    m.lastFocusedItem = invalid
    m.IsOmniDialogDisplayed = true
end sub

sub SetFocusedToLastItem()
    if m.lastFocusedItem  <> invalid
        m.lastFocusedItem.setFocus(true)
    end if
end sub
