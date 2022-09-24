--光波クローンマジック
function c120000078.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(120000078,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetTarget(c120000078.tgvtg)
	e1:SetOperation(c120000078.tgvop)
	c:RegisterEffect(e1)
end
function c120000078.ffilter(c)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and c:CheckActivateEffect(false,false,false)~=nil
end
function c120000078.tgvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c120000078.ffilter,e:GetHandlerPlayer(),LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c120000078.ffilter,e:GetHandlerPlayer(),LOCATION_DECK,0,1,1,nil)
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,true,false)
	Duel.ClearTargetCard()
	g:GetFirst():CreateEffectRelation(e)
	local th=g:GetFirst()
	local ac=th:GetActivateEffect()
	local effs={Duel.GetPlayerEffect(tp,EFFECT_CANNOT_ACTIVATE)}
	for _,eff in ipairs(effs) do
		if type(eff:GetValue())=='function' then
			if eff:GetValue()(eff,ac,tp) then return false end
		end	
	end	
	local tg=te:GetTarget()
	e:SetProperty(te:GetProperty())
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.SendtoGrave(g,REASON_COST)
	Duel.ClearOperationInfo(0)
end
function c120000078.tgvop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end
	