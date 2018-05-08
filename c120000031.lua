--エクシーズ・エージェント
function c120000031.initial_effect(c)
	--remove overlay replace
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(120000031,0))
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCondition(c120000031.rmcon)
	e1:SetOperation(c120000031.rmop)
	c:RegisterEffect(e1)
end
function c120000031.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local at=Duel.GetAttackTarget()
	return bit.band(r,REASON_COST)~=0 and re:IsActiveType(TYPE_XYZ) and e:GetHandler():IsAbleToRemoveAsCost()
		and ep==e:GetOwnerPlayer() and a and at and a:IsFaceup() and a:IsType(TYPE_XYZ) and at:IsFaceup() and at:IsType(TYPE_XYZ)
end
function c120000031.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_REPLACE)
end
