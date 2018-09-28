--- 
-- @author Valery Zakharov <va13ak@gmail.com>
-- @date 2017-01-06 11:46:24

local bit = require "plugin.bit"
local band = bit.band

local resOK = 0x00
local resFail = 0xFF
local lastErrorCodeFail = "?"


-- Код системы налогообложения
-- Используется при регистрации и перерегистрации
local enumTaxCode = {
        -- Общая
        -- [Description("ОСН")]
        Common = 0x01,

        -- Упрощённая Доход
        -- [Description("УСН доход")]
        Simplified = 0x02,

        -- Упрощённая Доход минус Расход
        -- [Description("УСН доход - расход")]
        SimplifiedWithExpense = 0x04,

        -- Единый налог на вмененный доход
        -- [Description("ЕНВД")]
        ENVD = 0x08,

        -- Единый сельскохозяйственный налог
        -- [Description("ЕСН")]
        CommonAgricultural = 0x10,

        -- Патентная система налогообложения
        -- [Description("Патент")]
        Patent = 0x20
}


local taxations = {
    { id = 1, value = enumTaxCode.Common, name = "(1) ОСН" },
    { id = 2, value = enumTaxCode.Simplified, name = "(2) УСН доход" },
    { id = 3, value = enumTaxCode.SimplifiedWithExpense, name = "(3) УСН доход - расход" },
    { id = 4, value = enumTaxCode.ENVD, name = "(4) ЕНВД" },
    { id = 5, value = enumTaxCode.CommonAgricultural, name = "(5) ЕСН" },
    { id = 6, value = enumTaxCode.Patent, name = "(6) Патент" }
}

local iFiscal = require "fiscal.ifiscal"
local mspos = iFiscal:new()


function mspos:executeIFiscalCoreMethod( method, ... )
    if self.debugMode then
        self:log( "debugMode:" .. method )
        self.lastErrorCode = 0
        self.lastErrorDescription = ""
        local ret
        if ( method == "getTaxation" ) then
            ret = enumTaxCode.Common + enumTaxCode.ENVD
        end
        return resOK, tostring( ret )
    end

	if myPrinter then
    else
	   self:log( "myPrinter module not found" )
       self.lastErrorCode = lastErrorCodeFail
       self.lastErrorDescription = "myPrinter module not found"
       return resFail
	end

    if myPrinter.msposFiscalCore then
    else
       self:log( "myPrinter.msposFiscalCore() method not found" )
       self.lastErrorCode = lastErrorCodeFail
       self.lastErrorDescription = "myPrinter.msposFiscalCore() method not found"
       return resFail
    end

    local res, ret2 = myPrinter.msposFiscalCore( method, ... )
    local errorCode
    if res then
        self.lastErrorCode = lastErrorCodeFail
        self.lastErrorDescription = res
        errorCode = resFail
    else
        self.lastErrorCode = 0
        self.lastErrorDescription = ""
        errorCode = resOK
    end
    return errorCode, ret2
end

function mspos:cashIn( sum )
    local strSum = string.format("%.2f", sum)
    
    self:log( "\n=== cashIn:", strSum )

    return self:executeIFiscalCoreMethod( "cashIn",  strSum)
end

function mspos:cashOut( sum )
    local strSum = string.format("%.2f", sum)

    self:log( "\n=== cashOut:", strSum )

    return self:executeIFiscalCoreMethod( "cashOut", strSum )
end


function mspos:printEmptyCheque ( ... )
    self:log( "\n=== printEmptyCheque" )

    return self:executeIFiscalCoreMethod( "printEmptyCheque" )
end

function mspos:checkTaxation( taxation, flagsTaxation )
    if ( taxation == 0 ) then
        return true
    end

    local row = taxations[taxation]
    if ( row ) then
        if ( band( flagsTaxation, row.value ) == row.value ) then
            return true
        end
    end
end

