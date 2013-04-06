;Author Likaci www.xiazhiri.com
;��лSunwind��˼· http://blog.csdn.net/liuyukuan/article/details/8615735
SetWorkingDir %A_ScriptDir%

Loop, %0% ;��������ʼ
{
    param := %A_Index%
	if param contains LikaciiniPath  ;��������в�������likaciiniPath,���Զ�Ѱ��wincmd.ini
	{
		StringReplace,inipath,param,LikaciiniPath,,All
		Continue
	}

	;�ų�����·��
    If param not contains ::{,.tib
	{
		if !inipath
			inipath := Getini() ;��ȡini·��
		if !CheckEnv(inipath) ;������л���
			Return
		if !Saveini(inipath) ;����Tc���������ļ�
			Return
		Sleep 200
		if ShiftKey := GetKeyState("Shift","P") ;����shift �ұ�
			LorR = right
		else
			LorR = Left
		if !Tabs := GetTabs(inipath,LorR) ;��ȡ�����ļ�����ȡtabs
			Return
		CheckandActiveTabs(Tabs,LorR,param,ShiftKey) ;����Ŀ��
	}
    else
		Run Explorer.exe %param%

	HasParam=1
}

if !HasParam
	IfNotExist totalcmd.exe
	{
		MsgBox, ��ȷ��ctotalcmd.exe��totalcmd.exe��ͬĿ¼��
		Return
	}
	else
		Run totalcmd.exe  /O /T 
Return
;����������

Getini(){
	RegRead,inipath,HKCU,Software\Ghisler\Total Commander,IniFileName
	if ErrorLevel
		inipath := A_WorkingDir "\wincmd.ini"
	Return inipath
}

CheckEnv(inipath){
		IfNotExist, %inipath%
		{
			MsgBox,ʹ����ɫ��TC��`n��ô��ȷ�������ļ���ͬĿ¼��:`ntotoalcmd.exe`nctotalcmd.exe`nwincmd.ini
			Return
		}
		IfNotExist, totalcmd.exe
		{
			msgbox,û�з���totalcmd.exe`n��ȷ�������ļ���ͬĿ¼��:`ntotoalcmd.exe`nctotalcmd.exe
			Return
		}
Return true
}

Saveini(inipath){
	loop, %inipath%
		time := A_LoopFileTimeModified
	if ErrorLevel
	{
		msgbox ��ȡwincmd.iniʧ��
		Return	
	}
	IfWinExist, ahk_class TTOTAL_CMD
		isTCExist := 1
	else
	{
		Run,totalcmd.exe
		WinWait, AHK_CLASS TTOTAL_CMD
	}
	PostMessage 1075, 580, 0, , AHK_CLASS TTOTAL_CMD	
	loop{
		loop,%inipath%
			time2 := A_LoopFileTimeModified
		if ErrorLevel
			Continue
		if strlen(time2)!=14
			Continue
		if time2!=%time%
			break
	}
	Return true
}

GetTabs(inipath,LorR){
	Tabs := object()
	IniRead, ActiveTab, %inipath%, %LorR%,path ;��ȡ����ı�ǩ
	IniRead, ActiveTabNum, %inipath%, %LorR%tabs,activetab ;��ȡ�����ǩ�����
	loop
	{
		Index := A_Index - 1
		IniRead, UnActiveTab, %inipath%, %LorR%tabs,%Index%_path ;��ȡ�Ҳ�δ����ı�ǩ
		if UnActiveTab = ERROR
			break	
		Tabs.Insert(UnActiveTab)
	}
	ActiveTabNum+=1
	Tabs.Insert(ActiveTabNum,ActiveTab)
	Return %Tabs%
}

CheckAndActiveTabs(Tabs,LorR,param,ShiftKey){
	loop % Tabs.MaxIndex()
	{
		path :=  Tabs[A_Index]
		IfInString,path,%param%
		{
			if LorR = Left
				TargetNum := 5200 + A_Index
			else
				TargetNum := 5300 + A_Index
			WinActivate, ahk_class TTOTAL_CMD
			PostMessage 1075, %TargetNum%, 0, , AHK_CLASS TTOTAL_CMD	
			Return
		}
	}
	if ShiftKey
		 Run totalcmd.exe  /O /T /R="%param%"
	else
		 Run totalcmd.exe  /O /T /L="%param%"
Return 
}


