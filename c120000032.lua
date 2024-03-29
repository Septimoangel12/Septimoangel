--BK カウンターブロー
function c120000032.initial_effect(c)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(120000032,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1)
	e1:SetCondition(c120000032.condition)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(c120000032.target)
	e1:SetOperation(c120000032.operation)
	c:RegisterEffect(e1)
end
function c120000032.condition(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return (a and a:GetControler()==tp and a:IsSetCard(0x84) and a:IsRelateToBattle())
		or (d and d:GetControler()==tp and d:IsSetCard(0x84) and d:IsRelateToBattle()) and Duel.GetCurrentChain()==0
end
function c120000032.cfilter(c,e,tp,eg,ep,ev,re,r,rp)
	return not c:IsHasEffect(120000032) and not c:IsHasEffect(511001408) and not c:IsHasEffect(511001283) and c120000032.filter(c,e,tp,eg,ep,ev,re,r,rp)
end
function c120000032.filter(c,e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if e:GetHandler():IsLocation(LOCATION_HAND) then
		ft=ft-1
	end
	if ft<=0 and not c:IsType(TYPE_FIELD) then return false end
	local te=c:GetActivateEffect()
	if not c:IsType(TYPE_TRAP) or not te then return false end
	local condition=te:GetCondition()
	local cost=te:GetCost()
	local target=te:GetTarget()
	if te:GetCode()==EVENT_CHAINING or te:GetCode()==EVENT_FREE_CHAIN then
		return (not condition or condition(te,tp,eg,ep,ev,re,r,rp)) and (not cost or cost(te,tp,eg,ep,ev,re,r,rp,0))
			and (not target or target(te,tp,eg,ep,ev,re,r,rp,0))
	else
		local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(te:GetCode(),true)
		return res and (not condition or condition(te,tp,teg,tep,tev,tre,tr,trp)) and (not cost or cost(te,tp,teg,tep,tev,tre,tr,trp,0))
			and (not target or target(te,tp,teg,tep,tev,tre,tr,trp,0))
	end
end
function c120000032.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and c120000032.filter(chkc,e,tp,eg,ep,ev,re,r,rp) end
	if chk==0 then return Duel.IsExistingTarget(c120000032.cfilter,tp,0,LOCATION_GRAVE,1,nil,e,tp,eg,ep,ev,re,r,rp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	Duel.SelectTarget(tp,c120000032.cfilter,tp,0,LOCATION_GRAVE,1,1,nil,e,tp,eg,ep,ev,re,r,rp)
end
function c120000032.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		local tpe=tc:GetType()
		local te=tc:GetActivateEffect()
		local tg=te:GetTarget()
		local co=te:GetCost()
		local op=te:GetOperation()
		e:SetCategory(te:GetCategory())
		e:SetProperty(te:GetProperty())
		Duel.ClearTargetCard()
		if bit.band(tpe,TYPE_FIELD)~=0 then
			local fc=Duel.GetFieldCard(1-tp,LOCATION_SZONE,5)
			if Duel.IsDuelType(DUEL_OBSOLETE_RULING) then
				if fc then Duel.Destroy(fc,REASON_RULE) end
				fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
				if fc and Duel.Destroy(fc,REASON_RULE)==0 then Duel.SendtoGrave(tc,REASON_RULE) end
			else
				fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
				if fc and Duel.SendtoGrave(fc,REASON_RULE)==0 then Duel.SendtoGrave(tc,REASON_RULE) end
			end
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		if bit.band(tpe,TYPE_TRAP+TYPE_FIELD)==TYPE_TRAP+TYPE_FIELD then
			Duel.MoveSequence(tc,5)
		end
		Duel.Hint(HINT_CARD,0,tc:GetCode())
		tc:CreateEffectRelation(te)
		if bit.band(tpe,TYPE_EQUIP+TYPE_CONTINUOUS+TYPE_FIELD)==0 and not tc:IsHasEffect(EFFECT_REMAIN_FIELD) then
			tc:CancelToGrave(false)
		end
		if te:GetCode()==EVENT_CHAINING or te:GetCode()==EVENT_FREE_CHAIN then
			if co then co(te,tp,eg,ep,ev,re,r,rp,1) end
			if tg then tg(te,tp,eg,ep,ev,re,r,rp,1) end
		else
			local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(te:GetCode(),true)
			if co then co(te,tp,teg,tep,tev,tre,tr,trp,1) end
			if tg then tg(te,tp,teg,tep,tev,tre,tr,trp,1) end
		end
		Duel.BreakEffect()
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		if g then
			local etc=g:GetFirst()
			while etc do
				etc:CreateEffectRelation(te)
				etc=g:GetNext()
			end
		end
		tc:SetStatus(STATUS_ACTIVATED,true)
		if not tc:IsDisabled() then
			if te:GetCode()==EVENT_CHAINING or te:GetCode()==EVENT_FREE_CHAIN then
				if op then op(te,tp,eg,ep,ev,re,r,rp) end
			else
				local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(te:GetCode(),true)
				if op then op(te,tp,teg,tep,tev,tre,tr,trp) end
			end
		else
			--insert negated animation here
		end
		Duel.RaiseEvent(Group.CreateGroup(tc),EVENT_CHAIN_SOLVED,te,0,tp,tp,Duel.GetCurrentChain())
		if g and tc:IsType(TYPE_EQUIP) and not tc:GetEquipTarget() then
			Duel.Equip(tp,tc,g:GetFirst())
		end
		tc:ReleaseEffectRelation(te)
		if etc then	
			etc=g:GetFirst()
			while etc do
				etc:ReleaseEffectRelation(te)
				etc=g:GetNext()
			end
		end
	end
end