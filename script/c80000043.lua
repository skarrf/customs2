-- Grim Forest Fairy
-- Scripted by ColdYogurt
-- Cards Used: Sky Striker Ace - Kaina 12421694, Mudragon of the Swamp 54757758, Arcana Triumph Joker 93880808,
--				Joker's Knight 29284413, Edge Imp Tomahawk 97567736, Grim Forest Vulpes 80000033, my giant brain
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,80000024,s.matfilter)
	--self destruct
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SELF_DESTROY)
	e1:SetCondition(s.descon)
	c:RegisterEffect(e1)
	--Cannot be targeted
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--Prevent target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(s.tglimit)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(s.descost)
	e4:SetTarget(s.destg)
	e4:SetOperation(s.desop)
	c:RegisterEffect(e4)
end

s.listed_series={0x39b}
function s.matfilter(c,scard,sumtype,tp)
	return c:IsSetCard(0x39b,scard,sumtype,tp) and c:IsAttribute(ATTRIBUTE_DARK,scard,sumtype,tp)
end

function s.descon(e)
	return not ((Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,80000038),e:GetHandlerPlayer(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) or Duel.IsEnvironment(80000038))
		or (Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,80000039),e:GetHandlerPlayer(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)))
end

function s.tglimit(e,c)
	return c:IsAttribute(e:GetHandler():GetAttribute())
end

function s.bruh(c,tpe)
	return c:IsCode(tpe)
end
function s.descfilter(c,tp)
	return c:IsSetCard(0x39b) and c:IsMonster() and c:IsDiscardable()
end
function s.dfilter(c,tpe)
	if (tpe==80000024) then
		return c:IsCode(80000043) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsSetCard(0x39b)
	end
	if (tpe==80000025) then
		return c:IsCode(80000032) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsSetCard(0x39b)
	end
	if (tpe==80000026) then
		return c:IsCode(80000033) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsSetCard(0x39b)
	end
	if (tpe==80000027) then
		return c:IsCode(80000034) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsSetCard(0x39b)
	end
	if (tpe==80000029) then
		return c:IsCode(80000035) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsSetCard(0x39b)
	end
	if (tpe==80000030) then
		return c:IsCode(80000036) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsSetCard(0x39b)
	end
	if (tpe==80000031) then
		return c:IsCode(80000037) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsSetCard(0x39b)
	end
	if (tpe==80000036) or (tpe==80000037) then
		return c:IsCode(80000045) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsSetCard(0x39b)
	end
end
function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.descfilter,tp,LOCATION_HAND,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	Duel.DiscardHand(tp,s.descfilter,1,1,REASON_COST+REASON_DISCARD,nil,tp)
	local g=Duel.GetOperatedGroup()
	e:SetLabel(g:GetFirst():GetCode())
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(s.dfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil,e:GetLabel())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.dfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil,e:GetLabel())
	if #g>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		--Duel.HintSelection(sg)
		Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)
	else
		local bruh=Duel.SelectMatchingCard(tp,s.bruh,tp,LOCATION_GRAVE,0,1,1,nil,e:GetLabel()) -- +LOCATION_REMOVED?
		Duel.SendtoHand(bruh,nil,REASON_EFFECT)
	end
end





--[[
function s.descfilter(c,tp)
	return c:IsSetCard(0x39b) and c:IsMonster() and c:IsDiscardable()
end
function s.dfilter(c,tpe)
	if (tpe==80000024) then
		return c:IsCode(80000043) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsSetCard(0x39b)
	end
	if (tpe==80000025) then
		return c:IsCode(80000032) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsSetCard(0x39b)
	end
	if (tpe==80000026) then
		return c:IsCode(80000033) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsSetCard(0x39b)
	end
	if (tpe==80000027) then
		return c:IsCode(80000034) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsSetCard(0x39b)
	end
	if (tpe==80000029) then
		return c:IsCode(80000035) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsSetCard(0x39b)
	end
	if (tpe==80000030) then
		return c:IsCode(80000036) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsSetCard(0x39b)
	end
	if (tpe==80000031) then
		return c:IsCode(80000037) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsSetCard(0x39b)
	end
	if (tpe==80000036) or (tpe==80000037) then
		return c:IsCode(80000045) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsSetCard(0x39b)
	end
end
function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.descfilter,tp,LOCATION_HAND,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	Duel.DiscardHand(tp,s.descfilter,1,1,REASON_COST+REASON_DISCARD,nil,tp)
	local g=Duel.GetOperatedGroup()
	e:SetLabel(g:GetFirst():GetCode())
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(s.dfilter,tp,0,LOCATION_DECK+LOCATION_EXTRA,nil,e:GetLabel())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.dfilter,tp,0,LOCATION_DECK+LOCATION_EXTRA,nil,e:GetLabel())
	if #g>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end
--]]





