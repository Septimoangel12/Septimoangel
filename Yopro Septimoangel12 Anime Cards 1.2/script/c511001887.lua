--光のピラミッド
function c511001887.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Banish
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(c511001887.banop)
	c:RegisterEffect(e2)
	--Destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetOperation(c511001887.leave)
	c:RegisterEffect(e3)
end
function c511001887.filter(c)
	return c:IsFaceup() and (c:IsAttribute(ATTRIBUTE_DEVINE) or c:IsRace(RACE_DEVINE) or bit.band(c:GetOriginalRace(),RACE_DEVINE)==RACE_DEVINE 
	or bit.band(c:GetOriginalAttribute(),ATTRIBUTE_DEVINE)==ATTRIBUTE_DEVINE) and c:IsAbleToRemove()
end
function c511001887.banop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c511001887.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)>0 then
		local dg=Duel.GetMatchingGroup(c511001887.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		local tc=dg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetRange(LOCATION_SZONE)
		e1:SetTargetRange(0,LOCATION_MZONE)
		e1:SetValue(c100000535.aclimit)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
		tc=dg:GetNext()
		Duel.Remove(dg,POS_FACEUP,REASON_EFFECT)
		end
	end
end
function c511001887.aclimit(e,re,tp)
	local loc=re:GetActivateLocation()
	return (loc==LOCATION_MZONE) and re:IsActiveType(TYPE_MONSTER) or re:GetCode(10000020) or re:GetCode(10000000) or re:GetCode(10000010) and re:IsAttribute(ATTRIBUTE_DEVINE)
	or re:IsRace(RACE_DEVINE)
end
function c511001887.defilter(c)
	local code=c:GetCode()
	return c:IsFaceup() and (code==78800047 or code==78800046 or code==51402177 or code==15013468) and c:IsDestructable()
end
function c511001887.leave(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetPreviousControler()==tp and c:IsStatus(STATUS_ACTIVATED) then
		local g=Duel.GetMatchingGroup(c511001887.defilter,tp,LOCATION_ONFIELD,0,nil)
		Duel.Destroy(g,REASON_EFFECT,LOCATION_REMOVED)
	end
end