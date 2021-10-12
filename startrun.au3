#include <AutoItConstants.au3>
#include <FileConstants.au3>
#include <StringConstants.au3>
#include <MsgBoxConstants.au3>

Local $hLogfile = FileOpen('logfile.txt', $FO_APPEND)
Local $hDoorFile = FileOpen('online-door.txt', $FO_READ)
Local $doorData = FileRead($hDoorFile)
Local $deviceList = StringSplit($doorData, @CRLF)

Run(".\exe\netconfig.exe")

;~ 等待窗口激活
Local $hWnd = WinWait("netconfig", "", 5)

Sleep(500)

;~ 点击 tcp 按钮
Opt("MouseCoordMode", 2)
MouseClick($MOUSE_CLICK_PRIMARY, 315, 30, 1)

Sleep(1500)

For $i = 833 To $deviceList[0]
  Local $ipaddr = StringSplit($deviceList[$i], ' ')[1]
  Local $deviceid = StringSplit($deviceList[$i], ' ')[2]

  ShowStatus($i & ' ' & '开始设置：' & $ipaddr & ' ' & $deviceid)

  Sleep(1500)

  ;~ 设置设备 IP
  ControlSetText($hWnd, "", "SysIPAddress321", $ipaddr)
  ;~ 设置设备 ID
  ControlSetText($hWnd, "", "Edit1", $deviceid)

  Sleep(1500)

  ;~ 点击【获取设置】
  ControlClick($hWnd, "", "Button10")

  Sleep(4000)

  Local $sText = ControlGetText($hWnd, "", "Edit33")
  FileWriteLine($hLogfile, $i & ': ' & $ipaddr & ' ' & $deviceid & ' ' & $sText)

  ;~ server enable checkbox 的状态
  Local $bServerEnable = ControlCommand($hWnd, "", "Button6", "IsChecked")

  If $bServerEnable == 0 Then
    Opt("MouseCoordMode", 2)
    MouseClick($MOUSE_CLICK_PRIMARY, 15+157, 183+32, 1)
  EndIf

  SetServerConfig()

  ;~ 点击【写设置】
  ControlClick($hWnd, "", "Button11")

  Sleep(4000)

  Local $sText = ControlGetText($hWnd, "", "Edit33")
  FileWriteLine($hLogfile, $i & ': ' & $ipaddr & ' ' & $deviceid & ' ' & $sText)

Next

ShowStatus('程序执行完毕')

;~ 关闭文件
FileClose($hLogfile)
FileClose($hDoorFile)

;~ 利用 result 显示状态
Func ShowStatus($status)
  ControlSetText($hWnd, "", "Edit33", $status)
EndFunc

;~ 设置服务器上报配置
Func SetServerConfig()
  ;~ 服务器 IP：10.192.6.1
  ControlSetText($hWnd, "", "Edit27", "10")
  ControlSetText($hWnd, "", "Edit26", "192")
  ControlSetText($hWnd, "", "Edit25", "6")
  ControlSetText($hWnd, "", "Edit24", "1")

  Sleep(1500)

  ;~ 服务器端口和心跳包时间
  ControlSetText($hWnd, "", "Edit28", "7788")
  ControlSetText($hWnd, "", "Edit29", "3")
EndFunc