#include "script_component.hpp"

[QEGVAR(medical,injured), {
    params ["_unit", "_painLevel"];
    [_unit, "hit", PAIN_TO_SCREAM(_painLevel)] call FUNC(playInjuredSound);
}] call CBA_fnc_addEventHandler;

[QEGVAR(medical,moan), {
    params ["_unit", "_painLevel"];
    [_unit, "moan", PAIN_TO_MOAN(_painLevel)] call FUNC(playInjuredSound);
}] call CBA_fnc_addEventHandler;

if (!hasInterface) exitWith {};

GVAR(nextFadeIn) = 0;
GVAR(heartBeatEffectRunning) = false;

[false] call FUNC(initEffects);
[LINKFUNC(handleEffects), 1, []] call CBA_fnc_addPerFrameHandler;

["ace_unconscious", {
    params ["_unit", "_unconscious"];

    if (_unit != ACE_player) exitWith {};

    // Toggle unconscious player's ability to talk in radio addons
    if (["task_force_radio"] call EFUNC(common,isModLoaded)) then {
        _unit setVariable ["tf_voiceVolume", [1, 0] select _unconscious, true];
        _unit setVariable ["tf_unable_to_use_radio", _unconscious]; // Only used locally
    };
    if (["acre_main"] call EFUNC(common,isModLoaded)) then {
        _unit setVariable ["acre_sys_core_isDisabled", _unconscious, true];
    };
    // Greatly reduce player's hearing ability while unconscious (affects radio addons)
    [QUOTE(ADDON), VOL_UNCONSCIOUS, _unconscious] call EFUNC(common,setHearingCapability);

    [_unconscious, 1] call FUNC(effectUnconscious);
    ["unconscious", _unconscious] call EFUNC(common,setDisableUserInputStatus);
}] call CBA_fnc_addEventHandler;

// Reset volume upon death for spectators
[QEGVAR(medical,death), {
    params ["_unit"];

    if (_unit != ACE_player) exitWith {};
    if (["task_force_radio"] call EFUNC(common,isModLoaded)) then {
        _unit setVariable ["tf_voiceVolume", 1, true];
        _unit setVariable ["tf_unable_to_use_radio", false];
    };
    if (["acre_main"] call EFUNC(common,isModLoaded)) then {
        _unit setVariable ["acre_sys_core_isDisabled", false, true];
    };
    [QUOTE(ADDON), 1, false] call EFUNC(common,setHearingCapability);
}] call CBA_fnc_addEventHandler;

// Update effects to match new unit's current status (this also handles respawn)
["unit", {
    params ["_new"];

    private _status = _new getVariable ["ace_unconscious", false];

    if (["task_force_radio"] call EFUNC(common,isModLoaded)) then {
        _new setVariable ["tf_voiceVolume", [1, 0] select _status, true];
        _new setVariable ["tf_unable_to_use_radio", _status];
    };
    if (["acre_main"] call EFUNC(common,isModLoaded)) then {
        _new setVariable ["acre_sys_core_isDisabled", _status, true];
    };
    [QUOTE(ADDON), VOL_UNCONSCIOUS, _status] call EFUNC(common,setHearingCapability);
    [_status, 0] call FUNC(effectUnconscious);
    ["unconscious", _status] call EFUNC(common,setDisableUserInputStatus);
}] call CBA_fnc_addPlayerEventHandler;


// Kill vanilla bleeding feedback effects.
#ifdef DISABLE_VANILLA_DAMAGE_EFFECTS
TRACE_1("disabling vanilla bleeding feedback effects",_this);
[{
    {isNil _x} count [
        "BIS_fnc_feedback_damageCC",
        "BIS_fnc_feedback_damageRadialBlur",
        "BIS_fnc_feedback_damageBlur"
    ] == 0
}, {
    {
        ppEffectDestroy _x;
    } forEach [
        BIS_fnc_feedback_damageCC,
        BIS_fnc_feedback_damageRadialBlur,
        BIS_fnc_feedback_damageBlur
    ];
}] call CBA_fnc_waitUntilAndExecute;
#endif
