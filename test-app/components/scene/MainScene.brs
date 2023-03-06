sub init()
    print "MainScene : Init "
    setLocals()
    SetControls()
    setTheme()
    SetObserves()
    SetDefaultFocus()
    Initialize()
end sub

sub setLocals()
    m.exitCalled = false
    m.exitPopUpOpened = false

end sub

sub SetControls()
    m.lHeading = m.top.findNode("lHeading")
    m.lWithPerson = m.top.findNode("lWithPerson")
    m.lDuration = m.top.findNode("lDuration")
    m.lEquipment = m.top.findNode("lEquipment")
    m.lEquipmentTitle = m.top.findNode("lEquipmentTitle")
    m.lTopDescription = m.top.findNode("lTopDescription")
    m.lDeepLinkLabel = m.top.findNode("lDeepLinkLabel")
    m.lDeepLinkValue = m.top.findNode("lDeepLinkValue")

    m.bsPreloader = m.top.findNode("bsPreloader")
    m.sdkDialog = m.top.findNode("sdkDialog")
    m.pMainPoster = m.top.findNode("pMainPoster")
    m.pOverlayPoster = m.top.findNode("pOverlayPoster")

    m.pWatchnow = m.top.findNode("pWatchnow")
    m.lWatchnow = m.top.findNode("lWatchnow")
    m.pMoredetails = m.top.findNode("pMoredetails")
    m.lMoreDetails = m.top.findNode("lMoreDetails")


    m.timer = m.top.findNode("Timer")

    m.openSansbold56 = CreateObject("roSGNode", "Font")
    m.openSansbold56.uri = "pkg:/fonts/OpenSans-Bold.ttf"
    m.openSansbold56.size = 56

    m.openSansbold32 = CreateObject("roSGNode", "Font")
    m.openSansbold32.uri = "pkg:/fonts/OpenSans-Bold.ttf"
    m.openSansbold32.size = 32

    m.openSans_regular26 = CreateObject("roSGNode", "Font")
    m.openSans_regular26.uri = "pkg:/fonts/OpenSans-Regular.ttf"
    m.openSans_regular26.size = 26

    m.openSans_regular30 = CreateObject("roSGNode", "Font")
    m.openSans_regular30.uri = "pkg:/fonts/OpenSans-Regular.ttf"
    m.openSans_regular30.size = 30

    m.lWatchnow.font = m.openSansbold32
    m.lMoreDetails.font = m.openSansbold32

    m.lHeading.font = m.openSansbold56
    m.lWithPerson.font = m.openSans_regular30
    m.lDuration.font = m.openSans_regular30
    m.lEquipment.font = m.openSans_regular30
    m.lEquipmentTitle.font = m.openSans_regular30
    m.lTopDescription.font = m.openSans_regular26
    m.lDeepLinkLabel.font = m.openSans_regular26
    m.lDeepLinkValue.font = m.openSans_regular26

end sub

sub setTheme()
    m.top.backgroundColor = "#000000"
    m.pOverlayPoster.uri = "pkg:/images/overlay/Overlay.png"
    m.pOverlayPoster.blendColor = "#000000"

    m.bsPreloader.poster.uri = "pkg:/images/focus/loader.png"
    m.bsPreloader.poster.width = "160"
    m.bsPreloader.poster.height = "160"
end sub

sub SetObserves()
    m.timer.observeField("fire", "OnTimerFire")
end sub

sub SetDefaultFocus()
    m.pMoredetails.opacity = 0.5
    m.pWatchnow.opacity = 1
    m.pWatchnow.setFocus(true)
end sub

sub Initialize()
    'STEP 1 : To Initialize Itbl SDK'
    ItblInitializeSDK("YOUR_API_KEY", "https://api.iterable.com", "itbl")
    ' ItblInitializeSDK("dasfds", "https://test-itbl2.free.beeceptor.com", "test")
    'STEP 2 : To Initialize Itbl SDK'
    status = ItblSetEmailOrUserId({"email":"newuser@test.com"})
    print "ItblSetEmailOrUserId status "status
    ' Or we can call with userId as below '
    'status = ItblSetEmailOrUserId({"userId":"test"})
    ' Below one give error if you set both. It required to set either of them.'
    'status = ItblSetEmailOrUserId({"email":"test@test.com","userId":"test"})
    ' Below one give error to set proper value. '
    ' status = ItblSetEmailOrUserId(invalid)
    m.timer.control = "START"
end sub


function OnTimerFire()
    'STEP 3 : To Load SDK and show dialog'
    applicationLoadStatus = ItblOnApplicationLoaded()
    print "ItblOnApplicationLoaded Status "applicationLoadStatus

    if not applicationLoadStatus.success
        m.lDeepLinkLabel.text = "Library Status : "
    end if
    m.lDeepLinkValue.text = applicationLoadStatus.message
end function

' TO do any action based on click event.'
function OnItblClickEvent(event as dynamic)
    clickEventData = event.getData()
    print "OnItblClickEvent : "clickEventData
    m.lDeepLinkValue.text = clickEventData.buttonDeepLink
end function

' TO do any action based on Close dialog to set focus back to specific item..'
function OnItblCloseEvent(event as dynamic)
    closeDialogData = event.getData()
    print "OnItblDialogClose : "closeDialogData
end function

function OnkeyEvent(key as string, press as boolean) as boolean
    result = false
    if press
        print "MainScene : onKeyEvent : key = " key " press = " press
        if key = "back"
        else if key = "down" then
            if m.pWatchnow.hasFocus()
                m.pWatchnow.opacity = 0.5
                m.pMoredetails.opacity = 1
                m.pMoredetails.setFocus(true)
            end if
        else if key = "up" then
            if m.pMoredetails.hasFocus()
                m.pMoredetails.opacity = 0.5
                m.pWatchnow.opacity = 1
                m.pWatchnow.setFocus(true)
            end if
        else if key = "OK" then
            if m.pMoredetails.hasFocus()
                ItblCustomEventTrack("MOREDETAIL", {"click":"more detail"})
            end if
        end if
    end if
    return result
end function
