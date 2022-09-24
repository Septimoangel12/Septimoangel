--キューピッド・キス
function c120000059.initial_effect(c)
	aux.AddEquipProcedure(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(120000059,0))
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetCondition(c120000059.ctcon)
	e1:SetOperation(c120000059.ctop)
	c:RegisterEffect(e1)
end
function c120000059.ctcon(e,tp,eg,ep,ev,re,r,rp)
	local eq=e:GetHandler():GetEquipTarget()
	local tc=Duel.GetAttacker()
	local at=Duel.GetAttackTarget()
	return (tc==eq or at==eq) and (tc:GetCounter(0x1090)>0 or (at and at:GetCounter(0x1090)>0)) and (tc:IsRelateToBattle() or at:IsRelateToBattle())
end
function c120000059.ctop(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if a:GetCounter(0x1090)>0 or d:GetCounter(0x1090)>0 then
		Duel.GetControl(a,tp)
		Duel.GetControl(d,tp)
	end
end
