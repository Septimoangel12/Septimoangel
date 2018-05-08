--デュエリスト・キングダム 
function c120000071.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PREDRAW)
	e1:SetCountLimit(1)
	e1:SetRange(0xff)
	e1:SetCondition(c120000071.con)
	e1:SetOperation(c120000071.op)
	c:RegisterEffect(e1)
	--decrease tribute
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(120000071,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EFFECT_SUMMON_PROC)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
	e2:SetCondition(c120000071.ntcon)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e3)
	--faceup def
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_REMOVED)
	e4:SetCode(EFFECT_DEVINE_LIGHT)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
	c:RegisterEffect(e4)
	--cannot direct attack
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e5:SetRange(LOCATION_REMOVED)
	e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	c:RegisterEffect(e5)
	--unaffectable
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetRange(LOCATION_REMOVED)
	e6:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e6:SetValue(1)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_IMMUNE_EFFECT)
	e7:SetValue(c120000071.ctcon2)
	c:RegisterEffect(e7)
	--cannot attack
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e8:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e8:SetRange(LOCATION_REMOVED)
	e8:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e8:SetCondition(c120000071.atkcon)
	e8:SetTarget(c120000071.atktg)
	c:RegisterEffect(e8)
	--check
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e9:SetCode(EVENT_ATTACK_ANNOUNCE)
	e9:SetRange(LOCATION_REMOVED)
	e9:SetOperation(c120000071.checkop)
	e9:SetLabelObject(e2)
	c:RegisterEffect(e9)
	--Set Spell cards can activate in opponent's turn
	local e10=Effect.CreateEffect(c)
	e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e10:SetType(EFFECT_TYPE_FIELD)
	e10:SetCode(EFFECT_BECOME_QUICK)
	e10:SetRange(LOCATION_REMOVED)
	e10:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
	c:RegisterEffect(e10)
	--Machine Inmunity 
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_FIELD)
	e11:SetRange(LOCATION_REMOVED)
	e11:SetCode(EFFECT_IMMUNE_EFFECT)
	e11:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e11:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_MACHINE))
	e11:SetValue(c120000071.efilter)
	c:RegisterEffect(e11)
	--
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE)
	e12:SetCode(EFFECT_CANNOT_TO_DECK)
	e12:SetRange(LOCATION_REMOVED)
	c:RegisterEffect(e12)
	local e13=e12:Clone()
	e13:SetCode(EFFECT_CANNOT_TO_HAND)
	c:RegisterEffect(e13)
	local e14=e12:Clone()
	e14:SetCode(EFFECT_CANNOT_TO_GRAVE)
	c:RegisterEffect(e14)
	local e15=e12:Clone()
	e15:SetCode(EFFECT_CANNOT_REMOVE)
	c:RegisterEffect(e15)
end
function c120000071.con(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnCount()==1
end
function c120000071.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil,120000071) then
		Duel.DisableShuffleCheck()
		Duel.SendtoDeck(c,nil,-2,REASON_RULE)
	else
		Duel.Remove(c,POS_FACEUP,REASON_RULE)
	end
	if e:GetHandler():GetPreviousLocation()==LOCATION_HAND and Duel.IsPlayerCanDraw(e:GetHandlerPlayer(),1)then
		Duel.Draw(tp,1,REASON_RULE)
	end
	local g=Duel.GetMatchingGroup(aux.NOT(Card.IsHasEffect),tp,0xff,0xff,nil,EFFECT_LIMIT_SUMMON_PROC)
	local g2=Duel.GetMatchingGroup(aux.NOT(Card.IsHasEffect),tp,0xff,0xff,nil,EFFECT_LIMIT_SET_PROC)
	local tc=g:GetFirst()
	if tc then
		while tc do
			tc:RegisterFlagEffect(1200000711,0,0,1)
			tc=g:GetNext()
		end
	end
	local tc2=g2:GetFirst()
	if tc2 then
		while tc2 do
			tc2:RegisterFlagEffect(1200000711,0,0,1)
			tc2=g2:GetNext()
		end
	end
end
function c120000071.ntcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c120000071.ctcon2(e,re)
	return re:GetHandler()~=e:GetHandler()
end
function c120000071.atkcon(e)
	return e:GetHandler():GetFlagEffect(30606547)~=0
end
function c120000071.atktg(e,c)
	return c:GetFieldID()~=e:GetLabel()
end
function c120000071.checkop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(30606547)~=0 then return end
	local fid=eg:GetFirst():GetFieldID()
	e:GetHandler():RegisterFlagEffect(30606547,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	e:GetLabelObject():SetLabel(fid)
end
function c120000071.efilter(e,re,rp)
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer() and re:IsActiveType(TYPE_SPELL) and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) 
	and Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
end
