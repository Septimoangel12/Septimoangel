--ＺＷ－極星神馬聖鎧
function c120000024.initial_effect(c)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(120000024,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetRange(LOCATION_ONFIELD)
	e1:SetTarget(c120000024.eqtg)
	e1:SetOperation(c120000024.eqop)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(120000024,1))
    e2:SetCategory(CATEGORY_ATKCHANGE)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_ATTACK_ANNOUNCE)
    e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c120000024.atkcon)
	e2:SetOperation(c120000024.atkop)
    c:RegisterEffect(e2)
	--sp summon
	local e3=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(120000024,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCondition(c120000024.spcon)
	e3:SetTarget(c120000024.sptg)
	e3:SetOperation(c120000024.spop)
	c:RegisterEffect(e3)
end
function c120000024.filter(c)
	return c:IsFaceup() and c:IsCode(56840427)
end
function c120000024.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c120000024.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and e:GetHandler():IsType(TYPE_MONSTER)
		and Duel.IsExistingTarget(c120000024.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c120000024.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c120000024.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if c:IsLocation(LOCATION_MZONE) and c:IsFacedown() then return end
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:GetControler()~=tp or tc:IsFacedown() or not tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	Duel.Equip(tp,c,tc,true)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(c120000024.eqlimit)
	e1:SetLabelObject(tc)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(1000)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e2)
end
function c120000024.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c120000024.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    return not c:IsType(TYPE_MONSTER) and c:GetEquipTarget() and Duel.GetAttacker()==c:GetEquipTarget() and Duel.GetAttackTarget()~=nil 
end
function c120000024.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    if c:GetEquipTarget() and Duel.GetAttacker()==c:GetEquipTarget() and Duel.GetAttackTarget()~=nil then
		--atkup
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_EQUIP)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(c120000024.attval)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1) 
	end
end
function c120000024.attval(e,c)
	return Duel.GetAttackTarget():GetAttack()
end
function c120000024.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetPreviousEquipTarget()
	return c:IsReason(REASON_LOST_TARGET) and ec and ec:IsReason(REASON_DESTROY)
end
function c120000024.spfilter(c,e,tp)
	return c:IsCode(56840427) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c120000024.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c120000024.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c120000024.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c120000024.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c120000024.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end