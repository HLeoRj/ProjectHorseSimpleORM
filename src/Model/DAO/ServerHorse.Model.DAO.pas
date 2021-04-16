unit ServerHorse.Model.DAO;

interface

uses
  System.SysUtils,
  System.Classes,
  System.JSON,
  REST.JSON,
  Data.DB,
  DataSet.Serialize,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param,
  FireDAC.Stan.Error,
  FireDAC.DatS,
  FireDAC.Phys.Intf,
  FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  SimpleInterface,
  SimpleDAO,
  SimpleAttributes,
  SimpleQueryFiredac,

  ServerHorse.Consts,
  ServerHorse.Settings;

type

  iDAOGeneric<T: class> = interface
    ['{1DAE62A0-0C6E-4FA6-BF9E-2377A25F267C}']
    function Find: TJsonArray; overload;
    function Find(const aID: String): TJsonObject; overload;
    function Insert(const aJsonObject: TJsonObject): TJsonObject;
    function Update(const aJsonObject: TJsonObject): TJsonObject;
    function Delete(aField: String; aValue: String): TJsonObject;
    function DAO: ISimpleDAO<T>;
    function DataSetAsJsonArray: TJsonArray;
    function DataSetAsJsonObject: TJsonObject;
    function DataSetToStream: String;

    function Settings(Value: TshCaseDefinition = shLower): iDAOGeneric<T>;
    function SettingsGBJSON(Value: TshCaseDefinition): iDAOGeneric<T>;
    function SettingsDataSetSerialize(Value: TshCaseDefinition): iDAOGeneric<T>;

  end;

  TDAOGeneric<T: class, constructor> = class(TInterfacedObject, iDAOGeneric<T>)
  private
    FIndexConn: Integer;
    FConn: iSimpleQuery;
    FDAO: ISimpleDAO<T>;
    FDataSource: TDataSource;
    FSettings: iServerHorseSettings<T>;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: iDAOGeneric<T>;
    function Find: TJsonArray; overload;
    function Find(const aID: String): TJsonObject; overload;
    function Insert(const aJsonObject: TJsonObject): TJsonObject;
    function Update(const aJsonObject: TJsonObject): TJsonObject;
    function Delete(aField: String; aValue: String): TJsonObject;
    function DAO: ISimpleDAO<T>;
    function DataSetAsJsonArray: TJsonArray;
    function DataSetAsJsonObject: TJsonObject;
    function DataSetToStream: String;

    function Settings(Value: TshCaseDefinition = shLower): iDAOGeneric<T>;
    function SettingsGBJSON(Value: TshCaseDefinition): iDAOGeneric<T>;
    function SettingsDataSetSerialize(Value: TshCaseDefinition): iDAOGeneric<T>;
  end;

implementation

{ TDAOGeneric<T> }

uses
  ServerHorse.Model.Connection;

constructor TDAOGeneric<T>.Create;
begin
  FDataSource := TDataSource.Create(nil);
  FIndexConn := ServerHorse.Model.Connection.Connected;
  FConn := TSimpleQueryFiredac.New(ServerHorse.Model.Connection.FConnList.Items
    [FIndexConn]);
  FDAO := TSimpleDAO<T>.New(FConn).DataSource(FDataSource);
  FSettings := TServerHorseSettings<T>.New;
end;

function TDAOGeneric<T>.DAO: ISimpleDAO<T>;
begin
  Result := FDAO;
end;

function TDAOGeneric<T>.DataSetAsJsonArray: TJsonArray;
begin
  Result := FDataSource.DataSet.ToJSONArray;
end;

function TDAOGeneric<T>.DataSetAsJsonObject: TJsonObject;
begin
  Result := FDataSource.DataSet.ToJSONObject;
end;

function TDAOGeneric<T>.DataSetToStream: String;
var
  lStream: TStringStream;
  FDMemTable: TFDMemTable;
begin
  lStream := TStringStream.Create;
  FDMemTable := TFDMemTable.Create(nil);
  try
    FDMemTable.Assign(FDataSource.DataSet);
    FDMemTable.SaveToStream(lStream, sfJSON);
    lStream.Position := 0;
    Result := lStream.DataString;
  finally
    lStream.Free;
    FDMemTable.Free;
  end;
end;

function TDAOGeneric<T>.Delete(aField, aValue: String): TJsonObject;
begin
  FDAO.Delete(aField, aValue);
  Result := FDataSource.DataSet.ToJSONObject;
end;

destructor TDAOGeneric<T>.Destroy;
begin
  FDataSource.Free;
  ServerHorse.Model.Connection.Disconnected(FIndexConn);
  inherited;
end;

function TDAOGeneric<T>.Find(const aID: String): TJsonObject;
begin
  FDAO.Find(StrToInt(aID));
  Result := FDataSource.DataSet.ToJSONObject;
end;

function TDAOGeneric<T>.Find: TJsonArray;
var
  ateste: Integer;
  ateste2: string;
begin
  FDAO.Find(False);
  Result := FDataSource.DataSet.ToJSONArray;
end;

class function TDAOGeneric<T>.New: iDAOGeneric<T>;
begin
  Result := Self.Create;
end;

function TDAOGeneric<T>.Settings(Value: TshCaseDefinition = shLower)
  : iDAOGeneric<T>;
begin
  Result := Self;
  FSettings := TServerHorseSettings<T>.New.CaseDefinition(Value);
  SettingsDataSetSerialize(Value);
  SettingsGBJSON(Value);
end;

function TDAOGeneric<T>.SettingsDataSetSerialize(Value: TshCaseDefinition)
  : iDAOGeneric<T>;
begin
  Result := Self;
  TDataSetSerializeConfig.GetInstance.CaseNameDefinition :=
    FSettings.ShorseToDSSerializeCaseDefinition(Value).DSerializeCaseDefinition;
end;

function TDAOGeneric<T>.SettingsGBJSON(Value: TshCaseDefinition)
  : iDAOGeneric<T>;
begin
  Result := Self;
  FSettings.ShorseToGBJSONCaseDefinition(Value);
end;

function TDAOGeneric<T>.Insert(const aJsonObject: TJsonObject): TJsonObject;
var
  aObj: T;
begin
  aObj := T.Create;
  try
    FSettings.JsonObjectToObject(aObj, aJsonObject);
    FDAO.Insert(aObj);
    Result := FDataSource.DataSet.ToJSONObject;
  finally
    aObj.Free;
  end;
end;

function TDAOGeneric<T>.Update(const aJsonObject: TJsonObject): TJsonObject;
var
  aObj: T;
begin
  aObj := T.Create;
  try
    FSettings.JsonObjectToObject(aObj, aJsonObject);
    FDAO.Update(aObj);
    Result := FDataSource.DataSet.ToJSONObject;
  finally
    aObj.Free;
  end;
end;

end.
