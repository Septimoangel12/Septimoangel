--潔癖のバリア－クリア・フォース
function c511007014.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetTarget(c511007014.target)
	e1:SetOperation(c511007014.activate)
	c:RegisterEffect(e1)
	if not c511007014.global_check then
		c511007014.global_check=true
		--Check for ATK changing effects
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_ADJUST)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetOperation(c511007014.operation)
		Duel.RegisterEffect(e2,0)
	end
end
function c511007014.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	local g=Duel.GetMatchingGroup(nil,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		if tc:IsFaceup() and tc:GetFlagEffect(511007014)==0 then
			local e1=Effect.CreateEffect(c) 
			e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
			e1:SetCode(EVENT_CHAIN_SOLVED)
			e1:SetRange(LOCATION_MZONE)
			e1:SetLabel(tc:GetAttack())
			e1:SetOperation(c511007014.op)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			tc:RegisterFlagEffect(511007014,RESET_EVENT+0x1fe0000,0,1)  
		end 
		tc=g:GetNext()
	end	 
end
function c511007014.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==c:GetAttack() then return end
	local val=c:GetAttack()-e:GetLabel()
	Duel.RaiseEvent(c,511007014,re,REASON_EFFECT,rp,tp,val)
	e:SetLabel(c:GetAttack())
end
function c511007014.filter(c)
	return c:IsFaceup() and c:GetAttack()~=c:GetBaseAttack()
end
function c511007014.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c511007014.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function c511007014.activate(e,tp,eg,ep,ev,re,r,rp)
	--[[local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetOperation(c511007014.negop)
	e1:SetReset(RESET_PHASE+PHASE_BATTLE)
	Duel.RegisterEffect(e1,tp)]]
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(511007014)
	e2:SetCondition(c511007014.atkcon)
	e2:SetOperation(c511007014.atkop)
	e2:SetReset(RESET_PHASE+PHASE_BATTLE)
	Duel.RegisterEffect(e2,tp)
	local g=Duel.GetMatchingGroup(c511007014.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_SET_ATTACK_FINAL)
		e3:SetValue(tc:GetBaseAttack())
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
		tc:RegisterEffect(e3)
		tc=g:GetNext()
		end
end
--[[function c511007014.dfilter(c,e,tp)
	return c:IsControler(1-tp)
end]]
--[[function c511007014.negop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsChainNegatable(ev) then return end
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_ATKCHANGE)
	if ex and tg~=nil and tc+tg:FilterCount(c511007014.dfilter,nil)-tg:GetCount()>0 then
		Duel.NegateEffect(ev)
	end
end]]
function c511007014.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsControler,1,nil,1-tp) and rp~=tp and ev>0
end
function c511007014.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
	e1:SetValue(tc:GetAttack()-ev)
	tc:RegisterEffect(e1)
end