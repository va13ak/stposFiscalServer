--- 
-- @author Valery Zakharov <va13ak@gmail.com>
-- @date 2017-01-22 11:43:38
-- @description https://docs.google.com/document/d/1WH3rLBixVjZ5KnOhcgAPIH7Soux-kruk_i_dw35E4pc/edit?usp=sharing

local defaultPort = 60100

local CRC_PRESET = 0xFFFF;
local CRC_POLYNOM = 0x8408;

local dtChar = 0;
local dtShort = 1;
local dtInt = 2;
local dtFloat = 3;
local dtString = 4;
local dtLong = 5;
local dtVoid = 6;

local fc_CloseServerConnection = 0;
local fc_OpenServerConnection = 1;

local fc_InitFiscalConnection = 2;
local fc_SearchFiscalConnection = 3;
local fc_CloseFiscalConnection = 4;
local fc_OpenFiscalConnection = 5;

local fc_BeginFiscalReceipt = 6;
local fc_EndFiscalReceipt = 7;
local fc_PrintRecItem = 8;
local fc_PrintText = 9;
local fc_PrintRecTotal = 10;
local fc_PrintRecSubtotalAdjustment = 11;
local fc_PrintRecVoid = 12;
local fc_PrintDuplicateReceipt = 13;
local fc_PrintRecCash = 14;
local fc_PrintNullReceipt = 15;
local fc_PrintXReport = 16;
local fc_PrintZReport = 17;
local fc_GetSN = 18;
local fc_GetLastReceiptNum =19;
local fc_GetCash = 20;
local fc_PrintPeriodicReport = 21;
local fc_PrintReport = 22;

local rcOk = 0;
local rcPaperEnd = 1;
local rcWorkOut = 2;
local rcParamError = 3;
local rcFail = -1;

local resOK = 0x00;
local resFail = 0xFF;

-- enum fiscal_port_type    / model :)
local fm_None       = 0;
local fm_miniFP6    = 1;
local fm_miniFP54   = 2;
local fm_exellio1   = 3;
local fm_miniFP     = 4;
local fm_FR7        = 5;
local fm_ATOL       = 6;
local fm_SMV2       = 7;
local fm_Any        = -1;

-- enum fiscal_port_type
local fp_COM = 0;
local fp_USB = 1;
local fp_NONE = -1;


local headerMark = string.byte( 'H' );

local ut13 = require "fiscal.utils13"
local bit = require "plugin.bit"

local bnot = bit.bnot
local band, bor, bxor = bit.band, bit.bor, bit.bxor
local lshift, rshift, rol = bit.lshift, bit.rshift, bit.rol

local errorCodesDescription = { 
        [0x00] = "Ошибок нет",  -- rcOk
        [0x01] = "Закончилась кассовая лента",  -- rcPaperEnd
        [0x02] = "Превышена продолжительность кассовой смены",  -- rcWorkOut
        [0x03] = "Неверные параметры функции",  -- rcParamError
        [0x04] = "Превышение интервала передачи контрольно-отчетной информации на сервер налоговой",
        [0xF0] = "Неопознанная ошибка (не вошла в таблицу)",    --[-1]=[0xFF-->0xF0] -- rcFail
        
        -- User defined
        [0xF1] = "Не найдены подключенные к фискальному серверу (pi-компьютеру) фискальные регистраторы",
        [0xF2] = "Ошибка установки связи с подключенным к фискальному серверу (pi-компьютеру) фискальным регистратором",
        [0xFB] = "Ошибка заголовка полученных данных",
        [0xFC] = "Ошибка целостности полученных данных",
        [0xFD] = "Ошибка формата пакета",
        [0xFE] = "Фискальный сервер (pi-компьютер) не отвечает",
        [0xFF] = "Не удалось установить соединение с фискальным сервером (pi-компьютером)"
}

local function addChar ( val )  -- 1x byte
    return { dtChar, val }
end

local function addInt ( val )   -- 4x byte
    return table.copy( { dtInt }, ut13.intToByteArrayLE ( val, 4 ) )
end

local function addLong ( val )  -- 8x byte
    return table.copy( { dtLong }, ut13.intToByteArrayLE ( val, 8 ) )
end

local function addFloat ( val ) -- 4x byte
    return table.copy( { dtFloat }, ut13.floatToByteArrayLE ( val ) )
end

