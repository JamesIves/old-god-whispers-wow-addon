-- Sound ids for all of the whispers, divided into seperate tables for each old god. --
local CthunSounds = {
  546633, 546620, 546621, 546623, 546626, 546627, 546628, 546636
}

local NzothSounds = {
  2529827, 2529828, 2529829, 2529830, 2529831, 2529832, 2529833, 2529834, 2529835, 2529836, 2529837, 2529838, 2529839, 2529840
  , 2529841, 2529842, 2529843, 2529844, 2529846, 2564962, 2564963, 2564964, 2564965, 2564966, 2564967, 2564968, 2564969, 2564970, 2618480, 2618483, 2618486,
  2923228, 2923229, 2923230, 2923231, 2923232, 2923233, 2923236, 2923237, 2959164, 2959166, 2959167, 2959168, 2959169, 2959170, 2959189, 2959190, 2959191, 2959192, 2959193, 2959194, 2960030
}

local IlgynothSounds = {
  1360537, 1360538, 1360539, 1360540, 1360541, 1360542, 1360543, 1360544,1360545,
  1360546, 1360547, 1360553, 1360554, 1360555, 1360556, 1360557, 1360558,  1360559,
  1360560, 1360561, 1360562, 3178932, 3178933, 3178934, 3178935, 3178936,3178937
  , 3180746, 3180788, 3180789, 3180790,  3180791, 3180792, 3180900, 3180901,
  3180902, 3180903, 3180904, 3180905, 3180906, 3180907, 3180910, 3180911, 3180938,
  3180939, 3180940, 3180944
}

local YoggSaronSounds = {
  564844, 564858, 564838, 564877, 564865, 564834, 564862, 564868, 564857, 564870, 564856, 564845, 564823
}

local GhuunSounds = {
  2000113, 2000114, 2000115, 2000119, 2000120, 2000121, 2000149
}

-- Fires a random function on an interval. --
local function PerformRandom(delay, func)
  C_Timer.After(delay, func)
end

