$oHTTP = ObjCreate("winhttp.winhttprequest.5.1")
$oHTTP.Open("GET", "https://www.google.com/", True)
$oHTTP.SetRequestHeader("Host", $sServerUrl)
$oHTTP.SetRequestHeader("Origin", "https://www.google.com/")
$oHTTP.SetRequestHeader("Referer", "https://www.google.com/")
$oHTTP.Send()
$oHTTP.WaitForResponse()

; $statusCode = $oHTTP.Status
; $oHTTP.ResponseText
