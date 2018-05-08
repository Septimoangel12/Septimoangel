--Vain－裏切りの嘲笑
function c120000129.initial_effect(c)
	--To Grave
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_RECOVER+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_BATTLE_PHASE)
	e1:SetCondition(c120000129.condition)
	e1:SetTarget(c120000129.target)
	e1:SetOperation(c120000129.operation)
	c:RegisterEffect(e1)
end
c120000129.collection={
	[33725002]=true;[66970002]=true;[511004118]=true;[511004119]=true;[511004120]=true;[111009401]=true;
}
function c120000129.condition(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at and c120000129.collection[at:GetCode()]
end
function c120000129.filter(c)
	return c120000129.collection[c:GetCode()] and c:IsAbleToGrave()
end
function c120000129.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c120000129.filter,tp,0,LOCATION_DECK,1,nil) end
	local sg=Duel.GetMatchingGroup(c120000129.filter,tp,0,LOCATION_DECK,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,sg,sg:GetCount(),0,0)
end
function c120000129.sgfilter(c,p)
	return c120000129.collection[c:GetCode()] and c:IsLocation(LOCATION_GRAVE) and c:IsControler(p)
end
function c120000129.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Duel.GetMatchingGroup(c120000129.filter,tp,0,LOCATION_DECK,nil)
	if Duel.SendtoGrave(sg,REASON_EFFECT)>0 then
	local og=Duel.GetOperatedGroup()
	local ct=og:FilterCount(c120000129.sgfilter,nil,1-tp)
	if ct>0 then
	 Duel.Recover(tp,ct*500,REASON_EFFECT)
	 Duel.ShuffleDeck(1-tp)
	 Duel.DiscardDeck(1-tp,ct*5,REASON_EFFECT)
		end
	end 
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e2:SetTarget(c120000129.tg)
	c:RegisterEffect(e2)
	--cannot attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_ATTACK)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e3:SetTarget(c120000129.tg)
	c:RegisterEffect(e3)
end
function c120000129.tg(e,c)
	return c120000129.collection[c:GetCode()]
end
