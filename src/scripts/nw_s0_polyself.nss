//::///////////////////////////////////////////////
//:: Polymorph Self
//:: NW_S0_PolySelf.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The PC is able to changed their form to one of
    several forms.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 21, 2002
//:://////////////////////////////////////////////

#include "x2_inc_spellhook"
void main()
{
    if (!X2PreSpellCastCode())
    {
        return;
    }
    // End of Spell Cast Hook
    //Declare major variables
    int nSpell = GetSpellId();
    object oTarget = GetSpellTargetObject();
    effect eVis = EffectVisualEffect(VFX_IMP_POLYMORPH);
    effect ePoly;
    int nPoly;
    int nMetaMagic = GetMetaMagicFeat();
    int nDuration = GetCasterLevel(OBJECT_SELF);
    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2; //Duration is +100%
    }

    //Determine Polymorph subradial type
    if(nSpell == 387)
    {
        nPoly = POLYMORPH_TYPE_GIANT_SPIDER;

    }
    else if (nSpell == 388)
    {
     nPoly = POLYMORPH_TYPE_TROLL;

    }
    else if (nSpell == 389)
    {
        nPoly = POLYMORPH_TYPE_UMBER_HULK;

    }
    else if (nSpell == 390)
    {
      nPoly = POLYMORPH_TYPE_PIXIE;

    }
    else if (nSpell == 391)
    {
       nPoly = POLYMORPH_TYPE_ZOMBIE;

    }
    ePoly = EffectPolymorph(nPoly);
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_POLYMORPH_SELF, FALSE));

    //Apply the VFX impact and effects
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePoly, oTarget, RoundsToSeconds(nDuration));

    object oHide = GetItemInSlot ( INVENTORY_SLOT_CARMOUR, oTarget );
    AddItemProperty ( DURATION_TYPE_PERMANENT,
                      ItemPropertyOnHitCastSpell (IP_CONST_ONHIT_CASTSPELL_ACTIVATE_ITEM, 1 ),
                      oHide );
}

