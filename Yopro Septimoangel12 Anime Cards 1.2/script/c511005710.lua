--スターライト・フォース
function c511005710.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c511005710.condition)
	e1:SetTarget(c511005710.target)
	e1:SetOperation(c511005710.activate)
	c:RegisterEffect(e1)
	--lv up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(511005710,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCondition(c511005710.lvcon)
	e2:SetOperation(c511005710.lvop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(511005710,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCondition(c511005710.descon)
	e3:SetTarget(c511005710.destg)
	e3:SetOperation(c511005710.desop)
	c:RegisterEffect(e3)
end
function c511005710.cfilter(c)
	return c:GetSummonLocation()==LOCATION_EXTRA 
end
function c511005710.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c511005710.cfilter,1,nil)
end
function c511005710.filter(c)
	return c:IsFaceup() and c:GetSummonLocation()==LOCATION_EXTRA
end
function c511005710.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c511005710.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
end
function c511005710.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c511005710.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local tc=g:GetFirst()
	while tc do
		--level 4
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(4)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_RANK_LEVEL_S)
		e2:SetValue(4)
		tc:RegisterEffect(e2)
		--disable
		local e3=e1:Clone()
		e3:SetCode(EFFECT_DISABLE)
		tc:RegisterEffect(e3)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_DISABLE_EFFECT)
		tc:RegisterEffect(e4)
		tc:RegisterFlagEffect(511005710,RESET_EVENT,0x1fe0000,0,0)
		tc=g:GetNext()
	end
end
function c511005710.lvcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c511005710.lvfilter(c)
	return c:GetFlagEffect(511005710)~=0 and c:IsFaceup()
end
function c511005710.lvop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetMatchingGroup(c511005710.lvfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local lv=tg:GetFirst()
	while lv do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		lv:RegisterEffect(e1)
		lv=tg:GetNext()
	end	
end
function c511005710.descon(e)
	local g1=Duel.GetMatchingGroup(Card.IsFaceup,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,nil)
	local g2=Duel.GetMatchingGroup(Card.IsFaceup,e:GetHandlerPlayer(),0,LOCATION_ONFIELD,nil)
	if g1:GetCount()<=0 or g2:GetCount()<=0 then return false end
	return g1:GetSum(Card.GetLevel)<=g2:GetSum(Card.GetLevel)
end
function c511005710.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c511005710.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.Destroy(c,REASON_EFFECT)
	end
end
