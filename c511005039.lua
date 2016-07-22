--シンクロ・ライヴァリー
function c511005039.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(c511005039.condition)
	e1:SetOperation(c511005039.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c511005039.filter(c)
    return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsControler(tp)
end
function c511005039.condition(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c511005039.filter,1,nil,1-tp)
end
function c511005039.operation(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e1:SetValue(1)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end