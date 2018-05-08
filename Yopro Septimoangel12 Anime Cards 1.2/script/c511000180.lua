--闇からの奇襲
function c511000180.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c511000180.condition)
	e1:SetOperation(c511000180.operation)
	c:RegisterEffect(e1)
end
function c511000180.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN2 and (Duel.GetActivityCount(tp,ACTIVITY_NORMALSUMMON)~=0 or Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)~=0)
end
function c511000180.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_SKIP_TURN)
		e1:SetTargetRange(0,1)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_EP)
		Duel.RegisterEffect(e2,tp)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CANNOT_BP)
		Duel.RegisterEffect(e3,tp)
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_FIELD)
		e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e4:SetTargetRange(1,0)
		e4:SetCode(EFFECT_SKIP_DP)
		if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_BATTLE then
			e4:SetCondition(c511000180.skipcon)
			e4:SetLabel(Duel.GetTurnCount())
			e4:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_SELF_TURN,2)
		else
			e4:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_SELF_TURN)
		end
		Duel.RegisterEffect(e4,tp)
		local e5=e4:Clone()
		e5:SetCode(EFFECT_SKIP_SP)
		Duel.RegisterEffect(e5,tp)
		local e6=e4:Clone()
		e6:SetCode(EFFECT_SKIP_M1)
		Duel.RegisterEffect(e6,tp)
		local e7=Effect.CreateEffect(c)
		e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e7:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
		e7:SetRange(LOCATION_GRAVE)
		e7:SetCountLimit(1)
		e7:SetTarget(c511000180.target)
		e7:SetOperation(c511000180.activate)
		e7:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
		c:RegisterEffect(e7)
end
function c511000180.skipcon(e)
	return Duel.GetTurnCount()~=e:GetLabel()
end
function c511000180.filter(c,tp,turn)
	return c:GetPreviousControler()==tp and c:GetTurnID()==turn-2 and c:IsType(TYPE_MONSTER) and c:GetPreviousLocation()==LOCATION_MZONE
end
function c511000180.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c511000180.filter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,0,1,nil,tp,Duel.GetTurnCount()) end
end
function c511000180.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then return end
	local g=Duel.GetMatchingGroup(c511000180.filter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,0,nil,tp,Duel.GetTurnCount())
	local tc=g:GetFirst()
	while tc do
		if tc:IsPreviousPosition(POS_FACEUP_ATTACK) then
			Duel.MoveToField(tc,tp,tp,LOCATION_MZONE,POS_FACEUP_ATTACK,true)
		end
		tc=g:GetNext()
	end
	local sk=Duel.GetTurnPlayer()
	Duel.SkipPhase(sk,PHASE_MAIN2,RESET_PHASE+PHASE_MAIN2,1)
end