--C・ドラゴン
function c120000083.initial_effect(c)
	--synchro summon
	Synchro.AddProcedure(c,nil,1,1,Synchro.NonTuner(nil),1,99)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c120000083.atkval)
	c:RegisterEffect(e1)
	--mill
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(64973287,1))
	e2:SetCategory(CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCondition(aux.bdocon)
	e2:SetTarget(c120000083.ddtg)
	e2:SetOperation(c120000083.ddop)
	c:RegisterEffect(e2)
end
function c120000083.atkfilter(c)
	return c:IsSetCard(0x25) and c:IsType(TYPE_MONSTER)
end
function c120000083.atkval(e,c)
	return Duel.GetMatchingGroupCount(c120000083.atkfilter,c:GetControler(),LOCATION_GRAVE,0,nil)*200
end
function c120000083.ddtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local bc=e:GetHandler():GetBattleTarget()
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(bc:GetLevel())
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,1-tp,bc:GetLevel())
end
function c120000083.ddop(e,tp,eg,ep,ev,re,r,rp)
	local p,val=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.DiscardDeck(p,val,REASON_EFFECT)
end
