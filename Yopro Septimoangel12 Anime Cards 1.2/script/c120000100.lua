--ダークネス・ネオスフィア
function c120000100.initial_effect(c)
	c:EnableUnsummonable()
	--Gains effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetRange(LOCATION_ONFIELD)
	e1:SetCountLimit(1)
	e1:SetOperation(c120000100.codeop)
	c:RegisterEffect(e1)
	--Activate 1 Set Spell/Trap card
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(120000100,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_ONFIELD)
	e2:SetCountLimit(1)
	e2:SetTarget(c120000100.actg)
	e2:SetOperation(c120000100.acop)
	c:RegisterEffect(e2)
	--Set Spell/Trap cards
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(120000100,1))
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_ONFIELD)
	e3:SetCountLimit(1)
	e3:SetOperation(c120000100.setop)
	c:RegisterEffect(e3)
end
function c120000100.codeop(e,tp,eg,ep,ev,re,r,rp)	
	e:GetHandler():CopyEffect(100000701,RESET_EVENT+0x1fe0000)
end
function c120000100.filter(c)
	return c:IsFacedown() and c:GetSequence()~=5 
end
function c120000100.actg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and c120000100.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c120000100.filter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEDOWN)
	Duel.SelectTarget(tp,c120000100.filter,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil)
end
function c120000100.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
	Duel.ConfirmCards(tp,tc)
	if tc:IsType(TYPE_SPELL+TYPE_TRAP) then
		local te=tc:GetActivateEffect()
		local tep=tc:GetControler()
		if not te then
			Duel.Destroy(tc,REASON_EFFECT)
		else
			local condition=te:GetCondition()
			local cost=te:GetCost()
			local target=te:GetTarget()
			local operation=te:GetOperation()
			if te:GetCode()==EVENT_FREE_CHAIN and te:IsActivatable(tep)
				and (not condition or condition(te,tep,eg,ep,ev,re,r,rp))
				and (not cost or cost(te,tep,eg,ep,ev,re,r,rp,0))
				and (not target or target(te,tep,eg,ep,ev,re,r,rp,0)) then
				Duel.ClearTargetCard()
				e:SetProperty(te:GetProperty())
				Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
				Duel.ChangePosition(tc,POS_FACEUP)
				if tc:GetType()==TYPE_SPELL or tc:GetType()==TYPE_TRAP then
					tc:CancelToGrave(false)
				end
				tc:CreateEffectRelation(te)
				if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
				if target then target(te,tep,eg,ep,ev,re,r,rp,1) end
				local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
				local tg=g:GetFirst()
				while tg do
					tg:CreateEffectRelation(te)
					tg=g:GetNext()
				end
				tc:SetStatus(STATUS_ACTIVATED,true)
				if operation then operation(te,tep,eg,ep,ev,re,r,rp) end
				tc:ReleaseEffectRelation(te)
				tg=g:GetFirst()
				while tg do
					tg:ReleaseEffectRelation(te)
					tg=g:GetNext()
				end
			else
				Duel.Destroy(tc,REASON_EFFECT)
				end
			end
		end
	end
end
function c120000100.setfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c120000100.setop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c120000100.setfilter,tp,LOCATION_SZONE,0,nil)	
	local g2=Duel.GetMatchingGroup(c120000100.setfilter,tp,0,LOCATION_SZONE,nil)
	local opt=0
	if g1:GetCount()>0 and g2:GetCount()>0 then
		opt=Duel.SelectOption(tp,aux.Stringid(120000100,2),aux.Stringid(120000100,3))
	elseif g1:GetCount()>0 then
		opt=Duel.SelectOption(tp,aux.Stringid(120000100,2))	
	elseif g2:GetCount()>0 then
		opt=Duel.SelectOption(tp,aux.Stringid(120000100,3))+1	
	else return end
	if opt==0 then
		local tc=g1:GetFirst()
		while tc do
			Duel.ChangePosition(tc,POS_FACEDOWN)
			Duel.RaiseEvent(tc,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
			tc=g1:GetNext()
		end	
		local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_SZONE,0,nil)
		Duel.ShuffleSetCard(g)
	else
		local tc=g2:GetFirst()
		while tc do
			Duel.ChangePosition(tc,POS_FACEDOWN)
			Duel.RaiseEvent(tc,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
			tc=g2:GetNext()
		end
		local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_SZONE,nil)
		Duel.ShuffleSetCard(g)
	end
end
