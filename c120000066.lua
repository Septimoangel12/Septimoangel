--地縛霊の誘い
function c120000066.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(120000066,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMING_BATTLE_START+TIMING_BATTLE_END)
	e1:SetCondition(c120000066.condition1)
	e1:SetTarget(c120000066.target1)
	e1:SetOperation(c120000066.activate1)
	c:RegisterEffect(e1)
end
function c120000066.condition1(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer() and (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<PHASE_BATTLE)
end
function c120000066.filter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsPosition(POS_FACEUP_ATTACK) or c:IsHasEffect(EFFECT_DEFENSE_ATTACK) and c:GetFlagEffect(120000066)==0 
		and c:CanAttack()
end
function c120000066.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	local at=Duel.GetAttacker()
	if chk==0 then return Duel.IsExistingTarget(c120000066.filter1,tp,0,LOCATION_ONFIELD,1,nil)
    and Duel.IsExistingTarget(Card.IsType,tp,LOCATION_ONFIELD,0,1,nil,TYPE_MONSTER) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local g1=Duel.SelectTarget(tp,c120000066.filter1,tp,0,LOCATION_ONFIELD,1,1,nil,at)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTACKTARGET)
	local g2=Duel.SelectTarget(tp,Card.IsType,tp,LOCATION_ONFIELD,0,1,1,nil,TYPE_MONSTER)
end
function c120000066.activate1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	local c1=tg:GetFirst()
	local c2=tg:GetNext()
	if tg:GetCount()==2 and c1 and c2 and c2:IsPosition(POS_FACEUP_ATTACK) or c2:IsHasEffect(EFFECT_DEFENSE_ATTACK) and c1:IsRelateToEffect(e) and c2:IsRelateToEffect(e) 
	and c2:CanAttack() and not c1:IsImmuneToEffect(e) then
		Duel.CalculateDamage(c2,c1)	
	end
end
