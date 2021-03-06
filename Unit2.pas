unit Unit2;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, neTabControl,
  FMX.Controls.Presentation, FMX.TabControl, FMX.Edit, FMX.Menus, FMX.StdCtrls,
  FMX.Layouts, FMX.ListBox, FMX.ScrollBox, FMX.Memo, FMX.Objects;

type
  TForm2 = class(TForm)
    StyleBook1: TStyleBook;
    Button1: TButton;
    Edit1: TEdit;
    Button2: TButton;
    Button3: TButton;
    ListBox1: TListBox;
    Button4: TButton;
    CheckBox1: TCheckBox;
    Button5: TButton;
    Edit2: TEdit;
    Button6: TButton;
    Label1: TLabel;
    GroupBox1: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
    procedure RadioButton1Change(Sender: TObject);
    procedure RadioButton2Change(Sender: TObject);
  private
    procedure UpdateTagList;
    function TestOnBeforeDelete(const AItem: TneTabItem): boolean;
    procedure TestOnAfterDelete(ADeletedItem: TneTabItem; ADeletedFrame: TFrame);
  public
    customNETabContol: TNETabControl;
  end;

var
  Form2: TForm2;

implementation

{$R *.fmx}

uses Unit1, FMX.Styles.Objects,
  Unit3;


procedure GetImageFromResources(const ImageName: string; var Image: TBitMap);
var
  InStream: TResourceStream;
begin
  if trim(ImageName)<>'' then
  begin
    InStream := TResourceStream.Create(HInstance, ImageName, RT_RCDATA);
    try
        Image:=TBitmap.Create;
        Image.Canvas.Bitmap.LoadFromStream(InStream);
    finally
      InStream.Free;
    end;
  end;
end;


procedure TForm2.Button1Click(Sender: TObject);
var
  tmpFrame: TFrame3;
begin
  tmpFrame:=TFrame3.Create(nil);
  tmpFrame.Label1.Text:=Random(10000).ToString;
  customNETabContol.AddTab('Tab '+random(1000).ToString, TFrame(tmpFrame));
  UpdateTagList;
end;

procedure TForm2.UpdateTagList;
var
  i: integer;
  tmpListItem: TListBoxItem;
  tmpList,
  tmpList1: TStringList;
begin
  ListBox1.Clear;
  tmpList:=customNETabContol.GetTabsTags;
  tmpList1:=customNETabContol.GetTabsText;
  for i:=0 to tmpList.Count-1 do
  begin
    tmpListItem:=TListBoxItem.Create(ListBox1);
    tmpListItem.Parent:=ListBox1;
    tmpListItem.Text:=tmpList1.Strings[i]+': '+tmpList.Strings[i];
    tmpListItem.TagString:=tmpList.Strings[i];
    ListBox1.AddObject(tmpListItem);
  end;

  if ListBox1.Count>0 then
    ListBox1.ItemIndex:=0;

  if Assigned(tmpList) then
    tmpList.Free;
  if Assigned(tmpList1) then
    tmpList1.Free;
end;

procedure TForm2.Button2Click(Sender: TObject);
var
  tmpItem: TneTabItem;
  tmpFrame: TFrame3;
begin
  if Trim(Edit1.Text)='' then
    ShowMessage('Empty tag')
  else
  begin
    tmpItem:=TneTabItem.Create(customNETabContol);
    tmpItem.Text:=Trim(Edit1.Text);

    if customNETabContol.TabCount mod 2=0 then
    begin
      tmpItem.CanClose:=true;
    end
    else
      tmpItem.CanClose:=false;

    tmpFrame:=TFrame3.Create(tmpItem);
    tmpFrame.Label1.Text:=Random(10000).ToString;

    customNETabContol.AddTab(Trim(Edit1.Text), tmpItem, TFrame(tmpFrame));
    UpdateTagList;
  end;
end;

procedure TForm2.Button3Click(Sender: TObject);
begin
  if (ListBox1.Count=0) or (ListBox1.ItemIndex=-1) then Exit;
  customNETabContol.SetActiveTab(ListBox1.Selected.TagString);
end;

procedure TForm2.Button4Click(Sender: TObject);
begin
  if (ListBox1.Count=0) or (ListBox1.ItemIndex=-1) then Exit;
  customNETabContol.DeleteTab(ListBox1.Selected.TagString);
  UpdateTagList;
end;

procedure TForm2.Button5Click(Sender: TObject);
var
  tmpFrame: TFrame1;
begin
  tmpFrame:=TFrame1.Create(nil);
  tmpFrame.Label1.Text:=Random(10000).ToString;
  customNETabContol.InsertTab('Tab '+random(1000).ToString,
                          Random(customNETabContol.TabCount), TFrame(tmpFrame));
  UpdateTagList;
