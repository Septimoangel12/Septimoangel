--希望の絆
function c511005023.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c511005023.condition)
	e1:SetTarget(c511005023.target)
	e1:SetOperation(c511005023.operation)
	c:RegisterEffect(e1)
end
function c511005023.cfilter(c,tp)
  return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsControler(tp)
end
function c511005023.condition(e,tp,eg,ep,ev,re,r,rp)
  return eg:IsExists(c511005023.cfilter,1,nil,tp)
end
function c511005023.spfilter(c,e,tp)
  return c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c511005023.target(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingTarget(c511005023.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,Duel.SelectTarget(tp,c511005023.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp),1,0,0)
end
function c511005023.filter(c)
  return c:IsType(TYPE_XYZ) and c:IsFaceup()
end
function c511005023.operation(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local tc=Duel.GetFirstTarget()
  if not (tc:IsRelateToEffect(e) and c511005023.spfilter(tc,e,tp)) then return end
  if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
    local og=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_MZONE,0,1,1,nil,TYPE_XYZ):GetFirst():GetOverlayGroup()
    if c:IsRelateToEffect(e) then
      c:CancelToGrave()
      og:AddCard(c)
    end
    if og:GetCount()>0 then
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
      local nc=Duel.SelectMatchingCard(tp,c511005023.filter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
      Duel.Overlay(nc,og)
    end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabelObject(tc)
		e1:SetOperation(desop)
		Duel.RegisterEffect(e1,tp)
	end
end
function desop(e,tp,eg,ep,ev,re,r,rp)
  local tc=e:GetLabelObject()
  if tc:IsOnField() then Duel.Destroy(tc,REASON_EFFECT) end
end