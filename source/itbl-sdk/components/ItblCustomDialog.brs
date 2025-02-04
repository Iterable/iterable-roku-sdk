sub init()
    setLocals()
    SetControls()
    setTheme()
    SetObservers()
    SetDefaultFocus()
end sub

sub setLocals()
    m.exitCalled = false
    m.exitPopUpOpened = false
    m.errorMessage = invalid
    m.width = 540
    m.buttonHeight = 64
    m.buttonBorderSize = 3
    m.buttonArray = []
    m.focusedIndex = 0
    m.defaultTheme = {
        "backgroundColor" : "#1C1C1C"
        "defaultBoldFont" : "font:MediumBoldSystemFont"
        "defaultRegularFont": "font:MediumSystemFont"
        "buttonBorderColor": "0xFFFFFF"
        "buttonColorFocused": "0xB30041"
        "buttonTextColorFocused": "0xFFFFFF"
        "buttonColorUnFocused" : "0xFFFFFF"
        "buttonTextColorUnFocused": "0xFFFFFF"
    }
end sub

sub SetControls()
    m.gContainer = m.top.findNode("gContainer")
    m.gMainGroup = m.top.findNode("gMainGroup")
    m.background = m.top.findNode("background")
    m.mainDialog = m.top.findNode("mainDialog")
    m.pImage = m.top.findNode("pImage")
    m.lgMessage = m.top.findNode("lgMessage")
    m.lgButton = m.top.findNode("lgButton")
end sub

sub setTheme()
end sub

sub SetObservers()
    m.top.ObserveField("focusedChild", "OnFocusedChildChanged")
end sub

sub SetDefault()
    m.buttonArray = []
    m.focusedIndex = 0
    m.background.uri = ""
    m.background.uri = "pkg:/ItblImages/focus/white_fill_corner_radius_10.9.png"
    m.background.blendColor = "#808080"

    m.pImage.uri = ""
    m.pImage.uri = "pkg:/ItblImages/focus/white_fill_corner_radius_10.9.png"
    m.lgMessage.removeChildrenIndex(m.lgMessage.getChildCount() - 1, 0)
    m.lgButton.removeChildrenIndex(m.lgButton.getChildCount() - 1, 0)
    if m.errorMessage = invalid
        m.gMainGroup.removeChild(m.errorMessage)
        m.errorMessage = invalid
    end if
end sub

sub SetDefaultFocus()
    if m.buttonArray.count() > 0
        m.focusedIndex = 0
        m.buttonArray[m.focusedIndex].setFocus(true)
    end if
end sub

sub OnContentSet(event as dynamic)
    data = event.getData()
    if data <> invalid
        SetDefault()
        payload = data.ottPayload
        if payload.backgroundColor <> invalid and payload.backgroundColor <> ""
            m.background.blendColor = payload.backgroundColor
        else
            m.background.blendColor = m.defaultTheme.backgroundColor
        end if
        if payload.fhd_image <> invalid and payload.fhd_image <> ""
            m.pImage.uri = payload.fhd_image
        end if

        if payload.dialogHeader <> invalid and payload.dialogHeader <> ""
            header = CreateLabel(payload.dialogHeader, 32, payload.dialogHeaderFont, m.defaultTheme.defaultBoldFont)
            header.wrap = true
            header.lineSpacing = 2
            header.maxLines = 2
            m.lgMessage.appendChild(header)
        end if
        if payload.dialogText <> invalid and payload.dialogText <> ""
            message = CreateLabel(payload.dialogText, 26, payload.dialogBodyFont, m.defaultTheme.defaultRegularFont)
            message.wrap = true
            message.lineSpacing = 2
            message.maxLines = 2
            m.lgMessage.appendChild(message)
        end if

        if payload.buttons <> invalid
            counter = 1
            for each item in payload.buttons
                button = CreateButton("button_"+counter.ToStr(), item, 30, payload.dialogButtonFont, m.defaultTheme.defaultRegularFont)
                m.lgButton.appendChild(button)
                counter++
            end for
        end if
        boundingRect = m.gMainGroup.boundingRect()
        m.background.height = boundingRect.height + (34*2)
        m.background.width = boundingRect.width + (34*2)

    end if
end sub

sub ShowHideErrorMessage(showMessage as boolean, errorMessage = "" as string)
    if showMessage
      if m.errorMessage = invalid
          m.errorMessage = CreateLabel(errorMessage, 24, invalid, m.defaultTheme.defaultRegularFont)
          m.errorMessage.wrap = true
          m.errorMessage.color = "#FF0000"
          m.errorMessage.maxLines = 1
          boundingRect = m.mainDialog.boundingRect()
          m.errorMessage.translation = [0,boundingRect.height + 10]
          m.gMainGroup.appendChild(m.errorMessage)
      else
          m.errorMessage.text = errorMessage
      end if
    else
      m.gMainGroup.removeChild(m.errorMessage)
      m.errorMessage = invalid
    end if


    boundingRect = m.gMainGroup.boundingRect()
    m.background.height = boundingRect.height + (34*2)
    m.background.width = boundingRect.width + (34*2)
