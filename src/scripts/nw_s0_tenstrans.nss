//::///////////////////////////////////////////////
//:: Tensor's Transformation
//:: NW_S0_TensTrans.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Gives the caster the following bonuses:
        +1 Attack per 2 levels
        +4 Natural AC
        20 STR and DEX and CON
        1d6 Bonus HP per level
        +5 on Fortitude Saves
        -10 Intelligence
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 26, 2001
//:://////////////////////////////////////////////
//: Sep2002: losing hit-points won't get rid of the rest of the bonuses

#include "x2_inc_spellhook"

void main()
{


  //----------------------------------------------------------------------------
  // GZ, Nov 3, 2003
  // There is a serious problems with creatures turning into unstoppable killer
  // machines when affected by tensors transformation. NPC AI can't handle that
  // spell anyway, so I added this code to disable the use of Tensors by any
  // NPC.
  //----------------------------------------------------------------------------
  if (!GetIsPC(OBJECT_SELF))
  {
      WriteTimestampedLogEntry(GetName(OBJECT_SELF) + "[" + GetTag (OBJECT_SELF) +"] tried to cast Tensors Transformation. Bad! Remove that spell from the creature");
      return;
  }

  /*
    Spellcast Hook Code
      Added 2003-06-23 by GeorgZ
      If you want to make changes to all spells,
      check x2_inc_spellhook.nss to find out more
    */

    if (!X2PreSpellCastCode())
    {
        return;
    }

    // End of Spell Cast Hook


    //Declare major variables
    int nLevel = GetCasterLevel(OBJECT_SELF);
    int nHP, nCnt, nDuration;
    nDuration = GetCasterLevel(OBJECT_SELF);
    int nMeta = GetMetaMagicFeat();
    int i;
    nHP = 0;
    for ( i = 1; i <= nLevel; i++ )
    {
        nHP += d6();
    }
    if ( nMeta == METAMAGIC_MAXIMIZE )
    {
        nHP = nLevel * 6;
    }
    else if(nMeta == METAMAGIC_EXTEND)
    {
        nDuration *= 2;
    }
    int nConstBonus = ( nHP * 2 ) / GetHitDice ( OBJECT_SELF );
    //Declare effects
    effect eAttack = EffectAttackIncrease(nLevel/2);
    effect eSave = EffectSavingThrowIncrease(SAVING_THROW_FORT, 5);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect ePoly = EffectPolymorph(28);
    effect eSwing = EffectModifyAttacks(2);

    //Link effects
    effect eLink = EffectLinkEffects(eAttack, ePoly);

    eLink = EffectLinkEffects(eLink, eSave);
    eLink = EffectLinkEffects(eLink, eDur);
    eLink = EffectLinkEffects(eLink, eSwing);

    effect eHP = EffectTemporaryHitpoints(nHP);

    effect eVis = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);
    //Signal Spell Event
    SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, SPELL_TENSERS_TRANSFORMATION, FALSE));

    ClearAllActions(); // prevents an exploit
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, RoundsToSeconds(nDuration));

    object oHide = GetItemInSlot ( INVENTORY_SLOT_CARMOUR, OBJECT_SELF );
    AddItemProperty ( DURATION_TYPE_PERMANENT,
                      ItemPropertyOnHitCastSpell (IP_CONST_ONHIT_CASTSPELL_ACTIVATE_ITEM, 1 ),
                      oHide );
    AddItemProperty ( DURATION_TYPE_PERMANENT,
                      ItemPropertyAbilityBonus (IP_CONST_ABILITY_CON, nConstBonus ),
                      oHide );
}
