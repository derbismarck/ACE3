/*
 * Author: BaerMitUmlaut
 * Handles the blood volume effect.
 *
 * Arguments:
 * 0: Enable <BOOL>
 * 1: Intensity <NUMBER>
 *
 * Return Value:
 * None
 */
#include "script_component.hpp"
params ["_enable", "_intensity"];

if ((!_enable) || {_intensity == 0}) exitWith {
    GVAR(ppBloodVolume) ppEffectEnable false;
};
GVAR(ppBloodVolume) ppEffectEnable true;
GVAR(ppBloodVolume) ppEffectAdjust [1, 1, 0, [0, 0, 0, 0],  [1, 1, 1, 1 - _intensity],  [0.2, 0.2, 0.2, 0]];
GVAR(ppBloodVolume) ppEffectCommit 1;
