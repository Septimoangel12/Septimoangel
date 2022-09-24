--デュエリスト・キングダム (アニメ)
function c120000071.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(0xff)
	e1:SetCondition(c120000071.rcon)
	c:RegisterEffect(e1)
	aux.EnableExtraRules(c,c120000071,c120000071.init)
end
function c120000071.init(c)
	--Terrains
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetCountLimit(1)
	e1:SetCondition(c120000071.con)
	e1:SetOperation(c120000071.op1)
	Duel.RegisterEffect(e1,0)
	--
	local e2=e1:Clone()
	e2:SetOperation(c120000071.op2)
	Duel.RegisterEffect(e2,0)
	--decrease tribute
	local e3=Effect.GlobalEffect()
	e3:SetDescription(aux.Stringid(120000071,1))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EFFECT_SUMMON_PROC)
	e3:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
	e3:SetCondition(c120000071.ntcon)
	e3:SetTarget(c120000071.nttg)
	Duel.RegisterEffect(e3,0)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_SET_PROC)
	e4:SetTarget(c120000071.nttg2)
	Duel.RegisterEffect(e4,0)
	local e5=e2:Clone()
	e5:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e5:SetTarget(c120000071.nttg3)
	Duel.RegisterEffect(e5,0)
	local e6=e3:Clone()
	e6:SetCode(EFFECT_LIMIT_SET_PROC)
	e6:SetTarget(c120000071.nttg4)
	Duel.RegisterEffect(e6,0)
	--set up flags to prevent loop with above effect
	local e7=Effect.GlobalEffect()
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_ADJUST)
	e7:SetCondition(c120000071.limitcon)
	e7:SetOperation(c120000071.limitop)
	Duel.RegisterEffect(e7,0)
	--summon face-up defense
	local e8=Effect.GlobalEffect()
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_IGNORE_IMMUNE)
	e8:SetCode(EFFECT_LIGHT_OF_INTERVENTION)
	e8:SetTargetRange(1,1)
	Duel.RegisterEffect(e8,0)
	--cannot direct attack
	local e9=Effect.GlobalEffect()
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e9:SetProperty(EFFECT_FLAG_OATH+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e9:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e9:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	Duel.RegisterEffect(e9,0)
	 --cannot attack
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD)
	e10:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e10:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e10:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e10:SetCondition(c120000071.atkcon)
	e10:SetTarget(c120000071.atktg)
	Duel.RegisterEffect(e10,0)
	--check
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e11:SetCode(EVENT_ATTACK_ANNOUNCE)
	e11:SetOperation(c120000071.atkcheckop)
	e11:SetLabelObject(e10)
	Duel.RegisterEffect(e11,0)
	--Set Spell cards can activate in opponent's turn
	local e12=Effect.GlobalEffect()
	e12:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e12:SetType(EFFECT_TYPE_FIELD)
	e12:SetCode(EFFECT_BECOME_QUICK)
	e12:SetRange(LOCATION_REMOVED)
	e12:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
	Duel.RegisterEffect(e12,0)
	--Machine Inmunity 
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_FIELD)
	e13:SetCode(EFFECT_IMMUNE_EFFECT)
	e13:SetTargetRange(LOCATION_ONFIELD,0)
	e13:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_MACHINE))
	e13:SetValue(c120000071.efilter1)
	Duel.RegisterEffect(e13,0)
	--
	local e14=e13:Clone()
	Duel.RegisterEffect(e14,1)
	Duel.RegisterFlagEffect(0,120000071,0,0,1)
	Duel.RegisterFlagEffect(1,120000071,0,0,1)
