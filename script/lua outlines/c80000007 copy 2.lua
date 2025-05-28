-- Generic Dragon - Burka
-- Scripted by ColdYogurt
-- Cards Used: Ophiel, Revolution Dragon, Magigirl, Zefrasaber, 
local s,id=GetID()
function s.initial_effect(c)
	--ritual restriction
	c:EnableReviveLimit()
	--pendulum summon
	Pendulum.AddProcedure(c)
	--Ritual Summon
	local e2=Ritual.CreateProc(c,RITPROC_GREATER,g,nil,aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCost(s.spcost)
	--e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end

s.listed_series={0x39a}
function s.spcostfilter(c)
	return c:IsSetCard(0x39a) and c:IsRitualMonster()
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.spcostfilter,tp,LOCATION_HAND,0,1,c) end
	Duel.Destroy(c,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,s.spcostfilter,tp,LOCATION_HAND,0,1,1,c)
	Duel.ConfirmCards(1-tp,g)
end

--use variable g in the ritual filter?



