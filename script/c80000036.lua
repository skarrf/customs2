-- Grim Forest Bruin
-- Scripted by ColdYogurt
-- Cards Used: Segmental Dragon 15055114
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--special summon from hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.hspcon)
	e1:SetTarget(s.hsptg)
	e1:SetOperation(s.hspop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
end

s.listed_series={0x39b}
function s.hspfilter1(c,tp)
	return c:IsMonster() and c:IsSetCard(0x39b) and c:IsAbleToRemoveAsCost()
end
function s.hspfilter2(c,tp)
	return c:IsCode(80000030) and c:IsAbleToRemoveAsCost()
end
function s.hspcon(e,c)
	if c==nil then return true end
	local tp=e:GetHandlerPlayer()
	local rg1=Duel.GetMatchingGroup(s.hspfilter1,tp,LOCATION_GRAVE,0,nil,tp)
	local rg2=Duel.GetMatchingGroup(s.hspfilter2,tp,LOCATION_GRAVE,0,nil,tp)
	return aux.SelectUnselectGroup(rg1,e,tp,2,2,aux.ChkfMMZ(1),0)
		and aux.SelectUnselectGroup(rg2,e,tp,1,1,aux.ChkfMMZ(1),0)
		and Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,80000038),c:GetControler(),LOCATION_ONFIELD,0,1,nil)
		or Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,80000039),c:GetControler(),LOCATION_ONFIELD,0,1,nil)
end
function s.hsptg(e,tp,eg,ep,ev,re,r,rp,c)
	local rg1=Duel.GetMatchingGroup(s.hspfilter2,tp,LOCATION_GRAVE,0,nil,tp)
	local mg1=aux.SelectUnselectGroup(rg1,e,tp,1,1,aux.ChkfMMZ(1),1,tp,HINTMSG_REMOVE,nil,nil,true)
	if #mg1>0 then
		local sg=mg1:GetFirst()
		local rg2=Duel.GetMatchingGroup(s.hspfilter1,tp,LOCATION_GRAVE,0,nil,tp)
		rg2:RemoveCard(sg)
		local mg2=aux.SelectUnselectGroup(rg2,e,tp,1,1,aux.ChkfMMZ(1),1,tp,HINTMSG_REMOVE,nil,nil,true)
		mg1:Merge(mg2)
	end
	if #mg1==2 then
		mg1:KeepAlive()
		e:SetLabelObject(mg1)
		return true
	end
	return false
end
function s.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then return end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	g:DeleteGroup()
end

function s.desfilter(c)
	return c:IsFaceup() and c:IsAttackBelow(2499) and c:GetSequence()<5
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.desfilter,tp,0,LOCATION_MZONE,1,c,c:IsAttackBelow(2499)) end
	local g=Duel.GetMatchingGroup(s.desfilter,tp,0,LOCATION_MZONE,c,c:IsAttackBelow(2499))
	g:AddCard(c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local g=Duel.GetMatchingGroup(s.desfilter,tp,0,LOCATION_MZONE,nil,2499)
		Duel.Destroy(g,REASON_EFFECT)
	end
end




