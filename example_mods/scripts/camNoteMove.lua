-- BY TPOSEJANK, edited by 💜 Rodney, An Imaginative Person 💙!
local off = {55, 55} -- x and y movement force
local velocity = {false, 3.877} -- sonic.exe lol
local opponentNotes = true -- change this to false if you dont want to trigger when opponent notes
local bfNotes = true -- change this to false if you want to trigger when player notes
local xy = {{-off[1], 0}, {0, off[2]}, {0, -off[2]}, {off[1], 0}} -- table which has the applied movement force

local focusThingy
function goodNoteHit(id, noteData, noteType, isSustainNote)
	if bfNotes and (focusThingy == 'boyfriend' or focusThingy == 'gf') then
		resetCam(noteData, noteType)
	end
end
function opponentNoteHit(id, noteData, noteType, isSustainNote)
	if opponentNotes and (focusThingy == 'dad' or focusThingy == 'gf') then
		resetCam(noteData, noteType)
	end
end

function onMoveCamera(focus)
	focusThingy = focus
	if velocity[1] then setProperty('cameraSpeed', 1) end
end

function resetCam(noteData, noteType) -- noteType is here to do cool stuff with setToCharCamPosition
	if getProperty('isCameraOnForcedPos') == false then
		runHaxeCode('game.moveCameraSection();')
		if velocity[1] then setProperty('cameraSpeed', velocity[2]) end
		setProperty('camFollow.x', getProperty('camFollow.x') + xy[noteData+1][1])
		setProperty('camFollow.y', getProperty('camFollow.y') + xy[noteData+1][2])
	end
end

function setToCharCamPosition(character, offset)
	local function doMathStupid(one, operator, two)
		-- Fuck math, why does bf do - while dad and gf do + on x like WTF?!
		one, two = one == nil and 0 or tonumber(one), two == nil and 0 or tonumber(two)
		if operator == '+' then -- Addition
			return one + two
		elseif operator == '-' then -- Subtraction
			return one - two
		elseif operator == '*' then -- Multiplication
			return one * two
		elseif operator == '/' then -- Division
			return one / two
		end
	end
	
	-- makes sure these are strings
	character = tostring(character)
	offset = tostring(offset)
	
	-- set camera to then characters camera position
	setProperty('camFollow.x', getMidpointX(character) + (offset == 'dad' and 150 or offset == 'gf' and 0 or offset == 'bf' and -100))
	setProperty('camFollow.y', getMidpointY(character) + (offset == 'dad' and -100 or offset == 'gf' and 0 or offset == 'bf' and -100))
	setProperty('camFollow.x', doMathStupid(getProperty('camFollow.x'), offset == 'bf' and '-' or '+', getProperty(character .. '.cameraPosition[0]')))
	setProperty('camFollow.y', getProperty('camFollow.y') + getProperty(character .. '.cameraPosition[1]'))
	
	if character == 'dad' or character == 'gf' or character == 'boyfriend' then
		local holyshit = (character == 'dad' and 'opponent' or character == 'gf' and 'girlfriend' or character == 'boyfriend' and 'boyfriend')
		setProperty('camFollow.x', doMathStupid(getProperty('camFollow.x'), character == 'boyfriend' and '-' or '+', getProperty(holyshit .. 'CameraOffset[0]')))
		setProperty('camFollow.y', getProperty('camFollow.y') + getProperty(holyshit .. 'CameraOffset[1]'))
	end
	
	-- from source on setting character camera position
	--[[camFollow.set(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
	camFollow.x += dad.cameraPosition[0] + opponentCameraOffset[0];
	camFollow.y += dad.cameraPosition[1] + opponentCameraOffset[1];
	
	camFollow.set(gf.getMidpoint().x, gf.getMidpoint().y);
	camFollow.x += gf.cameraPosition[0] + girlfriendCameraOffset[0];
	camFollow.y += gf.cameraPosition[1] + girlfriendCameraOffset[1];

	camFollow.set(boyfriend.getMidpoint().x - 100, boyfriend.getMidpoint().y - 100);
	camFollow.x -= boyfriend.cameraPosition[0] - boyfriendCameraOffset[0];
	camFollow.y += boyfriend.cameraPosition[1] + boyfriendCameraOffset[1];]]
end