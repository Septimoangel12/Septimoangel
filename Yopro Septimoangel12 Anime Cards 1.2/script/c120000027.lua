--コンバート・コンタクト
function c120000027.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c120000027.condition)
	e1:SetTarget(c120000027.target)
	e1:SetOperation(c120000027.activate)
	c:RegisterEffect(e1)
end
function c120000027.cfilter(c)
	return c:IsType(TYPE_MONSTER)
end
function c120000027.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(c120000027.cfilter,tp,LOCATION_ONFIELD,0,nil)==0 
	and Duel.GetMatchingGroupCount(c120000027.cfilter,tp,0,LOCATION_ONFIELD,nil)>0
end
function c120000027.filter(c)
	return c:IsSetCard(0x1f) and c:IsAbleToGrave()
end
function c120000027.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c120000027.cfilter,tp,0,LOCATION_ONFIELD,nil)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,g:GetCount()*2)
		and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
		and Duel.IsExistingMatchingCard(c120000027.filter,tp,LOCATION_HAND,0,1,nil)
		and Duel.IsExistingMatchingCard(c120000027.filter,tp,LOCATION_DECK,0,1,nil) end
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,g:GetCount()*2)
end
function c120000027.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c120000027.filter,tp,LOCATION_HAND,0,nil)
	local g2=Duel.GetMatchingGroup(c120000027.filter,tp,LOCATION_DECK,0,nil)
	if g1:GetCount()>0 and g2:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg2=g2:Select(tp,1,1,nil)
		sg1:Merge(sg2)
		Duel.SendtoGrave(sg1,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
	local dg=Duel.GetMatchingGroup(c120000027.cfilter,tp,0,LOCATION_ONFIELD,nil)
		Duel.Draw(tp,dg:GetCount()*2,REASON_EFFECT)
	end
end
