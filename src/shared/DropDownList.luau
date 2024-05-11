local Tween = game:GetService("TweenService")

--[[
	Элемет выпадающего списка
]]
local Element = {}

--[[
	Выпадающий список
]]
local DropdownList = {}

--[[
	Конструктор
	Text	Текст элемента
	func	Функция которая будет вызвана при нажатии на элемент, если не указана, то возвращается значение Text
]]
function Element:new(Text:string, func)
	
	local public = {
		_text = Text
	}
	
	public._func = func or (function() 
		return public._text		
	end)
	
	setmetatable(public, self)
	self.__index = self
	return public
end

--[[
	Конструктор
	
	List	таблица-список из Element
	Parent	Parent фрейма
	ParentB	Guipublicect, с которого берется размер, позиция и цвет
	rows	количество строк(необязательно), по умолчанию 4
	Name	Имя фрейма(необязательно), по умолчанию "Dropdown list"
	AnimationSpeed	Скорость анимации(необязательно), по умолчанию 0.3 сек
]]
function DropdownList:new(List:{Element}, FrameC:GuiObject, rows:number, name:string, AnimationSpeed:number)
	
	if not name then
		name = "Dropdown list"
	end
	
	
	local public = {
		_Name	= name,
		_List	= List,
		_rows	= rows or 4,
		_AnimationSpeed = AnimationSpeed or 0.3
	}
	
	local Frame 	= Instance.new("Frame")
	Frame.Parent	= FrameC.Parent
	Frame.Position	= FrameC.Position
	Frame.Size		= FrameC.Size
	Frame.BackgroundColor = FrameC.BackgroundColor
	Frame.Name = name
	
	local Opened	= Instance.new("BoolValue")
	Opened.Parent	= Frame
	Opened.Name 	= "Opened"
	
	public._Frame = Frame
	

	
	
	local openButton	= Instance.new("TextButton")
	openButton.Parent	= Frame
	openButton.Position	= UDim2.new(0,0,0,0)
	openButton.Size 	= UDim2.new(1, 0, 1, 0)
	openButton.Name 	= "OpenList"
	openButton.Text	= name
	openButton.BackgroundTransparency = 1
	openButton.TextScaled = true
	
	
	local Content	= Instance.new("Folder")
	Content.Parent	= Frame
	Content.Name	= "Content"
	
	
	local ScrollFrame:GuiObject
	
	
	
	local retValue
	
	--[[
		Добавить элемент в список
	]]
	function public:AddElement(element:Element)
		local Element = Instance.new("TextButton")

		Element.Parent	= Content

		Element.Visible	= false

		Element.Size	= UDim2.new(1, 
			0, 
			0,
			openButton.AbsoluteSize.Y)

		Element.Text	= element._text
		Element.BackgroundTransparency = 1
	end


--[[
	Открыть список
]]
	function public:Open()
		Opened.Value = true
		
		openButton.Visible = false

		local a = Content:GetChildren()
		
		local l = public._rows
		if public._rows > #a then
			l = #a
		end

		ScrollFrame				= Instance.new("ScrollingFrame")
		ScrollFrame.Parent		= Frame
		ScrollFrame.Position	= UDim2.new(0, 0, 0, 0)
		ScrollFrame.Size		= UDim2.new(1, 0, 0, 0)
		ScrollFrame.CanvasSize	= UDim2.new(0, 0, 0, openButton.AbsoluteSize.Y * #a)
		ScrollFrame.BackgroundColor	= Frame.BackgroundColor
		
		Tween:Create(
			ScrollFrame,
			TweenInfo.new(
				public._AnimationSpeed,
				Enum.EasingStyle.Quad,
				Enum.EasingDirection.InOut,
				0,
				false,
				0
			),
			{
				Size = UDim2.new(1, 0, 0, openButton.AbsoluteSize.Y * l)
			}
		):Play()
		
		
		for i = 1, #a  do
			if a[i].ClassName == "TextButton" then
				local copy:GuiObject = a[i]:Clone()
				copy.Parent		= ScrollFrame
				copy.Visible	= true
				copy.Position	= UDim2.new(0, 0, 0, openButton.AbsoluteSize.Y * (i-1))
				copy.Size 		= UDim2.new(1, 0, 0, openButton.AbsoluteSize.Y)
			end
		end
		
		ScrollFrame.MouseLeave:Connect(function(x: number, y: number) 
			public:Close()
		end)
	end


--[[
	Закрыть выпадающий список
]]
	function public:Close()

		Opened.Value = false
		
		local a = Tween:Create(
			ScrollFrame,
			TweenInfo.new(
				public._AnimationSpeed,
				Enum.EasingStyle.Quad,
				Enum.EasingDirection.InOut,
				0,
				false,
				0
			),
			{
				Size = UDim2.new(1, 0, 0, openButton.AbsoluteSize.Y)
			}
		)
		a:Play()
		a.Completed:Wait()

		
		if ScrollFrame then
			ScrollFrame:Destroy()
		end
		openButton.Visible = true
	end
	
	--[[
		Получить кнопку
	]]
	function public:GetButton():GuiButton
		return openButton
	end
	
	--[[
		Обработчик
		Просто вызываешь его и не паришся
	]]
	function public:Handler()
		
		openButton.MouseButton1Click:Connect(function()

			public:Open()
			
			local a = ScrollFrame:GetChildren()
				for i = 1, #a do
				if a[i].ClassName == "TextButton" then
					a[i].MouseButton1Click:Connect(function()
						retValue = List[i]._func()
						public:Close()
						openButton.Text = retValue
					end)
				end
			end
			
		end)
	end
	
	function public:GetPressed(default)
		if not Opened.Value then
			return retValue
		else
			return default
		end
	end
	
	function public:Update(updatefunc:(newValue:number) -> ())
		Opened:GetPropertyChangedSignal("Value"):Connect(function(...: any) 
			local g = public:GetPressed(false)
			if g then
				updatefunc(g)
			end
		end)
	end
	
	
	
	for i = 1, #List do
		public:AddElement(List[i])
	end
	
	setmetatable(public, self)
	self.__index = self
	
	return public
end





local DropDownListModule = {Element		=	Element,
	DropdownList	=	DropdownList}

return DropDownListModule
