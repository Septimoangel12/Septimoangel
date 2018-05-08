--仲裁の代償
function c511002404.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c511002404.condition)
	e1:SetTarget(c511002404.target)
	e1:SetOperation(c511002404.activate)
	c:RegisterEffect(e1)
end
function c511002404.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp) and Duel.GetLocationCount(1-tp,LOCATION_SZONE)>=3 or Duel.GetLocationCount(1-tp,LOCATION_MZONE)>=3
end
function c511002404.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_GRAVE,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,2,0,0)
end
function c511002404.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_GRAVE,nil)
	local select=2
	if g:GetCount()>0 and Duel.GetLocationCount(1-tp,LOCATION_SZONE)>=3 then
		select=Duel.SelectOption(1-tp,aux.Stringid(7093411,1))
	elseif g:GetCount()>0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>=3 then
		select=Duel.SelectOption(1-tp,aux.Stringid(90140980,0))
		select=select+1 
	end
	if select==0 and Duel.GetLocationCount(1-tp,LOCATION_SZONE)>=3 then	
		local sg=g:Select(1-tp,2,2,nil)
		sg:AddCard(c)
		Duel.SendtoHand(sg,1-tp,REASON_EFFECT)
		Duel.ShuffleHand(1-tp)
		local tc=sg:GetFirst()
		while tc do
			Duel.MoveToField(tc,tp,nil,LOCATION_SZONE,POS_FACEDOWN,true)
			tc=sg:GetNext()
		end
		local rsel=sg:RandomSelect(tp,1)
		Duel.ConfirmCards(tp,rsel)
		Duel.ConfirmCards(1-tp,rsel)
		if rsel:IsContains(c) then
			Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE,1)
			sg:RemoveCard(c)
			Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)
			Duel.SendtoGrave(c,REASON_EFFECT)
		else
			Duel.SendtoGrave(sg,REASON_EFFECT) 
			end
		end	
	if select==1 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>=3 then
	local sg=g:Select(1-tp,2,2,nil)
		sg:AddCard(c)
		Duel.SendtoHand(sg,1-tp,REASON_EFFECT)
		Duel.ShuffleHand(1-tp)
		local tc=sg:GetFirst()
		while tc do
			Duel.MoveToField(tc,tp,nil,LOCATION_MZONE,POS_FACEDOWN_ATTACK,true)
			tc=sg:GetNext()
		end
		Duel.ShuffleSetCard(sg)
		local rsel=sg:RandomSelect(tp,1)
		Duel.ConfirmCards(tp,rsel)
		Duel.ConfirmCards(1-tp,rsel)
		if rsel:IsContains(c) then
			Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE,1)
			sg:RemoveCard(c)
			Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)
			Duel.SendtoGrave(c,REASON_EFFECT)
		else
			Duel.SendtoGrave(sg,REASON_EFFECT) end
	end
end