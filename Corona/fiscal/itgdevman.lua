--- 
-- @author Valery Zakharov <va13ak@gmail.com>
-- @date 2018-09-28 13:55:00

local bit = require "plugin.bit"
local band = bit.band

local json = require("json")

local resOK = 0x00
local resFail = 0xFF
local lastErrorCodeFail = "?"



local iFiscal = require "fiscal.ifiscal"
local itgdevman = iFiscal:new()


function itgdevman:fillCashier( data )
    data.cashier = ""
    data.cpwd = ""
end

function itgdevman:callDeviceManager( data, ... )
    self:fillCashier( data )

    local reqData = {
                        ver = 1,
                        device = "",
                        tag = 0,
                        sign = ""
                    }
    if arg[1] then  -- non-fiscal
        reqData.nonfiscal = data
        reqData.type = 2    -- non-fiscal
    else
        reqData.fiscal = data
        reqData.type = 1    -- fiscal
    end


    self:log( "\n=== send data (raw):", reqData )

    local jsonData = json.prettify(reqData)

    if self.debugMode then
        -- debug mode
    else
        if myPrinter then
        else
           self:log( "myPrinter module not found" )
           self.lastErrorCode = lastErrorCodeFail
           self.lastErrorDescription = "myPrinter module not found"
           return resFail
        end

        if myPrinter.itgDeviceManager then
        else
           self:log( "myPrinter.itgDeviceManager() method not found" )
           self.lastErrorCode = lastErrorCodeFail
           self.lastErrorDescription = "myPrinter.itgDeviceManager() method not found"
           return resFail
        end
    end

    self:log( "\n=== send data:", jsonData )

    local callbackFunction = function ( status, ... )
        self:log( "status:", status, arg[1], arg[2] )
        local onEndPrint = self.onEndPrint
        local result = status
        if status then
            local resultCode = arg[1]
            if resultCode == -1 then
                local respDataString = arg[2]
                local respData = json.decode( respDataString )
                if ( respData.res ) then
                    if ( respData.res == 0 ) or ( respData.res == "0" ) then -- ok
                        self.lastErrorCode = 0
                        self.lastErrorDescription = respData.errortxt
                    else
                        self.lastErrorCode = respData.res
                        self.lastErrorDescription = respData.errortxt
                    end
                else
                    self.lastErrorCode = lastErrorCodeFail
                    self.lastErrorDescription = "parameter \"res\" is missing in device manager's reply"
                end
            
            else
                self.lastErrorCode = lastErrorCodeFail
                self.lastErrorDescription = "device manager activity cancelled"
            end

        else
            self.lastErrorCode = lastErrorCodeFail
            self.lastErrorDescription = arg[1]
        end

        local result = self.fiscalServer:checkError( self )

        self:log( "self.fiscalServer:checkError( self )", result )

        self.lastSessionLog = nil

        self.lastErrorCode = 0
        self.lastErrorDescription = ""

        self.fiscalServer:runOnEndPrint( onEndPrint, result )
    end

    --local res, ret2 = myPrinter.itgDeviceManager( jsonData, callbackFunction );
    local res
    if self.debugMode then
        self:log( "there is must starting test callback" )
        --local callBackEx = function () return callbackFunction( true, -1, '{"ver":"1","device":"datecs12","tag":"0","sign":"HT65rtgftRTHR#$%*","res":"0"}' ) end
        local callBackEx = function () return callbackFunction( true, -1, '{"ver":"1","device":"datecs12","tag":"0","sign":"HT65rtgftRTHR#$%*","res":"1","errortxt":"Error 234. Can\'t found device \'datecs12\'."}' ) end
        timer.performWithDelay( 1000, callBackEx, 1 )
        res = nil
        self:log( "there is callback must be started in 1000 ms" )
    else
        res = myPrinter.itgDeviceManager( jsonData, callbackFunction )
    end

    local errorCode
    if res then
        self.lastErrorCode = lastErrorCodeFail
        self.lastErrorDescription = res
        errorCode = resFail
    else
        self.lastErrorCode = 0
        self.lastErrorDescription = ""
        errorCode = nil -- second parameter is nil, not resOK; because the process still running and we should tell it to server's executeDirect

        --[[
        self:log( "\n=== get data:", ret2 )

        local respData = json.decode(ret2)
        if respData.res == 0 then -- ok
        else
            self.lastErrorCode = respData.res
            self.lastErrorDescription = respData.errortxt
            errorCode = respData.res
        end
        ]]
    end
    --return errorCode, ret2
    return errorCode
