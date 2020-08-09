unit UListViewControl;

interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  IdBaseComponent, StdCtrls,ComCtrls, ExtCtrls;

type
  TListViewControl = class
  private
  {}
  public
    class procedure ClearItems(ListView : TListView);
    class procedure AddItem(ListView: TListView;szCaption : string;Items : TStrings);

  end;
implementation

{ TListViewControl }

class procedure TListViewControl.AddItem(ListView: TListView;szCaption : string;
                                          Items: TStrings);
var
  I : Integer;
begin
  for I := 0 to ListView.Items.Count - 1 do
  begin
    if ListView.Items[I].Caption = '' then
    begin
      ListView.Items[I].Caption := szCaption;
      ListView.Items[I].SubItems := Items;
      Break;
    end;
  end;
  if I >= ListView.Items.Count then
  begin
    with ListView.Items.Add do
    begin
      Caption := szCaption;
      SubItems := Items;
    end;
  end;
end;

class procedure TListViewControl.ClearItems(ListView: TListView);
var
  I: Integer;
  J: Integer;
begin
  if ListView = nil then Exit;
  for I := 0 to ListView.Items.Count - 1 do
  begin
    ListView.Items[I].Caption := '';
    for J := 0 to ListView.Columns.Count - 2 do
    begin
      ListView.Items[I].SubItems[J] := '';
    end;
  end;
end;

end.
