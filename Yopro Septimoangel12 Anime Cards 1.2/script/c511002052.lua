--魔法効果の矢
function c511002052.initial_effect(c)
	--Change the effect target of an Spell Card
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetDescription(aux.Stringid(59560625,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c511002052.efcon)
	e1:SetTarget(c511002052.eftg)
	e1:SetOperation(c511002052.efop)
	c:RegisterEffect(e1)
	--Copy Spell
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(84565800,1))
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c511002052.condition1)
	e2:SetTarget(c511002052.target1)
	e2:SetOperation(c511002052.operation1)
	c:RegisterEffect(e2)
	--Lose Atk
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(11287364,0))
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCondition(c511002052.condition2)
	e3:SetCost(c511002052.cost2)
	e3:SetTarget(c511002052.target2)
	e3:SetOperation(c511002052.operation2)
	e3:SetLabel(0)
	c:RegisterEffect(e3)
end
function c511002052.efcon(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp or not re:IsHasType(EFFECT_TYPE_ACTIVATE) or not re:IsActiveType(TYPE_SPELL)
		or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or g:GetCount()~=1 then return false end
	local tc=g:GetFirst()
	e:SetLabelObject(tc)
	return tc:IsLocation(LOCATION_MZONE) and tc:IsControler(e:GetHandler():GetControler())
end
function c511002052.tcfilter(c,re,rp,tf,ceg,cep,cev,cre,cr,crp)
	return tf(re,rp,ceg,cep,cev,cre,cr,crp,0,c)
end
function c511002052.eftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tf=re:GetTarget()
	local res,ceg,cep,cev,cre,cr,crp=Duel.CheckEvent(re:GetCode(),true)
	if chkc then return chkc~=e:GetLabelObject() and chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and tf(re,rp,ceg,cep,cev,cre,cr,crp,0,chkc) end
	if chk==0 then return Duel.IsExistingTarget(c511002052.tcfilter,tp,0,LOCATION_MZONE,1,e:GetLabelObject(),re,rp,tf,ceg,cep,cev,cre,cr,crp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c511002052.tcfilter,tp,0,LOCATION_MZONE,1,1,e:GetLabelObject(),re,rp,tf,ceg,cep,cev,cre,cr,crp)
end
function c511002052.efop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if g:GetFirst():IsRelateToEffect(e) then
		Duel.ChangeTargetCard(ev,g)
	end
end
function c511002052.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c511002052.filter,tp,0,LOCATION_GRAVE,1,nil)
end
function c511002052.filter(c,e,tp,eg,ep,ev,re,r,rp)
	local ref=c:GetReasonEffect()
	if not  c:IsReason(REASON_RULE) and (not ref or ref:GetHandler():GetOwner()==tp) then return false end
	if not c:IsPreviousLocation(LOCATION_ONFIELD) then return false end
		local te=c:GetActivateEffect()
		if not te then return false end
		local cost=te:GetCost()
		local target=te:GetTarget()
		return c:IsType(TYPE_SPELL) and (not cost or cost(te,tp,eg,ep,ev,re,r,rp,0)) and (not target or target(te,tp,eg,ep,ev,re,r,rp,0))
end
function c511002052.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and c511002052.filter(chkc,e,tp,eg,ep,ev,re,r,rp) end
	if chk==0 then return Duel.IsExistingTarget(c511002052.filter,tp,0,LOCATION_GRAVE,1,nil,e,tp,eg,ep,ev,re,r,rp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	local g=Duel.SelectTarget(tp,c511002052.filter,tp,0,LOCATION_GRAVE,1,1,nil)
end
function c511002052.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) or not c:IsRelateToEffect(e) then return end
	if tc:IsType(TYPE_MONSTER) then return end
		local te=tc:GetActivateEffect()
		if not te then return end
		local tpe=tc:GetType()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetValue(tpe)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
		if bit.band(tpe,TYPE_FIELD)~=0 then
			local of=Duel.GetFieldCard(1-tp,LOCATION_SZONE,5)
			if of then Duel.Destroy(of,REASON_RULE) end
			of=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
			if of and Duel.Destroy(of,REASON_RULE)==0 then Duel.SendtoGrave(tc,REASON_RULE) end
			Duel.MoveSequence(c,5)
		end
		Duel.ClearTargetCard()
		local tg=te:GetTarget()
		local co=te:GetCost()
		e:SetCategory(te:GetCategory())
		e:SetProperty(te:GetProperty())
		if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
		if co then co(e,tp,eg,ep,ev,re,r,rp,1) end
		if bit.band(tpe,TYPE_EQUIP+TYPE_CONTINUOUS+TYPE_FIELD)==0 then
			c:CancelToGrave(false)
		else
			c:CancelToGrave(true)
			local code=te:GetHandler():GetOriginalCode()
			c:CopyEffect(code,RESET_EVENT+0x1fe0000)
		end
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp)
	end
end
function c511002052.czfilter(c,tp)
	return c:IsRace(RACE_ZOMBIE)
end
function c511002052.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c511002052.czfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c511002052.zfilter(c,tp)
	return c:IsRace(RACE_ZOMBIE) and Duel.IsExistingTarget(c511002052.nzfilter,tp,0,LOCATION_MZONE,1,nil)
end
function c511002052.nzfilter(c)
	return c:IsFaceup() and not c:IsRace(RACE_ZOMBIE)
end
function c511002052.cost2(e,tp,eg,ep,ev,re,r,rp)
	e:SetLabel(1)
	return true
end
function c511002052.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return Duel.CheckReleaseGroup(tp,c511002052.zfilter,1,nil,tp)
	end
	local rg=Duel.SelectReleaseGroup(tp,c511002052.zfilter,1,1,nil,tp)
	local atk=rg:GetFirst():GetTextAttack()
	if atk<0 then atk=0 end
	e:SetLabel(atk)
	Duel.Release(rg,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c511002052.nzfilter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c511002052.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local atk=e:GetLabel()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCountLimit(1)
		e1:SetLabel(atk)
		e1:SetOwnerPlayer(tp)
		e1:SetOperation(c511002052.atkop)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end
function c511002052.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local atk=e:GetLabel()
	if Duel.GetTurnPlayer()==e:GetOwnerPlayer() then
		if c:GetAttack()>0 then
			Duel.Hint(HINT_CARD,0,511002052)
		end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-atk)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
	end
end