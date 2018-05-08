--悪夢の三面鏡
function c511001561.initial_effect(c)
    --Copy
    local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c511001561.target)
	e1:SetOperation(c511001561.operation)
	c:RegisterEffect(e1)
end
function c511001561.cfilter(c,tp)
	return c:GetSummonPlayer()~=tp
end
function c511001561.filter(c)
    return c:IsType(TYPE_MONSTER) and c:IsFaceup() 
end
function c511001561.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=eg:Filter(c511001561.cfilter,nil,tp)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(tp) and c511001561.filter(chkc,tp) end
    if chk==0 then return eg:IsExists(c511001561.cfilter,1,nil,tp) and Duel.IsExistingMatchingCard(c511001561.filter,tp,LOCATION_ONFIELD,0,1,nil)
       and g:GetCount()<=Duel.GetLocationCount(tp,LOCATION_MZONE) end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,g:GetCount(),0,0)
end
function c511001561.operation(e,tp,eg,ep,ev,re,r,rp)
    local g=eg:Filter(c511001561.cfilter,nil,e,tp)
    local h=Duel.SelectTarget(tp,c511001561.filter,tp,LOCATION_ONFIELD,0,1,1,nil)
    local tc=h:GetFirst()
    if g:GetCount()<=Duel.GetLocationCount(tp,LOCATION_MZONE)
        and Duel.IsPlayerCanSpecialSummonMonster(tp,511001562,100,0x4011,tc:GetBaseAttack(),tc:GetBaseDefense(),tc:GetLevel(),tc:GetRace(),tc:GetAttribute()) then
        for i=1,g:GetCount() do
        local token=Duel.CreateToken(tp,511001562)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_SET_BASE_ATTACK)
        e1:SetValue(tc:GetBaseAttack())
        e1:SetReset(RESET_EVENT+0xfe0000)
        token:RegisterEffect(e1)
        local e2=e1:Clone()
        e2:SetCode(EFFECT_SET_BASE_DEFENSE)
        e2:SetValue(tc:GetBaseDefense())
        token:RegisterEffect(e2)
        local e3=e1:Clone()
        e3:SetCode(EFFECT_CHANGE_LEVEL)
        e3:SetValue(tc:GetLevel())
        token:RegisterEffect(e3)
        local e4=e1:Clone()
        e4:SetCode(EFFECT_CHANGE_RACE)
        e4:SetValue(tc:GetRace())
        token:RegisterEffect(e4)
        local e5=e1:Clone()
        e5:SetCode(EFFECT_CHANGE_ATTRIBUTE)
        e5:SetValue(tc:GetAttribute())
        token:RegisterEffect(e5)
        local e6=e1:Clone()
        e6:SetCode(EFFECT_CHANGE_CODE)
		e6:SetValue(tc:GetCode())
        token:RegisterEffect(e6)
        Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
        --Cannot Attack or be tributed this turn
        local e7=Effect.CreateEffect(e:GetHandler())
        e7:SetType(EFFECT_TYPE_SINGLE)
        e7:SetCode(EFFECT_CANNOT_ATTACK)
        e7:SetReset(RESET_EVENT+0xfe0000+RESET_PHASE+PHASE_END)
        token:RegisterEffect(e7)
        local e8=e7:Clone()
        e8:SetCode(EFFECT_UNRELEASABLE_SUM)
        token:RegisterEffect(e8)
        local e9=e7:Clone()
        e9:SetCode(EFFECT_UNRELEASABLE_NONSUM)
        token:RegisterEffect(e9)
        end
    end
end