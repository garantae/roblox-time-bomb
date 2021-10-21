--[[

	BombBehavior
	@author Garantae
	
	Responsible for its animation, movement speed increase for the user, being able to pass it,
	and blowing up.

--]]

--// Variables
local BombTick = script.Parent.BombTick
local IsTimerRunning = false
local IsBombOn = false
local BombEnabled = true
local ExplosionSFX = script.Parent.Handle.ExplosionSFX
local PassSFX = script.Parent.Handle.PassSFX


--// Animation
local HoldAnimation = Instance.new("Animation")
	HoldAnimation.AnimationId = "rbxassetid://4835079303"
	

script.Parent.Handle.Touched:Connect(function(hit)
	
	if hit.Parent:FindFirstChild("Humanoid") ~= nil and BombEnabled == true and hit.Parent:FindFirstChild("Humanoid").Health > 0 and BombTick.Value > 0 then
		BombEnabled = false
		
		--// Lose bonus speed
		if script.Parent.Parent:FindFirstChild("Humanoid") then
			
			if script.Parent.Parent:FindFirstChild("Humanoid").WalkSpeed > 16 then
				script.Parent.Parent:FindFirstChild("Humanoid").WalkSpeed = script.Parent.Parent:FindFirstChild("Humanoid").WalkSpeed - 4
			end
			
			local AllTracks = script.Parent.Parent:FindFirstChild("Humanoid"):GetPlayingAnimationTracks()
			for i, track in pairs (AllTracks) do
				track:Stop()
			end
		end
		
		PassSFX:Play()
		script.Parent.Parent = hit.Parent
		wait(2)
		BombEnabled = true
		
	end
end)


--// Function on when the bomb is equipped
script.Parent.Equipped:Connect(function()
	
	IsBombOn = true

	if script.Parent.Parent:FindFirstChild("Humanoid") then
		
		--// Play the bomb's hold animation
		local AnimationTrack = script.Parent.Parent:FindFirstChild("Humanoid"):LoadAnimation(HoldAnimation)
			AnimationTrack:Play()
			AnimationTrack.Priority = 1
	
		--// Increase the player's movement speed by 4
		if script.Parent.Parent:FindFirstChild("Humanoid").WalkSpeed ~= 0 and script.Parent.Parent:FindFirstChild("Humanoid").WalkSpeed < 20 then
			script.Parent.Parent:FindFirstChild("Humanoid").WalkSpeed = script.Parent.Parent:FindFirstChild("Humanoid").WalkSpeed + 4
		end
	end
	
	--// Bomb timer
	while IsBombOn == true and IsTimerRunning == false do
		IsTimerRunning = true
		for i=BombTick.Value,0,-1 do
			wait(1)
			BombTick.Value = i
				if i == 0 then
					BlowUp()
				end
		end
	end
end)

function BlowUp()
	
	local BombExplode = Instance.new("Explosion", game.Workspace)
		BombExplode.DestroyJointRadiusPercent = 0
		BombExplode.Position = script.Parent.Handle.Position
		
		if script.Parent.Parent:FindFirstChild("Humanoid") ~= nil then
			script.Parent.Parent:FindFirstChild("Humanoid").Health = 0
		end

	IsBombOn = false
	ExplosionSFX:Play()
			
	repeat wait() until ExplosionSFX.IsPlaying == false
					
	script.Parent:Destroy()
	
end
