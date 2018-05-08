--造反劇
function c511001109.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(511001109,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c511001109.atkcon)
	e1:SetTarget(c511001109.atktg)
	e1:SetOperation(c511001109.atkop)
	c:RegisterEffect(e1)
end
function c511001109.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0 or Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
end
function c511001109.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAttackPos,tp,0,LOCATION_MZONE,1,nil) 
	or Duel.IsExistingTarget(Card.IsAttackPos,tp,LOCATION_MZONE,0,1,nil) end
end
function c511001109.atkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(511001109,0))
	local g1=Duel.SelectMatchingCard(tp,Card.IsAttackPos,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local tc=g1:GetFirst()
	local dc=tc:GetControler()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(511001109,1))
	local g2=Duel.SelectMatchingCard(1-dc,nil,dc,LOCATION_MZONE,0,1,1,g1:GetFirst())
	local tc1=g1:GetFirst()
	local tc2=g2:GetFirst()
	if tc1 and tc2==nil and tc1:IsPosition(POS_FACEUP_ATTACK) then
			Duel.Damage(tc1:GetControler(),tc1:GetAttack(),REASON_BATTLE)
			Duel.RaiseSingleEvent(tc1,EVENT_BATTLE_DAMAGE,e,REASON_BATTLE,tp,tc1:GetControler(),tc1:GetAttack())
			Duel.RaiseEvent(tc1,EVENT_BATTLE_DAMAGE,e,REASON_BATTLE,tp,tc1:GetControler(),tc1:GetAttack())
	elseif tc2 and g2:GetCount()>0 and tc1:IsPosition(POS_FACEUP_ATTACK) then
		Duel.CalculateDamage(tc1,tc2,true)
	end
end