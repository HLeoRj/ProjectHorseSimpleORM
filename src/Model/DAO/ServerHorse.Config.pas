unit ServerHorse.Config;

interface

uses
  System.SysUtils,
  ServerHorse.Consts,
  GBJSON.Config,
  GBJSON.Helper,
  DataSet.Serialize.Config, System.JSON;

type

  iServerHorseConfig<T> = interface
    ['{36434654-025F-4E2A-B54E-416B362A9B65}']
    function CaseDefinition(Value: TshCaseDefinition)
      : iServerHorseConfig<T>; overload;
    function CaseDefinition: TshCaseDefinition; overload;

    function GBJSONCaseDefinition: TCaseDefinition;
    function DataSetSerializeCaseDefinition: TCaseNameDefinition;
    procedure JsonObjectToObject(aObj: TObject; aJsonObject: TJSONObject);
  end;

  TServerHorseConfig<T: class, constructor> = class(TInterfacedObject,
    iServerHorseConfig<T>)
  private
    FCaseDefinition: TshCaseDefinition;
  public

    function CaseDefinition(Value: TshCaseDefinition)
      : iServerHorseConfig<T>; overload;
    function CaseDefinition: TshCaseDefinition; overload;

    function GBJSONCaseDefinition: TCaseDefinition;
    function DataSetSerializeCaseDefinition: TCaseNameDefinition;

    procedure JsonObjectToObject(aObj: TObject; aJsonObject: TJSONObject);

    constructor Create;
    destructor Destroy; override;
    class function New: iServerHorseConfig<T>;
  end;

implementation

uses
  GBJSON.Interfaces;

{ TServerHorseConfig }

function TServerHorseConfig<T>.CaseDefinition(Value: TshCaseDefinition)
  : iServerHorseConfig<T>;
begin
  result := Self;
  FCaseDefinition := Value;
end;

function TServerHorseConfig<T>.CaseDefinition: TshCaseDefinition;
begin
  result := FCaseDefinition;
end;

function TServerHorseConfig<T>.DataSetSerializeCaseDefinition
  : TCaseNameDefinition;
begin
  case FCaseDefinition of
    shNone:
      result := cndNone;
    shLower:
      result := cndLower;
    shUpper:
      result := cndUpper;
    shLowerCamelCase:
      result := cndLowerCamelCase;
    shUpperCamelCase:
      result := cndUpperCamelCase;
    shCamelCase:
      result := cndCamelCase;
  end;
end;

function TServerHorseConfig<T>.GBJSONCaseDefinition: TCaseDefinition;
begin
  case FCaseDefinition of
    shNone:
      result := cdNone;
    shLower:
      result := cdLower;
    shUpper:
      result := cdUpper;
    shLowerCamelCase:
      result := cdLowerCamelCase;
    shUpperCamelCase:
      result := cdUpperCamelCase;
    shCamelCase:
      result := cdCamelCase;
  end;
end;

constructor TServerHorseConfig<T>.Create;
begin
  FCaseDefinition := shLower;
end;

destructor TServerHorseConfig<T>.Destroy;
begin

  inherited;
end;

procedure TServerHorseConfig<T>.JsonObjectToObject(aObj: TObject;
  aJsonObject: TJSONObject);
begin
  TGBJSONConfig.GetInstance.CaseDefinition(GBJSONCaseDefinition);
  TGBJSONDefault.Serializer<T>(False).JsonObjectToObject(aObj, aJsonObject);
  aObj.fromJSONObject(aJsonObject);
end;

class function TServerHorseConfig<T>.New: iServerHorseConfig<T>;
begin
  result := Self.Create;
end;

end.
