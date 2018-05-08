--涅槃の超魔導剣士
function c120000050.initial_effect(c)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--synchro summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(120000050,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(aux.SynCondition(nil,aux.NonTuner(nil),1,99))
	e1:SetTarget(aux.SynTarget(nil,aux.NonTuner(nil),1,99))
	e1:SetOperation(aux.SynOperation(nil,aux.NonTuner(nil),1,99))
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)	
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(120000050,0))
	e2:SetCondition(c120000050.syncon)
	e2:SetTarget(c120000050.syntg)
	e2:SetOperation(c120000050.synop)
	e2:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(120000050,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)	
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c120000050.intg)	
	e3:SetOperation(c120000050.indop)
	c:RegisterEffect(e3)
	--pendulum
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(120000050,2))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(c120000050.pencon)
	e4:SetTarget(c120000050.pentg)
	e4:SetOperation(c120000050.penop)
	c:RegisterEffect(e4)
end
function c120000050.matfilter2(c,syncard)
	local tp=syncard:GetControler() 
	return c:IsType(TYPE_PENDULUM) and c:IsReleasable()
	and c:GetSummonType()==SUMMON_TYPE_PENDULUM 
	and c:IsFaceup() and Duel.IsExistingMatchingCard(c120000050.matfilter1,tp,LOCATION_MZONE,0,1,c,syncard)
end
function c120000050.matfilter1(c,syncard)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsReleasable()
end
function c120000050.synfilter(c,syncard,lv,g2,minc)
	local tlv=c:GetLevel()
	if lv-tlv<=0 then return false end
	local g=g2:Clone()
	g:RemoveCard(c)
	return g:CheckWithSumEqual(Card.GetLevel,lv-tlv,minc-1,63)
end
function c120000050.syncon(e,c,tuner,mg)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	local ct=-Duel.GetLocationCount(tp,LOCATION_MZONE)
	local minc=2
	if minc<ct then minc=ct end
	local g1=nil
	local g2=nil
	--if mg then
		--g1=mg:Filter(c120000050.matfilter1,nil,c)
		--g2=mg:Filter(c120000050.matfilter2,nil,c)
	--else
	g1=Duel.GetMatchingGroup(c120000050.matfilter1,tp,LOCATION_MZONE,0,nil,c)
	g2=Duel.GetMatchingGroup(c120000050.matfilter2,tp,LOCATION_MZONE,0,nil,c)
	--end
	--local pe=Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_SMATERIAL)
	local lv=10
	--if not pe then
	return g1:IsExists(c120000050.synfilter,1,nil,c,lv,g2,minc)
	--else
		--return c120000050.synfilter(pe:GetOwner(),c,lv,g2,minc)
	--end
end
function c120000050.syntg(e,tp,eg,ep,ev,re,r,rp,chk,c,tuner,mg)
	local g=Group.CreateGroup()
	local g1=nil
	local g2=nil
	--if mg then
		--g1=mg:Filter(c120000050.matfilter1,nil,c)
		--g2=mg:Filter(c120000050.matfilter2,nil,c)
	--else
	g1=Duel.GetMatchingGroup(c120000050.matfilter1,tp,LOCATION_MZONE,0,nil,c)
	g2=Duel.GetMatchingGroup(c120000050.matfilter2,tp,LOCATION_MZONE,0,nil,c)
	--end
	local ct=-Duel.GetLocationCount(tp,LOCATION_MZONE)
	local minc=2
	if minc<ct then minc=ct end

	local lv=10
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	local tuner=g1:Select(tp,1,1,nil):GetFirst()
	g:AddCard(tuner)
	g2:RemoveCard(tuner)
	local lv1=tuner:GetLevel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	local m2=g2:SelectWithSumEqual(tp,Card.GetLevel,lv-lv1,minc-1,63)
	g:Merge(m2)
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else return false end
end
function c120000050.synop(e,tp,eg,ep,ev,re,r,rp,c,tuner,mg)
	local g=e:GetLabelObject()
	Duel.Release(g,REASON_EFFECT)
	g:DeleteGroup()
end
function c120000050.infilter1(c,e)
	local lv=c:GetLevel()
	return lv>0 and c:IsFaceup() and c:GetSummonType()==SUMMON_TYPE_PENDULUM and c:GetTurnID()==Duel.GetTurnCount() 
	and c:GetFlagEffect(120000050)==0
end
function c120000050.intg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING) and Duel.IsExistingTarget(c120000050.infilter1,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c120000050.infilter1,tp,LOCATION_MZONE,0,nil)
    local tg,lv=g:GetMinGroup(Card.GetLevel)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local sg=tg:FilterSelect(tp,Card.IsCanBeEffectTarget,1,1,nil,e)
	Duel.SetTargetCard(sg)
end
function c120000050.indop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end 
		--Indestructable Battle
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		--No Battle Damage
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		--Atk Down
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_DAMAGE_STEP_END)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCondition(c120000050.atkcon)
		e3:SetOperation(c120000050.atkop)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)	
		tc:RegisterEffect(e3)	
		--
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_BATTLED)
		e4:SetRange(LOCATION_MZONE)
		e4:SetCondition(c120000050.atkcon)
		e4:SetOperation(c120000050.efcop2)
		e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)	
		tc:RegisterEffect(e4)	
		tc:RegisterFlagEffect(120000050,RESET_EVENT+0x1fe0000,0,1)
end
function c120000050.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRelateToBattle() and (Duel.GetAttacker()==c or Duel.GetAttackTarget()==c)
end
function c120000050.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local tg=g:GetFirst()
	while tg do
		local atk=c:GetAttack()
		local at=Effect.CreateEffect(c)
		at:SetType(EFFECT_TYPE_SINGLE)
		at:SetCode(EFFECT_UPDATE_ATTACK)
		at:SetValue(-atk)
		at:SetReset(RESET_EVENT+0x1fe0000)
		tg:RegisterEffect(at)
		tg=g:GetNext()
	end
end
function c120000050.infilter2(c,lv,e)
	return c:IsFaceup() 
	and c:GetSummonType()==SUMMON_TYPE_PENDULUM and c:GetLevel()==lv and c:GetTurnID()==Duel.GetTurnCount()
end
function c120000050.efcop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lv=c:GetLevel()
	local g=Duel.SelectMatchingCard(tp,c120000050.infilter2,tp,LOCATION_MZONE,0,1,1,nil,lv+1,e,tp)
	local tc=g:GetFirst()
	if tc and tc:IsFaceup() then
		--Indestructable Battle
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		--No Battle Damage
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		--Atk Down
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_DAMAGE_STEP_END)
		e3:SetRange(LOCATION_MZONE)
		e3:SetLabelObject(e)
		e3:SetCondition(c120000050.atkcon)
		e3:SetOperation(c120000050.atkop)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)	
		--
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_BATTLED)
		e4:SetRange(LOCATION_MZONE)
		e4:SetCondition(c120000050.atkcon)
		e4:SetOperation(c120000050.efcop2)
		e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)	
		tc:RegisterEffect(e4)
	end	
end
function c120000050.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE)
end
function c120000050.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7) end
end
function c120000050.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_SZONE,6) and not Duel.CheckLocation(tp,LOCATION_SZONE,7) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
