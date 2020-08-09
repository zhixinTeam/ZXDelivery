unit UGlobal;

interface
  Type TOPType= (otPurYS, otSaleFH);

//获取SubStr在Str中左边的部分字符串，从左起搜索
function GetLeftStr(SubStr, Str: string): string;

//获取SubStr在Str中右边的部分字符串，从左起搜索
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
