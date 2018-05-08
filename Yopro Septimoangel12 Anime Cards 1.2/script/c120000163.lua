--ラスト・カウンター
function c120000163.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetDescription(aux.Stringid(120000163,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_BATTLE_DESTROYED)
	e1:SetCondition(c120000163.condition)
	e1:SetTarget(c120000163.target)
	e1:SetOperation(c120000163.activate)
	c:RegisterEffect(e1)
end
function c120000163.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local bc=tc:GetBattleTarget()
	return tc:GetPreviousControler()==tp and bc:IsRelateToBattle()
end
function c120000163.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsSetCard(0x48)
end
function c120000163.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=eg:GetFirst():GetReasonCard()
	if chk==0 then return tg:IsCanBeEffectTarget(e) and Duel.IsExistingMatchingCard(c120000163.filter,tp,LOCATION_ONFIELD,0,1,nil) end
	if tg and tg:IsLocation(LOCATION_ONFIELD) and tg:GetAttack()>0 then
	Duel.SetTargetCard(tg)
	end
end
function c120000163.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local atk=tc:GetAttack()
	if tc and tc:IsRelateToEffect(e) and tc:GetAttack()>0 then
		--atk 
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(120000163,1))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		if tc:RegisterEffect(e1) then 
			--damage
			local e2=Effect.CreateEffect(c)
			e2:SetDescription(aux.Stringid(120000163,2))
			e2:SetCategory(CATEGORY_DAMAGE)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
			e2:SetCode(EVENT_DESTROYED)
			e2:SetLabelObject(tc)
			e2:SetCondition(c120000163.damcon)
			e2:SetOperation(c120000163.damop)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e2,tp)
			tc:RegisterFlagEffect(120000163,RESET_EVENT+0x17a0000+RESET_PHASE+PHASE_END,0,1)
			end
			local g=Duel.SelectMatchingCard(tp,c120000163.filter,tp,LOCATION_ONFIELD,0,1,1,nil)
			local dg=g:GetFirst()
			if dg then
				--gain atk
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_UPDATE_ATTACK)
				e3:SetValue(atk)
				e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
				dg:RegisterEffect(e3)	
		end	
	end
end	
function c120000163.damcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return eg:IsContains(tc) and tc:GetFlagEffect(120000163)~=0 
end
function c120000163.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(120000163,2))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e1:SetCountLimit(1)
	e1:SetLabelObject(e:GetLabelObject())
	e1:SetTarget(c120000163.tg)
	e1:SetOperation(c120000163.op)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
	Duel.RegisterEffect(e1,tp)
end	
function c120000163.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local atk=e:GetLabelObject():GetBaseAttack()
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(atk)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,atk)
end
function c120000163.op(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
