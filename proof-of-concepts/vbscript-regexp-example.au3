#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         genius257

#ce ----------------------------------------------------------------------------

$oRegExp = ObjCreate("VBScript.RegExp")
$oRegExp.Global = True
$oRegExp.IgnoreCase = False
$oRegExp.Pattern = "[a-zA-Z]+"

$sentence = "This is a test."
Local $oMatches = $oRegExp.execute($sentence)

$i = 0
$iMax = $oMatches.Count()
While $i<$iMax
	$oMatch = $oMatches.Item($i)
	ConsoleWrite( _
		"{"& _
		"FirstIndex: "&$oMatch.FirstIndex&", "& _
		"Length: "&$oMatch.Length&", "& _
		"Value: "&$oMatch.Value& _
		"}"&@CRLF _
	)
	$i += 1
WEnd

;~ #include <WinAPI.au3>

;~ ConsoleWrite(VarGetType(10.1)&@CRLF)
;~ ConsoleWrite(VarGetType(_WinAPI_IntToFloat(10))&@CRLF)
;~ ConsoleWrite(Number(10.1, 1)&@CRLF)
;~ IsFloat(
;~ MsgBox(0, "", (9801)/(2206^(1/2)) )
;~ MsgBox(0, "", 9801/2^(1/2206) )
;~ MsgBox(0, "", 2^(1/2))

$a = 9801
$b = 2206*(2^(1/2))
MsgBox(0, "", $a/$b)

$b = False
MsgBox(0, "", $b==False)
