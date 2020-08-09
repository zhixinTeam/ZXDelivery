unit UGlobal;

interface
  Type TOPType= (otPurYS, otSaleFH);

//��ȡSubStr��Str����ߵĲ����ַ���������������
function GetLeftStr(SubStr, Str: string): string;

//��ȡSubStr��Str���ұߵĲ����ַ���������������
function GetRightStr(SubStr, Str: string): string;


var
  gOPType : TOPType;


implementation


function GetLeftStr(SubStr, Str: string): string;
begin
   Result := Copy(Str, 1, Pos(SubStr, Str) - 1);
end;
//-------------------------------------------

function GetRightStr(SubStr, Str: string): string;
var
   i: integer;
begin
   i := pos(SubStr, Str);
   if i > 0 then
     Result := Copy(Str
       , i + Length(SubStr)
       , Length(Str) - i - Length(SubStr) + 1)
   else
     Result := '';
end;


end.
