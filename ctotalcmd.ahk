Loop, %0%  ;��ÿ������ִ��һ�Σ�
{
    param := %A_Index%
    If param not contains ::{,.tib
     Run totalcmd.exe  /O /T /L="%param%"
    Else
     Run Explorer.exe %param%
;    MsgBox, 4,, �� %A_Index% �������� %param%��������
;    IfMsgBox, No
;        break
	p=1
}
	if !p
    	Run totalcmd.exe  /O /T 
