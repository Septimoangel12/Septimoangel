--投下交換
--Coded by Lyris
function c511007030.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c511007030.cost)
	e1:SetOperation(c511007030.operation)
	c:RegisterEffect(e1)
end
function c511007030.cfilter1(c,e,tp)
	return c:IsFaceup() and c:IsAbleToGraveAsCost() and Duel.IsExistingMatchingCard(c511007030.cfilter2,tp,LOCATION_MZONE,0,1,c,e,tp,c:GetLevel())
end
function c511007030.cfilter2(c,e,tp,lv)
	return c:IsFaceup() and c:IsAbleToGraveAsCost() and Duel.IsExistingMatchingCard(c511007030.filter,tp,LOCATION_HAND,0,1,nil,e,tp,lv+c:GetLevel())
end
function c511007030.filter(c,e,tp,lv)
	return c:GetLevel()==lv and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c511007030.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(c511007030.cfilter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	local g1=Duel.SelectMatchingCard(tp,c511007030.cfilter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	local tc=g1:GetFirst()
	local lv=tc:GetLevel()
	local g2=Duel.SelectMatchingCard(tp,c511007030.cfilter2,tp,LOCATION_MZONE,0,1,1,tc,e,tp,lv)
	e:SetLabel(lv+g2:GetFirst():GetLevel())
	g1:Merge(g2)
	Duel.SendtoGrave(g1,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c511007030.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local lv=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c511007030.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp,lv)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end