end;

procedure TForm2.Button6Click(Sender: TObject);
var
  tmpItem: TneTabItem;
  tmpFrame: TFrame1;
begin
  if Trim(edit2.Text)='' then Edit2.Text:='0';
  if Trim(Edit1.Text)='' then
  begin
    ShowMessage('Empty tag');
    Exit;
  end;

  if Edit2.Text.ToInteger>customNETabContol.TabCount-1 then
    ShowMessage('The index must be smaller than the tab count')
  else
  begin
    tmpItem:=TneTabItem.Create(customNETabContol);
    tmpItem.Text:=Trim(Edit1.Text);

    if customNETabContol.TabCount mod 2=0 then
    begin
      tmpItem.CanClose:=true;
    end
    else
      tmpItem.CanClose:=false;

    tmpFrame:=TFrame1.Create(tmpItem);
    tmpFrame.Label1.Text:=Random(10000).ToString;

    customNETabContol.InsertTab(Trim(Edit1.Text),
                        edit2.Text.ToInteger, tmpitem, TFrame(tmpFrame));
    UpdateTagList;
  end;
end;


procedure TForm2.CheckBox1Change(Sender: TObject);
begin
  if (ListBox1.Count=0) or (ListBox1.ItemIndex=-1) then Exit;
  customNETabContol.GetTab(ListBox1.Selected.TagString).ShowIcon:=
    CheckBox1.IsChecked;
end;

procedure TForm2.FormCreate(Sender: TObject);
var
  tmpPop1, tmpPop2: TPopupMenu;
  tmpPopItem: TMenuItem;
  tmpImage: TBitmap;
begin
  customNETabContol:=TNETabControl.Create(self);
  customNETabContol.Parent:=self;
  customNETabContol.Align:=TAlignLayout.MostTop;
  customNETabContol.Margins.Left:=20;
  customNETabContol.Margins.Right:=20;
  customNETabContol.Margins.Top:=20;
  customNETabContol.Height:=300;
  customNETabContol.OnBeforeDelete:=TestOnBeforeDelete;
  customNETabContol.OnAfterDelete:=TestOnAfterDelete;

  tmpPop1:=TPopupMenu.Create(customNETabContol);
  tmpPopItem:=TMenuItem.Create(tmpPop1);
  tmpPopItem.Text:='Added on';
  tmpPop1.AddObject(tmpPopItem);

  tmpPopItem:=TMenuItem.Create(customNETabContol);
  tmpPopItem.Text:='-';
  tmpPop1.AddObject(tmpPopItem);

  customNETabContol.PopupBeforeDefault:=tmpPop1;

  tmpPop2:=TPopupMenu.Create(customNETabContol);
  tmpPopItem:=TMenuItem.Create(tmpPop2);
  tmpPopItem.Text:='-';
  tmpPop2.AddObject(tmpPopItem);

  tmpPopItem:=TMenuItem.Create(customNETabContol);
  tmpPopItem.text:='After dark';
  tmpPop2.AddObject(tmpPopItem);

  customNETabContol.PopupAfterDefault:=tmpPop2;

  GetImageFromResources('CloseNormal', tmpImage);
  customNETabContol.CloseImageNormal:=tmpImage;
  GetImageFromResources('CloseHover', tmpImage);
  customNETabContol.CloseImageHover:=tmpImage;
  GetImageFromResources('ClosePressed', tmpImage);
  customNETabContol.CloseImagePressed:=tmpImage;

  customNETabContol.HintStyle:=THintStyle.ShowTitle;

  customNETabContol.StyleLookup:='neTabControlStyle';

  RadioButton1.IsChecked:=true;

end;



procedure TForm2.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Single);
begin
  Label1.Text:='X: '+X.ToString+' - Y: '+Y.ToString;
end;

procedure TForm2.RadioButton1Change(Sender: TObject);
begin
  if RadioButton1.IsChecked then
    customNETabContol.HintStyle:=THintStyle.ShowTitle;
end;

procedure TForm2.RadioButton2Change(Sender: TObject);
begin
  if RadioButton2.IsChecked then
    customNETabContol.HintStyle:=THintStyle.ShowPreview;
end;

procedure TForm2.TestOnAfterDelete(ADeletedItem: TneTabItem; ADeletedFrame: TFrame);
begin
  if Assigned(ADeletedItem) then
  begin
    ShowMessage('Item deleted: '+ADeletedItem.Text);
    ADeletedItem.Free;

    if Assigned(ADeletedFrame) then
      ShowMessage('Label: '+TFrame3(ADeletedFrame).Label1.Text);
  end;
end;

function TForm2.TestOnBeforeDelete(const AItem: TneTabItem): boolean;
begin
  inherited;

  ShowMessage('On before delete');
  result:=true;
end;

end.
