#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"ace_medical_treatment", "ace_interact_menu"};
        author = ECSTRING(common,ACETeam);
        authors[] = {"Glowbal"};
        url = ECSTRING(main,URL);
        VERSION_CONFIG;
    };
};

#include "CfgEventHandlers.hpp"
#include "ui\menu.hpp"
#include "ACE_Settings.hpp"
#include "CfgVehicles.hpp"
#include "ui\ui\RscTitles.hpp"
#include "ui\ui\CfgInGameUI.hpp"
#include "ui\ui\triagecard.hpp"
