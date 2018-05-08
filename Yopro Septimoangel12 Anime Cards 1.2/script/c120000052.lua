--銀河の魔導師
function c120000052.initial_effect(c)
	--xyzlv
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_XYZ_LEVEL)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_ONFIELD)
	e1:SetValue(c120000052.xyzlv)
	c:RegisterEffect(e1)
	--xyz summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC_G)
	e2:SetRange(LOCATION_ONFIELD)
	e2:SetCountLimit(1)
	e2:SetCost(c120000052.xyzcost)
	e2:SetCondition(c120000052.Xyzcon)
	e2:SetOperation(c120000052.Xyzop)
	e2:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e2)
end
function c120000052.xyzlv(e,c)
	return 0x80000+e:GetHandler():GetLevel()
end
function c120000052.xyzcost(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.RegisterFlagEffect(tp,120000052,RESET_PHASE+PHASE_END,0,1)
end
function c120000052.Xyzfilter(c,e,tp,ce,minxyzct,og)
	local ct=c.minxyzct
	return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and ce:IsCanBeXyzMaterial(c) and (c.xyz_filter==nil or c.xyz_filter(ce)) and ct
	and Card.GetSynchroLevel,lv,minc,maxc,syncard and Duel.CheckXyzMaterial(c,c.xyz_filter,minxyzct,og) 
end
function c120000052.Xyzcon(e,c,og)
		if c==nil then return true end
		local tp=c:GetControler()
		return e:GetHandler():IsType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(c120000052.Xyzfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,og)
end
function c120000052.Xyzop(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
		local c=e:GetHandler()
		--lv up
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_UPDATE_LEVEL)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e3:SetValue(4)
		c:RegisterEffect(e3)
		--2 materials
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(511001225)
		e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e4)
		--atk
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e5:SetProperty(EFFECT_FLAG_DELAY)
		e5:SetCode(EVENT_BE_PRE_MATERIAL)
		e5:SetRange(LOCATION_MZONE)
		e5:SetCondition(c120000052.atkcon)
		e5:SetOperation(c120000052.atkop)
		e5:SetReset(RESET_PHASE+PHASE_END)
		c:RegisterEffect(e5)
		--cannnot tribute
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_SINGLE)
		e6:SetCode(EFFECT_UNRELEASABLE_SUM)
		e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e6:SetValue(1)
		e6:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e6)
		local e7=e6:Clone()
		e7:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		c:RegisterEffect(e7)
		--cannnot fusion material
		local e8=e7:Clone()
		e8:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		c:RegisterEffect(e8)
		--cannnot synchro material
		local e9=e8:Clone()
		e9:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		c:RegisterEffect(e9)
		local e10=e9:Clone()
		--cannot link material
		e10:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		c:RegisterEffect(e10)
end
function c120000052.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_XYZ
end
function c120000052.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(-2000)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	rc:RegisterEffect(e1)
end
