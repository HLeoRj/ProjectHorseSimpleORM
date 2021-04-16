unit ServerHorse.Settings;

interface

uses
  System.SysUtils,
  System.JSON,
  ServerHorse.Consts,

  GBJSON.Interfaces,
  GBJSON.Config,
  GBJSON.Helper,

  DataSet.Serialize.Config;

type

  iServerHorseSettings<T> = interface
    ['{36434654-025F-4E2A-B54E-416B362A9B65}']
    function CaseDefinition(Value: TshCaseDefinition)
      : iServerHorseSettings<T>; overload;
    function CaseDefinition: TshCaseDefinition; overload;
    function GBJSONCaseDefinition: TCaseDefinition;
    function DSerializeCaseDefinition: TCaseNameDefinition;

    function ShorseToDSSerializeCaseDefinition(Value: TshCaseDefinition)
      : iServerHorseSettings<T>;
    function ShorseToGBJSONCaseDefinition(Value: TshCaseDefinition)
      : iServerHorseSettings<T>;
    procedure JsonObjectToObject(aObj: TObject; aJsonObject: TJSONObject);

  end;

  TServerHorseSettings<T: class, constructor> = class(TInterfacedObject,
    iServerHorseSettings<T>)
  private
    fCaseDefinition: TshCaseDefinition;
    fGCaseDefinition: TCaseDefinition;
    fDSCaseDefinition: TCaseNameDefinition;
  public

    function CaseDefinition(Value: TshCaseDefinition)
      : iServerHorseSettings<T>; overload;
    function CaseDefinition: TshCaseDefinition; overload;

    function GBJSONCaseDefinition: TCaseDefinition;
    function ShorseToGBJSONCaseDefinition(Value: TshCaseDefinition)
      : iServerHorseSettings<T>;

    function DSerializeCaseDefinition: TCaseNameDefinition;
    function ShorseToDSSerializeCaseDefinition(Value: TshCaseDefinition)
      : iServerHorseSettings<T>;

    procedure JsonObjectToObject(aObj: TObject; aJsonObject: TJSONObject);

    constructor Create;
    destructor Destroy; override;
    class function New: iServerHorseSettings<T>;
  end;

implementation

{ TServerHorseConfig }

function TServerHorseSettings<T>.CaseDefinition(Value: TshCaseDefinition)
  : iServerHorseSettings<T>;
begin
  result := Self;
  fCaseDefinition := Value;
  ShorseToGBJSONCaseDefinition(Value);
  ShorseToDSSerializeCaseDefinition(Value);
end;

function TServerHorseSettings<T>.CaseDefinition: TshCaseDefinition;
begin
  result := fCaseDefinition;
end;

constructor TServerHorseSettings<T>.Create;
begin
  fCaseDefinition := shLower;
  fDSCaseDefinition := cndUpperCamelCase;
  fGCaseDefinition := cdLower;
end;

destructor TServerHorseSettings<T>.Destroy;
begin

  inherited;
end;

procedure TServerHorseSettings<T>.JsonObjectToObject(aObj: TObject;
  aJsonObject: TJSONObject);
begin
  TGBJSONConfig.GetInstance.CaseDefinition(fGCaseDefinition);
  TGBJSONDefault.Serializer<T>(False).JsonObjectToObject(aObj, aJsonObject);
  aObj.fromJSONObject(aJsonObject);
end;

class function TServerHorseSettings<T>.New: iServerHorseSettings<T>;
begin
  result := Self.Create;
end;

function TServerHorseSettings<T>.DSerializeCaseDefinition: TCaseNameDefinition;
begin
  result := fDSCaseDefinition;
end;

function TServerHorseSettings<T>.GBJSONCaseDefinition: TCaseDefinition;
begin
  result := fGCaseDefinition;
end;

function TServerHorseSettings<T>.ShorseToDSSerializeCaseDefinition
  (Value: TshCaseDefinition): iServerHorseSettings<T>;
begin
  result := Self;
  fDSCaseDefinition := TCaseNameDefinition(Value);

  { fGCaseDefinition: TCaseDefinition;
    fDSCaseDefinition: TCaseNameDefinition; }
  { case Value of
    shNone:
    fDSCaseDefinition := TCaseNameDefinition(Value); // cndNone;
    shLower:
    fDSCaseDefinition := cndLower;
    shUpper:
    fDSCaseDefinition := cndUpper;
    shLowerCamelCase:
    fDSCaseDefinition := cndLowerCamelCase;
    shUpperCamelCase:
    fDSCaseDefinition := cndUpperCamelCase;
    end; }
end;

function TServerHorseSettings<T>.ShorseToGBJSONCaseDefinition
  (Value: TshCaseDefinition): iServerHorseSettings<T>;
begin
  result := Self;
  fGCaseDefinition := TCaseDefinition(Value);
  { case Value of
    shNone:
    fGCaseDefinition := cdNone;
    shLower:
    fGCaseDefinition := cdLower;
    shUpper:
    fGCaseDefinition := cdUpper;
    shLowerCamelCase:
    fGCaseDefinition := cdLowerCamelCase;
    shUpperCamelCase:
    fGCaseDefinition := cdUpperCamelCase;
    end; }
end;

end.
