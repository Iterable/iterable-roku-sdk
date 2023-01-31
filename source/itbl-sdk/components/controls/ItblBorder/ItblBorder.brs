sub init()
    m.rTop = m.top.FindNode("rTop")
    m.rRight = m.top.FindNode("rRight")
    m.rBottom = m.top.FindNode("rBottom")
    m.rLeft = m.top.FindNode("rLeft")
end sub

sub ResetToDefault()

  m.rTop.width = 0
  m.rTop.height = 0
  m.rTop.translation = [0, 0]

  m.rRight.width = 0
  m.rRight.height = 0
  m.rRight.translation = [0, 0]

  m.rBottom.width = 0
  m.rBottom.height = 0
  m.rBottom.translation = [0, 0]

  m.rLeft.width = 0
  m.rLeft.height = 0
  m.rLeft.translation = [0, 0]
end sub

sub OnBorderDataChange(event as dynamic)
    borderData = event.GetData()
    ResetToDefault()
    m.rTop.width = borderData.width
    m.rTop.height = borderData.size
    m.rTop.color = borderData.buttonBorderColor
    m.rTop.translation = [0, 0]

    m.rRight.width = borderData.size
    m.rRight.height = borderData.height
    m.rRight.color = borderData.buttonBorderColor
    m.rRight.translation = [(borderData.width-borderData.size), 0]

    m.rBottom.width = borderData.width
    m.rBottom.height = borderData.size
    m.rBottom.color = borderData.buttonBorderColor
    m.rBottom.translation = [0, (borderData.height-borderData.size)]

    m.rLeft.width = borderData.size
    m.rLeft.height = borderData.height
    m.rLeft.color = borderData.buttonBorderColor
    m.rLeft.translation = [0, 0]
end sub

sub OnColorChange(event as dynamic)
    color = event.GetData()

    m.rTop.color = color
    m.rRight.color = color
    m.rBottom.color = color
    m.rLeft.color = color
end sub
