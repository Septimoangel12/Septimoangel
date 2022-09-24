--溶岩魔神ラヴァ・ゴーレム (アニメ)
--Lava Golem (Anime)
function c120000070.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	aux.AddLavaProcedure(c,2,POS_FACEUP,nil,0,aux.Stringid(102380,0))
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetDescription(aux.Stringid(102380,1))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e1:SetRange(LOCATION_ONFIELD)
	e1:SetCountLimit(1)
	e1:SetCondition(c120000070.damcon)
	e1:SetTarget(c120000070.damtg)
	e1:SetOperation(c120000070.damop)
	c:RegisterEffect(e1)
end
function c120000070.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c120000070.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_MONSTER) and e:GetHandler():IsPosition(POS_FACEUP) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(700)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,tp,700)
end
function c120000070.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
