#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"ace_common"};
        author = ECSTRING(common,ACETeam);
        authors[] = {"Glowbal", "KoffeinFlummi","Arcanum417"};
        url = ECSTRING(main,URL);
        VERSION_CONFIG;
    };
};

#include "ACE_Settings.hpp"
#include "CfgEventHandlers.hpp"
#include "CfgVehicles.hpp"
