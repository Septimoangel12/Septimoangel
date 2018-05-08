--悲劇の引き金
function c120000150.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c120000150.descon)
	e1:SetTarget(c120000150.destg)
	e1:SetOperation(c120000150.desop)
	c:RegisterEffect(e1)
end
function c120000150.cfilter(c,p)
	return c:GetControler()==p and c:IsType(TYPE_MONSTER) and c:IsOnField() 
end
function c120000150.descon(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsChainNegatable(ev) then return false end
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	return ex and tg~=nil and tc+tg:FilterCount(c120000150.cfilter,nil,tp)-tg:GetCount()==1
end
function c120000150.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAttackPos()
end
function c120000150.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
	local g=Duel.GetMatchingGroup(c120000150.filter,tp,0,LOCATION_ONFIELD,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	end
end
function c120000150.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	if not tc:IsDisabled() then
		if tc:IsRelateToEffect(re) and Duel.NegateEffect(ev) then
		local g=Duel.GetMatchingGroup(c120000150.filter,tp,0,LOCATION_ONFIELD,nil)
			if g:GetCount()>0 then
				Duel.Destroy(g,REASON_EFFECT)
			end	
		end		
	end
end
