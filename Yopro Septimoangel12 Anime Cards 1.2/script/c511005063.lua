--マジカルシルクハット
if not c511005063.gl_chk then
	c511005063.gl_chk=true
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
function c511005063.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c511005063.condition)
	e1:SetTarget(c511005063.target)
	e1:SetOperation(c511005063.activate)
	c:RegisterEffect(e1)
	--Set Spell or Trap Cards
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCost(c511005063.stcost)
	e2:SetTarget(c511005063.sttar)
	e2:SetOperation(c511005063.stop)
	c:RegisterEffect(e2)
	--Set card destroy
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BATTLE_DESTROYED)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c511005063.actcon)
	e3:SetOperation(c511005063.actmop)
	c:RegisterEffect(e3)
	--remain field
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e4)
	--flip
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_POSITION)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetOperation(c511005063.posop)
	c:RegisterEffect(e5)
	--Destroy3
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e6:SetCode(EVENT_LEAVE_FIELD)
	e6:SetOperation(c511005063.desop2)
	c:RegisterEffect(e6)
end
function c511005063.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER)
end
function c511005063.condition(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	return Duel.IsExistingMatchingCard(c511005063.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c511005063.tgfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c511005063.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c511005063.tgfilter(chkc,tp) end
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>2
		and Duel.IsExistingTarget(c511005063.tgfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,511005063)
	Duel.SelectTarget(tp,c511005063.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,3,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,3,0,0)
end
function c511005063.spfilter(c,e,tp)
	return Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),nil,0x11,0,0,0,0,0)
end
function c511005063.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() then
		if tc:IsHasEffect(EFFECT_DEVINE_LIGHT) then Duel.ChangePosition(tc,POS_FACEUP_DEFENCE)
		else Duel.ChangePosition(tc,POS_FACEDOWN_DEFENCE) end
			local e1=Effect.CreateEffect(tc)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(TYPE_TOKEN)
			e1:SetCondition(c511005063.econ)
			e1:SetReset(RESET_EVENT+0x1fe0000)
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
			local e6=e1:Clone()
			e6:SetCode(EFFECT_UNRELEASABLE_NONSUM)
			e6:SetValue(1)
			e6:SetCondition(c511005063.recon)
			tc:RegisterEffect(e6,true)
			tc:RegisterFlagEffect(78800019,RESET_EVENT,0x17a0000,0,0)
		end
		for i=1,3 do
			local cs=Duel.CreateToken(tp,511005062)
			Duel.SpecialSummonStep(cs,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
			local e1=Effect.CreateEffect(cs)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(TYPE_TOKEN)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			cs:RegisterEffect(e1,true)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_REMOVE_RACE)
			e2:SetValue(RACE_ALL)
			cs:RegisterEffect(e2,true)
			local e3=e1:Clone()
			e3:SetCode(EFFECT_REMOVE_ATTRIBUTE)
			e3:SetValue(0xff)
			cs:RegisterEffect(e3,true)
			local e4=e1:Clone()
			e4:SetCode(EFFECT_SET_BASE_ATTACK)
			e4:SetValue(0)
			cs:RegisterEffect(e4,true)
			local e5=e1:Clone()
			e5:SetCode(EFFECT_SET_BASE_DEFENSE)
			e5:SetValue(0)
			cs:RegisterEffect(e5,true)
			local e6=e1:Clone()
			e6:SetType(EFFECT_TYPE_SINGLE)
			e6:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
			e6:SetValue(1)
			cs:RegisterEffect(e6,true)
			local e7=e1:Clone()
			e7:SetType(EFFECT_TYPE_SINGLE)
			e7:SetCode(EFFECT_CANNOT_ATTACK)
			cs:RegisterEffect(e7,true)
			local e8=e1:Clone()
			e8:SetType(EFFECT_TYPE_SINGLE)
			e8:SetCode(EFFECT_UNRELEASABLE_SUM)
			e8:SetValue(1)
			cs:RegisterEffect(e8,true)
			local e9=e8:Clone()
			e9:SetType(EFFECT_TYPE_SINGLE)
			e9:SetCode(EFFECT_UNRELEASABLE_NONSUM)
			e9:SetValue(1)
			e9:SetCondition(c511005063.recon)
			cs:RegisterEffect(e9,true)
			local e10=e1:Clone()
			e10:SetType(EFFECT_TYPE_SINGLE)
			e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e10:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
			e10:SetValue(1)
			cs:RegisterEffect(e10,true)
			local e11=e1:Clone()
			e11:SetType(EFFECT_TYPE_SINGLE)
			e11:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
			e11:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
			e11:SetValue(1)
			cs:RegisterEffect(e11,true)
			cs:SetStatus(STATUS_NO_LEVEL,true)
			cs:RegisterFlagEffect(511005063,RESET_EVENT+0x17a0000,0,0)
		end
		Duel.SpecialSummonComplete()
		local gs1=Duel.GetMatchingGroup(c511005063.gsfilter,tp,LOCATION_MZONE,0,nil,e,tp)
		Duel.ShuffleSetCard(gs1)
		--destroy1
		local e12=Effect.CreateEffect(e:GetHandler())
		e12:SetCategory(CATEGORY_DESTROY)
		e12:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		e12:SetRange(LOCATION_SZONE)
		e12:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
		e12:SetCode(EVENT_LEAVE_FIELD)
		e12:SetCondition(c511005063.descon)
		e12:SetOperation(c511005063.desop)
		e12:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e12)
		--Destroy2
		local e13=Effect.CreateEffect(e:GetHandler())
		e13:SetCategory(CATEGORY_DESTROY)
		e13:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		e13:SetRange(LOCATION_SZONE)
		e13:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
		e13:SetCode(EVENT_FLIP)
		e13:SetCondition(c511005063.descon2)
		e13:SetOperation(c511005063.desop)
		e13:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e13)
