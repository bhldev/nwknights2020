//::///////////////////////////////////////////////
//:: Heal
//:: [NW_S0_Heal.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Heals the target to full unless they are undead.
//:: If undead they reduced to 1d4 HP.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 12, 2001
//:://////////////////////////////////////////////
//:: Update Pass By: Preston W, On: Aug 1, 2001

#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"
void main()
{
    if (!X2PreSpellCastCode())
    {
        return;
    }
    // End of Spell Cast Hook

  //if the caster has invisibility(any type) on it, it will be removed.
  removeInvisibilitySpell(OBJECT_SELF);

  //Declare major variables
  int nCasterLevel = GetCasterLevel (OBJECT_SELF) * 5;
  object oTarget = GetSpellTargetObject();
  effect eKill, eHeal;
  int nDamage, nHeal, nModify, nMetaMagic, nTouch;
  effect eSun = EffectVisualEffect(VFX_IMP_SUNSTRIKE);
  effect eHealVis = EffectVisualEffect(VFX_IMP_HEALING_X);
    //Check to see if the target is an undead
    if (GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
    {
        if(!GetIsReactionTypeFriendly(oTarget))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_HEAL));
            //Make a touch attack
            if (TouchAttackMelee(oTarget))
            {
                //Make SR check
                if (!MyResistSpell(OBJECT_SELF, oTarget))
                {
                    //Roll damage
                    nModify = d4();
                    nMetaMagic = GetMetaMagicFeat();
                    //Make metamagic check
                    if (nMetaMagic == METAMAGIC_MAXIMIZE)
                    {
                        nModify = 1;
                    }
                    //Figure out the amount of damage to inflict
                    nDamage =  GetCurrentHitPoints(oTarget) - nModify;
                    //Set damage
                    eKill = EffectDamage(nDamage, DAMAGE_TYPE_POSITIVE);
                    //Apply damage effect and VFX impact
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eKill, oTarget);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eSun, oTarget);
                }
            }
        }
    }
    else
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_HEAL, FALSE));
        //Figure out how much to heal
        nHeal = nCasterLevel;
        //Set the heal effect
        eHeal = EffectHeal(nHeal);
        //Apply the heal effect and the VFX impact
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eHealVis, oTarget);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);
    }




}
