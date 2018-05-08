--奇跡の銀河
function c511005078.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c511005078.condition)
	e1:SetTarget(c511005078.target)
	e1:SetOperation(c511005078.operation)
	c:RegisterEffect(e1)
	if not c511005078.global_check then
		c511005078.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_BATTLE_DAMAGE)
		ge1:SetOperation(c511005078.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c511005078.checkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(ep,511005078,RESET_PHASE+PHASE_END,0,1)
end
function c511005078.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,511005078)==0 and Duel.GetCurrentPhase()==PHASE_MAIN2 
end
function c511005078.filter(c)
	return c:IsFaceup() and c:IsPosition(POS_FACEUP_ATTACK)
end
function c511005078.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c511005078.filter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(nil,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTACK)
	local g1=Duel.SelectTarget(tp,c511005078.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local g2=Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
	g1:Merge(g2)
end
function c511005078.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()==2 then
		Duel.CalculateDamage(g:GetFirst(),g:GetNext())
	end
end
