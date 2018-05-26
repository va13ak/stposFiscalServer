--- 
-- @author Valery Zakharov <va13ak@gmail.com>
-- @date 2017-01-12 00:35:05

fiscalServer = { 
	eventListenerAdded = false,
	lang_code,
	device,
	devices = {},
	devTypes = {
					[4]="atol2",
					[5]="atol3",
					--[6]="atol3udp", 
					[7]="krypton",	--
					[8]="krypton",
					[9]="pifiscal",
					[10]="mspos",
				},
	devPrinterTypes = {
					[10]=5,
				},
	defId = "mainDevice"
}

function fiscalServer:checkError( ... )
	local result = nil
	if ( self.device ) then
		if ( self.device.lastErrorCode == 0 ) then
			result = true

		else
			local strError = "Ошибка печати на фискальный регистратор ("..self.device.devId.."): (" .. ( self.device.lastErrorCode or "nil" ) .. ") " .. ( self.device.lastErrorDescription or " ошибка подключения" )
			self:log( "error:", strError )

			if ( self.ldb ) then
				curOrderId = curOrderId or "?"
				for i = 1, #self.device.lastSessionLog do
					local rec = self.device.lastSessionLog[ i ]
					self.ldb:addNewRowData( "debug_log", { message=rec.message,
															time=os.date( '%Y-%m-%d %H:%M:%S', rec.time ) } )
				end
				self.ldb:addLogDebug( "fiscalServer error ord_id " .. curOrderId .. "\n " .. strError, true )
			end

			if ( self.lang_code ) then
				native.showAlert( trans['error'][self.lang_code], strError, { trans['ok'][self.lang_code] } )
			end

		end
	end

	return result
end

function fiscalServer:executeDirect( f, ... )
	local result = nil
	if ( self.device ) then

		self.device.lastSessionLog = {}

		local res, err = pcall ( f, self.device, ... )
		if ( res ) then
			result = self:checkError()
		else
			local strError = "Ошибка выполнения при печати на фискальный регистратор ("..self.device.devId..") (сообщите пожалуйста разработчику):\n" .. err .. "\n" .. debug.traceback( )
			self:log( "ERROR:", strError )
			
			if ( self.ldb ) then
				--if type( arg[1] == "table" ) then
				--	arg[1].orderId
				--end
				curOrderId = curOrderId or "?"
				for i = 1, #self.device.lastSessionLog do
					local rec = self.device.lastSessionLog[ i ]
					self.ldb:addNewRowData( "debug_log", { message=rec.message,
															time=os.date( '%Y-%m-%d %H:%M:%S', rec.time ) } )
				end
				self.ldb:addLogDebug( "fiscalServer error ord_id "..curOrderId.."\n ".. strError, true )
			end
			
			if ( self.lang_code ) then
				native.showAlert( trans['error'][self.lang_code], strError, { trans['ok'][self.lang_code] } )
			end
		end

		self.device.lastSessionLog = nil

		self.device.lastErrorCode = 0
		self.device.lastErrorDescription = ""
	end

	local onEndPrint = self:getOnEndPrint( ... )
	if onEndPrint then
		self:log( "---!!!========", "onEndPrintEnd", onEndPrint)
		self:log( "---!!!========", "Spinner", Spinner)
		if Spinner then
			Spinner:stop()
			self:log( "---!!!========", "SpinnerStoped", Spinner)
		end
		onEndPrint( result ~= true )
		onEndPrint = nil
	end

	return result
end

local function pack2( ... ) return { n = select( '#', ... ), ... } end
local function unpack2( t ) return unpack( t, 1, t.n ) end

function fiscalServer:getOnEndPrint( ... )
	local onEndPrint
	for i, v in ipairs( arg ) do
		if type( v ) == "table" then
			if v.onEndPrint then
				onEndPrint = v.onEndPrint
				break
			end
		end
	end
	return onEndPrint
end

