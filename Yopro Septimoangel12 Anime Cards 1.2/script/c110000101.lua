--オレイカルコス・トリトス
function c110000101.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c110000101.actcon)
	c:RegisterEffect(e1)
	--disable target effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(c110000101.disop)
	c:RegisterEffect(e2)
	--selfdes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ADJUST)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c110000101.sdcon2)
	e3:SetOperation(c110000101.sdop)
	c:RegisterEffect(e3)
end
function c110000101.sdcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(110000101)==0
end
function c110000101.sdop(e,tp,eg,ep,ev,re,r,rp)	
	e:GetHandler():CopyEffect(511000256,RESET_EVENT+0x1fe0000)
	e:GetHandler():CopyEffect(110000100,RESET_EVENT+0x1fe0000)
	e:GetHandler():RegisterFlagEffect(110000101,RESET_EVENT+0x1fe0000,0,1)
end
function c110000101.actcon(e)
	local tc=Duel.GetFieldCard(e:GetHandler():GetControler(),LOCATION_SZONE,5)	
	return tc~=nil and tc:IsFaceup() and tc:GetCode()==110000100
end
function c110000101.sdcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(110000101)==0
end
function c110000101.disop(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp or not re:IsActiveType(TYPE_SPELL+TYPE_TRAP) then return end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or g:GetCount()==0 then return end
	local gc=g:GetFirst()
	if not gc:IsControler(tp) or not gc:IsType(TYPE_MONSTER) then return false end
		if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
			Duel.Destroy(re:GetHandler(),REASON_EFFECT)
	end		
end
