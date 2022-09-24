--マジカルシルクハット
local c120000030,id=GetID()
if not c120000030.gl_chk then
	c120000030.gl_chk=true
	local regeff=Card.RegisterEffect
	Card.RegisterEffect=function(c,e,f)
		local tc=e:GetOwner()
		if tc then
			local tg=e:GetTarget()
			if tg then
				if c35803249 and tg==c35803249.distg then --Jinzo - Lord
					--Debug.Message('"Jinzo - Lord" detected')
					e:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
				elseif c51452091 and tg==c51452091.distarget then --Royal Decree
					--Debug.Message('"Royal Decree" detected')
					e:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
				elseif c77585513 and tg==c77585513.distg then --Jinzo
					--Debug.Message('"Jinzo" detected')
					e:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
				elseif c84636823 and tg==c84636823.distg then --Spell Canceller
					--Debug.Message('"Spell Canceller" detected')
					e:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
				end
			end
		end
		return regeff(c,e,f)
	end
end
function c120000030.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c120000030.condition)
	e1:SetTarget(c120000030.target)
	e1:SetOperation(c120000030.activate)
	c:RegisterEffect(e1)
	--remain field
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e2)
	--selfdes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_ONFIELD)
	e3:SetCode(EFFECT_SELF_DESTROY)
	e3:SetCondition(c120000030.descon)
	c:RegisterEffect(e3)
end
function c120000030.condition(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then return false end
	return Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsRace,RACE_SPELLCASTER),e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function c120000030.tgfilter(c)
	return c:IsType(TYPE_MONSTER)
end
function c120000030.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(tp) and c120000030.tgfilter(chkc,tp) end
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)
	 and Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsRace,RACE_SPELLCASTER),e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil) end
	local ct=Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_ONFIELD,0,nil,TYPE_MONSTER)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,ct,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,3-ct,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,3-ct,0,0)
