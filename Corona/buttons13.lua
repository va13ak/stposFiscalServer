local widget = require( "widget" )

local newLinePos = 0

local scrollView

local topFirstButtonRow

local buttonHeight

local colButtonIdent
local rowButtonIdent

local colButtonsNumber
local rowButtonsNumber

local buttonHandler

local buttons = {}

local function round( par )
	return math.floor( par + 0.5 );
	--return math.floor( par );
end

local function sVprint( ... )

	local stringForPrint = ""

	for i, v in ipairs(arg) do
		-- stringForPrint = stringForPrint .. tostring( v ) .. "\t"
		if stringForPrint ~= "" then
			stringForPrint = stringForPrint .. " ";
		end;
		stringForPrint = stringForPrint .. tostring( v )
	end

	--local stringForPrintObject = display.newText( stringForPrint, displayContentCenterX, 0, 300, 0, native.systemFont, 12)
	local stringForPrintObject = display.newText( {
														text = stringForPrint,
														x = displayContentCenterX,
														y = 0,
														width = displayContentWidth - 10,
														height = 0, 
														font = native.systemFont,
														fontSize = 12
													} )
	stringForPrintObject:setFillColor( 0 ) 
	stringForPrintObject.anchorY = 0.0		-- Top
	stringForPrintObject.y = newLinePos
	newLinePos = stringForPrintObject.y + stringForPrintObject.contentHeight

	scrollView:insert( stringForPrintObject )

	scrollView:scrollTo( "bottom", { time = 0, onComplete = onScrollComplete } )
end


local function addButton(row, col, buttonId, ... )
	local singleButtonWidth = round( (displayContentWidth - (colButtonIdent * (colButtonsNumber - 1))) / colButtonsNumber );
	local relativeWidth = arg[2] or 1;
	local buttonWidth = (relativeWidth * singleButtonWidth) + (colButtonIdent * (relativeWidth - 1));
	buttons[buttonId] = widget.newButton {
		id = buttonId,
		label = arg[1] or buttonId,


		left = 0 + (singleButtonWidth + colButtonIdent) * (col - 1),
		width = buttonWidth,

		top = topFirstButtonRow + (buttonHeight + rowButtonIdent) * (row - 1),
		height = buttonHeight,

		onEvent = buttonHandler,

	    emboss = false,
	    --properties for a rounded rectangle button...
	    shape = "roundedRect",
	    cornerRadius = 1,
	    --fillColor = { default = { 1, 0, 0, 1 }, over = { 1, 0.1, 0.7, 0.4 } },
	    --strokeColor = { default = { 1, 0.4, 0, 1 }, over = { 0.8, 0.8, 1, 1 } },
	    strokeWidth = 4, 

	    font = native.systemFont,
	    fontSize = 12
	}
	return buttons[buttonId];
end


local function addTextField(row, col, buttonId, ...)
	local buttonWidth = round( (displayContentWidth - colButtonIdent * (colButtonsNumber - 1)) / colButtonsNumber );
	--[[
	]]
	-- native.newTextField( centerX, centerY, width, height )
	local left = 0 + (buttonWidth + colButtonIdent) * (col - 1);
	local width = buttonWidth;

	local top = topFirstButtonRow + (buttonHeight + rowButtonIdent) * (row - 1);
	local height = buttonHeight;
	buttons[buttonId] = native.newTextField( left + (width/2), top + (height/2), width, height );
	buttons[buttonId]:resizeFontToFitHeight();
	if arg[1] then
		buttons[buttonId]:addEventListener( "userInput", arg[1] );
	end;
	if arg[2] then
		buttons[buttonId].text = arg[2];
	end;
	return buttons[buttonId];
end



displayContentWidth = display.contentWidth
displayContentHeight = display.contentHeight
--displayContentWidth = display.actualContentWidth
--displayContentHeight = display.actualContentHeight
--displayContentWidth = display.viewableContentWidth
--displayContentHeight = display.viewableContentHeight
displayContentCenterX = display.contentCenterX
--displayContentCenterX = display.actualContentWidth / 2




colButtonsNumber = 2
rowButtonsNumber = 6

colButtonIdent = 4
rowButtonIdent = 4

buttonHeight = 25

topFirstButtonRow = displayContentHeight + 1
			- ( (rowButtonsNumber - 1) * rowButtonIdent + rowButtonsNumber * buttonHeight )

-- Create a ScrollView
scrollView = widget.newScrollView
{
	left = 0,
	top = 0,
	width = displayContentWidth,
	height = topFirstButtonRow - 5,
	-- bottomPadding = 50,
	id = "onBottom",
	horizontalScrollDisabled = true,
	verticalScrollDisabled = false,
	listener = scrollListener,
}

local function setColButtonsNumber( _colButtonsNumber )
	colButtonsNumber = _colButtonsNumber;
end

local function setButtonHandler( _buttonHandler )
	buttonHandler = _buttonHandler;
end

local function getButton( name )
	return buttons[name];
end

local function enableButton( name, enabled )
	local button = getButton(name);
	if (button == nil) then
		return;
	end;
	button:setEnabled(enabled);
	local dR, dG, dB, dA = display.getDefault( "fillColor" );
	if (enabled) then
		button:setFillColor( dR, dG, dB, dA );
	else
		button:setFillColor( dR, dG, dB, dA - 0.3 );
	end;
end

local function markButton( name, enabled )
	local button = getButton(name);
	if (button == nil) then
		return;
	end;
	local dR, dG, dB, dA = display.getDefault( "fillColor" );
	if (enabled) then
		button:setFillColor( dR, dG, dB, dA - 0.3 );
	else
		button:setFillColor( dR, dG, dB, dA );
	end;
end

return {
	addButton = addButton,
	addTextField = addTextField,
	setColButtonsNumber = setColButtonsNumber,
	setButtonHandler = setButtonHandler,
	getButton = getButton,
	enableButton = enableButton,
	markButton = markButton,
	sVprint = sVprint
}