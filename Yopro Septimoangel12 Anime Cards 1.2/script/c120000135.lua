--チャリオット・パイル
function c120000135.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(120000135,0))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c120000135.damcon)
	e2:SetTarget(c120000135.damtg)
	e2:SetOperation(c120000135.damop)
	c:RegisterEffect(e2)
	--Negate the attack and destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(120000135,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c120000135.descon)
	e3:SetCost(c120000135.descost)
	e3:SetTarget(c120000135.destg)
	e3:SetOperation(c120000135.desop)
	c:RegisterEffect(e3)
end
function c120000135.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
		and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c120000135.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(800)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,800)
end
function c120000135.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsReleasableByEffect()
end
function c120000135.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.IsChainDisablable(0) then
	local sel=1
		local g=Duel.GetMatchingGroup(c120000135.filter,1-tp,LOCATION_ONFIELD,0,nil)
		Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(120000135,2))
		if g:GetCount()>0 then
			sel=Duel.SelectOption(1-tp,1213,1214)
		else
			sel=Duel.SelectOption(1-tp,1214)+1
		end
		if sel==0 then
		local sg=g:Select(1-tp,1,1,nil)
		Duel.Release(sg,REASON_EFFECT)
		Duel.NegateEffect(0)
		return
		end
	end	
		Duel.Damage(p,d,REASON_EFFECT)
end
function c120000135.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp) and Duel.GetAttackTarget()==nil
end
function c120000135.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) end
	Duel.PayLPCost(tp,800)
end
function c120000135.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.GetAttacker()
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,1,0,0)
end
function c120000135.desop(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	if at:IsAttackable() then
		if Duel.NegateAttack() then
			Duel.Destroy(at,REASON_EFFECT)
		end
	end
end