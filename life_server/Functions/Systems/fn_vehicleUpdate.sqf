/*
	File: fn_vehicleUpdate.sqf
	Author : NiiRoZz

	Description:
	Tells the database that this vehicle need update inventory.
*/
private["_vehicle","_plate","_uid","_query","_sql","_dbInfo","_thread"];
_vehicle = [_this,0,ObjNull,[ObjNull]] call BIS_fnc_param;
_mode = [_this,1,1,[0]] call BIS_fnc_param;
if(isNull _vehicle) exitWith {}; //NULL
_ressourceItems = ["oil_unprocessed","oil_processed","copper_unrefined","copper_refined","iron_unrefined","iron_refined","salt_unrefined","salt_refined","sand","glass","diamond_uncut","diamond_cut","rock","cement","heroin_unprocessed","heroin_processed","cannabis","marijuana","cocaine_unprocessed","cocaine_processed","turtle_raw"];

_dbInfo = _vehicle getVariable["dbInfo",[]];
if(count _dbInfo == 0) exitWith {};
_uid = _dbInfo select 0;
_plate = _dbInfo select 1;
switch (_mode) do {
	case 1: {
		_vehItems = getItemCargo _vehicle;
		_vehMags = getMagazineCargo _vehicle;
		_vehWeapons = getWeaponCargo _vehicle;
		_vehBackpacks = getBackpackCargo _vehicle;
		_cargo = [_vehItems,_vehMags,_vehWeapons,_vehBackpacks];
		_cargo = [_cargo] call DB_fnc_mresArray;
		_query = format["UPDATE vehicles SET gear='%3' WHERE pid='%1' AND plate='%2'",_uid,_plate,_cargo];
		_thread = [_query,1] call DB_fnc_asyncCall;
	};

	case 2: {
		_trunk = _vehicle getVariable["Trunk",[[],0]];
		_trunk2 = _trunk select 0;
		{
			_itemName = _x select 0;
			if(_itemName in _ressourceItems) then	{
				_trunk2 set [_forEachIndex,666];
			};
		} forEach _trunk2;
		_trunk2 = _trunk2 - [666];
		_trunk set [0, _trunk2];
		_trunk = [_trunk] call DB_fnc_mresArray;
		_query = format["UPDATE vehicles SET inventory='%3' WHERE pid='%1' AND plate='%2'",_uid,_plate,_trunk];
		_thread = [_query,1] call DB_fnc_asyncCall;
	};
};
