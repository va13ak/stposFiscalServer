--- 
-- @author Valery Zakharov <va13ak@gmail.com>
-- @date 2017-01-06 11:46:24

local resOK = 0x00;
local resFail = 0xFF;

local iFiscal = require "fiscal.ifiscal"
local mspos = iFiscal:new()


function mspos:executeIFiscalCoreMethod( method, ... )
	if myPrinter then
    else
	   self:log( "myPrinter module not found" )
       return rcFail
	end

    if true then
        local res = myPrinter.msposFiscalCore( method, ... )
        if res then
            self.lastErrorCode = "?"
            self.lastErrorDescription = res
        else
            self.lastErrorCode = 0
            self.lastErrorDescription = ""
        end
        return self.lastErrorCode
    end

    if true then
       return
    end

	if not myPrinter.msposFiscalCore then
       return rcFail
    end

    local res, err = pcall( myPrinter.msposFiscalCore, ... )
	if ( res ) then
		return res

	else
		return rcFail, err
	end
end

function callbackfunc( tbl )
    -- body
end


function mspos:cashIn( sum )
    local strSum = string.format("%.2f", sum)
    
    self:log( "\n=== cashIn:", strSum );

    return self:executeIFiscalCoreMethod( "cashIn",  strSum)
end

function mspos:cashOut( sum )
    local strSum = string.format("%.2f", sum)

    self:log( "\n=== cashOut:", strSum );

    return self:executeIFiscalCoreMethod( "cashOut", string.format("%02d", strSum) )
end


function mspos:printEmptyCheque ( ... )
    self:log( "\n=== printEmptyCheque" )

    return self:executeIFiscalCoreMethod( "printEmptyCheque" )
end

function mspos:printCheque ( ... )
    self:log( "\n=== printCheque" )

    local data = arg[1]

    return self:executeIFiscalCoreMethod( "printCheque", data )
end

function mspos:printTestCheque ( ... )
    self:log( "\n=== printTestCheque" )
    
    local data = {}
    data.is_refund = arg[1] or false
    data.phone_number = arg[2] or ""
    data.pmt_type = 1
    data.items = { { code=111, name="Колбаса \"Докторская\"", price=12.10, discount=2.10, amount=2.000, taxGroup=1 },
                    { code=112, name="Морковка, кг", price=8.10, discount=1.05, amount=1.000, taxGroup=2 } }

    return self:executeIFiscalCoreMethod( "printCheque", data )
end

function mspos:printNonFiscalCheque ( ... )
    self:log( "\n=== printNonFiscalCheque" )

    return self:executeIFiscalCoreMethod( "printNonFiscalCheque", arg[1] or "" )
end


function mspos:cancelCheque()
    self:log( "\n=== cancelCheque" )

    return self:executeIFiscalCoreMethod( "cancelCheque" )
end



function mspos:printXReport()
	self:log( "\n=== printXReport" )

    return self:executeIFiscalCoreMethod( "printXReport" )
end

function mspos:printZReport()
	self:log( "\n=== printZReport" )

    return self:executeIFiscalCoreMethod( "printZReport" )
end



function mspos:init( ... )
    return self:executeIFiscalCoreMethod( "init" )
end

function mspos:shutdown( ... )
    return self:executeIFiscalCoreMethod( "shutdown" )
end



function mspos:new( ... )
	newObj = { }
	-- set up newObj
	self.__index = self
	return setmetatable(newObj, self)
end

return mspos
