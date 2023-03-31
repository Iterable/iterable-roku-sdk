sub init() as void
    Initialize()
end sub


sub Initialize()
    'STEP 1: Initialize Iterable's Roku SDK
    ItblInitializeSDK("YOUR_API_KEY", "https://api.iterable.com", "com.example.my-roku-channel")
    'STEP 2: Identify the user by email or userId
    status = ItblSetEmailOrUserId({"email":"user@example.com"})
    'ItblSetEmailOrUserId({"userId":"1234"})
end sub


'Add ItblOnApplicationLoaded function call in specific function. So when that function called it will show itbl dialog.'
function FooBar()
    'STEP 3 : Show the in-app message'
    response = ItblOnApplicationLoaded()
end function

' TO do any action based on click event.'
function OnItblClickEvent(event as dynamic)
    clickEventData = event.getData()
end function

' TO do any action based on Close dialog to set focus back to specific item..'
function OnItblCloseEvent(event as dynamic)
    closeDialogData = event.getData()
end function

' TO do any action based on Close dialog to set focus back to specific item..'
function TrackCustomEvent(event as string, data as object)
    ItblCustomEventTrack("CLICK", {"button":"more detail"})
end function
