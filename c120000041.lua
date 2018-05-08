--分断の壁
function c120000041.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c120000041.activate)
	c:RegisterEffect(e1)
end
function c120000041.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetCondition(c120000041.condition)
	e1:SetTarget(c120000041.target)
	e1:SetOperation(c120000041.operation)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c120000041.condition(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return d~=nil and d:IsFaceup() and ((a:GetControler()==1-tp and a:IsRelateToBattle()) or (d:GetControler()==1-tp and d:IsRelateToBattle()))
end
function c120000041.filter(c)
	return c:IsType(TYPE_MONSTER)
end
function c120000041.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c120000041.filter,tp,0,LOCATION_ONFIELD,1,nil) end
end
function c120000041.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c120000041.filter,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()==0 then return end
	local atk=Duel.GetMatchingGroupCount(c120000041.filter,tp,0,LOCATION_ONFIELD,nil)*800
	local at=Duel.GetAttacker()
	if at and at:IsControler(1-tp) and at:IsRelateToBattle() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-atk)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		at:RegisterEffect(e1)
	end	
end
