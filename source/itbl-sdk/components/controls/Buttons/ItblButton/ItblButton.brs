sub init()
    SetLocals()
    SetControls()
    m.top.observeField("focusedChild", "OnFocusedChild")
end sub

sub SetLocals()
    m.theme = m.global.appTheme
end sub

sub SetControls()
    m.gBorder = m.top.FindNode("gBorder")
    m.rFillBox = m.top.FindNode("rFillBox")
    m.lText = m.top.FindNode("lText")
end sub

sub ResetToDefault()

  m.rFillBox.width = 0
  m.rFillBox.height = 0
  m.rFillBox.uri = ""
end sub

sub OnBorderDataChange(event as dynamic)
    borderData = event.GetData()
    ResetToDefault()
    m.gBorder.borderData = borderData

    m.rFillBox.width = borderData.width - 2
    m.rFillBox.height = borderData.height - 1

    m.lText.width = borderData.width
    m.lText.height = borderData.height
    m.lText.font = borderData.font
    m.rFillBox.blendColor = borderData.buttonColorUnFocused
    m.lText.color = borderData.buttonTextColorUnFocused
    m.rFillBox.uri = "pkg:/ItblImages/focus/rectPoster.png"
end sub

sub OnFocusedChild()
    if m.top.hasFocus()
        m.gBorder.visible = true
        m.rFillBox.visible = true
        m.rFillBox.blendColor = m.top.borderData.buttonColorFocused
        m.lText.color = m.top.borderData.buttonTextColorFocused
    else
        m.gBorder.visible = false
        m.rFillBox.visible = true
        m.rFillBox.blendColor = m.top.borderData.buttonColorUnFocused
        m.lText.color = m.top.borderData.buttonTextColorUnFocused
    end if
end sub
