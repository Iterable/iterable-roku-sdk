function CreateRegistryManager() as object
    instance = {

        SaveUserInfo: sub(userInfo as object)
            reg = CreateObject("roRegistrySection", "ItblSDK")
            userInfoJson = FormatJson(userInfo)
            reg.Write("userInfo",userInfoJson)
            reg.Flush()
        end sub,
        GetUserInfo: function() as object
            reg = CreateObject("roRegistrySection", "ItblSDK")
            readValues = reg.Read("userInfo")
            userInfo = invalid
            if readValues <> invalid and readValues <> ""
              userInfo = ParseJson(readValues)
            end if
            return userInfo
        end function,
        ClearUserInfo: sub()
            reg = CreateObject("roRegistrySection", "ItblSDK")
            reg.Delete("userInfo")
            reg.Flush()
        end sub,

        ClearAllSettings: sub()
            Registry = CreateObject("roRegistry")

            for each section in Registry.GetSectionList()
                RegistrySection = CreateObject("roRegistrySection", section)
                for each key in RegistrySection.GetKeyList()
                    RegistrySection.Delete(key)
                end for
                RegistrySection.flush()
            end for

            Registry.Delete(section)
        end sub
    }

    return instance
end function