function mspos:printCheque ( ... )
    self:log( "\n=== printCheque" )

    local errorCode, flagsTaxation = self:getTaxation( )
    if ( errorCode ~= resOK ) then
        return errorCode
    end

    local data = arg[1]

    local dataOut = { 
        phone_number = data.phone_number or "",
        is_refund = (arg[2] == true) and "1" or "0",
        pmt_type = (data.pmt_type == 1) and "1" or "0",
        taxation = "0",
        items = { }
    }

    local taxationById = { }
    if self.fiscalServer.ldb then
        for k, v in pairs( self.fiscalServer.ldb:getAllData("fiscal_groups") ) do
            taxationById[v.fscg_id] = v.fscg_sno or 0   -- 20180710 - add
        end
        self:log( "fiscal_groups:", self.fiscalServer.ldb:getAllData("fiscal_groups") )
    end

    self:log( "taxationById:", taxationById )

    local dataOutItemsByTaxation = { }
    local haveEmptyTaxation
    local haveNotEmptyTaxation
    local haveWrongTaxation

    for k, v in pairs( data.items ) do
        local currTaxation = 0
        if ( v.fscg_id ) then
            currTaxation = taxationById[v.fscg_id];
        end
        
        if ( currTaxation == 0 ) then
            haveEmptyTaxation = true
        else
            haveNotEmptyTaxation = true
        end

        if self:checkTaxation( currTaxation, flagsTaxation ) then
        else
            haveWrongTaxation = true
        end

        self:log( "currTaxation, fscg_id:", currTaxation, v.fscg_id)
        if dataOutItemsByTaxation[currTaxation] then
        else
            dataOutItemsByTaxation[currTaxation] = { }
        end

        table.insert(dataOutItemsByTaxation[currTaxation], {
                price = string.format( "%.2f", ( (1. * (v.amount or 1.) * (v.price or 0.) - (v.discount or 0.) ) / (v.amount or 1.) ) ),
                amount = string.format( "%.3f", v.amount or 1.000 ),
                taxGroup = string.format( "%d", ( ( v.tax or 0 ) == 0 ) and "1" or ( v.tax - 1 ) ),  -- будем считать налоговые группы как в MSPOS-Expert от 1
                code = v.code and string.format( "%d", v.code ) or "",
                name = v.name or ""
            } )
    end

    self:log( "haveEmptyTaxation:", haveEmptyTaxation )
    self:log( "haveNotEmptyTaxation:", haveNotEmptyTaxation )
    self:log( "haveWrongTaxation:", haveWrongTaxation )
    self:log( "dataOutItemsByTaxation:", dataOutItemsByTaxation )

    if ( haveEmptyTaxation and haveNotEmptyTaxation ) then
        self.lastErrorCode = lastErrorCodeFail
        self.lastErrorDescription = "Найдены товары одновременно с явно и неявно (0) указанной системой налогообложения"
        return resFail
    end

    if ( haveWrongTaxation ) then
        self.lastErrorCode = lastErrorCodeFail
        self.lastErrorDescription = "Найдены товары с незапрограммированной системой налогообложения"
        return resFail
    end

    for k, v in pairs( dataOutItemsByTaxation ) do
        dataOut.items = v
        dataOut.taxation = tostring( ( k == 0 ) and 0 or taxations[k].value )

        self:log( dataOut )
        self:log( dataOut.items )
        for k1, v1 in pairs( dataOut.items ) do
            self:log( v1 )
        end

        errorCode = self:executeIFiscalCoreMethod( "printCheque", dataOut )

        if ( errorCode ~= resOK ) then
            break
        end
    end

    return errorCode
end