function fiscalServer:execute( ... )
	local result = nil
	local onEndPrint = self:getOnEndPrint( ... )
	if onEndPrint then
		self:log( "---!!!========", "onEndPrintStart", onEndPrint)
		local execDirectParams = pack2( ... )
		local execDirect = function () return self:executeDirect( unpack2( execDirectParams ) ) end
		self:log( "---!!!========", "Spinner", Spinner)
		if Spinner then
			Spinner:start()
			self:log( "---!!!========", "SpinnerStarted", Spinner)
		end
		timer.performWithDelay( 100, execDirect, 1 )
		result = true
	else
		result = self:executeDirect( ... )
	end
	return result
end

function fiscalServer:log( ... )
	local currTime = os.time()
	-- local currTime = os.time(os.date( "*t" )
	local stringForPrint = ""
	--local stringForPrint = "===== "
	for i, v in ipairs( arg ) do
		if stringForPrint ~= "" then
			stringForPrint = stringForPrint .. " "
		end
		stringForPrint = stringForPrint .. tostring( v )
		if ( type( v ) == "table" ) then
			stringForPrint = stringForPrint .. ": { "
			for _k, _v in pairs( v ) do
--				if type( _v ) == "function" then
--					stringForPrint = stringForPrint .. " " .. _k .. "=(function), "
--				else
					stringForPrint = stringForPrint .. " " .. _k .. "=" .. tostring( _v ) .. ", "
--				end
			end
			stringForPrint = stringForPrint .. "}"
		end
	end

	if ( self.ldb ) then
		local everythingLogging
		if SETTINGS then
			if SETTINGS['is_enable_write_to_debug_log'] == "true" then
				everythingLogging = true
			end
		end

		if ( everythingLogging ) then
			self.ldb:addLogDebug( "fiscalServer: " .. stringForPrint )

		elseif ( self.device ) then
			if ( self.device.lastSessionLog ) then
				table.insert( self.device.lastSessionLog, { time=currTime, message=("fiscalServer: "..stringForPrint) } )
			end;
		end;
	end;

	stringForPrint = "" .. os.date( "%H:%M:%S", currTime ) .. ": " .. stringForPrint

	print( stringForPrint )
end

function fiscalServer:getModuleName( fsct_type )
	local moduleName = self.devTypes[ fsct_type ]
	self:log( "check device list for fsct_type =", fsct_type, "/ moduleName =", moduleName )
	return moduleName
end

function fiscalServer:checkDevice( ... ) -- leaved for back compatibility
	-- return self:getModuleName( userProfile.fsct_type )
	return self:setDevice( ... )
end

function fiscalServer:checkPrinter( prnData )
	local fsct_type = self.devPrinterTypes[ prnData.prnt_type ]
	local moduleName
	if fsct_type then
		moduleName = self.devTypes[ fsct_type ]
	end
	self:log( "check device list for prnt_type =", prnData.prnt_type, "/ fsct_type =", fsct_type, "/ moduleName =", moduleName )
	return moduleName
end


function fiscalServer:genDeviceId( ... )
	local devId = "" .. ( arg[1] or "" ) .. "/" .. ( arg[2] or "0" )
	--[[
	for i, v in ipairs( arg ) do

		devId = devId .. "/" .. ( v or "" )
	end
	--]]
	return devId
end

function fiscalServer:getDeviceId( ... )
	local devId = self.defId
	if arg[1] then
		if arg[1].prn_id then
			local prnData = arg[1]
			devId = self:genDeviceId( prnData.prn_ipAddress, prnData.prn_port )

		elseif arg[1].fsct_type then
			local userProfile = arg[1]
			devId = self:genDeviceId( userProfile.pos_fsc_ipaddress, userProfile.pos_fsc_port )
		end
	end
	return devId
end

function fiscalServer:getDevice( ... )
	local devId = self.defId
	self:log ( arg )
	if arg[1] then
		if ( type( arg[1] ) == "table" ) then
			devId = self:getDeviceId( arg[1] )

		else
			devId = arg[1]
		end
	end
	return self.devices[devId]
end

function fiscalServer:init( ... )
	--self:log( 111, ... )

	--[[
	if myPrinter then
	else
		self.devTypes[10] = nil	-- myPrinter not initialized - there is no android or its simulator
		self:log("myPrinter not initialized - there is no android or its simulator")
	end
	--]]

	if self.ldb then
		
	elseif arg[2] then
		self.ldb = arg[2]
	end

	if ( not self.lang_code ) then
		if ( arg[1].lang_code ) then
			self.lang_code = arg[1].lang_code
		end
	end

	--self:log( 222, ... )
	local device = self:getDevice( arg[1] )
	if device then
		return device
	end

	local ip
	local port
	local fsct_type

	if arg[1] then
		self:log( "init input parameters: ", arg[1] )
		if arg[1].prn_id then
			local prnData = arg[1]
			port = prnData.prn_port
			ip = prnData.prn_ipAddress
			fsct_type = self.devPrinterTypes[ prnData.prnt_type ]

		elseif arg[1].fsct_type then
			local userProfile = arg[1]
			ip = userProfile.pos_fsc_ipaddress
			port = userProfile.pos_fsc_port
			fsct_type = userProfile.fsct_type
		end
	end

	local moduleName = self:getModuleName( fsct_type )

	if ( moduleName ) then
		local deviceModule = require( "fiscal." .. moduleName )

		device = deviceModule:new( ip, port, fsct_type )

		device.log = function ( obj, ... )
			self:log( ... )
		end

		self:log( "parameters: "..moduleName, ip, port, fsct_type )

		local devId = self:genDeviceId( ip, port )

		device.devId = devId

		self.devices[ devId ] = device

		device:init()

		if ( self.eventListenerAdded ~= true ) and ( device.waitForIncomingConnection == true ) then
			Runtime:addEventListener("enterFrame",
										function()
											self:waitForConnection( )
										end
									)
			self.eventListenerAdded = true
		end
	end

	return device
end

function fiscalServer:shutdown( ... )
	if ( self.devices ) then
		for k, v in pairs( self.devices ) do
			if v then
				self:execute( v.shutdown, ... )
				self.devices[k] = nil
			end
		end
	end
end


function fiscalServer:setDevice( ... )
	local device = self:getDevice( ... )
	self:log( "setDevice", device)
	if not device then
		self:log( "setDevice + init", arg)
		device = self:init( ... )
		self:log( "setDevice", device)
	end
	if device then 
		self.device = device
	end
	return device
end


function fiscalServer:printXReport( ... )
	return self:execute( self.device.printXReport, ... )
end

function fiscalServer:printZReport( ... )
	return self:execute( self.device.printZReport, ... )
end

function fiscalServer:printPeriodicalReportByDate( ... )
	return self:execute( self.device.printPeriodicalReportByDate, ... )
end

function fiscalServer:printPeriodicalReportByNo( ... )
	return self:execute( self.device.printPeriodicalReportByNo, ... )
end

function fiscalServer:printArtsReport( ... )
	return self:execute( self.device.printArtsReport, ... )
end


function fiscalServer:cashIn( ... )
	return self:execute( self.device.cashIn, ... )
end

function fiscalServer:cashOut( ... )
	return self:execute( self.device.cashOut, ... )
end


function fiscalServer:printEmptyCheque( ... )
	return self:execute( self.device.printEmptyCheque, ... )
end


function fiscalServer:printCheque( ... )
	return self:execute( self.device.printCheque, ... )
end

function fiscalServer:printReturnCheque( ... )
	return self:execute( self.device.printCheque, arg[1], true )
end

function fiscalServer:printChequeCopy( ... )
	return self:execute( self.device.printChequeCopy, ... )
end

function fiscalServer:printTestCheque( ... )
	return self:execute( self.device.printTestCheque, ... )
end


function fiscalServer:cancelCheque( ... )
	return self:execute( self.device.cancelCheque, ... )
end


function fiscalServer:getSerial( ... )
	return self:execute( self.device.getSerial, ... )
end

function fiscalServer:printInfo( ... )
	return self:execute( self.device.printInfo, ... )
end
	
function fiscalServer:printNonFiscalCheque( ... )
	return self:execute( self.device.printNonFiscalCheque, ... )
end

function fiscalServer:printString( ... )
	return self:execute( self.device.printNonFiscalCheque, ... )
end

function fiscalServer:isConnected( ... )
	return self:execute( self.device.isConnected, ... )
end

function fiscalServer:waitForConnection( ... )
	if ( self.devices ) then
		for k, v in pairs( self.devices ) do
			if v then
				self:execute( v.waitForConnection, ... )
			end
		end
	end
end
