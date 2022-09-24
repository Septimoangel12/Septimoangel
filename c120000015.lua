--トゥーン・ワールド
--アンダーソン.
function c120000015.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--change type
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_ADD_TYPE)
	e2:SetValue(TYPE_TOON)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	c:RegisterEffect(e2)
	--indes 1
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_ONFIELD,0)
	e3:SetValue(c120000015.indval1)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_TOON))
	c:RegisterEffect(e3)
	--no damage
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_ONFIELD,0)
	e4:SetValue(c120000015.indval2)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_TOON))
	c:RegisterEffect(e4)
	--Inside the Toon World
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(120000015,0))
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_BATTLED)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(c120000015.condition)
	e5:SetOperation(c120000015.operation)
	c:RegisterEffect(e5)
end
c120000015.listed_series={0x62}
function c120000015.indval1(e,c)
	return not c:IsType(TYPE_TOON)
end
function c120000015.indval2(e,c)
	return c and not c:IsType(TYPE_TOON)
end
function c120000015.condition(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if d and d:IsType(TYPE_TOON) and d:IsControler(tp) then a,d=d,a
		e:SetLabelObject(a)
	end
	if a and a:IsType(TYPE_TOON) and a:IsControler(tp) then 
		e:SetLabelObject(a)
		return true
	else return false end
end
function c120000015.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc and tc:IsRelateToBattle() then 
		--battle
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetRange(LOCATION_ONFIELD)
		e1:SetValue(c120000015.efilter)
		e1:SetCondition(c120000015.econ)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e2:SetRange(LOCATION_ONFIELD)
		e2:SetLabelObject(e1)
		e2:SetValue(c120000015.tgfilter)
		e2:SetCondition(c120000015.econ)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e3:SetCode(EFFECT_IGNORE_BATTLE_TARGET)
		e3:SetRange(LOCATION_ONFIELD)
		e3:SetLabelObject(e2)
		e3:SetValue(c120000015.indval1)
		e3:SetCondition(c120000015.econ)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e3)
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e4:SetCode(EFFECT_UNRELEASABLE_SUM)
		e4:SetRange(LOCATION_ONFIELD)
		e4:SetLabelObject(e3)
		e4:SetValue(c120000015.sumlimit)
		e4:SetCondition(c120000015.econ)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e4)
		local e5=Effect.CreateEffect(e:GetHandler())
		e5:SetType(EFFECT_TYPE_FIELD)
		e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e5:SetCode(EFFECT_CANNOT_RELEASE)
		e5:SetRange(LOCATION_ONFIELD)
		e5:SetAbsoluteRange(tp,0,1)
		e5:SetLabelObject(e4)
		e5:SetCondition(c120000015.econ)
		e5:SetTarget(c120000015.rellimit)
		e5:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e5)
		local e6=Effect.CreateEffect(e:GetHandler())
		e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e6:SetCode(EVENT_ATTACK_ANNOUNCE)
		e6:SetLabelObject(e5)
		e6:SetOperation(c120000015.resetop)
		e6:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e6)
	end
end
function c120000015.cfilter(c)
	return c:IsFaceup() and c:IsCode(15259703) and not c:IsStatus(STATUS_DISABLED)
end
function c120000015.econ(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c120000015.cfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function c120000015.efilter(e,te,c)
	local tc=te:GetOwner()
	if te:GetHandler():IsCode(15259703) and (te:GetHandler():IsType(TYPE_TOON) or te:GetHandler():IsSetCard(0x62)) then return false end
	return c~=tc and te:GetOwnerPlayer()~=e:GetHandlerPlayer() and
	te:IsHasCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_POSITION+CATEGORY_LVCHANGE+CATEGORY_TOHAND+CATEGORY_DESTROY+CATEGORY_REMOVE+CATEGORY_TODECK+CATEGORY_RELEASE+CATEGORY_TOGRAVE+CATEGORY_DISABLE+CATEGORY_NEGATE+CATEGORY_CONTROL+CATEGORY_EQUIP+CATEGORY_COUNTER)
end
function c120000015.tgfilter(e,re,rp)
	if re:GetHandler():IsCode(15259703) or re:GetHandler():IsType(TYPE_TOON) or re:GetHandler():IsSetCard(0x62) then return false end
	return re:GetOwner()~=e:GetOwner() and re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c120000015.sumlimit(e,c)
	if not c then return false end
	return not c:IsControler(e:GetHandlerPlayer()) or c:IsType(TYPE_TOON) or c:IsSetCard(0x62)
end
function c120000015.rellimit(e,c,tp,sumtp)
	return c==e:GetHandler() and not (c:IsType(TYPE_TOON) or c:IsSetCard(0x62))
end
function c120000015.resetop(e,tp,eg,ep,ev,re,r,rp)
	local e5=e:GetLabelObject()
	local e4=e5:GetLabelObject()
	local e3=e4:GetLabelObject()
	local e2=e3:GetLabelObject()
	local e1=e2:GetLabelObject()
	e:Reset()
	e1:Reset()
	e2:Reset()
	e3:Reset()
	e4:Reset()
	e5:Reset()
end