end
function c120000030.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local fid=c:GetFieldID()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then return end
		c:RegisterFlagEffect(120000030,RESET_EVENT+RESETS_STANDARD_DISABLE,0,0,fid)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
		local g1=Duel.SelectMatchingCard(tp,aux.FilterFaceupFunction(Card.IsRace,RACE_SPELLCASTER),tp,LOCATION_ONFIELD,0,1,1,nil)
		local hatm1=g1:GetFirst()
		local ct=Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_ONFIELD,0,g1:GetFirst(),TYPE_MONSTER)
		if hatm1 and ct>0 and Duel.SelectYesNo(tp,aux.Stringid(120000030,0)) then 
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
			local g2=Duel.SelectMatchingCard(tp,Card.IsType,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,3,hatm1,TYPE_MONSTER)
			g1:Merge(g2)
			g1:KeepAlive()
			for hatma in aux.Next(g2) do
				Duel.ChangePosition(hatma,POS_FACEDOWN_DEFENSE)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CHANGE_TYPE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetValue(TYPE_TOKEN)
				e1:SetLabel(fid)
				e1:SetCondition(c120000030.econ)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				hatma:RegisterEffect(e1)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_REMOVE_RACE)
				e2:SetValue(RACE_ALL)
				hatma:RegisterEffect(e2)
				local e3=e1:Clone()
				e3:SetCode(EFFECT_REMOVE_ATTRIBUTE)
				e3:SetValue(0xff)
				hatma:RegisterEffect(e3)
				local e4=e1:Clone()
				e4:SetCode(EFFECT_SET_BASE_ATTACK)
				e4:SetValue(0)
				hatma:RegisterEffect(e4)
				local e5=e1:Clone()
				e5:SetCode(EFFECT_SET_BASE_DEFENSE)
				e5:SetValue(0)
				hatma:RegisterEffect(e5)
				local e6=e1:Clone()
				e6:SetCode(EFFECT_CHANGE_LEVEL)
				e6:SetValue(0)
				hatma:RegisterEffect(e6)
				local e7=e1:Clone()
				e7:SetCode(EFFECT_UNRELEASABLE_SUM)
				e7:SetValue(1)
				e7:SetReset(RESET_EVENT+RESETS_STANDARD)
				hatma:RegisterEffect(e7)
				local e8=e7:Clone()
				e8:SetCode(EFFECT_UNRELEASABLE_NONSUM)
				hatma:RegisterEffect(e8)
				hatma:RegisterFlagEffect(120000030+2,RESET_EVENT+RESETS_STANDARD,0,0,fid)
		end	
	end
	local zone=4-#g1
	if ft<zone then
		Duel.Destroy(e:GetHandler(),REASON_EFFECT) 
	else	
		for i=1,zone do
			local hat=Duel.CreateToken(tp,511005062)
			Duel.MoveToField(hat,tp,tp,LOCATION_MZONE,POS_FACEDOWN_DEFENSE,true)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(TYPE_TOKEN)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			hat:RegisterEffect(e1,true)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_REMOVE_RACE)
			e2:SetValue(RACE_ALL)
			hat:RegisterEffect(e2,true)
			local e3=e1:Clone()
			e3:SetCode(EFFECT_REMOVE_ATTRIBUTE)
			e3:SetValue(0xff)
			hat:RegisterEffect(e3,true)
			local e4=e1:Clone()
			e4:SetCode(EFFECT_SET_BASE_ATTACK)
			e4:SetValue(0)
			hat:RegisterEffect(e4,true)
			local e5=e1:Clone()
			e5:SetCode(EFFECT_SET_BASE_DEFENSE)
			e5:SetValue(0)
			hat:RegisterEffect(e5,true)
			local e6=Effect.CreateEffect(c)
			e6:SetType(EFFECT_TYPE_SINGLE)
			e6:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
			hat:RegisterEffect(e6,true)
			local e7=e1:Clone()
			e7:SetType(EFFECT_TYPE_SINGLE)
			e7:SetCode(EFFECT_CANNOT_ATTACK)
			hat:RegisterEffect(e7,true)
			local e8=e1:Clone()
			e8:SetType(EFFECT_TYPE_SINGLE)
			e8:SetCode(EFFECT_UNRELEASABLE_SUM)
			e8:SetValue(1)
			hat:RegisterEffect(e8,true)
			local e9=e8:Clone()
			e9:SetType(EFFECT_TYPE_SINGLE)
			e9:SetCode(EFFECT_UNRELEASABLE_NONSUM)
			e9:SetValue(1)
			hat:RegisterEffect(e9,true)
			local e10=e1:Clone()
			e10:SetType(EFFECT_TYPE_SINGLE)
			e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e10:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
			e10:SetValue(1)
			hat:RegisterEffect(e10,true)
			local e11=e1:Clone()
			e11:SetType(EFFECT_TYPE_SINGLE)
			e11:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
			e11:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
			e11:SetValue(1)
			hat:RegisterEffect(e11,true)
			local e12=e1:Clone()
			e12:SetType(EFFECT_TYPE_SINGLE)
			e12:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
			e12:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
			e12:SetValue(1)
			hat:RegisterEffect(e12,true)
			--Destroy token
			local e13=Effect.CreateEffect(c)
			e13:SetCategory(CATEGORY_DESTROY)
			e13:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e13:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e13:SetCode(EVENT_FLIP)
			e13:SetOperation(c120000030.hatop)
			e13:SetReset(RESET_EVENT+RESETS_STANDARD)
			hat:RegisterEffect(e13)
			local e14=Effect.CreateEffect(c)
			e14:SetType(EFFECT_TYPE_SINGLE)
			e14:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_SET_AVAILABLE)
			e14:SetCode(EFFECT_SELF_DESTROY)
			e14:SetLabelObject(e:GetHandler())
			e14:SetLabel(fid)
			e14:SetCondition(c120000030.hdescon)
			e14:SetReset(RESET_EVENT+RESETS_STANDARD)
			hat:RegisterEffect(e14)
			hat:SetStatus(STATUS_NO_LEVEL,true)
			hat:RegisterFlagEffect(120000030+3,RESET_EVENT+RESETS_STANDARD,0,0,fid)
		end	
		Duel.ChangePosition(hatm1,POS_FACEDOWN_DEFENSE)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(TYPE_TOKEN)
		e1:SetLabel(fid)
		e1:SetCondition(c120000030.econ)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		hatm1:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_REMOVE_RACE)
		e2:SetValue(RACE_ALL)
		hatm1:RegisterEffect(e2)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_REMOVE_ATTRIBUTE)
		e3:SetValue(0xff)
		hatm1:RegisterEffect(e3)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_SET_BASE_ATTACK)
		e4:SetValue(0)
		hatm1:RegisterEffect(e4)
		local e5=e1:Clone()
		e5:SetCode(EFFECT_SET_BASE_DEFENSE)
		e5:SetValue(0)
		hatm1:RegisterEffect(e5)
		local e6=e1:Clone()
		e6:SetCode(EFFECT_CHANGE_LEVEL)
		e6:SetValue(0)
		hatm1:RegisterEffect(e6)
		local e7=e1:Clone()
		e7:SetCode(EFFECT_UNRELEASABLE_SUM)
		e7:SetValue(1)
		e7:SetReset(RESET_EVENT+RESETS_STANDARD)
		hatm1:RegisterEffect(e7)
		local e8=e7:Clone()
		e8:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		hatm1:RegisterEffect(e8)
		hatm1:RegisterFlagEffect(120000030+1,RESET_EVENT+RESETS_STANDARD,0,0,fid)
		local gs1=Duel.GetMatchingGroup(c120000030.gsfilter,tp,LOCATION_ONFIELD,0,nil,fid)
		Duel.ChangePosition(gs1,POS_FACEDOWN_DEFENSE)
		Duel.ShuffleSetCard(gs1)
	end	
	--destroy1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_F)
	e1:SetRange(LOCATION_ONFIELD)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetLabelObject(hatm1)
	e1:SetLabel(fid)
	e1:SetCondition(c120000030.descon3)
	e1:SetOperation(c120000030.desop2)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_ONFIELD)
	e2:SetCode(EVENT_CHAINING)
	e2:SetLabelObject(hatm1)
	e2:SetLabel(fid)
	e2:SetCondition(c120000030.descon4)
	e2:SetOperation(c120000030.desop2)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_ONFIELD)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetLabelObject(hatm1)
	e3:SetLabel(fid)
	e3:SetCondition(c120000030.descon2)
	e3:SetOperation(c120000030.desop2)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e3)
	--destroy2
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_F)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_BATTLE_START)
	e4:SetLabel(fid)
	e4:SetCondition(c120000030.descon6)
	e4:SetOperation(c120000030.desop4)
	e4:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e4)
	--
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e5:SetRange(LOCATION_ONFIELD)
	e5:SetCode(EVENT_CHAINING)
	e5:SetLabel(fid)
	e5:SetCondition(c120000030.descon7)
	e5:SetOperation(c120000030.desop5)
	e5:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e5)
	--Reset
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e6:SetCode(EVENT_LEAVE_FIELD)
	e6:SetLabel(fid)
	e6:SetOperation(c120000030.desop6)
	c:RegisterEffect(e6)
	--
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_DESTROY)
	e7:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_REPEAT+EFFECT_FLAG_NO_TURN_RESET)
	e7:SetRange(LOCATION_ONFIELD)
	e7:SetCode(EVENT_ADJUST)
	e7:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
	e7:SetLabelObject(hatm1)
	e7:SetLabel(fid)
	e7:SetCondition(c120000030.retcon1)
	e7:SetOperation(c120000030.desop6)
	e7:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e7)
	--
	local e8=Effect.CreateEffect(c)
	e8:SetCategory(CATEGORY_DESTROY)
	e8:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_REPEAT+EFFECT_FLAG_NO_TURN_RESET)
	e8:SetRange(LOCATION_ONFIELD)
	e8:SetCode(EVENT_ADJUST)
	e8:SetLabel(fid)
	e8:SetOperation(c120000030.desop7)
	e8:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e8)
	--Set Spell or Trap Cards
	local e9=Effect.CreateEffect(c)
	e9:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e9:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e9:SetType(EFFECT_TYPE_IGNITION)
	e9:SetRange(LOCATION_ONFIELD)
	e9:SetCost(c120000030.stcost)
	e9:SetTarget(c120000030.sttar)
	e9:SetOperation(c120000030.stop)
	e9:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e9)
