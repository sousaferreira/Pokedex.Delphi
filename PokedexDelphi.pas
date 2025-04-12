unit PokedexDelphi;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, REST.Types, REST.Client,
  Data.Bind.Components, Data.Bind.ObjectScope, Vcl.ExtCtrls, Vcl.StdCtrls,System.JSON,System.Net.URLClient,System.Net.HttpClient,
  System.Net.HttpClientComponent, Vcl.Buttons, System.Skia, Vcl.Skia;

type
  TForm2 = class(TForm)
    EditNome: TEdit;
    OpenDialog1: TOpenDialog;
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    Shape4: TShape;
    Shape5: TShape;
    Shape6: TShape;
    Shape7: TShape;
    Shape8: TShape;
    Shape9: TShape;
    Shape10: TShape;
    Shape11: TShape;
    Shape13: TShape;
    Shape12: TShape;
    Shape14: TShape;
    Shape15: TShape;
    ImgPokemon: TImage;
    Shape16: TShape;
    Informações: TMemo;
    Shape17: TShape;
    Panel1: TPanel;
    Shape18: TShape;
    Shape19: TShape;
    Shape20: TShape;
    Shape22: TShape;
    Shape21: TShape;
    Shape23: TShape;
    Shape24: TShape;
    Shape25: TShape;
    Shape26: TShape;
    Shape27: TShape;
    Shape28: TShape;
    Shape29: TShape;
    Shape30: TShape;
    Shape31: TShape;
    Shape32: TShape;
    Shape33: TShape;
    Shape34: TShape;
    Shape35: TShape;
    Shape36: TShape;
    Shape37: TShape;
    Shape38: TShape;
    Shape39: TShape;
    Shape40: TShape;
    Shape41: TShape;
    Shape42: TShape;
    Shape43: TShape;
    Shape44: TShape;


    procedure Button1Click(Sender: TObject);
    private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.Button1Click(Sender: TObject);
var
  PokemonNome: string;
  JsonObj, SpriteObj, TypeObj, AbilityObj: TJSONObject;
  TypesArr, AbilitiesArr: TJSONArray;
  Tipo, Habilidade, Altura, Peso, ImgURL: string;
  Http: TNetHTTPClient;
  ImgStream: TMemoryStream;
begin


  PokemonNome := LowerCase(EditNome.Text); // nome deve ser minúsculo

  RESTClient1.BaseURL := 'https://pokeapi.co/api/v2/pokemon/' + PokemonNome;
  RESTRequest1.Execute;

  if RESTResponse1.StatusCode = 200 then
  begin
    JsonObj := RESTResponse1.JSONValue as TJSONObject;

    // Altura e Peso
    Altura := JsonObj.GetValue<string>('height');
    Peso := JsonObj.GetValue<string>('weight');

    // Tipo
    TypesArr := JsonObj.GetValue('types') as TJSONArray;
    TypeObj := TypesArr.Items[0] as TJSONObject;
    Tipo := TypeObj.GetValue<TJSONObject>('type').GetValue<string>('name');

    // Habilidade
    AbilitiesArr := JsonObj.GetValue('abilities') as TJSONArray;
    AbilityObj := AbilitiesArr.Items[0] as TJSONObject;
    Habilidade := AbilityObj.GetValue<TJSONObject>('ability').GetValue<string>('name');

    // Sprite
    SpriteObj := JsonObj.GetValue('sprites') as TJSONObject;
    ImgURL := SpriteObj.GetValue('front_default').Value;

    // Mostrar imagem do Pokémon
    Http := TNetHTTPClient.Create(nil);
    ImgStream := TMemoryStream.Create;
    try
      Http.Get(ImgURL, ImgStream);
      ImgStream.Position := 0;
      ImgPokemon.Picture.LoadFromStream(ImgStream);
    finally
      ImgStream.Free;
      Http.Free;
    end;

    // Exibir no Memo
    Informações.Clear;
    Informações.Lines.Add('Nome: ' + PokemonNome);
    Informações.Lines.Add('Tipo: ' + Tipo);
    Informações.Lines.Add('Habilidade: ' + Habilidade);
    Informações.Lines.Add('Altura: ' + Altura);
    Informações.Lines.Add('Peso: ' + Peso);
  end
  else
    ShowMessage('Pokémon não encontrado. Verifique o nome e tente novamente.');
end;

end.
