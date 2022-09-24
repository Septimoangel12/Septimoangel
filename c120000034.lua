--H・C ソード・シールド
function c120000034.initial_effect(c)
	--Change Battle Damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1:SetDescription(aux.Stringid(120000034,0))
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1)
	e1:SetCondition(c120000034.precon)
	e1:SetOperation(c120000034.preop)
	c:RegisterEffect(e1)
end
function c120000034.precon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetBattleDamage(tp)>=2000 and Duel.GetCurrentChain()==0
end
function c120000034.preop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsAbleToGraveAsCost() and Duel.SendtoGrave(c,REASON_COST+REASON_REPLACE)>0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
		e1:SetOperation(c120000034.damop)
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
		Duel.RegisterEffect(e1,tp)
		Duel.SetLP(tp,100,REASON_EFFECT)
	end
end
function c120000034.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(tp,0)
end