--リサイコロ
function c120000207.initial_effect(c)
	--Synchro Summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DICE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1c0)
	e1:SetTarget(c120000207.sptg)
	e1:SetOperation(c120000207.spop)
	c:RegisterEffect(e1)
end
function c120000207.spfilter(c,e,tp)
	return c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
end

c120000207.collection={ [16725505]=true; [27660735]=true; }

function c120000207.tfilter(c,e,tp)
	return c:IsType(TYPE_TUNER) and c120000207.collection[c:GetCode()] and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c120000207.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCountFromEx(tp,tp,e:GetHandler())>0
		and Duel.IsExistingMatchingCard(c120000207.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) 
		and Duel.IsExistingMatchingCard(c120000207.tfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c120000207.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCountFromEx(tp)
	if ft<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c120000207.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc1=g:GetFirst()
	local lv=Duel.TossDice(tp,1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=Duel.SelectMatchingCard(tp,c120000207.tfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		local tc2=tg:GetFirst()
	if tc1 and tc2 and Duel.SpecialSummonStep(tc2,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc2:RegisterEffect(e1)
		Duel.SpecialSummonComplete()
		Duel.SynchroSummon(tp,tc1,tc2)	
	if not tc1:IsOnField() then 
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,nil)
		Duel.Destroy(g,REASON_EFFECT) end
	end	
end