end	
function c120000030.econ(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFacedown()
end	
function c120000030.hatop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
function c120000030.tdfilter(c,fid)
	return c:IsFaceup() and c:GetFlagEffectLabel(120000030)==fid and not (c:IsStatus(STATUS_DISABLED) or c:IsDisabled()) 
end
function c120000030.hdescon(e)
	local fid=e:GetLabel()
	return not Duel.IsExistingMatchingCard(c120000030.tdfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil,fid)
end
function c120000030.gsfilter(c,fid)
	return c:IsFacedown() and (c:GetFlagEffectLabel(120000030+1)==fid or c:GetFlagEffectLabel(120000030+2)==fid or c:GetFlagEffectLabel(120000030+3)==fid or c:GetFlagEffectLabel(120000030+4)==fid)
end
function c120000030.descon2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return tc and tc:GetFlagEffectLabel(120000030+1)==e:GetLabel() and eg:IsContains(tc)
end
function c120000030.retfilter(c,fid)
	return c:GetFlagEffectLabel(120000030+1)
end
function c120000030.descon3(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return tc and tc==Duel.GetAttackTarget() and tc:GetFlagEffectLabel(120000030+1)==e:GetLabel()
end
function c120000030.descon4(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:IsStatus(STATUS_BATTLE_DESTROYED) or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsContains(tc) 
end
function c120000030.descon6(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttackTarget() 
	return tc and tc:GetFlagEffectLabel(120000030+2)==e:GetLabel()
end
function c120000030.thfilter(c,tp,fid)
	return c:IsFacedown() and c:GetFlagEffectLabel(120000030+2)==fid and c:IsControler(tp) 
end
function c120000030.descon7(e,tp,eg,ep,ev,re,r,rp)
	local fid=e:GetLabel()
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsExists(c120000030.thfilter,1,nil,tp,fid)
end
function c120000030.refilter(c,fid)
	return c:IsFacedown() and c:GetFlagEffectLabel(120000030+2)==fid or c:GetFlagEffectLabel(120000030+3)==fid  or c:GetFlagEffectLabel(120000030+4)==fid 
end
function c120000030.retcon1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local fid=e:GetLabel()
	return not tc:IsPosition(POS_FACEDOWN_DEFENSE) or not Duel.IsExistingMatchingCard(c120000030.refilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil,fid) 
	or e:GetHandler():IsStatus(STATUS_DISABLED) or e:GetHandler():IsDisabled() 
end
function c120000030.refilter2(c,fid)
	return c:IsFaceup() and c:GetFlagEffectLabel(120000030+2)==fid  
end
function c120000030.desop7(e,tp,eg,ep,ev,re,r,rp)
	local fid=e:GetLabel()
	local g=Duel.GetMatchingGroup(c120000030.refilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,fid)
	local tc=g:GetFirst()
	for tc in aux.Next(g) do
		if tc:GetFlagEffectLabel(120000030+2)==fid then
			tc:ResetFlagEffect(120000030+2) 
		end
	end
end
function c120000030.desfilter1(c,fid)
	return c:IsFacedown() and c:GetFlagEffectLabel(120000030+2)==fid 
end
function c120000030.desfilter2(c,fid)
	return c:GetFlagEffectLabel(120000030+3)==fid or c:GetFlagEffectLabel(120000030+4)==fid 
end
function c120000030.desop2(e,tp,eg,ep,ev,re,r,rp)
	local tc1=e:GetLabelObject()
	local fid=e:GetLabel()
	if tc1 and tc1:GetFlagEffectLabel(120000030+1)==fid then
		Duel.ChangePosition(tc1,tc1:GetPreviousPosition())
		if tc1:GetFlagEffectLabel(120000030+1)==fid then
			tc1:ResetFlagEffect(120000030+1)
		else 
			tc1:ResetFlagEffect(120000030+2) 
		end		
	end
	local g1=Duel.GetMatchingGroup(c120000030.desfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,fid)
	local tc2=g1:GetFirst()
	for tc2 in aux.Next(g1) do
		Duel.ChangePosition(tc2,tc2:GetPreviousPosition()) 
		if tc2:GetFlagEffectLabel(120000030+1)==fid then
			tc2:ResetFlagEffect(120000030+1)
		else 
			tc2:ResetFlagEffect(120000030+2) 
		end
	end
	local g2=Duel.GetMatchingGroup(c120000030.desfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,fid)
	if #g2>0 then
		Duel.Destroy(g2,REASON_EFFECT)
	end
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
function c120000030.desop4(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttackTarget() 
	local fid=e:GetLabel()
	if tc and tc:GetFlagEffectLabel(120000030+2)==fid then
		Duel.ChangePosition(tc,tc:GetPreviousPosition())  
		if tc:GetFlagEffectLabel(120000030+1)==fid then
			tc:ResetFlagEffect(120000030+1)
		else 
			tc:ResetFlagEffect(120000030+2) 
		end	
	end
end
function c120000030.desfilter3(c,fid)
	return c:IsFacedown() and c:GetFlagEffectLabel(120000030+2)==fid
end
function c120000030.desop5(e,tp,eg,ep,ev,re,r,rp)
	local fid=e:GetLabel()
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(c120000030.desfilter3,nil,fid)
	local tc=tg:GetFirst()
	if tc then
		Duel.ChangePosition(tc,tc:GetPreviousPosition()) 
		if tc:GetFlagEffectLabel(120000030+1)==fid then
			tc:ResetFlagEffect(120000030+1)
		else 
			tc:ResetFlagEffect(120000030+2) 
		end	
	end
end
function c120000030.desfilter4(c,fid)
	return c:IsFacedown() and c:GetFlagEffectLabel(120000030+1)==fid or c:GetFlagEffectLabel(120000030+2)==fid 
end
function c120000030.desop6(e,tp,eg,ep,ev,re,r,rp)
	local fid=e:GetLabel()
	local g1=Duel.GetMatchingGroup(c120000030.desfilter4,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,fid)
	local tc=g1:GetFirst()
	for tc in aux.Next(g1) do
		Duel.ChangePosition(tc,tc:GetPreviousPosition()) 
		if tc:GetFlagEffectLabel(120000030+1)==fid then
			tc:ResetFlagEffect(120000030+1)
		else 
			tc:ResetFlagEffect(120000030+2) 
		end
	end
	local g2=Duel.GetMatchingGroup(c120000030.desfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,fid)
	if #g2>0 then
		Duel.Destroy(g2,REASON_EFFECT)
	end
	e:GetHandler():ResetFlagEffect(120000030)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
function c120000030.costfilter(c)
	return c:GetFlagEffect(120000030+3)~=0 and c:IsType(TYPE_TOKEN) 
end
function c120000030.stcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c120000030.costfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c120000030.costfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c120000030.stfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c120000030.sttar(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c120000030.stfilter,e:GetHandlerPlayer(),LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c120000030.stop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local fid=c:GetFieldID()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c120000030.stfilter,e:GetHandlerPlayer(),LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_MZONE,POS_FACEDOWN_DEFENSE,true)
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(TYPE_TOKEN)
		e1:SetReset(RESET_EVENT|(RESETS_STANDARD|RESET_MSCHANGE|RESET_TOFIELD))
		tc:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_REMOVE_RACE)
		e2:SetValue(RACE_ALL)
		tc:RegisterEffect(e2,true)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_REMOVE_ATTRIBUTE)
		e3:SetValue(0xff)
		tc:RegisterEffect(e3,true)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_SET_BASE_ATTACK)
		e4:SetValue(0)
		tc:RegisterEffect(e4,true)
		local e5=e1:Clone()
		e5:SetCode(EFFECT_SET_BASE_DEFENSE)
		e5:SetValue(0)
		tc:RegisterEffect(e5,true)
		local e6=Effect.CreateEffect(tc)
		e6:SetType(EFFECT_TYPE_SINGLE)
		e6:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
		tc:RegisterEffect(e6,true)
		local e7=e1:Clone()
		e7:SetType(EFFECT_TYPE_SINGLE)
		e7:SetCode(EFFECT_CANNOT_ATTACK)
		tc:RegisterEffect(e7,true)
		local e8=e1:Clone()
		e8:SetType(EFFECT_TYPE_SINGLE)
		e8:SetCode(EFFECT_UNRELEASABLE_SUM)
		e8:SetValue(1)
		tc:RegisterEffect(e8,true)
		local e9=e8:Clone()
		e9:SetType(EFFECT_TYPE_SINGLE)
		e9:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		e9:SetValue(1)
		tc:RegisterEffect(e9,true)
		local e10=e1:Clone()
		e10:SetType(EFFECT_TYPE_SINGLE)
		e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e10:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		e10:SetValue(1)
		tc:RegisterEffect(e10,true)
		local e11=e1:Clone()
		e11:SetType(EFFECT_TYPE_SINGLE)
		e11:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
		e11:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		e11:SetValue(1)
		tc:RegisterEffect(e11,true)
		tc:SetStatus(STATUS_NO_LEVEL,true)
		tc:RegisterFlagEffect(120000030+4,RESET_EVENT+0x17a0000,0,0,fid)
	end	
	--Activate set card
	local ac1=Effect.CreateEffect(c)
	ac1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_F)
	ac1:SetCode(EVENT_BE_BATTLE_TARGET)
	ac1:SetRange(LOCATION_SZONE)
	ac1:SetLabelObject(tc)
	ac1:SetLabel(fid)
	ac1:SetCondition(c120000030.actcon1)
	ac1:SetOperation(c120000030.actop1)
	ac1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(ac1)
	local ac2=Effect.CreateEffect(c)
	ac2:SetCategory(CATEGORY_DESTROY)
	ac2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_F)
	ac2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	ac2:SetRange(LOCATION_SZONE)
	ac2:SetCode(EVENT_BECOME_TARGET)
	ac2:SetLabelObject(tc)
	ac2:SetLabel(fid)
	ac2:SetCondition(c120000030.actcon2)
	ac2:SetOperation(c120000030.actop2)
	ac2:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(ac2)
	local gs1=Duel.GetMatchingGroup(c120000030.gsfilter,tp,LOCATION_ONFIELD,0,nil,fid)
	Duel.ChangePosition(gs1,POS_FACEDOWN_DEFENSE)
	Duel.ShuffleSetCard(gs1)
