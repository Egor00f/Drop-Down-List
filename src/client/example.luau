local ReplicatedStorage = game:GetService("ReplicatedStorage")
local playerGui = game:GetService('Players').LocalPlayer:WaitForChild('PlayerGui')


local Frame = Instance.new("Frame")
Frame.Parent = playerGui


local DropdownList = require(ReplicatedStorage.DropdownList)

function a()
	--if you want, can do something here
	return "Amogus"
end

local List = DropdownList.DropdownList:new(
	{                                   -- List of Elemets
		DropdownList.Element("One", a), -- Second arg is function (you can don't add)
		DropdownList.Element("Two"),
		DropdownList.Element("Three"),
		DropdownList.Element("UwU"),
	},
	Frame,           -- Frame that will be
	3,               -- Rows, default 4
	"Dropdown List", -- Name of List
	1                -- Speed of animation
)

List:Handler()

List:Update(function(newVal:number)
  print(newVal)	-- See to console
end)