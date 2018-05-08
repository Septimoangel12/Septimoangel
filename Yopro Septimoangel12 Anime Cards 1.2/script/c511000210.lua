--強制召喚
function c511000210.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511000210.target)
	e1:SetOperation(c511000210.activate)
	c:RegisterEffect(e1)
end
function c511000210.cfilter(c,e,tp)
	local rc=c:GetRace()
	return Duel.IsExistingMatchingCard(c511000210.spfilter,tp,0,LOCATION_DECK,1,nil,rc,e,tp)
end
function c511000210.spfilter(c,rc,e,tp)
	return c:IsRace(rc)
end
function c511000210.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c511000210.cfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c511000210.cfilter,1-tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,0,0)
end
function c511000210.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.SelectMatchingCard(tp,c511000210.cfilter,tp,0,LOCATION_MZONE,1,1,rc,nil)
	if tc:GetCount()>0 then
	local ft=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	if ft<=0 then return end
	local c=e:GetHandler()
	local rc=tc:GetFirst():GetRace()
	local sg=Duel.GetMatchingGroup(c511000210.spfilter,tp,0,LOCATION_DECK,nil,rc,e,tp)
	if sg:GetCount()<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=sg:Select(1-tp,ft,ft,nil)
	local tc=g:GetFirst()
	while tc do
		if Duel.SpecialSummonStep(tc,0,1-tp,1-tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
	Duel.SpecialSummonComplete()
		end
	end
end