end
function c120000030.actcon1(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttackTarget()
	return d:IsControler(tp) and d==e:GetLabelObject()
end
function c120000030.actop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local te=tc:GetActivateEffect()
	if not te or not tc==Duel.GetAttackTarget() then return end
	local pre={Duel.GetPlayerEffect(tp,EFFECT_CANNOT_ACTIVATE)}
	if pre[1] then
		for i,eff in ipairs(pre) do
			local prev=eff:GetValue()
			if type(prev)~='function' or prev(eff,te,tp) then return false end
		end
	end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and tc:IsRelateToBattle() and tc:CheckActivateEffect(false,false,false)~=nil and not tc:IsHasEffect(EFFECT_CANNOT_TRIGGER) then
		local tpe=tc:GetOriginalType()
		local tg=te:GetTarget()
		local co=te:GetCost()
		local op=te:GetOperation()
		e:SetCategory(te:GetCategory())
		e:SetProperty(te:GetProperty())
		Duel.ClearTargetCard()
		if (tpe&TYPE_FIELD)~=0 then
			local fc=Duel.GetFieldCard(1-tp,LOCATION_SZONE,5)
			if Duel.IsDuelType(DUEL_1_FIELD) then
				if fc then Duel.Destroy(fc,REASON_RULE) end
				fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
				if fc and Duel.Destroy(fc,REASON_RULE)==0 then Duel.SendtoGrave(tc,REASON_RULE) end
			else
				fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
				if fc and Duel.SendtoGrave(fc,REASON_RULE)==0 then Duel.SendtoGrave(tc,REASON_RULE) end
			end
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		if (tpe&TYPE_TRAP+TYPE_FIELD)==TYPE_TRAP+TYPE_FIELD then
			Duel.MoveSequence(tc,5)
		end
		Duel.Hint(HINT_CARD,0,tc:GetCode())
		tc:CreateEffectRelation(te)
		if (tpe&TYPE_EQUIP+TYPE_CONTINUOUS+TYPE_FIELD)==0 and not tc:IsHasEffect(EFFECT_REMAIN_FIELD) then
			tc:CancelToGrave(false)
		end
		if te:GetCode()==EVENT_CHAINING then
			local te2=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_EFFECT)
			local tc=te2:GetHandler()
			local g=Group.FromCards(tc)
			local p=tc:GetControler()
			if co then co(te,tp,g,p,chain,te2,REASON_EFFECT,p,1) end
			if tg then tg(te,tp,g,p,chain,te2,REASON_EFFECT,p,1) end
		elseif te:GetCode()==EVENT_FREE_CHAIN then
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
			if te:GetCode()==EVENT_CHAINING then
				local te2=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_EFFECT)
				local tc=te2:GetHandler()
				local g=Group.FromCards(tc)
				local p=tc:GetControler()
				if op then op(te,tp,g,p,chain,te2,REASON_EFFECT,p) end
			elseif te:GetCode()==EVENT_FREE_CHAIN then
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
function c120000030.actcon2(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and eg:IsContains(e:GetLabelObject()) 
end
function c120000030.actop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local te=tc:GetActivateEffect()
	if not te then return end
	local pre={Duel.GetPlayerEffect(tp,EFFECT_CANNOT_ACTIVATE)}
	if pre[1] then
		for i,eff in ipairs(pre) do
			local prev=eff:GetValue()
			if type(prev)~='function' or prev(eff,te,tp) then return false end
		end
	end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and tc:CheckActivateEffect(false,false,false)~=nil and not tc:IsHasEffect(EFFECT_CANNOT_TRIGGER) then
		local tpe=tc:GetOriginalType()
		local tg=te:GetTarget()
		local co=te:GetCost()
		local op=te:GetOperation()
		e:SetCategory(te:GetCategory())
		e:SetProperty(te:GetProperty())
		Duel.ClearTargetCard()
		if (tpe&TYPE_FIELD)~=0 then
			local fc=Duel.GetFieldCard(1-tp,LOCATION_SZONE,5)
			if Duel.IsDuelType(DUEL_1_FIELD) then
				if fc then Duel.Destroy(fc,REASON_RULE) end
				fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
				if fc and Duel.Destroy(fc,REASON_RULE)==0 then Duel.SendtoGrave(tc,REASON_RULE) end
			else
				fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
				if fc and Duel.SendtoGrave(fc,REASON_RULE)==0 then Duel.SendtoGrave(tc,REASON_RULE) end
			end
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		if (tpe&TYPE_TRAP+TYPE_FIELD)==TYPE_TRAP+TYPE_FIELD then
			Duel.MoveSequence(tc,5)
		end
		Duel.Hint(HINT_CARD,0,tc:GetCode())
		tc:CreateEffectRelation(te)
		if (tpe&TYPE_EQUIP+TYPE_CONTINUOUS+TYPE_FIELD)==0 and not tc:IsHasEffect(EFFECT_REMAIN_FIELD) then
			tc:CancelToGrave(false)
		end
		if te:GetCode()==EVENT_CHAINING then
			local te2=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_EFFECT)
			local tc=te2:GetHandler()
			local g=Group.FromCards(tc)
			local p=tc:GetControler()
			if co then co(te,tp,g,p,chain,te2,REASON_EFFECT,p,1) end
			if tg then tg(te,tp,g,p,chain,te2,REASON_EFFECT,p,1) end
		elseif te:GetCode()==EVENT_FREE_CHAIN then
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
			if te:GetCode()==EVENT_CHAINING then
				local te2=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_EFFECT)
				local tc=te2:GetHandler()
				local g=Group.FromCards(tc)
				local p=tc:GetControler()
				if op then op(te,tp,g,p,chain,te2,REASON_EFFECT,p) end
			elseif te:GetCode()==EVENT_FREE_CHAIN then
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
function c120000030.descon(e)
	return not Duel.IsExistingMatchingCard(c120000030.refilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil,fid) 
end
