--魔導召喚士 テンペル
function c87608852.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(87608852,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c87608852.spcost)
	e1:SetTarget(c87608852.sptg)
	e1:SetOperation(c87608852.spop)
	c:RegisterEffect(e1)
	if not c87608852.global_check then
		c87608852.global_check=true
		c87608852[0]=true
		c87608852[1]=true
		c87608852[2]=false
		c87608852[3]=false
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c87608852.checkop1)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_CHAINING)
		ge2:SetOperation(c87608852.checkop2)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge3:SetOperation(c87608852.clear)
		Duel.RegisterEffect(ge3,0)
	end
end
function c87608852.checkop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsLevelAbove(5) then
			c87608852[tc:GetSummonPlayer()]=false
		end
		tc=eg:GetNext()
	end
end
function c87608852.checkop2(e,tp,eg,ep,ev,re,r,rp)
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsSetCard(0x106e) then
		c87608852[rp+2]=true
	end
end
function c87608852.clear(e,tp,eg,ep,ev,re,r,rp)
	c87608852[0]=true
	c87608852[1]=true
	c87608852[2]=false
	c87608852[3]=false
end
function c87608852.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return c87608852[tp] and c87608852[tp+2] and e:GetHandler():IsReleaseable() end
	Duel.Release(e:GetHandler(),REASON_COST)
	--oath effects
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c87608852.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c87608852.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLevelAbove(5)
end
function c87608852.spfilter(c,e,tp)
	return c:IsLevelAbove(5) and c:IsRace(RACE_SPELLCASTER) and c:IsAttribute(0x30)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c87608852.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c87608852.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
end
function c87608852.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c87608852.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end