end
function c120000071.rcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,120000071)==0
end
function c120000071.con(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFieldCard(LOCATION_SZONE,0,5)
	if tc and tc:IsFaceup() then return false end
	tc=Duel.GetFieldCard(1,LOCATION_SZONE,5)
	return not tc and Duel.GetTurnCount()==1
end
function c120000071.op1(e,tp,eg,ep,ev,re,r,rp)
	local tf1=Duel.GetFieldCard(1-tp,LOCATION_SZONE,5)
	local op1
	local op2
	local token1=nil
	local token2=nil
	if tf1==nil and Duel.SelectYesNo(1-tp,aux.Stringid(120000071,0)) then
		--Move the Terrain Spell Card to the field and place them in the Field Zone
		op1=Duel.SelectOption(1-tp,aux.Stringid(120000071,2),aux.Stringid(120000071,3),aux.Stringid(120000071,4),aux.Stringid(120000071,5),aux.Stringid(120000071,6),aux.Stringid(120000071,7))
		if op1==0 then	
			local token1=Duel.CreateToken(1-tp,316000205)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(TYPE_SPELL+TYPE_FIELD)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			token1:RegisterEffect(e1)
			Duel.MoveToField(token1,1-tp,1-tp,LOCATION_FZONE,POS_FACEUP,true)
			Duel.SpecialSummonComplete()
		elseif op1==1 then	
			local token1=Duel.CreateToken(1-tp,316000206)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(TYPE_SPELL+TYPE_FIELD)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			token1:RegisterEffect(e1)
			Duel.MoveToField(token1,1-tp,1-tp,LOCATION_FZONE,POS_FACEUP,true)
			Duel.SpecialSummonComplete()
		elseif op1==2 then	
			local token1=Duel.CreateToken(1-tp,316000207)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(TYPE_SPELL+TYPE_FIELD)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			token1:RegisterEffect(e1)
			Duel.MoveToField(token1,1-tp,1-tp,LOCATION_FZONE,POS_FACEUP,true)
			Duel.SpecialSummonComplete()
		elseif op1==3 then	
			local token1=Duel.CreateToken(1-tp,316000208)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(TYPE_SPELL+TYPE_FIELD)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			token1:RegisterEffect(e1)
			Duel.MoveToField(token1,1-tp,1-tp,LOCATION_FZONE,POS_FACEUP,true)
			Duel.SpecialSummonComplete()
		elseif op1==4 then	
			local token1=Duel.CreateToken(1-tp,316000209)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(TYPE_SPELL+TYPE_FIELD)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			token1:RegisterEffect(e1)
			Duel.MoveToField(token1,1-tp,1-tp,LOCATION_FZONE,POS_FACEUP,true)
			Duel.SpecialSummonComplete()
		elseif op1==5 then		
			local token1=Duel.CreateToken(1-tp,316000210)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(TYPE_SPELL+TYPE_FIELD)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			token1:RegisterEffect(e1)
			Duel.MoveToField(token1,1-tp,1-tp,LOCATION_FZONE,POS_FACEUP,true)
			Duel.SpecialSummonComplete()		
		end	
	end
end
function c120000071.op2(e,tp,eg,ep,ev,re,r,rp)
	local tf1=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	local op1
	local op2
	local token1=nil
	local token2=nil
	if tf1==nil and Duel.SelectYesNo(tp,aux.Stringid(120000071,0)) then
		--Move the Terrain Spell Card to the field and place them in the Field Zone
		op1=Duel.SelectOption(tp,aux.Stringid(120000071,2),aux.Stringid(120000071,3),aux.Stringid(120000071,4),aux.Stringid(120000071,5),aux.Stringid(120000071,6),aux.Stringid(120000071,7))
		if op1==0 then	
			local token1=Duel.CreateToken(tp,316000205)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(TYPE_SPELL+TYPE_FIELD)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			token1:RegisterEffect(e1)
			Duel.MoveToField(token1,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
			Duel.SpecialSummonComplete()
		elseif op1==1 then	
			local token1=Duel.CreateToken(tp,316000206)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(TYPE_SPELL+TYPE_FIELD)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			token1:RegisterEffect(e1)
			Duel.MoveToField(token1,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
			Duel.SpecialSummonComplete()
		elseif op1==2 then	
			local token1=Duel.CreateToken(tp,316000207)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(TYPE_SPELL+TYPE_FIELD)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			token1:RegisterEffect(e1)
			Duel.MoveToField(token1,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
			Duel.SpecialSummonComplete()
		elseif op1==3 then	
			local token1=Duel.CreateToken(tp,316000208)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(TYPE_SPELL+TYPE_FIELD)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			token1:RegisterEffect(e1)
			Duel.MoveToField(token1,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
			Duel.SpecialSummonComplete()
		elseif op1==4 then	
			local token1=Duel.CreateToken(tp,316000209)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(TYPE_SPELL+TYPE_FIELD)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			token1:RegisterEffect(e1)
			Duel.MoveToField(token1,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
			Duel.SpecialSummonComplete()
		elseif op1==5 then		
			local token1=Duel.CreateToken(tp,316000210)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(TYPE_SPELL+TYPE_FIELD)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			token1:RegisterEffect(e1)
			Duel.MoveToField(token1,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
			Duel.SpecialSummonComplete()		
		end	
	end
end
function c120000071.ntcon(e,c,minc)
	if c==nil then return true end
	local _,max=c:GetTributeRequirement()
	return minc==0 and max>0 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c120000071.nttg(e,c)
	return c==0 or c==1 or c:GetFlagEffect(120000071)==0
end
function c120000071.nttg2(e,c)
	return c==0 or c==1 or c:GetFlagEffect(120000071+1)==0
end
function c120000071.nttg3(e,c)
	return c==0 or c==1 or c:GetFlagEffect(120000071)~=0
end
function c120000071.nttg4(e,c)
	return c==0 or c==1 or c:GetFlagEffect(120000071+1)~=0
end
function c120000071.limitfilter(c)
	return c:IsHasEffect(EFFECT_LIMIT_SUMMON_PROC) and c:GetFlagEffect(120000071)==0
end
function c120000071.limitfilter2(c)
	return c:IsHasEffect(EFFECT_LIMIT_SET_PROC) and c:GetFlagEffect(120000071+1)==0
end
function c120000071.limitcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c120000071.limitfilter,tp,0xff,0xff,1,nil) or Duel.IsExistingMatchingCard(c120000071.limitfilter2,tp,0xff,0xff,1,nil)
end
function c120000071.limitop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c120000071.limitfilter,tp,0xff,0xff,nil)
	for tc in aux.Next(g) do
		tc:RegisterFlagEffect(120000071,0,0,0)
	end
	local g2=Duel.GetMatchingGroup(c120000071.limitfilter2,tp,0xff,0xff,nil)
	for tc in aux.Next(g2) do
		tc:RegisterFlagEffect(120000071+1,0,0,0)
	end
end
function c120000071.atkcon(e)
	return e:GetHandler():GetFlagEffect(120000071)~=0
end
function c120000071.atktg(e,c)
	return c:GetFieldID()~=e:GetLabel()
end
function c120000071.atkcheckop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(120000071)~=0 then return end
	local fid=eg:GetFirst():GetFieldID()
	e:GetHandler():RegisterFlagEffect(120000071,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	e:GetLabelObject():SetLabel(fid)
end
function c120000071.efilter1(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:IsActiveType(TYPE_SPELL) and (Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS) or 
	te:GetType()==TYPE_SPELL+TYPE_EQUIP)
end