--罪鍵の法－シン・キー・ロウ
function c120000033.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_DAMAGE_STEP_END)
	e1:SetTarget(c120000033.target)
	e1:SetOperation(c120000033.activate)
	c:RegisterEffect(e1)
	aux.GlobalCheck(c120000033,function()
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_BATTLED)
		ge1:SetOperation(c120000033.checkop)
		Duel.RegisterEffect(ge1,0)
	end)
end
function c120000033.checkop(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttackTarget()
	if at and at:IsControler(tp) and at:IsRelateToBattle() and not (at:IsStatus(STATUS_BATTLE_DESTROYED) or at:IsDefensePos()) then
		at:RegisterFlagEffect(120000033,RESET_EVENT+RESETS_STANDARD,0,0)
	end
end
function c120000033.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local at=Duel.GetAttackTarget()
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) and Duel.GetLocationCount(tp,LOCATION_MZONE)>2 and at:GetFlagEffect(120000033)>0 end
	Duel.SetTargetCard(at)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,3,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,3,0,0)
	at:RegisterFlagEffect(120000033,RESET_EVENT+RESETS_STANDARD,0,0)
end
function c120000033.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then return end
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>2 then
		local rfid=tc:GetRealFieldID()
		local atk=0
		local cr=false
		if tc:IsFaceup() and tc:IsRelateToEffect(e) then
			atk=tc:GetAttack()
			cr=true
		end
		if not Duel.IsPlayerCanSpecialSummonMonster(tp,67949764,0x87,0x4011,-2,0,1,RACE_FIEND,ATTRIBUTE_DARK) then return end
		if cr then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EVENT_LEAVE_FIELD)
			e1:SetOperation(c120000033.desop)
			e1:SetLabel(rfid)
			tc:RegisterEffect(e1,true)
		end
		for i=1,3 do
			local token=Duel.CreateToken(tp,67949764)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
			--Atk
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e2:SetRange(LOCATION_MZONE)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetValue(c120000033.valatk)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			token:RegisterEffect(e2,true)
			if cr then
				token:RegisterFlagEffect(67949764,RESET_EVENT+RESETS_STANDARD,0,0,rfid)
				tc:CreateRelation(token,RESET_EVENT+RESETS_STANDARD)
			end
			Duel.SpecialSummonComplete()
		end	
	end
end
function c120000033.desfilter(c,rfid)
	return c:GetFlagEffectLabel(67949764)==rfid
end
function c120000033.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c120000033.desfilter,tp,LOCATION_ONFIELD,0,nil,e:GetLabel())
	Duel.Destroy(g,REASON_EFFECT)
	e:Reset()
end
function c120000033.checkfilter(c)
	return c:IsFaceup() and c:GetFlagEffect(120000033)>0
end
function c120000033.valatk(e,c,tp)
	local g=Duel.GetMatchingGroup(c120000033.checkfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,nil)
	if #g==0 then return end
	local tc=g:GetFirst()
	local atk=tc:GetAttack()
	return atk
end