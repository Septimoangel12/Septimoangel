--魔法効果の矢
function c120000021.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(120000021,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c120000021.condition1)
	e1:SetOperation(c120000021.activate1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCondition(c120000021.condition2)
	e2:SetOperation(c120000021.activate2)
	c:RegisterEffect(e2)
end
function c120000021.condition1(e,tp,eg,ep,ev,re,r,rp)
	if not re then return false end
	return ep==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL)
end
function c120000021.activate1(e,tp,eg,ep,ev,re,r,rp)
	local op=re:GetOperation()
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c120000021.recpop1(tp,op))
end
function c120000021.recpop1(tp,op)
	return function(e,tp,eg,ep,ev,re,r,rp)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
		e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EVENT_ADJUST)
		e1:SetCountLimit(1)
		e1:SetOperation(c120000021.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c120000021.condition2(e,tp,eg,ep,ev,re,r,rp)
	if not re then return false end
	return ep~=tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL)
end
function c120000021.activate2(e,tp,eg,ep,ev,re,r,rp)
	local op=re:GetOperation()
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c120000021.recpop2(tp,op))
end
function c120000021.recpop2(tp,op)
	return function(e,tp,eg,ep,ev,re,r,rp)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
		e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EVENT_ADJUST)
		e1:SetCountLimit(1)
		e1:SetOperation(c120000021.retop)
		Duel.RegisterEffect(e1,1-tp)
	end
end
function c120000021.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	e:Reset()
	local te,eg,ep,ev,re,r,rp=c:CheckActivateEffect(true,true,true)
	if not te then return end
	local tg=te:GetTarget()
	local op=te:GetOperation()
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	local select=Duel.SelectOption(tp,aux.Stringid(5012,5),aux.Stringid(5012,6))
	if select==0 then 
		if tg then 
			tg(te,1-tp,eg,ep,ev,re,r,rp,1)
			op(e,1-tp,eg,ep,ev,re,r,rp)
		else	
			op(e,1-tp,eg,ep,ev,re,r,rp) 
		end	
	elseif select==1 then
		if tg then 
			tg(te,tp,eg,ep,ev,re,r,rp,1)
			op(e,tp,eg,ep,ev,re,r,rp)
		else	
			op(e,tp,eg,ep,ev,re,r,rp)
		end	
	end
end

