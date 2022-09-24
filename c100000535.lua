--神々の黄昏
function c100000535.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100000535,4))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c100000535.condition)
	e1:SetTarget(c100000535.target)
	e1:SetOperation(c100000535.operation)
	c:RegisterEffect(e1)
end
c100000535.listed_names={CARD_DARK_MAGICIAN,92377303,CARD_DARK_MAGICIAN_GIRL,30208479}
function c100000535.cfilter(c)
	return c:IsFaceup() and c:IsCode(table.unpack(c100000535.listed_names))
end
function c100000535.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c100000535.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,nil)
end
function c100000535.dfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsDestructable()
end
function c100000535.rmfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove() and (c:IsLocation(LOCATION_DECK+LOCATION_HAND) or aux.SpElimFilter(c))
end
function c100000535.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100000535.dfilter,tp,0,LOCATION_ONFIELD,1,nil) 
		and Duel.IsExistingMatchingCard(c100000535.rmfilter,tp,0x13,0,1,nil) end
	local rg=Duel.GetMatchingGroup(c100000535.rmfilter,tp,0x13,0,nil)
	local sg=Duel.GetMatchingGroup(c100000535.dfilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,rg,#rg,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,#sg,0,0)
end
function c100000535.operation(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c100000535.rmfilter,tp,0x13,0,nil)
	if Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)>0 then
		local dg=Duel.GetMatchingGroup(c100000535.dfilter,tp,0,LOCATION_ONFIELD,nil)
		Duel.Destroy(dg,REASON_EFFECT)
	end
end