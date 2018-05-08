--エンジンチューナー
function c511002410.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c511002410.target)
	e1:SetOperation(c511002410.operation)
	c:RegisterEffect(e1)
	--Cannot change Position 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	e2:SetCondition(c511002410.poscon)
	c:RegisterEffect(e2)
	--Atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(c511002410.value)
	c:RegisterEffect(e3)
	--remain field
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTarget(c511002410.desreptg)
	e4:SetOperation(c511002410.desrepop)
	c:RegisterEffect(e4)
	--Equip Again
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(511002410,0))
	e5:SetCategory(CATEGORY_EQUIP)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(c511002410.eqcon)
	e5:SetTarget(c511002410.target)
	e5:SetOperation(c511002410.operation)
	c:RegisterEffect(e5)
	--Equip limit
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_EQUIP_LIMIT)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetValue(c511002410.eqlimit)
	c:RegisterEffect(e6)
end
function c511002410.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c511002410.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c511002410.poscon(e)
	return e:GetHandler():GetEquipTarget():IsPosition(POS_FACEUP_ATTACK)
end
function c511002410.value(e,c)
	return e:GetHandler():GetEquipTarget():GetDefense()/2
end
function c511002410.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ec=c:GetPreviousEquipTarget()
	if chk==0 then return c:IsReason(REASON_LOST_TARGET) and ec and ec:IsReason(REASON_DESTROY) end
	return true
end
function c511002410.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:CancelToGrave()
end
function c511002410.eqcon(e)
	return e:GetHandler():GetEquipTarget()==nil
end
function c511002410.eqlimit(e,c)
	return c:IsFaceup() and c:IsAttackPos() and c:IsLocation(LOCATION_MZONE)
end