--ジャスティス・ブリンガー
function c120000149.initial_effect(c)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetRange(LOCATION_ONFIELD)
	e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e1:SetCondition(c120000149.condition)
	e1:SetTarget(c120000149.distarget)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_TRIGGER)
	c:RegisterEffect(e3)
end
function c120000149.condition(e)
	return Duel.GetTurnPlayer()~=e:GetHandlerPlayer()
end
function c120000149.distarget(e,c)
	return bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)~=0
end
