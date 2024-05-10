# Drop-down List

just dropdown list

## usage:
```
local dropdownList = require(dropdownList)

function a()
  return "Amogus"
end

local List = dropdownList.DropdownList:new(
  {                                 -- List of Elemets
    dropdownList.Element("One", a), -- Second arg is function (you can don't add)
    dropdownList.Element("Two"),
    dropdownList.Element("Three"),
    dropdownList.Element("UwU"),
  },
  Frame,          -- Frame that will be
  3,              -- Rows, default 3
  "Dropdown List" -- Name of List
)

List:Handler()

List:Update(function(newVal:number)
  print(newVal)
end)
```
