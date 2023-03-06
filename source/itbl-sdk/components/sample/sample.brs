sub init() as void
    Initialize()
end sub


sub Initialize()
    'STEP 1 : To Initialize Itbl SDK'
    ItblInitializeSDK("YOUR_API_KEY", "https://api.iterable.com", "customerPackageName")
    'STEP 2 : To Initialize Itbl SDK with email'
    status = ItblSetEmailOrUserId({"email":"test@test.com"})

    'STEP 2 : To Initialize Itbl sdk by setting email/userId to empy'
    ' ItblSetEmailOrUserId(invalid)
    'STEP 2 : To Initialize Itbl sdk with userId'
    ' ItblSetEmailOrUserId({"userId":"1234"})
    'STEP 2 : When Itbl sdk set with email and userId. It will give error and clear details from registry'
    ' status = ItblSetEmailOrUserId({"email":"test@test.com","userId":"test"})
end sub


'Add ItblOnApplicationLoaded function call in specific function. So when that function called it will show itbl dialog.'
function FooBar()
    'STEP 3 : To Load SDK and show dialog'
    response = ItblOnApplicationLoaded()
    print "response : "response
end function

' TO do any action based on click event.'
function OnItblClickEvent(event as dynamic)
    clickEventData = event.getData()
    print "OnItblClickEvent : "clickEventData
end function

' TO do any action based on Close dialog to set focus back to specific item..'
function OnItblCloseEvent(event as dynamic)
    closeDialogData = event.getData()
    print "OnItblDialogClose : "closeDialogData
end function

' TO do any action based on Close dialog to set focus back to specific item..'
function TrackCustomEvent(event as string, data as object)
    ItblCustomEventTrack("CLICK", {"button":"more detail"})
end function
