---
-- Description of the module.
-- @module Format
--
local Format = {
  -- single-line comment
  classname = "HMFormat"
}

-------------------------------------------------------------------------------
-- Format the number
--
-- @function [parent=#Format] formatNumber
--
-- @param #number n the number
-- @param #number decimal
--
-- @return #number the formated number
--
function Format.formatNumber(n, decimal)
  local separator = " "
  if n == nil then return 0 end
  --return tostring(math.floor(n)):reverse():gsub("(%d%d%d)","%1 "):gsub(" (%-?)$","%1"):reverse()
  if decimal == nil then decimal = 2 end
  if n > 100 and decimal > 1 then decimal = 1 end
  if n > 1000 then decimal = 0 end
  local left,num,right = string.match(Format.round(n, decimal),'^([^%d]*%d)(%d*)(.-)$')
  if num == nil then return 0 end
  if left == nil then left = "" end
  if right == nil then right = "" end
  return left..(num:reverse():gsub('(%d%d%d)','%1'..separator):reverse())..right
end

-------------------------------------------------------------------------------
-- Format the number
--
-- @see http://lua-users.org/wiki/FormattingNumbers
--
-- @details Round up unless the number is lower than x.02, then round down.
--   Since this is used mostly to format factory/resource numbers this gives
--   the minimum necessary amount rounded to a proper number of decimal places,
--   but drops small surpluses from floating point.
--
-- @function [parent=#Format] round
--
-- @param #number val the number
-- @param #number decimal the number
--
-- @return #number the formated number
--
--
function Format.round(val, decimal)
  if (decimal) then
    return math.ceil( (val * 10^decimal)) / (10^decimal)
  else
    return math.ceil(val)
  end
end

-------------------------------------------------------------------------------
-- Format the number
--
-- @function [parent=#Format] formatNumberKilo
--
-- @param #number n the number
-- @param #string suffix
--
-- @return #number the formated number
--
function Format.formatNumberKilo(value, suffix)
  if suffix == nil then suffix = "" end
  if value == nil then
    return 0
  elseif value < 1000 then
    return Format.formatNumber(value).." "..suffix
  elseif (value / 1000) < 1000 then
    return math.ceil(value*10 / 1000)/10 .. " k" ..suffix
  elseif (value / (1000*1000)) < 1000 then
    return math.ceil(value*10 / (1000*1000))/10 .. " M" ..suffix
  else
    return math.ceil(value*10 / (1000*1000*1000))/10 .. " G" ..suffix
  end
end

-------------------------------------------------------------------------------
-- Format the number
--
-- @function [parent=#Format] formatPercent
--
-- @param #number n the number
--
-- @return #number the formated number
--
function Format.formatPercent(num)
  local mult = 10^3
  return math.floor(num * mult + 0.5) / 10
end

-------------------------------------------------------------------------------
-- Format number for factory
--
-- @function [parent=#Format] formatNumberFactory
--
-- @param #number number
--
function Format.formatNumberFactory(number)
  local decimal = 2
  local format_number = User.getPreferenceSetting("format_number_factory")
  if format_number == "0" then decimal = 0 end
  if format_number == "0.0" then decimal = 1 end
  if format_number == "0.00" then decimal = 2 end
  return Format.formatNumber(number, decimal)
end

-------------------------------------------------------------------------------
-- Format number for element product or ingredient
--
-- @function [parent=#Format] formatNumberElement
--
-- @param #number number
--
function Format.formatNumberElement(number)
  local decimal = 2
  local format_number = User.getPreferenceSetting("format_number_element")
  if format_number == "0" then decimal = 0 end
  if format_number == "0.0" then decimal = 1 end
  if format_number == "0.00" then decimal = 2 end
  return Format.formatNumber(number, decimal)
end
return Format