function mspos:printTestCheque ( ... )
    self:log( "\n=== printTestCheque" )
    
    local data = {}
    data.phone_number = arg[3]
    data.pmt_type = arg[2] or 0 --pmt_type: 0 - cash, 1 - card
    data.items = { { code=110, name="Икра \"Заморская баклажанная\", кг", price=31.05, discount=2.10, amount=2.009, tax=0 },
                    { code=111, name="Колбаса \"Докторская\"", price=12.10, discount=2.10, amount=2.000, tax=1 },
                    { code=112, name="Морковка, кг", price=8.10, discount=1.05, amount=1.000, tax=2 } }

    return self:printCheque( data, arg[1] or false )
    --return self:executeIFiscalCoreMethod( "printCheque", data )
end

function mspos:printNonFiscalCheque ( ... )
    self:log( "\n=== printNonFiscalCheque" )

    return self:executeIFiscalCoreMethod( "printNonFiscalCheque", arg[1] or "" )
end


function mspos:getTaxation( ... )
    self:log( "\n=== getTaxation" )

    local errorCode, strTaxation = self:executeIFiscalCoreMethod( "getTaxation" )
    if ( errorCode ~= resOK ) then
        return errorCode, 0
    end

    local taxation = tonumber( strTaxation )

    self:log( "taxation:", taxation )

    return errorCode, taxation
end


function mspos:getTaxationList( ... )
    self:log( "\n=== getTaxationList" )

    local taxationList = { }

    local errorCode, taxation = self:getTaxation( ... )

    if ( errorCode ~= resOK ) then
        return taxationList
    end

    if ( band( taxation, enumTaxCode.Common ) == enumTaxCode.Common ) then 
        table.insert( taxationList, taxations[1].name )
    end
    if ( band( taxation, enumTaxCode.Simplified ) == enumTaxCode.Simplified ) then 
        table.insert( taxationList, taxations[2].name )
    end
    if ( band( taxation, enumTaxCode.SimplifiedWithExpense ) == enumTaxCode.SimplifiedWithExpense ) then 
        table.insert( taxationList, taxations[3].name )
    end
    if ( band( taxation, enumTaxCode.ENVD ) == enumTaxCode.ENVD ) then
        table.insert( taxationList, taxations[4].name )
    end
    if ( band( taxation, enumTaxCode.CommonAgricultural ) == enumTaxCode.CommonAgricultural ) then
        table.insert( taxationList, taxations[5].name )
    end
    if ( band( taxation, enumTaxCode.Patent ) == enumTaxCode.Patent ) then
        table.insert( taxationList, taxations[6].name )
    end

    self:log( "taxationList:", taxationList )

    return taxationList
end




function mspos:printCorrectionCheque ( ... )
    self:log( "\n=== printCorrectionCheque" )

    local params = arg[1]

    local data = {}
    data.cash = string.format( "%.2f", params.sum_cash )
    data.emoney = string.format( "%.2f", params.sum_electronic )
    data.advance = string.format( "%.2f", 0 )
    data.credit = string.format( "%.2f", 0 )
    data.other = string.format( "%.2f", 0 )
    data.taxGroup = string.format( "%d", (params.tax_num or 1) - 1 )
    
    data.opType = ( ( params.sw_income_expense == true ) or ( params.sw_income_expense == "true" ) ) and "3" or "1" -- true == expense, false == income
    
    data.docName = params.doc_name or ""
    if params.doc_date then
        data.docDate = params.doc_date.."T15:30:41.000Z"  -- "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'fff'Z'"
    end
    data.docNum = params.doc_num or "0"

    data.corrType = "0" -- Самостоятельная
    if ( params.type_independent == true ) or ( params.type_independent == "true" ) then
        data.corrType = "0" -- Самостоятельная
    elseif ( params.type_by_order == true ) or ( params.type_by_order == "true" ) then
        data.corrType = "1" -- По предписанию
    end
    
    local taxation = 0
    for k, v in pairs( taxations ) do
        if ( v.name == params.taxation ) then
            taxation = v.value
        end
    end
    data.taxation = tostring( taxation )

    self:log( data )

    return self:executeIFiscalCoreMethod( "printCorrectionCheque", data )
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