end
function c511005063.tdfilter(c)
	return c:IsFaceup() and c:IsCode(511005063)
end
function c511005063.econ(e)
	return Duel.IsExistingMatchingCard(c511005063.tdfilter,tp,LOCATION_SZONE,0,1,nil)
		or Duel.IsEnvironment(511005063)
end
function c511005063.recon(e)
	return Duel.GetTurnPlayer()~=e:GetOwnerPlayer()
end
function c511005063.dfilter(c,tp)
	return c:GetFlagEffect(78800019)~=0 and c:IsType(TYPE_MONSTER)
end
function c511005063.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c511005063.dfilter,1,nil,tp)
end
function c511005063.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
function c511005063.descon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c511005063.dfilter,1,nil,tp)
end
function c511005063.desfilter(c,e,tp)
	return c:GetFlagEffect(511005063)~=0 or c:GetFlagEffect(78800020)~=0 and c:IsType(TYPE_TOKEN)
end
function c511005063.posop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c511005063.dfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,e:GetHandler())
	Duel.ChangePosition(g,POS_FACEUP_ATTACK)
end
function c511005063.desop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c511005063.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,e:GetHandler())
	Duel.Destroy(g,REASON_EFFECT)
end
function c511005063.stfilter(c,e,tp)
	return c:GetFlagEffect(511005063)~=0 and c:IsType(TYPE_TOKEN)
end
function c511005063.stcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c511005063.stfilter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c511005063.stfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c511005063.spstfilter(c,e,tp)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEDOWN)
end
function c511005063.sttar(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c511005063.spstfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c511005063.stop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local g=Duel.GetMatchingGroup(c511005063.spstfilter,tp,LOCATION_HAND,0,nil,e,tp)
	if g:GetCount()<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,511005063)
	local sg=g:Select(tp,1,1,nil)
	local tc=sg:GetFirst()
	while tc do
	Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEDOWN_DEFENSE)
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(TYPE_TOKEN)
		e1:SetReset(RESET_EVENT+0x1fe0000)
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
		local e6=e1:Clone()
		e6:SetType(EFFECT_TYPE_SINGLE)
		e6:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
		e6:SetValue(1)
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
		e9:SetCondition(c511005063.recon)
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
		tc:RegisterFlagEffect(78800020,RESET_EVENT+0x17a0000,0,0)
		tc=sg:GetNext()
		sg:KeepAlive()
	end
	local gs1=Duel.GetMatchingGroup(c511005063.gsfilter,tp,LOCATION_MZONE,0,nil,e,tp)
	Duel.ShuffleSetCard(gs1)
end
function c511005063.gsfilter(c,e,tp)
	return c:IsFacedown() and c:GetFlagEffect(511005063)~=0 or c:GetFlagEffect(78800019)~=0 or c:GetFlagEffect(78800020)~=0
end
function c511005063.actfilter(c,tp)
	return c:GetFlagEffect(78800020)~=0 and c:IsControler(tp)
end
function c511005063.actcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c511005063.actfilter,1,nil,tp)
end
function c511005063.actmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if tc and tc:GetFlagEffect(78800020)~=0 then
		local tpe=tc:GetType()
		local te=tc:GetActivateEffect()
		if not te then return end
		local con=te:GetCondition()
		local co=te:GetCost()
		local tg=te:GetTarget()
		local op=te:GetOperation()
		if (not con or con(te,tp,eg,ep,ev,re,r,rp)) and (not co or co(te,tp,eg,ep,ev,re,r,rp,0))
			and (not tg or tg(te,tp,eg,ep,ev,re,r,rp,0)) then
			Duel.ClearTargetCard()
		if bit.band(tpe,TYPE_FIELD)~=0 then
			local of=Duel.GetFieldCard(1-tp,LOCATION_SZONE,5)
			if of then Duel.Destroy(of,REASON_RULE) end
			of=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
			if of and Duel.Destroy(of,REASON_RULE)==0 then Duel.SendtoGrave(tc,REASON_RULE) end
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		Duel.Hint(HINT_CARD,0,tc:GetCode())
		tc:CreateEffectRelation(te)
		if bit.band(tpe,TYPE_EQUIP+TYPE_CONTINUOUS+TYPE_FIELD)==0 then
			tc:CancelToGrave(false)
		end
		if con then con(te,tp,eg,ep,ev,re,r,rp,1) end
		if co then co(te,tp,eg,ep,ev,re,r,rp,1) end
		if tg then tg(te,tp,eg,ep,ev,re,r,rp,1) end
		Duel.BreakEffect()
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		if g then
			local etc=g:GetFirst()
			while etc do
				etc:CreateEffectRelation(te)
				etc=g:GetNext()
			end
		end
		if op then op(te,tp,eg,ep,ev,re,r,rp) end
		tc:ReleaseEffectRelation(te)
		if etc then	
			etc=g:GetFirst()
			while etc do
				etc:ReleaseEffectRelation(te)
				etc=g:GetNext()	end
			end		
		end
	end
end