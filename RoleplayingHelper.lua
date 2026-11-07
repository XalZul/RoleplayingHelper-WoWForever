-- Roleplaying Helper: WoW Forever compatibility layer
-- Original phrase tables are retained under Data/. Vanilla-only events are mapped
-- to modern events where possible; unsupported triggers are documented in README.
local ADDON, RPH = ...
_G.RPHForever = RPH
RPH.version = "0.2.0-dev"
RPH.events = {"entercombat","leavecombat","hurt","miss","absorb","block","dodge","parry","youcrit","youcritspell","youheal","youcritheal","petattackstart","petattackstop","petdies","resurrect","talktonpc_firsttime","talktonpc_beginning","talktonpc_middle","talktonpc_end","npctalksfriend","npctalksenemy","player_level_up","player_camping","hearthstone","trade_show","trade_closed","monster_emote_help","monster_emote_fear","monster_emote_enrage","mount","learn","drunk","sober","fall","exhausted","new_home","welcome_home","drowning","av_recall","bg_begin","epl_pvp_tower_cap","epl_pvp_tower_lose","scourge_cauldron","brd_emote_slave"}
_G.RPWORDLIST = _G.RPWORDLIST or {}
for _,k in ipairs(RPH.events) do RPWORDLIST[k]=RPWORDLIST[k] or {}; RPWORDLIST[k].ANY=RPWORDLIST[k].ANY or {} end
local defaults={enabled=true,chance=.03,delay=8}
local function InitDB()
 if type(RPHForeverDB)~="table" then RPHForeverDB={} end
 for k,v in pairs(defaults) do if RPHForeverDB[k]==nil then RPHForeverDB[k]=v end end
 RPHForeverDB.events=RPHForeverDB.events or {}
 for _,k in ipairs(RPH.events) do local c=RPHForeverDB.events[k] or {}; RPHForeverDB.events[k]=c; if c.enabled==nil then c.enabled=true end; if c.chance==nil then c.chance=defaults.chance end; if c.delay==nil then c.delay=defaults.delay end end
