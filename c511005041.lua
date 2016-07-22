--トラップリン
function c511005041.initial_effect(c)
    --Special Summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(c511005041.spcon)
    e1:SetOperation(c511005041.spop)
    c:RegisterEffect(e1)
end
function c511005041.spfilter(c)
    return c:IsType(TYPE_TRAP+TYPE_CONTINUOUS) and c:IsFaceup() and c:IsReleasable()
end
function c511005041.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetOwner()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c511005041.spfilter,tp,LOCATION_SZONE,0,1,nil)
end
function c511005041.spop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    Duel.Release(Duel.SelectMatchingCard(tp,c511005041.spfilter,tp,LOCATION_SZONE,0,1,1,nil),REASON_COST)
end