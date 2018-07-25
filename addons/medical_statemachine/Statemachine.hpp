// Manual transitions applied to this statemachine
//  - medical_fnc_handleRespawn:18
class ACE_Medical_StateMachine {
    list = "allUnits select {local _x}";
    skipNull = 1;

    class Default {
        onState = QFUNC(handleStateDefault);
        class Injury {
            targetState = "Injured";
            events[] = {QEGVAR(medical,Injury)};
        };
        class CriticalInjuryOrVitals {
            targetState = "Unconscious";
            events[] = {QEGVAR(medical,CriticalInjury), QEGVAR(medical,CriticalVitals), QEGVAR(medical,knockOut)};
        };
        class FatalVitals {
            targetState = "CardiacArrest";
            events[] = {QEGVAR(medical,FatalVitals)};
        };
        class FatalInjury {
            targetState = "FatalInjury";
            events[] = {QEGVAR(medical,FatalInjury)};
        };
    };
    class Injured {
        onState = QFUNC(handleStateInjured);
        class FullHeal {
            targetState = "Default";
            events[] = {QEGVAR(medical,FullHeal)};
        };
        class CriticalInjuryOrVitals {
            targetState = "Unconscious";
            events[] = {QEGVAR(medical,CriticalInjury), QEGVAR(medical,CriticalVitals), QEGVAR(medical,knockOut)};
        };
        class FatalVitals {
            targetState = "CardiacArrest";
            events[] = {QEGVAR(medical,FatalVitals)};
        };
        class FatalInjury {
            targetState = "FatalInjury";
            events[] = {QEGVAR(medical,FatalInjury)};
        };
    };
    class Unconscious {
        onState = QFUNC(handleStateUnconscious);
        onStateEntered = QUOTE([ARR_2(_this,(true))] call EFUNC(medical_status,setUnconsciousStatemachine));
        class DeathAI {
            targetState = "Dead";
            condition = QUOTE(!isPlayer _this && {EGVAR(medical,unconsciousConditionAI)});
        };
        class WakeUp {
            targetState = "Injured";
            condition = QEFUNC(medical_status,hasStableVitals);
            events[] = {QEGVAR(medical,WakeUp)};
            onTransition = QUOTE([ARR_2(_this,(false))] call EFUNC(medical_status,setUnconsciousStatemachine));
        };
        class FatalTransitions {
            targetState = "CardiacArrest";
            events[] = {QEGVAR(medical,FatalVitals)};
        };
        class FatalInjury {
            targetState = "FatalInjury";
            events[] = {QEGVAR(medical,FatalInjury)};
        };
    };
    class FatalInjury {
        // Transition state for handling instant death
        // This state raises the next transition in the same frame
        onStateEntered = QFUNC(enteredStateFatalInjury);
        class DeathAI {
            events[] = {QEGVAR(medical,FatalInjuryInstantTransition)};
            targetState = "Dead";
            condition = QUOTE(!isPlayer _this && {EGVAR(medical,fatalInjuryConditionAI)});
        };
        class SecondChance {
            events[] = {QEGVAR(medical,FatalInjuryInstantTransition)};
            targetState = "CardiacArrest";
            condition = QUOTE(EGVAR(medical,fatalInjuryCondition) > 0);
            onTransition = QFUNC(transitionSecondChance);
        };
        class Death {
            events[] = {QEGVAR(medical,FatalInjuryInstantTransition)};
            targetState = "Dead";
            condition = "true";
        };
    };
    class CardiacArrest {
        onStateEntered = QFUNC(enteredStateCardiacArrest);
        onStateLeaving = QFUNC(leftStateCardiacArrest);
        class DeathAI {
            targetState = "Dead";
            condition = QUOTE(!isPlayer _this && {EGVAR(medical,fatalInjuryConditionAI)});
        };
        class Timeout {
            targetState = "Dead";
            condition = QFUNC(conditionCardiacArrestTimer);
        };
        class Reanimation {
            targetState = "Unconscious";
            events[] = {QEGVAR(medical,CPRSucceeded)};
        };
        class Execution {
            targetState = "Dead";
            condition = QFUNC(conditionExecutionDeath);
            events[] = {QEGVAR(medical,FatalInjury)};
        };
    };
    class Dead {
        // When the unit is killed it's no longer handled by the statemachine
        onStateEntered = QFUNC(enteredStateDeath);
    };
};
