#include "script_component.hpp"

["CAManBase", "init", {
    params ["_unit"];

    // Check if last hit point is our dummy.
    private _allHitPoints = getAllHitPointsDamage _unit param [0, []];
    reverse _allHitPoints;

    if (_allHitPoints param [0, ""] != "ACE_HDBracket") then {
        private _config = [_unit] call CBA_fnc_getObjectConfig;
        if (getText (_config >> "simulation") == "UAVPilot") exitWith {TRACE_1("ignore UAV AI",typeOf _unit);};
        if (getNumber (_config >> "isPlayableLogic") == 1) exitWith {TRACE_1("ignore logic unit",typeOf _unit)};
        ERROR_1("Bad hitpoints for unit type ""%1""",typeOf _unit);
    } else {
        // Calling this function inside curly brackets allows the usage of
        // "exitWith", which would be broken with "HandleDamage" otherwise.
        _unit setVariable [
            QEGVAR(medical,HandleDamageEHID),
            _unit addEventHandler ["HandleDamage", {_this call FUNC(handleDamage)}]
        ];
    };
}, nil, [IGNORE_BASE_UAVPILOTS], true] call CBA_fnc_addClassEventHandler;

#ifdef DEBUG_MODE_FULL
[QEGVAR(medical,woundReceived), {
    params ["_unit", "_woundedHitPoint", "_receivedDamage", "_shooter", "_ammo"];
    TRACE_5("wound",_unit,_woundedHitPoint, _receivedDamage, _shooter, _ammo);
    //systemChat str _this;
}] call CBA_fnc_addEventHandler;
#endif


// this handles moving units into vehicles via load functions or zeus
// needed, because the vanilla INCAPACITATED state does not handle vehicles
["CAManBase", "GetInMan", {
    params ["_unit"];
    if (!local _unit) exitWith {};

    if (lifeState _unit == "INCAPACITATED") then {
        [_unit, true] call FUNC(setUnconsciousAnim);
    };
}] call CBA_fnc_addClassEventHandler;
