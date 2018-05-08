--バイ・バインド
function c120000068.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(511009110)
	e1:SetTarget(c120000068.target)
	e1:SetOperation(c120000068.activate)
	c:RegisterEffect(e1)
	if not c120000068.global_check then
		c120000068.global_check=true
		--register
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetCountLimit(1)
		ge1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge1:SetOperation(c120000068.atkchk)
		Duel.RegisterEffect(ge1,0)
	end
end
function c120000068.atkchk(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,419)==0 and Duel.GetFlagEffect(1-tp,419)==0 then
		Duel.CreateToken(tp,419)
		Duel.CreateToken(1-tp,419)
		Duel.RegisterFlagEffect(tp,419,nil,0,1)
		Duel.RegisterFlagEffect(1-tp,419,nil,0,1)
	end
	if Duel.GetFlagEffect(0,420)==0 then 
		Duel.CreateToken(tp,420)
		Duel.CreateToken(1-tp,420)
		Duel.RegisterFlagEffect(0,420,0,0,0)
	end
end
function c120000068.cfilter(c,e)
	local val=0
	if c:GetFlagEffect(284)>0 then val=c:GetFlagEffectLabel(284) end
	return c:IsFaceup() and c:IsControler(tp) and c:GetFlagEffect(120000068)==0 and c:GetAttack()~=val and (not e or c:IsCanBeEffectTarget(e))
end
function c120000068.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and chkc:IsControler(tp) and c120000068.cfilter(chkc) end
	if chk==0 then return eg:IsExists(c120000068.cfilter,1,nil,e) end
	if eg:GetCount()==1 then
		Duel.SetTargetCard(eg)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local g=eg:FilterSelect(tp,c120000068.cfilter,1,1,nil,e)
		Duel.SetTargetCard(g)
	end
end
function c120000068.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetCondition(c120000068.atkcon)
		e1:SetValue(tc:GetAttack())
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_DAMAGE_STEP_END)
		e2:SetCondition(c120000068.descon)
		e2:SetOperation(c120000068.desop)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
		tc:RegisterEffect(e2)
		tc:RegisterFlagEffect(120000068,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,0)
	end
end
function c120000068.atkcon(e)
	local ph=Duel.GetCurrentPhase()
	return ph>=0x08 and ph<=0x80
end
function c120000068.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetHandler():GetBattleTarget()
	return tc and tc:IsRelateToBattle() and e:GetOwnerPlayer()==tp and (tc:IsPosition(POS_FACEUP_ATTACK) and tc:GetAttack()<=c:GetAttack())
	or (tc:IsPosition(POS_FACEUP_DEFENCE) and tc:GetDefense()<c:GetAttack()) and not tc:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c120000068.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetBattleTarget()	
	if tc and tc:IsFaceup() and tc:IsRelateToBattle() then
		Duel.SendtoGrave(tc,REASON_BATTLE)
		tc:SetStatus(STATUS_BATTLE_DESTROYED,true)
		Duel.RaiseSingleEvent(tc,EVENT_BATTLE_DESTROYED,e,REASON_BATTLE,tp,tp,0)
		Duel.RaiseEvent(tc,EVENT_BATTLE_DESTROYED,e,REASON_BATTLE,tp,tp,0)
	end
end