--[[
function s.tgfilter(c)
	return c:IsSetCard(0x39b) and c:IsMonster() and c:IsDiscardable()
end
function s.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_HAND,0,1,nil,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	--local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.DiscardHand(tp,s.tgfilter,1,1,REASON_COST+REASON_DISCARD,nil,tp)
	local g=Duel.GetOperatedGroup()
	e:SetLabel(g:GetFirst():GetCode())
	--Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	--Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--if not c:IsRelateToEffect(e) then return end
	--if Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)>0 then
		if (e:GetLabel())==(80000024) then
			local bruh=Duel.SelectMatchingCard(tp,Card.IsCode(80000043),tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e,tp)
			if bruh>0 then
				Duel.SpecialSummon(bruh,0,tp,tp,true,false,POS_FACEUP)
		elseif (e:GetLabel())==(80000025) then
			local bruh=Duel.SelectMatchingCard(tp,Card.IsCode(80000032),tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e,tp)
			if bruh>0 then
				Duel.SpecialSummon(bruh,0,tp,tp,true,false,POS_FACEUP)
			end
		elseif (e:GetLabel())==(80000026) then
			local bruh=Duel.SelectMatchingCard(tp,Card.IsCode(80000033),tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e,tp)
			if bruh>0 then
				Duel.SpecialSummon(bruh,0,tp,tp,true,false,POS_FACEUP)
			end
		elseif (e:GetLabel())==(80000027) then
			local bruh=Duel.SelectMatchingCard(tp,Card.IsCode(80000034),tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e,tp)
			if bruh>0 then
				Duel.SpecialSummon(bruh,0,tp,tp,true,false,POS_FACEUP)
			end
		elseif (e:GetLabel())==(80000029) then
			local bruh=Duel.SelectMatchingCard(tp,Card.IsCode(80000035),tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e,tp)
			if bruh>0 then
				Duel.SpecialSummon(bruh,0,tp,tp,true,false,POS_FACEUP)
			end
		elseif (e:GetLabel())==(80000030) then
			local bruh=Duel.SelectMatchingCard(tp,Card.IsCode(80000036),tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e,tp)
			if bruh>0 then
				Duel.SpecialSummon(bruh,0,tp,tp,true,false,POS_FACEUP)
			end
		elseif (e:GetLabel())==(80000031) then
			local bruh=Duel.SelectMatchingCard(tp,Card.IsCode(80000037),tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e,tp)
			if g>0 then
				Duel.SpecialSummon(bruh,0,tp,tp,true,false,POS_FACEUP)
			end
		elseif (e:GetLabel())==(80000026|80000037) then
			local bruh=Duel.SelectMatchingCard(tp,Card.IsCode(80000045),tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e,tp)
			if g>0 then
				Duel.SpecialSummon(bruh,0,tp,tp,true,false,POS_FACEUP)
			end
		end
	end
end
]]--





--[[
function s.descfilter(c,tp)
	local tpe=c:GetCode()
	return c:IsDiscardable()
		and Duel.IsExistingMatchingCard(s.dfilter,tp,0,LOCATION_DECK+LOCATION_EXTRA,1,nil,tpe)
end
function s.dfilter(c,tpe)
	if tpe==80000024 then
		return c:IsCode(80000043) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsSetCard(0x39b)
	end
	if tpe==80000025 then
		return c:IsCode(80000032) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsSetCard(0x39b)
	end
	if tpe==80000026 then
		return c:IsCode(80000033) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsSetCard(0x39b)
	end
	if tpe==80000027 then
		return c:IsCode(80000034) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsSetCard(0x39b)
	end
	if tpe==80000029 then
		return c:IsCode(80000035) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsSetCard(0x39b)
	end
	if tpe==80000030 then
		return c:IsCode(80000036) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsSetCard(0x39b)
	end
	if tpe==80000031 then
		return c:IsCode(80000037) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsSetCard(0x39b)
	end
	if tpe==(80000036|80000037) then
		return c:IsCode(80000045) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsSetCard(0x39b)
	end
end
function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.descfilter,tp,LOCATION_HAND,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	Duel.DiscardHand(tp,s.descfilter,1,1,REASON_COST+REASON_DISCARD,nil,tp)
	local g=Duel.GetOperatedGroup()
	e:SetLabel(g:GetFirst():GetID()&0x39b)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.dfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.dfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP_DEFENSE)
	end
end
--]]