local function addString ( val )
    local stringArray = ut13.stringToByteArray( val )
    return table.copy( { dtString }, ut13.intToByteArrayLE ( #stringArray, 4 ), stringArray, { 0 } )
end

local function readValue ( data, position ) -- return: data, nextPos
    if ( not data ) then
        return nil, 0
    end
    if ( #data == 0 ) then
        return nil, 0
    end
    local pos = position or 1;
    local dateType = data[ pos ];
    local val;
    
    pos = pos + 1;


    if ( dateType == dtChar ) then
        val = data[ pos ]
        pos = pos + 1

    elseif ( dateType == dtShort ) then
        val = ut13.byteArrayToIntLE ( data, pos, pos+1 );
        --print ( "startPos:", pos, " ;endPos:", pos+1)
        pos = pos + 2

    elseif ( dateType == dtInt ) then
        val = ut13.byteArrayToIntLE ( data, pos, pos+3 );
        --print ( "startPos:", pos, " ;endPos:", pos+3)
        pos = pos + 4

    elseif ( dateType == dtFloat ) then
        val = ut13.byteArrayToFloatLE ( data, pos )
        pos = pos + 4

    elseif ( dateType == dtString ) then
        local len = ut13.byteArrayToIntLE ( data, pos, pos+3 )
        print ( "string len:", len )
        pos = pos + 4
        print ( "startPos:", pos, " ;endPos:", pos+3)
        val = ut13.byteArrayToString ( data, pos, pos+len-1)
        print ( "string:", val )
        pos = pos + len + 1

    elseif ( dateType == dtLong ) then
        val = ut13.byteArrayToIntLE ( data, pos, pos+7 );
        --print ( "startPos:", pos, " ;endPos:", pos+7)
        pos = pos + 8

    elseif ( dateType == dtVoid ) then

    end;

    return val, pos
end

local function parseValues ( data )
    local res = { }
    if ( not data ) then
        return res
    end
    if ( #data == 0 ) then
        return res
    end
    local pos = 1
    local counter = 1
    while ( pos < #data ) do
        res[counter], pos = readValue( data, pos );
        if ( pos == 0 ) then
            break;
        end;
        counter = counter + 1
    end
    return res
end

local function calculateCRC( crc, byte )
    crc = bxor( crc, band( byte, 0xFF ) );
    for j = 1, 8 do
        if ( band( crc, 0x0001 ) > 0 ) then
            crc = bxor( rshift( crc, 1 ), CRC_POLYNOM );
        else
            crc = rshift( crc, 1 );
        end
    end
    return crc;
end

local function addByteToBurst( burst, byte )
    table.insert( burst.data, #burst.data+1, byte );
    burst.crc = calculateCRC( burst.crc, byte );
end


local iFiscal = require "fiscal.ifiscal"

local piFiscal = iFiscal:new();
piFiscal.waitForHeaderTimeout = 7;

function piFiscal:getBurst ( ... )
    local dataBurst = { data = {}, crc = CRC_PRESET }

    local data = table.copy( ... );
    for i = 1, #data do
        addByteToBurst( dataBurst, data[i] );
        --self:log( ">> data: ", i, data[i] );
    end

    return table.copy( { headerMark }, ut13.intToByteArrayLE ( #data, 2 ), dataBurst.data, ut13.intToByteArrayLE ( dataBurst.crc, 2 ) );
end

function piFiscal:getErrorCodeDescription( errorCode )
    return errorCodesDescription[ errorCode ] or "Неизвестная ошибка";
end

function piFiscal:sendBurst( ... )
    local errorCode = nil

    if ( self.lastErrorCode >= 0xFE) then
        return self.lastErrorCode
    end
    
    if ( not self.client ) then
        errorCode = self:connect( )
        if errorCode ~= resOK then
            return errorCode
        end
    end

    local burst = self:getBurst( ... );

    local strBurst = ut13.byteArrayToString( burst );
    local resp;
    local answerBurst = { };
    local answerLen = 0;
    local answerCRC = 0;

    local res, res2, res3 = self.client:send( strBurst );
    local triesCount = 1;
    self:log( ">> ["..triesCount.."] "..ut13.byteArrayToHexDump( burst )..": ", res, res2, res3 );
    self:log( ">> data: ", strBurst );

    errorCode, answerBurst = self:readAnswer( self.client );

    return errorCode, answerBurst;
end

function piFiscal:readAnswer(client)
    local errorCode = nil;
    local answerReceived;
    local values = {}
    local header, _
    if ( self.client ) then
        self.client:settimeout( self.waitForHeaderTimeout );
        header, _, _ = string.byte(self.client:receive(1) or "");
        self.client:settimeout( self.ioTimeout );
        --self:log( "<<< ---- header: "..(header or "nil") );
    end;

    if not header then
        self:log( "<<< header: "..(header or "nil") );
        errorCode = 0xFE;   -- something wrong with data: header is missing (timeout)


    elseif ( header ~= headerMark ) then
        self:log( "<<< header: "..(header or "nil") );
        errorCode = 0xFB;   -- something wrong with data: header is wrong

    else
        local triesCount = 1;

        local loLength = self:receiveByte( triesCount );
        self:log( "<<< length(lo): ", loLength );
        local hiLength = self:receiveByte( triesCount );
        self:log( "<<< length(hi): ", hiLength );
        local length = bor( lshift( hiLength, 8 ), loLength );
        local sLength = ""..string.char( loLength, hiLength )
--      
--[[
        local sLength, _, _ = self.client:receive(2) or "";
        --local length = string.byte( sLength );
        self:log( "<<< sLength: ", sLength );
        self:log( "<<< sLength: ", ut13.stringToByteArray( sLength, 2 ) );
        self:log( "<<< sLength: ", ut13.byteArrayToInt( ut13.stringToByteArray( sLength, 2 ) ) );
        local length = ut13.byteArrayToInt( ut13.stringToByteArray( sLength, 2 ) );
        if (length == 0) then
            self:log( "<<< length(raw): "..(length or "nil") );
            return nil, nil, nil;
        end;

        length = length;
        --]]
        self:log( "<<< length: "..length );

        local bodyraw, _, _ = client:receive(length+2);
        self:log( "<<< bodyraw: ", bodyraw );

        --bodyraw = sLength..bodyraw;

        local body = ut13.stringToByteArray( bodyraw );


        local repBurst = { data = {}, crc = CRC_PRESET }

        for i = 1, #body-2 do
            addByteToBurst( repBurst, body[i] );
            --self:log( ">> data: ", i, body[i] );
        end

        local repCRC = bor( lshift( body[#body], 8 ), body[#body-1] )
        --self:log( ">> repCRC: ", repCRC );
        --self:log( ">> calcCRC: ", repBurst.crc );

        local answerData = repBurst.data;


        if (repCRC == repBurst.crc ) then
            self:log( "!!! BCC check is OK ("..ut13.intToHex( repCRC ) )

            values = parseValues( repBurst.data );
            if not errorCode then
                if ( #values > 0 ) then
                    errorCode = values[1];
                    if ( errorCode == 0xFF ) then
                        errorCode = 0xF0;
                    end
                else
                    errorCode = 0xFD;   -- something wrong with data: 1st two bytes always status
                end
            end

        else
            self:log( "!!! BCC check is FAILED: "..ut13.intToHex( repCRC ).." != "..ut13.intToHex( repBurst.crc ) )
            if not errorCode then
                errorCode = 0xFC;
            end;
        end

        self:log( "<<< body(raw): "..bodyraw );
        self:log( "<<< body: "..ut13.byteArrayToHexDump ( body ) );
        self:log( "<<< values: ", values );

        answerReceived = true;
    end;

    if ( answerReceived ) then
        self:log( "::ANSWER RECEIVED" )
    end

    if ( errorCode ) then

    elseif ( answerReceived ) then
        
    elseif self.client then
        errorCode = 0xFE;

    else
        errorCode = 0xFF;
    end;

    if ( errorCode ) then
        if (errorCode ~= resOK ) then
            self:log (errorCode);
            self:log( "Error found ("..string.format ( "%X", errorCode ).."):", self:getErrorCodeDescription( errorCode ) );
        end;
    end;

    if ( errorCode ) then
        self.lastErrorCode = errorCode;
    else
        self.lastErrorCode = 0;
    end;
    self.lastErrorDescription = self:getErrorCodeDescription( errorCode );

    return errorCode, values;
end



function piFiscal:connect( ... ) -- local
    local host = arg[1] or self.host
    --local port = arg[2] or self.port
    local port = defaultPort

    if ( port == 0 ) then
        port = defaultPort
    end

    self.port = port
    
    local errorCode = resOK

    local socket = require( "socket" )

    self:log( "----- connecting to "..tostring( port ).." on "..tostring( host ).." (piFiscal); devId: "..self.devId )
    --self.client = socket.connect( host, port )
    self.client = socket.tcp()
    self.client:settimeout( self.connectionTimeout )
    local res = self.client:connect( host, port )
    if res then

    --local ip, port = client:getsockname()
    --self:log( "IP Address:", ip )
    --self:log( "Port:", port )

    --if ( self.client ) then
        self.client:setoption("tcp-nodelay", true)
        self.client:settimeout( self.ioTimeout )

        local values

        local connected = self:isConnected()

        local triesCount = 2

        while ( triesCount > 0 ) do
            if not self.fiscal_port then
                self:log( "----- looking for fiscal printers" )

                errorCode, values = self:sendBurst( addChar( fc_SearchFiscalConnection ) )
                if ( errorCode == resOK ) then
                    local fpCount = values[2]
                    if ( fpCount == 0) then
                        self:log( "----- no fiscal printers found" )
                        errorCode = 0xF1
                        connected = nil

                    else
                        if ( fpCount > 8 ) then
                            self:log( "----- ahtung fiscal printers found too much: "..tostring(fpCount) )
                            fpCount = 8
                        end;
                        self:log( "----- fiscal printers found ("..tostring(fpCount).."):" )
                        for i = 1, fpCount do
                            local __i = (i - 1) * 3 + 1 + 2
                            self.fiscal_type = values[__i]      -- model
                            self.fiscal_port = values[__i+1]    -- port
                            self.fiscal_name = values[__i+2]    -- reg. no

                            self:log( "   model:", self.fiscal_type )
                            self:log( "   port:", self.fiscal_port )
                            self:log( "   reg. no:", self.fiscal_name )
                        end
                    end
                else
                    connected = nil -- 20180212
                end
            end

            if ( self.fiscal_port ) then
                self:log( "----- opening connection to fiscal printer on ", self.fiscal_port )
                errorCode, values = self:sendBurst( addChar( fc_OpenFiscalConnection ), addString( self.fiscal_port ) )
                if ( errorCode ~= resOK ) then
                    self:log( "----- error opening fiscal connection to printer" )
                    errorCode = 0xF2

                    self.fiscal_type = nil  -- model
                    self.fiscal_port = nil  -- port
                    self.fiscal_name = nil  -- reg. no

                    connected = nil

                else
                    self:log( "----- successful connection to fiscal printer on ", self.fiscal_port )
                    connected = true    -- 20180212
                    break
                end
            end

            triesCount = triesCount - 1
        end

        if not connected then
            self.client = nil
        end

    else

        errorCode  = 0xFF

        self.client = nil
    end

    self.lastErrorCode = errorCode
    self.lastErrorDescription = self:getErrorCodeDescription( self.lastErrorCode )

    return errorCode
end

function piFiscal:disconnect( ... ) -- local
    if ( arg[1] ) then
        if ( self.keepAliveConnection == true ) then
            return;
        end;
    end;
    if ( self.client ) then
        self:log( "----- close connection to fiscal printer" );
        local errorCode, values = self:sendBurst( addChar( fc_CloseFiscalConnection ) );
        self:log( "----- disconnecting port "..tostring( self.port ).." on "..tostring( self.host ).." (piFiscal); devId: "..self.devId )
        self.client:close();
    end;
    self.client = nil;
end

function piFiscal:isConnected( ... )
    return ( not ( self.client == nil ) );
end



function piFiscal:printLine( ... )
    local text = arg[1] or "";
    --local encodedText = Utf8ToAnsi( text );   -- getBurst will code the string
    local encodedText = text;
    if (#encodedText > 75) then
        encodedText = encodedText:sub(1, 75);
    end
    self:log( "\n=== printLine: "..encodedText );
    return self:sendBurst( addChar( fc_PrintText), addString( encodedText ) );
end



function piFiscal:cancelChequeInternal( ... )
    self:log( "\n=== cancelCheque" );
    return self:sendBurst( addChar( fc_PrintRecVoid ) );
end

function piFiscal:cancelCheque( ... )
    local res = self:cancelChequeInternal( ... );

    self:disconnect( true );

    return res;
end

function piFiscal:cancelCurrentOperation( ... )
    local res
    
    if ( self.lastErrorCode >= 0xFE) then
        return self.lastErrorCode
    end

    if ( not self.client ) then
        res = self:connect( )
        if res ~= resOK then
            return res
        end
    end

    local triesCount = 10
    while triesCount > 0 do
        res = self:cancelChequeInternal()
        if res == resOK then
            return resOK
        end
        triesCount = triesCount - 1
    end

    return res
end


function piFiscal:openCheque( ... )    -- 0 - sell; 1 - return
    local oper = arg[1] or 0;
    local cashier = "";
    self:log( "\n=== openCheque" );
    return self:sendBurst( addChar( fc_BeginFiscalReceipt ), addChar( oper ), addString( cashier ) );
end

function piFiscal:closeCheque( ... )
    local sum = arg[2] or 0;
    local pmt_type = arg[1] or 0;
    local payType;

    --[[
            if (userProfile.fsct_type==0) then --Мини фп6
                if orderHeader.pmt_type==1 then
                    paym_type = 0
                else
                    paym_type = 3
                end
            elseif (userProfile.fsct_type==1) then --Мини фп
                if orderHeader.pmt_type==1 then
                    paym_type = 2
                else
                    paym_type = 0
                end
            elseif (userProfile.fsct_type==2) then  --Мини фп54
                if orderHeader.pmt_type==1 then
                    paym_type = 3
                else
                    paym_type = 0
                end
            else 
                if userProfile.fsct_type==1 then
                    paym_type = 2
                else
                    paym_type = 0
                end
            end
    --]]
    --  pmt_type integer DEFAULT 0, -- 0-нал,1-плат карта,2 - банк, 3 - кредит, 4 - нал*, 5 - закрытие депозита, 6 - Yodo, 7 - Fondy
    --[[
        "MINI FP54";        2
        "MINI FP6";         0
        "Экселлио FPP-350"; 0
        "Экселлио FP-550es";0
        "MINI FP";          1
        "ФР-7";             2
        "Атол+Raspberry";   0

        "MGN 707";          3
        "Атол v2.4 (сетевой интерфейс)";    4
        "Атол v3.0 (сетевой интерфейс)";    5
        "Датекс Криптон v.4.x (local)";     7
        "Датекс Криптон v.4.x (internet)";  8
        "piFiscal mp (test)";   9
    --]]
    if self.fiscal_type == fm_miniFP then   --1
        if pmt_type == 1 then
            payType = 2;    -- card
        else
            payType = 0;    -- cash
        end;

    elseif self.fiscal_type == fm_miniFP54 then --2
        if pmt_type == 1 then
            payType = 3;    -- card -- in smarttouch we use 2
        else
            payType = 0;    -- cash
        end;

    elseif self.fiscal_type == fm_FR7 then  --2
        if pmt_type == 1 then
            payType = 3;    -- card
        else
            payType = 0;    -- cash
        end;

    -- так изначально сложилось, что по-умолчанию имеем такие параметры
    -- поэтому не будем нарушать дурную традицию :)
    else        -- if self.fiscal_type == fm_miniFP6 then       --0
        if pmt_type == 1 then
            payType = 0;    -- card
        else
            payType = 3;    -- cash
        end;

    end;

    self:log( "\n=== closeCheque" );
    local res = self:sendBurst( addChar( fc_PrintRecTotal ), addFloat( sum ), addChar( payType ) );
    return res;
end



function piFiscal:registerItem( params ) -- local

    local amount = params.amount or 1;
    local price = params.price or 0;
    local discount = params.discount or 0;
    local code = params.code or 0;
    local name = params.name or "";
    local taxGroup = (params.taxGroup or 0) % 10;
    local section = params.section or 0;
    if ( not params.section ) then
        section = math.floor( params.taxGroup / 10 );
    end;
    --self:log( "----------------TAX GROUP: "..taxGroup)
    --self:log( "----------------SECTION: "..section)

    name = string.gsub(name,"і","i")
    name = string.gsub(name,"ї","i")
    name = string.gsub(name,"№","N")
    name = string.gsub(name,",","")
    name = string.gsub(name,"\\","")
    name = string.gsub(name,"/","")
    if utf8replace then
        name = utf8replace(name, {["і"]="i",["ї"]="i",["№"]="N",[","]=" ",["/"]=" "}) 
    end

    self:log( "\n=== registerItem (code: ", code, 
                                "; name: ", name, 
                                "; amount: ", amount,
                                "; price: ", price,
                                "; discount: ", discount,
                                "; taxGroup: ", taxGroup,
                                "; section: ", section,
                        ")" );

    res = self:sendBurst( addChar ( fc_PrintRecItem ),
                            addString ( name ),
                            addLong ( 1*code ),
                            addFloat ( 1.*price ),
                            addFloat ( 1.*amount ),
                            addInt ( 1*taxGroup ),
                            addFloat ( -1.*discount )
                        );
    return res;
end



function piFiscal:printCheque( ... )
    self:log( "\n=== printCheque" );

    local data = arg[1];
    local isReturn = arg[2] or false;
    if not data then
        return nil;
    end
    local payType = data.pmt_type or 0;  --pmt_type: 0 - cash, 1 - card

    local res = resOK;

    if ( res == resOK ) then
        res = self:openCheque( isReturn and 1 or 0 );
    end;

    local disc_total = 0;

    if ( res == resOK ) then
        for k, v in pairs(data.items) do
            if ( type( v.discount ) == "number" ) then
                disc_total = disc_total + v.discount;
            end;
            res = self:registerItem( { code=v.code, name=v.name, price=v.price, discount=v.discount, amount=v.amount, taxGroup=v.tax } );
            if ( res ~= resOK ) then
                self:cancelChequeInternal();
                break;
            end;
        end;

        if ( res == resOK ) then    -- it seems it would work for mini_fp only :)
            res = self:sendBurst( addChar( fc_PrintRecSubtotalAdjustment ), addFloat( -1*disc_total ) );
        end;

        if ( res == resOK ) then
            res = self:closeCheque( payType );
        end;

        if ( res ~= resOK ) then
            self:cancelChequeInternal();
        end;
    end;

    self:disconnect( true );

    return res;
end


function piFiscal:printTestCheque( ... )
    self:log( "\n=== printTestCheque" );
    
    local isReturn = arg[1] or false
    local payType = arg[2] or 0  --pmt_type: 0 - cash, 1 - card
    local res = resOK;

    if ( res == resOK ) then
        res = self:openCheque( isReturn and 1 or 0 );
        if ( res == resOK ) then
            --res = self:registerItem( { name="Тест5678901234567890123456789012345678901234567890", price=0.01, amount=1, discount=-0.01, taxGroup=0 } );
            res = self:registerItem( { code=12343, name="Вафлi Артек 200гр", price=11.8, amount=2, discount=1.50, taxGroup=4 } );
            if ( res == resOK ) then
                --res = self:registerItem( { name="Оболонь Темное 0.5", price=14.50, discount=1.10, amount=1, taxGroup=25 } );
            end;
            if ( res == resOK ) then
                --res = self:registerItem( { name="Батон", price=7.00, amount=1, taxGroup=36 } );
            end;

            if ( res == resOK ) then
                res = self:closeCheque( payType );
            end;

            if ( res ~= resOK ) then
                self:cancelChequeInternal();
            end;
        end;
    end;

    self:disconnect( true );

    return res;
end



function piFiscal:printXReport()
    self:log( "\n=== printXReport" );
    local res = self:sendBurst( addChar( fc_PrintXReport ), addInt( 0 ) );
    self:disconnect( true );
    return res;
end

function piFiscal:printZReport()
    self:log( "\n=== printZReport" );
    local res = self:sendBurst( addChar( fc_PrintZReport ), addInt( 0 ) );
    self:disconnect( true );
    return res;
end



function piFiscal:cash( sum )
    --local res = self:cancelCurrentOperation();
    local res = resOK;
    local strSum = string.format( "%.2f", sum );
    self:log( "=== cash: "..strSum );
    return self:sendBurst( addChar( fc_PrintRecCash ), addFloat( sum ) );
end

function piFiscal:cashIn( sum )
    self:log( "\n=== cashIn:", sum );
    local res = self:cash( sum );
    self:disconnect( true );
    return res;
end

function piFiscal:cashOut( sum )
    self:log( "\n=== cashOut:", sum );
    local res = self:cash( -sum );
    self:disconnect( true );
    return res;
end



function piFiscal:printChequeCopy()
    self:log( "\n=== printChequeCopy" );
    return 0;
end

function piFiscal:printEmptyCheque()
    self:log( "\n=== printEmptyCheque" );
    
    local res = self:openCheque( );
    if ( res == resOK ) then
        res = self:closeCheque();
    end;

    if ( res ~= resOK ) then
        self:cancelChequeInternal();
    end;

    self:disconnect( true );

    return res;
end



function  piFiscal:getSerial( ... )
    self:log( "\n=== getSerial" )
    return 0
end



function piFiscal:new( ... )
    newObj = { host=arg[1], port=arg[2] or defaultPort }
    -- set up newObj
    self.__index = self
    return setmetatable(newObj, self)
end

return piFiscal