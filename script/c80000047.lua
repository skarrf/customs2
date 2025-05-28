-- Grim Forest Avem
-- Scripted by ColdYogurt
-- Cards Used: Darktellarknight Batlamyus 64414267, Orcust Dingirsu 93854893, Bahamut Shark 00440556, Question 38723936
--				AHHHHHHH, Hyper Rank-Up-Magic Utopiforce 67517351, Mirror Ladybug 45358284, Oni-Gami Combo 90470931,
--				Neo Galaxy-Eyes Photon Dragon 39272762, Outer Entity Nyarla 8809344, my giant fucking sleep-deprived brain
local s,id=GetID()
function s.initial_effect(c)
	--Xyz Summon
	c:EnableReviveLimit()
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x39b),4,2)
	--self destruct
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SELF_DESTROY)
	e1:SetCondition(s.descon)
	c:RegisterEffect(e1)
	--send to Graveyard
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(s.sendcost)
	e2:SetTarget(s.tgtg)
	e2:SetOperation(s.tgop)
	c:RegisterEffect(e2)
	--revive
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,id)
	e3:SetTarget(s.target)
	e3:SetOperation(s.activate)
	c:RegisterEffect(e3)
end

s.listed_series={0x39b}
function s.descon(e)
	return not ((Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,80000038),e:GetHandlerPlayer(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) or Duel.IsEnvironment(80000038))
		or (Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,80000039),e:GetHandlerPlayer(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)))
end

function s.filter(c)
	return c:IsMonster() or c:IsSpellTrap() and c:IsAbleToRemove()
end
function s.sendcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_GRAVE,0,nil)
	if #g==0 then return end
	local last=g:GetFirst()
	local tc=g:GetNext()
	for tc in aux.Next(g) do
		if tc:GetSequence()>last:GetSequence() then last=tc end
	end
	Duel.Remove(last,POS_FACEUP,REASON_COST)
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,nil) end
	e:SetCategory(CATEGORY_TOGRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,0)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,1,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
		Duel.SendtoGrave(c,REASON_EFFECT)
	end
end

function s.filter1(c)
	return c:IsMonster() and c:IsSetCard(0x39b) and c:IsFaceup()
end
function s.filter2(c,e,tp)
	return c:IsCode(80000047) and c:IsLocation(LOCATION_GRAVE) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_ONFIELD) and s.filter1(chkc,e,tp) end
	if chk==0 then return Duel.GetMatchingGroup(s.filter1,tp,LOCATION_ONFIELD,0,1,nil,e,tp) end
	--Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	--Duel.SelectTarget(tp,s.filter1,tp,LOCATION_ONFIELD,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_ONFIELD,0,1,1,nil,e,tp,tc,pg)
	local pg=aux.GetMustBeMaterialGroup(tp,tc,tp,nil,nil,REASON_XYZ)
	--if not tc or tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) or #pg>1 or (#pg==1 and not pg:IsContains(tc)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,tc,pg)
	local sc=g:GetFirst()
	if sc then
		sc:SetMaterial(tc)
		Duel.Overlay(sc,tc)
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		local c=e:GetHandler()
		local og=c:GetOverlayGroup()
		if #og==0 then return end
		Duel.SendtoGrave(og,REASON_EFFECT)
		local help=Duel.GetMatchingGroup(s.filter,tp,LOCATION_GRAVE,0,nil)
		if #help==0 then return end
		local last=help:GetFirst()
		local bruh=help:GetNext()
		for bruh in aux.Next(help) do
			if bruh:GetSequence()>last:GetSequence() then last=bruh end
		end
		Duel.Overlay(c,last)
		sc:CompleteProcedure()
	end
end




