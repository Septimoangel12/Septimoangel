--ワイゼルＣ 
local s,id=GetID()
function s.initial_effect(c)
	--selfdes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SELF_DESTROY)
	e1:SetCondition(s.sdcon)
	c:RegisterEffect(e1)
	--indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetValue(s.indval)
	c:RegisterEffect(e2)
end
function s.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup() and (c:IsSetCard(0x3013)) 
end
function s.sdcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(s.cfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) and not e:GetHandler():IsCode(63468625)
end
function s.indval(e,re,tp)
	return e:GetHandlerPlayer()~=re:GetHandlerPlayer()
end