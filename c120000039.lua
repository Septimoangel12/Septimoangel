--ドラゴンズ・オーブ
function c120000039.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c120000039.operation)
	c:RegisterEffect(e1)
end
function c120000039.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--Effect of Dragon-Type monsters cannot be negate/disable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_DISABLE)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetTarget(c120000039.distarget)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_INACTIVATE)
	e2:SetValue(c120000039.efilter)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_DISEFFECT)
	Duel.RegisterEffect(e3,tp)
	
end
function c120000039.distarget(e,c)
	return c:GetRace()==RACE_DRAGON
end
function c120000039.efilter(e,ct)
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	local tc=te:GetHandler()
	return tp==e:GetHandlerPlayer() and tc:GetRace()==RACE_DRAGON
end