end
local function Traits()
 local t={"ANY"}; local _,race=UnitRace("player"); local _,class=UnitClass("player")
 race=(race or ""):upper():gsub("%s+",""); if race=="SCOURGE" then race="UNDEAD" end
 class=(class or ""):upper()
 if race~="" then t[#t+1]=race end; if class~="" then t[#t+1]=class end
 return t
end
local function PhraseFor(key)
 local root=RPWORDLIST[key]; if type(root)~="table" then return end
 for _,trait in ipairs(Traits()) do
  local entry=root[trait]
  if type(entry)=="table" then
   local a={}; for _,v in ipairs(entry) do if type(v)=="string" and v~="" then a[#a+1]=v end end
   if #a>0 then
    local s=a[math.random(#a)]; local zone=GetZoneText() or ""; local sub=GetSubZoneText() or zone
    s=s:gsub("PLAYER_NAME",UnitName("player") or ""):gsub("PLAYER_GUILDNAME",GetGuildInfo("player") or ""):gsub("SUB_ZONE",sub):gsub("ZONE",zone)
    return s
   end
  end
 end
end
local lastRP=0
function RPH:Trigger(key,force)
 if not RPHForeverDB or not RPHForeverDB.enabled then return end
 local c=RPHForeverDB.events[key]; if not c or not c.enabled then return end
 local now=GetTime(); if now-lastRP<(tonumber(c.delay) or 0) then return end
 if not force and math.random()>(tonumber(c.chance) or 0) then return end
 local phrase=PhraseFor(key); if phrase then SendChatMessage(phrase,"SAY"); lastRP=now end
end
function RPH:Toggle() InitDB(); RPHForeverDB.enabled=not RPHForeverDB.enabled; print("Roleplaying Helper "..(RPHForeverDB.enabled and "enabled." or "disabled.")) end
function RPH:Status() InitDB(); print(("Roleplaying Helper %s | %.0f%% chance | %.1fs delay"):format(RPHForeverDB.enabled and "ON" or "OFF",RPHForeverDB.chance*100,RPHForeverDB.delay)) end
SLASH_RPHFOREVER1="/rp"; SLASH_RPHFOREVER2="/rph"
SlashCmdList.RPHFOREVER=function(msg)
 InitDB(); local cmd=(msg or ""):lower():match("^%s*(.-)%s*$")
 if cmd=="on" then RPHForeverDB.enabled=true; print("Roleplaying Helper enabled.")
 elseif cmd=="off" then RPHForeverDB.enabled=false; print("Roleplaying Helper disabled.")
 elseif cmd=="toggle" then RPH:Toggle()
 elseif cmd=="status" then RPH:Status()
 elseif cmd:match("^test%s+") then local key=cmd:match("^test%s+([%w_]+)$"); if key then RPH:Trigger(key,true) end
 elseif cmd=="help" then print("/rp [on|off|toggle|status|test EVENT]")
 else if RPH.options then RPH.options:SetShown(not RPH.options:IsShown()) else RPH:Status() end end
end
local function CombatLog()
 local a={CombatLogGetCurrentEventInfo()}; local sub=a[2]; local src=a[4]; local dst=a[8]; local pg=UnitGUID("player")
 if src==pg then
  if sub=="SPELL_HEAL" then RPH:Trigger(a[21] and "youcritheal" or "youheal")
  elseif sub=="SWING_DAMAGE" and a[18] then RPH:Trigger("youcrit")
  elseif (sub=="SPELL_DAMAGE" or sub=="RANGE_DAMAGE") and a[21] then RPH:Trigger("youcritspell") end
 elseif dst==pg then
  if sub=="SWING_DAMAGE" or sub=="SPELL_DAMAGE" or sub=="RANGE_DAMAGE" then RPH:Trigger("hurt")
  elseif sub=="SWING_MISSED" or sub=="SPELL_MISSED" or sub=="RANGE_MISSED" then
   local miss=sub=="SWING_MISSED" and a[12] or a[15]
   if miss=="DODGE" then RPH:Trigger("dodge") elseif miss=="PARRY" then RPH:Trigger("parry") elseif miss=="BLOCK" then RPH:Trigger("block") elseif miss=="ABSORB" then RPH:Trigger("absorb") else RPH:Trigger("miss") end
  end
 end
end
local f=CreateFrame("Frame"); RPH.frame=f; f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent",function(self,event,...)
 if event=="PLAYER_LOGIN" then
  InitDB(); for _,e in ipairs({"PLAYER_REGEN_DISABLED","PLAYER_REGEN_ENABLED","COMBAT_LOG_EVENT_UNFILTERED","PLAYER_ALIVE","PLAYER_LEVEL_UP","GOSSIP_SHOW","GOSSIP_CLOSED","MERCHANT_SHOW","TRADE_SHOW","TRADE_CLOSED","PLAYER_MOUNT_DISPLAY_CHANGED","CHAT_MSG_MONSTER_SAY","CHAT_MSG_MONSTER_EMOTE","CHAT_MSG_MONSTER_YELL","PLAYER_CAMPING"}) do self:RegisterEvent(e) end
  math.randomseed((GetServerTime and GetServerTime() or time())%2147483647); print("Roleplaying Helper (Forever) loaded. /rp help")
 elseif event=="PLAYER_REGEN_DISABLED" then RPH:Trigger("entercombat")
 elseif event=="PLAYER_REGEN_ENABLED" then RPH:Trigger("leavecombat")
 elseif event=="COMBAT_LOG_EVENT_UNFILTERED" then CombatLog()
 elseif event=="PLAYER_ALIVE" then RPH:Trigger("resurrect")
 elseif event=="PLAYER_LEVEL_UP" then RPH:Trigger("player_level_up")
 elseif event=="GOSSIP_SHOW" then RPH:Trigger("talktonpc_beginning")
 elseif event=="GOSSIP_CLOSED" then RPH:Trigger("talktonpc_end")
 elseif event=="MERCHANT_SHOW" then RPH:Trigger("talktonpc_middle")
 elseif event=="TRADE_SHOW" then RPH:Trigger("trade_show")
 elseif event=="TRADE_CLOSED" then RPH:Trigger("trade_closed")
 elseif event=="PLAYER_MOUNT_DISPLAY_CHANGED" then RPH:Trigger("mount")
 elseif event=="PLAYER_CAMPING" then RPH:Trigger("player_camping")
 elseif event=="CHAT_MSG_MONSTER_SAY" then RPH:Trigger("npctalksfriend")
 elseif event=="CHAT_MSG_MONSTER_EMOTE" or event=="CHAT_MSG_MONSTER_YELL" then RPH:Trigger("monster_emote_help") end
end)
local function MakeOptions()
 local p=CreateFrame("Frame","RPHForeverOptions",UIParent,"BasicFrameTemplateWithInset"); p:SetSize(320,230); p:SetPoint("CENTER"); p:SetMovable(true); p:EnableMouse(true); p:RegisterForDrag("LeftButton"); p:SetScript("OnDragStart",p.StartMoving); p:SetScript("OnDragStop",p.StopMovingOrSizing)
 local title=p:CreateFontString(nil,"OVERLAY","GameFontHighlight"); title:SetPoint("TOP",0,-8); title:SetText("Roleplaying Helper")
 local check=CreateFrame("CheckButton",nil,p,"UICheckButtonTemplate"); check:SetPoint("TOPLEFT",16,-42); check.text:SetText("Enable automatic roleplay")
 local cl=p:CreateFontString(nil,"OVERLAY","GameFontNormal"); cl:SetPoint("TOPLEFT",20,-90); cl:SetText("Global chance")
 local cs=CreateFrame("Slider",nil,p,"OptionsSliderTemplate"); cs:SetPoint("TOPLEFT",20,-110); cs:SetWidth(270); cs:SetMinMaxValues(0,1); cs:SetValueStep(.01); cs:SetObeyStepOnDrag(true); cs.Low:SetText("0%"); cs.High:SetText("100%")
 local dl=p:CreateFontString(nil,"OVERLAY","GameFontNormal"); dl:SetPoint("TOPLEFT",20,-150); dl:SetText("Minimum delay (seconds)")
 local ds=CreateFrame("Slider",nil,p,"OptionsSliderTemplate"); ds:SetPoint("TOPLEFT",20,-170); ds:SetWidth(270); ds:SetMinMaxValues(0,60); ds:SetValueStep(1); ds:SetObeyStepOnDrag(true); ds.Low:SetText("0"); ds.High:SetText("60")
 check:SetScript("OnClick",function(x) RPHForeverDB.enabled=x:GetChecked() end); cs:SetScript("OnValueChanged",function(_,v) RPHForeverDB.chance=v end); ds:SetScript("OnValueChanged",function(_,v) RPHForeverDB.delay=v end)
 p:SetScript("OnShow",function() InitDB(); check:SetChecked(RPHForeverDB.enabled); cs:SetValue(RPHForeverDB.chance); ds:SetValue(RPHForeverDB.delay) end); RPH.options=p
end
f:HookScript("OnEvent",function(_,event) if event=="PLAYER_LOGIN" then MakeOptions() end end)
