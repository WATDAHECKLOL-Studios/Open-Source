do
  repeat wait() until game.Loaded
	local animation = script:WaitForChild('Animation')
	local humanoid = script.Parent:WaitForChild('Humanoid')
	local dance = humanoid:LoadAnimation(animation)
	dance:Play()
	dance.Looped = true
end
