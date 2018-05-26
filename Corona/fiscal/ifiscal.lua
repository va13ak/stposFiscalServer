--- 
-- @author Valery Zakharov <va13ak@gmail.com>
-- @date 2017-01-06 11:46:24

local ut13 = require "fiscal.utils13"

local ENQ = 0x05 -- Запрос  05H
local ACK = 0x06 -- Подтверждение  06H  
local NAK = 0x15 -- Отрицание  15H

local EOT = 0x04 -- Конец передачи  04H 

local STX = 0x02 -- Начало текста  02H 
local ETX = 0x03 -- Конец текста  03H 
local DLE = 0x10 -- Экранирование управляющих символов 

local iFiscal = {
	host = nil,
	port = nil,
	keepAliveConnection = false,
    waitForIncomingConnection = false,
	client = nil,

    connectionTimeout = 5,
    ioTimeout = 1,

	lastErrorCode = 0,
	lastErrorDescription = {},

    byteRepresentation = {
        [ENQ] = "ENQ",
        [ACK] = "ACK",
        [NAK] = "NAK",
        [EOT] = "EOT",
        [STX] = "STX",
        [ETX] = "ETX",
        [DLE] = "DLE"
    }
}

function iFiscal:init( ... )
	return 0
end

function iFiscal:new( ... )
	newObj = { host=arg[1], port=arg[2] }
	-- set up newObj
	self.__index = self
	return setmetatable(newObj, self)
--	newObject = { host=arg[1], port=arg[2] };
--	self.__index = self;
--	setmetatable( newObject, self );
--	newObject:init( ... );
--	return newObject;
end



function iFiscal:log( ... )
    print( ... );
end



function iFiscal:printXReport ( ... )
	return 0;
end

function iFiscal:printZReport ( ... )
	return 0;
end

function iFiscal:printPeriodicalReportByDate( ... )
    return 0;
end

function iFiscal:printPeriodicalReportByNo( ... )
    return 0;
end

function iFiscal:printArtsReport( ... )
    return 0;
end



function iFiscal:cashIn ( ... )
	return 0;
end

function iFiscal:cashOut ( ... )
	return 0;
end


function iFiscal:printEmptyCheque ( ... )
    return 0;
end


function iFiscal:printCheque ( ... )
	return 0;
end

function iFiscal:printChequeCopy ( ... )
    return 0;
end

function iFiscal:printTestCheque ( ... )
    return 0;
end


function iFiscal:cancelCheque ( ... )
    return 0;
end


function iFiscal:getSerial ( ... )
    return 0;
end


function iFiscal:printInfo ( ... )
    return 0;
end

function iFiscal:printNonFiscalCheque ( ... )
    return 0;
end


function iFiscal:isConnected ( ... )
	return false;
end


function iFiscal:waitForConnection( ... )
    return 0;
end

function iFiscal:disconnect( ... )
    return 0;
end

function iFiscal:shutdown( ... )
    return 0;
end







function iFiscal:getSymbol( byte )
    local symbol;
    if ( byte < 32 ) or ( byte > 127 ) then
        symbol = self.byteRepresentation[byte];
        if (not symbol) then
            symbol = "?";
        end;
    else
        symbol = string.char( byte );
    end;
    return symbol;
end

function iFiscal:byteToChar( byte )
    if ( byte ) then
        local symbol;
        if ( byte < 32 ) or ( byte > 127 ) then
            symbol = self.byteRepresentation[byte];
        else
            symbol = string.char( byte );
        end;
        return ut13.stringToHexDump( string.char( byte ) )..(symbol and (" ("..symbol..")") or "");
    end;
    return "nil";
end

function iFiscal:sendByte( byte, ... ) -- local
	--[[
    if ( not self.client ) then
		self:connect();
	end;
    --]]

	if ( self.client ) then
	    local res1, res2, res3 = self.client:send( string.char( byte ) );

    	self:log( ">> "..(arg[1] and "["..arg[1].."] " or "")
        	        ..self:byteToChar( byte ).." :    "
            	    ..(res1 or "nil").." "
                	..(res2 or "nil").." "
	                ..(res3 or "nil") );

    	return res1, res2, res3;
	end;
	return nil;
end

function iFiscal:receiveByte( ... ) -- local
    local res1, res2, res3 = self.client:receive( 1 );
    if (res1) then
        res1 = res1:byte();
    end;

    self:log( "<< "..(arg[1] and "["..arg[1].."] " or "")
                ..self:byteToChar( res1 ).." :    "
                ..(res1 and self:getSymbol( res1 ) or "nil").." "
                ..(res2 or "nil").." "
                ..(res3 or "nil") );

    return res1, res2, res3;
end



return iFiscal