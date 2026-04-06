Func StringRepeat($sChar, $nCount)
    ; Create a buffer to hold the repeated characters
    $tBuffer = DLLStructCreate("char[" & $nCount + 1 & "]")

    ; Use msvcrt.dll's memset for high-speed memory filling
    DllCall("msvcrt.dll", "ptr:cdecl", "memset", "ptr", DLLStructGetPtr($tBuffer), "int", Asc($sChar), "int", $nCount)

    Return DLLStructGetData($tBuffer, 1)
EndFunc

; --- Example Usage ---
Local $result = StringRepeat("A", 20)
ConsoleWrite("Repeated String: " & $result & @CRLF)