-- Plays a random sound depending on what configuration settings are enabled. --
local function PlaySounds(click)
  -- availableSounds always starts of with a number of shared whispers. --
  local availableSounds = {2494907, 2494908, 2494909, 2494910, 2494911, 2494912, 2494913, 2494914, 2494915, 2494916}

  if OldGodWhispersDatabase['cthunEnabled'] == true then
      for k, v in pairs(CthunSounds) do
          table.insert(availableSounds, v)
      end
  end

  if OldGodWhispersDatabase['nzothEnabled'] == true then
      for k, v in pairs(NzothSounds) do
          table.insert(availableSounds, v)
      end
  end

  if OldGodWhispersDatabase['ghuunEnabled'] == true then
      for k, v in pairs(GhuunSounds) do
          table.insert(availableSounds, v)
      end
  end

  if OldGodWhispersDatabase['yoggSaronEnabled'] == true then
      for k, v in pairs(YoggSaronSounds) do
          table.insert(availableSounds, v)
      end
  end

  if OldGodWhispersDatabase['ilgynothEnabled'] == true then
      for k, v in pairs(IlgynothSounds) do
          table.insert(availableSounds, v)
      end
  end

  PlaySoundFile(availableSounds[math.random(#availableSounds)], "Dialog")

  -- This should only fire if it's a callback from an interval. --
  -- The click arg gets passed as true on all button presses to prevent double firing. --
  if OldGodWhispersDatabase['random'] == true and click == nil then
      PerformRandom(math.random(300, 1800), PlaySounds)
  end
end

-- Registers the frame that renders the button in-game. --
local frame = CreateFrame("Button", "DragFrame", UIParent)

frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_LOGOUT")

frame:SetPoint("Center", 0, 0)
frame:SetSize(45, 45)

-- Makes the frame draggable. --
frame:SetMovable(true)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", frame.StartMoving)
frame:SetScript("OnDragStop", frame.StopMovingOrSizing)

local icon = frame:CreateTexture("Texture", "Background")
-- N'Zoth eyeball texture. --
icon:SetTexture("3004126")

-- Makes the area behind the background invisible. --
icon:SetMask("Interface\\CharacterFrame\\TempPortraitAlphaMask")
icon:SetAllPoints(frame)

local ring = frame:CreateTexture("Texture", "Overlay")
ring:SetAtlas("adventureguide-ring")
ring:SetPoint("Center", frame)
ring:SetSize(60, 60)

local ringHighlight = frame:CreateTexture("Texture", "Overlay")
ringHighlight:SetAtlas("adventureguide-rewardring")
ringHighlight:SetPoint("Center", frame)
ringHighlight:SetSize(60, 60)
ringHighlight:SetBlendMode("Add")
ringHighlight:SetVertexColor(1, 1, 1, 0.25)

frame:SetScript("OnEnter", function(self)
  ringHighlight:Show()
end)

frame:SetScript("OnLeave", function(self)
  ringHighlight:Hide()
end)

frame:SetScript('OnClick', function(self)
  PlaySounds(true)
end)

frame:SetScript("OnEvent", function(self, event, arg1)
  if event == "ADDON_LOADED" and arg1 == "OldGodWhispers" then
      -- Checks to see if the session already has data for the addon. --
      if OldGodWhispersDatabase == nil then
          -- If no data is found some initial values get set. --
          OldGodWhispersDatabase = {
              random = false,
              addonShow = true,
              cthunEnabled = true,
              nzothEnabled = true,
              ghuunEnabled = true,
              yoggSaronEnabled = true,
              ilgynothEnabled = true
          }
      end
  else
      -- If there is addon data some initial calls get made to ensure the saved preferences are correctly respected. --
      if OldGodWhispersDatabase['addonShow'] == false then
          frame:Hide()
      end
      if OldGodWhispersDatabase['random'] == true then
          PerformRandom(math.random(300, 1800), PlaySounds)
      end
  end
end)

-- Handles slash commands / toggling. --
local function AvailableCommands(msg)
  if msg == 'toggle' then
      if OldGodWhispersDatabase['addonShow'] == true then
          frame:Hide()
      else
          frame:Show()
      end
      OldGodWhispersDatabase['addonShow'] = not OldGodWhispersDatabase['addonShow']
  elseif msg == 'random' then
      OldGodWhispersDatabase['random'] = not OldGodWhispersDatabase['random']
      print("Random Whispers - ", OldGodWhispersDatabase['random'] and "Enabled" or "Disabled")
      if OldGodWhispersDatabase['random'] == true then
          PerformRandom(math.random(300, 1800), PlaySounds)
      end
  elseif msg == 'cthun' then
      OldGodWhispersDatabase['cthunEnabled'] = not OldGodWhispersDatabase['cthunEnabled']
      print("C'thun Whispers - ",  OldGodWhispersDatabase['cthunEnabled'] and "Enabled" or "Disabled")
  elseif msg == 'nzoth' then
      OldGodWhispersDatabase['nzothEnabled'] = not OldGodWhispersDatabase['nzothEnabled']
      print("N'Zoth Whispers - ",  OldGodWhispersDatabase['nzothEnabled'] and "Enabled" or "Disabled")
  elseif msg == 'ghuun' then
      OldGodWhispersDatabase['ghuunEnabled'] = not OldGodWhispersDatabase['ghuunEnabled']
      print("G'huun Whispers - ",  OldGodWhispersDatabase['ghuunEnabled'] and "Enabled" or "Disabled")
  elseif msg == 'yoggsaron' then
      OldGodWhispersDatabase['yoggSaronEnabled'] = not OldGodWhispersDatabase['yoggSaronEnabled']
      print("Yogg-Saron Whispers - ",  OldGodWhispersDatabase['yoggSaronEnabled'] and "Enabled" or "Disabled")
  elseif msg == 'ilgynoth' then
      OldGodWhispersDatabase['ilgynothEnabled'] = not OldGodWhispersDatabase['ilgynothEnabled']
      print("Il'gynoth Whispers - ",  OldGodWhispersDatabase['ilgynothEnabled'] and "Enabled" or "Disabled")
  elseif msg == 'status' then
      print("Old God Whispers <James Ives - https://jamesiv.es>")
      print("Status:")
      print("Random Whispers - ", OldGodWhispersDatabase['random'] and "Enabled" or "Disabled")
      print("C'thun Whispers - ",  OldGodWhispersDatabase['cthunEnabled'] and "Enabled" or "Disabled")
      print("N'Zoth Whispers - ",  OldGodWhispersDatabase['nzothEnabled'] and "Enabled" or "Disabled")
      print("G'huun Whispers - ",  OldGodWhispersDatabase['ghuunEnabled'] and "Enabled" or "Disabled")
      print("Yogg-Saron Whispers - ",  OldGodWhispersDatabase['yoggSaronEnabled'] and "Enabled" or "Disabled")
      print("Il'gynoth Whispers - ",  OldGodWhispersDatabase['ilgynothEnabled'] and "Enabled" or "Disabled")
  else
      print("Old God Whispers <James Ives - https://jamesiv.es>")
      print("Available Commands:")
      print("/ogw toggle <Toggles the addon>")
      print("/ogw random <Enables random whispers from the Old Gods without pressing the button>")
      print("/ogw status <Shows which whispers are currently enabled/disabled>")
      print("/ogw cthun <Toggles whispers from C'thun>")
      print("/ogw nzoth <Toggles whispers from N'Zoth>")
      print("/ogw ghuun <Toggles whispers from G'huun>")
      print("/ogw yoggsaron <Toggles whispers from Yogg-Saron>")
      print("/ogw ilgynoth <Toggles whispers from Il'gynoth>")
  end
end

-- Registers /ogw and /oldgodwhispers as available commands. --
SLASH_OLD_GOD_WHISPERS1, SLASH_OLD_GOD_WHISPERS2 = '/ogw', '/oldgodwhispers'
SlashCmdList["OLD_GOD_WHISPERS"] = AvailableCommands
