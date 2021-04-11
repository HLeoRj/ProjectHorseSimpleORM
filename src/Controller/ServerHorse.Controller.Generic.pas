unit ServerHorse.Controller.Generic;

interface

uses
  ServerHorse.Consts,
  ServerHorse.Model.DAO,
  ServerHorse.Controller.Interfaces;

type
  TControllerGeneric<T : class, constructor> = class(TInterfacedObject, iControllerEntity<T>)
    private
      FModel : iDAOGeneric<T>;
      [weak]
      FParent : iController;
    public
      constructor Create(Parent : iController);
      destructor Destroy; override;
      class function New(Parent : iController) : iControllerEntity<T>;
      function This : iDAOGeneric<T>;
      function Settings(Value: TshCaseDefinition = shLower): iDAOGeneric<T>;
      function &End : iController;
  end;

implementation

{ TControllerUSERS }

function TControllerGeneric<T>.&End: iController;
begin
  Result := FParent;
end;

constructor TControllerGeneric<T>.Create(Parent : iController);
begin
  FParent := Parent;
  FModel := TDAOGeneric<T>.New;
end;

destructor TControllerGeneric<T>.Destroy;
begin

  inherited;
end;

class function TControllerGeneric<T>.New(Parent : iController): iControllerEntity<T>;
begin
    Result := Self.Create(Parent);
end;

function TControllerGeneric<T>.This: iDAOGeneric<T>;
begin
  Result := FModel;
end;

function TControllerGeneric<T>.Settings(Value: TshCaseDefinition): iDAOGeneric<T>;
begin
  Result := FModel.Settings(Value);
end;

end.
