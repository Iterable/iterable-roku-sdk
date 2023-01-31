function FileExists(fullPath as string)
    foundFile = false
    pathSeperator = fullPath.Split("/")' as String
    if pathSeperator.count() > 0
        fileName = pathSeperator[pathSeperator.count() - 1]
        if fileName <> invalid and fileName <> "" and Len(fileName) > 0
            fileNameStartLocation = Instr(fullPath, fileName)
            if fileNameStartLocation > 0
              filePath = Left(fullPath,fileNameStartLocation - 1)
              if Len(filePath) > 0
                fileExist = MatchFiles(filePath, fileName)
                if fileExist.count() > 0
                    foundFile = true
                end if
              end if
            end if
        end if
    end if
    return foundFile
end function


function CreateFont(fontPath, size)
  font = CreateObject("roSGNode", "Font")
  font.uri = fontPath
  font.size = size
  return font
end function