end

function itgdevman:cashIn( sum )
    -- task = 3
    local strSum = string.format("%.2f", sum)

    self:log( "\n=== cashIn:", strSum )

    local data = {
                    sum = sum,
                    task = 3
                 }

    return self:callDeviceManager( data )
end

function itgdevman:cashOut( sum )
    -- task = 4
    local strSum = string.format("%.2f", sum)
    
    self:log( "\n=== cashOut:", strSum )

    local data = {
                    sum = sum,
                    task = 4
                 }

    return self:callDeviceManager( data )
end


function itgdevman:printEmptyCheque ( ... )
    self:log( "\n=== printEmptyCheque" )

    local data = {}
    data.pmt_type = 0 --pmt_type: 0 - cash, 1 - card
    data.items = {}

    return self:printCheque( data, arg[1] or false )
end


function itgdevman:printCheque ( ... )
    -- task = 1 / 2 - return
    self:log( "\n=== printCheque" )

    local data = arg[1]

    local dataOut = { 
        phone_number = data.phone_number or "",
        task = (arg[2] == true) and 2 or 1,
        pmt_type = (data.pmt_type == 1) and "1" or "0",
        receipt = { sum = 0., rows = {}, pays = {}, hdtxt = "", btmtxt = "" }
    }

    local taxationById = { }
    if self.fiscalServer.ldb then
        for k, v in pairs( self.fiscalServer.ldb:getAllData("fiscal_groups") ) do
            taxationById[v.fscg_id] = v.fscg_sno or 0   -- 20180710 - add
        end
        self:log( "fiscal_groups:", self.fiscalServer.ldb:getAllData("fiscal_groups") )
    end

    self:log( "taxationById:", taxationById )

    local paysum = 0

    for k, v in pairs( data.items ) do
        local currTaxation = 0
        if ( v.fscg_id ) then
            currTaxation = taxationById[v.fscg_id];
        end

        local rowValue = {
                code = v.code or 0,
                name = v.name or "",
                cnt = ( v.amount or 1.000 ),
                price = (v.price or 0.),
                discount = (v.discount or 0.),
                taxgrp = ( ( ( v.tax or 0 ) == 0 ) and "1" or ( v.tax - 1 ) ),  -- будем считать налоговые группы как в MSPOS-Expert от 1
                taxation = currTaxation,
                txt = ""
            }

        table.insert(dataOut.receipt.rows, { row = rowValue } )

        paysum = paysum + math.floor ( 0.5 + ( 1. * rowValue.cnt * rowValue.price - rowValue.discount ) )
    end

    table.insert(dataOut.receipt.pays, { pay = {
            type = data.pmt_type,
            sum = paysum
        } } )


    return self:callDeviceManager( dataOut )
end

function itgdevman:printTestCheque ( ... )
    self:log( "\n=== printTestCheque" )
    
    local data = {}
    data.phone_number = arg[3]
    data.pmt_type = arg[2] or 0 --pmt_type: 0 - cash, 1 - card
    data.items = { { code=110, name="Икра \"Заморская баклажанная\", кг", price=31.05, discount=2.10, amount=2.009, tax=0 },
                    { code=111, name="Колбаса \"Докторская\"", price=12.10, discount=2.10, amount=2.000, tax=1 },
                    { code=112, name="Морковка, кг", price=8.10, discount=1.05, amount=1.000, tax=2 } }

    return self:printCheque( data, arg[1] or false )
    --return self:callDeviceManager( "printCheque", data )
end

function itgdevman:printNonFiscalCheque ( ... )
    self:log( "\n=== printNonFiscalCheque" )

    return self:callDeviceManager( { text = arg[1] or "" }, true )  -- non-fiscal
end


function itgdevman:cancelCheque()
    self:log( "\n=== cancelCheque" )

    return self:callDeviceManager( { task = 8 } )  -- cancels opened check
end

function iFiscal:printChequeCopy ( ... )
    self:log( "\n=== printChequeCopy" )

    return self:callDeviceManager( { task = 5 } ) -- reprints last document
end


function itgdevman:printXReport()
    -- task = 6
	self:log( "\n=== printXReport" )

    return self:callDeviceManager( { task = 6 } )
end

function itgdevman:printZReport()
    -- task = 7
	self:log( "\n=== printZReport" )

    return self:callDeviceManager( { task = 7 } )
end



function itgdevman:new( ... )
	newObj = { }
	-- set up newObj
	self.__index = self
	return setmetatable(newObj, self)
end

return itgdevman