end sub

function CreateLabel(labelText as string, fontSize as integer, labelFont as object, defaultFont as string)
      label = CreateObject("roSGNode", "Label")
      label.text =labelText
      label.width = m.width
      if labelFont <> invalid and FileExists(labelFont)
          fontPath = labelFont
          font = CreateFont(fontPath, fontSize)
      else
          font = defaultFont
      end if
      label.font = font
      return label
end function


function CreateButton(id as string, item as object, fontSize as integer, dialogButtonFont as object, defaultFont as string)


      buttonBorderColor = item.buttonBorderColor
      buttonColorFocused = item.buttonColorFocused
      buttonColorUnFocused = item.buttonColorUnFocused
      buttonTextColorFocused = item.buttonTextColorFocused
      buttonTextColorUnFocused = item.buttonTextColorUnFocused
      if buttonBorderColor = invalid or buttonBorderColor = "" then buttonBorderColor = m.defaultTheme.buttonBorderColor
      if buttonColorFocused = invalid or buttonColorFocused = "" then buttonColorFocused = m.defaultTheme.buttonColorFocused
      if buttonColorUnFocused = invalid or buttonColorUnFocused = "" then buttonColorUnFocused = m.defaultTheme.buttonColorUnFocused
      if buttonTextColorFocused = invalid or buttonTextColorFocused = "" then buttonTextColorFocused = m.defaultTheme.buttonTextColorFocused
      if buttonTextColorUnFocused = invalid or buttonTextColorUnFocused = "" then buttonTextColorUnFocused = m.defaultTheme.buttonTextColorUnFocused
      if dialogButtonFont <> invalid and FileExists(dialogButtonFont)
          fontPath = dialogButtonFont
          font = CreateFont(fontPath, fontSize)
      else
          font = defaultFont
      end if
      borderData = {
            "height"  : m.buttonHeight,
            "width"   : m.width,
            "size"    : m.buttonBorderSize,
            "buttonBorderColor"    : buttonBorderColor,
            "buttonColorFocused"   : buttonColorFocused,
            "buttonColorUnFocused"   : buttonColorUnFocused,
            "buttonTextColorFocused"   : buttonTextColorFocused,
            "buttonTextColorUnFocused"   : buttonTextColorUnFocused
            "font"    : font
      }
      print "borderData  "borderData
      button = CreateObject("roSGNode", "ItblButton")
      button.id = id
      button.buttonText = item.buttonText
      button.buttonDeeplink = item.buttonDeeplink
      button.borderData = borderData
      button.observeField("buttonSelected", "OnButtonSelected")

      m.buttonArray.push(button)

      return button
end function


sub OnButtonFocused(event as dynamic)
      node = event.getRoSGNode()
      child = node.getChild(0)
      if node.hasFocus()
          node.blendColor = node.focusedColor
          child.color = child.focusedColor
      else
          node.blendColor = node.unFocusedColor
          child.color = child.unFocusedColor
      end if
end sub

sub SetFocusToButton(key)
      buttonCount = m.buttonArray.count()
      if buttonCount > 1
          if key = "down"
            if m.focusedIndex < (buttonCount - 1)
                m.focusedIndex++
                m.buttonArray[m.focusedIndex].setFocus(true)
            end if
          else if key = "up"
              if m.focusedIndex > 0
                  m.focusedIndex--
                  m.buttonArray[m.focusedIndex].setFocus(true)
              end if
          end if
      else if buttonCount > 0
        SetDefaultFocus()
      end if
end sub

sub OnFocusedChildChanged()
    if m.top.hasFocus()
        SetDefaultFocus()
    end if
end sub

function OnkeyEvent(key as string, press as boolean) as boolean
    result = false
    if press

        if key = "back"
            if m.errorMessage = invalid
                m.top.closeDialog = true
                result = true
            end if
        else if key = "up" or key = "down"
            ShowHideErrorMessage(false)
            SetFocusToButton(key)
            result = true
        else if key = "OK"
            ShowHideErrorMessage(false)
            if m.buttonArray[m.focusedIndex].hasFocus()
                m.top.clickEvent =  { "buttonText": m.buttonArray[m.focusedIndex].buttonText, "buttonDeeplink": m.buttonArray[m.focusedIndex].buttonDeeplink, "action": "link", "isClick": true, "message" :  m.buttonArray[m.focusedIndex].buttonDeeplink}
                result = true
            end if
        else
            ShowHideErrorMessage(false)
        end if
    end if
    return result
end function
