--- 
-- @author Valery Zakharov <va13ak@gmail.com>
-- @date 16.12.2016 15:52:04

local bit = require "plugin.bit"

local bnot = bit.bnot
local band, bor, bxor = bit.band, bit.bor, bit.bxor
local lshift, rshift, rol = bit.lshift, bit.rshift, bit.rol

-- http://www.herongyang.com/Unicode/UTF-8-UTF-8-Encoding-Algorithm.html
local function utf8char( c )
	local b1, b2, b3, b4
	if (c < 0x80) then
		b1 = bor( band( rshift(c,  0), 0x7F), 0x00);
	elseif (c < 0x0800) then
		b1 = bor( band( rshift(c,  6), 0x1F), 0xC0);
		b2 = bor( band( rshift(c,  0), 0x3F), 0x80);
	elseif (c < 0x010000) then
		b1 = bor( band( rshift(c, 12), 0x0F), 0xE0);
		b2 = bor( band( rshift(c,  6), 0x3F), 0x80);
		b3 = bor( band( rshift(c,  0), 0x3F), 0x80);
	elseif (c < 0x110000) then
		b2 = bor( band( rshift(c, 18), 0x07), 0xF0);
		b2 = bor( band( rshift(c, 12), 0x3F), 0x80);
		b3 = bor( band( rshift(c,  6), 0x3F), 0x80);
		b4 = bor( band( rshift(c,  0), 0x3F), 0x80);
	end
	--print(b1, b2, b3, b4)
	return ""..string.char(b1)..(b2 and string.char(b2) or "")..(b3 and string.char(b3) or "")..(b4 and string.char(b4) or "")
end

-- http://lua-users.org/wiki/LuaUnicode
local function utf8to32( utf8str )
	assert(type(utf8str) == "string")
	local res, seq, val = {}, 0, nil
	for i = 1, #utf8str do
		local c = string.byte(utf8str, i)
		if seq == 0 then
			table.insert(res, val)
			seq = c < 0x80 and 1 or c < 0xE0 and 2 or c < 0xF0 and 3 or
			      c < 0xF8 and 4 or --c < 0xFC and 5 or c < 0xFE and 6 or
				  error("invalid UTF-8 character sequence")
			val = band(c, 2^(8-seq) - 1)
		else
			val = bor(lshift(val, 6), band(c, 0x3F))
		end
		seq = seq - 1
	end
	table.insert(res, val)
	table.insert(res, 0)
	return res
end

local ansi_decode = {
  [128]='\208\130',[129]='\208\131',[130]='\226\128\154',[131]='\209\147',[132]='\226\128\158',[133]='\226\128\166',
  [134]='\226\128\160',[135]='\226\128\161',[136]='\226\130\172',[137]='\226\128\176',[138]='\208\137',[139]='\226\128\185',
  [140]='\208\138',[141]='\208\140',[142]='\208\139',[143]='\208\143',[144]='\209\146',[145]='\226\128\152',
  [146]='\226\128\153',[147]='\226\128\156',[148]='\226\128\157',[149]='\226\128\162',[150]='\226\128\147',[151]='\226\128\148',
  [152]='\194\152',[153]='\226\132\162',[154]='\209\153',[155]='\226\128\186',[156]='\209\154',[157]='\209\156',
  [158]='\209\155',[159]='\209\159',[160]='\194\160',[161]='\209\142',[162]='\209\158',[163]='\208\136',
  [164]='\194\164',[165]='\210\144',[166]='\194\166',[167]='\194\167',[168]='\208\129',[169]='\194\169',
  [170]='\208\132',[171]='\194\171',[172]='\194\172',[173]='\194\173',[174]='\194\174',[175]='\208\135',
  [176]='\194\176',[177]='\194\177',[178]='\208\134',[179]='\209\150',[180]='\210\145',[181]='\194\181',
  [182]='\194\182',[183]='\194\183',[184]='\209\145',[185]='\226\132\150',[186]='\209\148',[187]='\194\187',
  [188]='\209\152',[189]='\208\133',[190]='\209\149',[191]='\209\151'
}

local utf8_decode = {
  [128]={[147]='\150',[148]='\151',[152]='\145',[153]='\146',[154]='\130',[156]='\147',[157]='\148',[158]='\132',[160]='\134',[161]='\135',[162]='\149',[166]='\133',[176]='\137',[185]='\139',[186]='\155'},
  [130]={[172]='\136'},
  [132]={[150]='\185',[162]='\153'},
  [194]={[152]='\152',[160]='\160',[164]='\164',[166]='\166',[167]='\167',[169]='\169',[171]='\171',[172]='\172',[173]='\173',[174]='\174',[176]='\176',[177]='\177',[181]='\181',[182]='\182',[183]='\183',[187]='\187'},
  [208]={[129]='\168',[130]='\128',[131]='\129',[132]='\170',[133]='\189',[134]='\178',[135]='\175',[136]='\163',[137]='\138',[138]='\140',[139]='\142',[140]='\141',[143]='\143',[144]='\192',[145]='\193',[146]='\194',[147]='\195',[148]='\196',
    [149]='\197',[150]='\198',[151]='\199',[152]='\200',[153]='\201',[154]='\202',[155]='\203',[156]='\204',[157]='\205',[158]='\206',[159]='\207',[160]='\208',[161]='\209',[162]='\210',[163]='\211',[164]='\212',[165]='\213',[166]='\214',
    [167]='\215',[168]='\216',[169]='\217',[170]='\218',[171]='\219',[172]='\220',[173]='\221',[174]='\222',[175]='\223',[176]='\224',[177]='\225',[178]='\226',[179]='\227',[180]='\228',[181]='\229',[182]='\230',[183]='\231',[184]='\232',
    [185]='\233',[186]='\234',[187]='\235',[188]='\236',[189]='\237',[190]='\238',[191]='\239'},
  [209]={[128]='\240',[129]='\241',[130]='\242',[131]='\243',[132]='\244',[133]='\245',[134]='\246',[135]='\247',[136]='\248',[137]='\249',[138]='\250',[139]='\251',[140]='\252',[141]='\253',[142]='\254',[143]='\255',[144]='\161',[145]='\184',
    [146]='\144',[147]='\131',[148]='\186',[149]='\190',[150]='\179',[151]='\191',[152]='\188',[153]='\154',[154]='\156',[155]='\158',[156]='\157',[158]='\162',[159]='\159'},[210]={[144]='\165',[145]='\180'}
}

local nmdc = {
  [36] = '$',
  [124] = '|'
}

local function AnsiToUtf8(s)
  local r, b = ''
  for i = 1, s and s:len() or 0 do
    b = s:byte(i)
    if b < 128 then
      r = r..string.char(b)
    else
      if b > 239 then
        r = r..'\209'..string.char(b - 112)
      elseif b > 191 then
        r = r..'\208'..string.char(b - 48)
      elseif ansi_decode[b] then
        r = r..ansi_decode[b]
      else
        r = r..'_'
      end
    end
  end
  return r
end

local function Utf8ToAnsi(s)
  local a, j, r, b = 0, 0, ''
  for i = 1, s and s:len() or 0 do
    b = s:byte(i)
    if b < 128 then
      if nmdc[b] then
        r = r..nmdc[b]
      else
        r = r..string.char(b)
      end
    elseif a == 2 then
      a, j = a - 1, b
    elseif a == 1 then
      a, r = a - 1, r..utf8_decode[j][b]
    elseif b == 226 then
      a = 2
    elseif b == 194 or b == 208 or b == 209 or b == 210 then
      j, a = b, 1
    else
      r = r..'_'
    end
  end
  return r
end

-- GOT TABLE AT http://scite-ru.bitbucket.org/pack/tools/CodePage.lua
-- TO DO: add transcode functions for it
local charset1251to866 =
{
  [168]=240, --Ё
  [184]=241, --ё
  [185]=252, --№
  [192]=128,[193]=129,[194]=130,[195]=131,[196]=132,
  [197]=133,[198]=134,[199]=135,[200]=136,[201]=137,
  [202]=138,[203]=139,[204]=140,[205]=141,[206]=142,
  [207]=143,[208]=144,[209]=145,[210]=146,[211]=147,
  [212]=148,[213]=149,[214]=150,[215]=151,[216]=152,
  [217]=153,[218]=154,[219]=155,[220]=156,[221]=157,
  [222]=158,[223]=159,[224]=160,[225]=161,[226]=162,
  [227]=163,[228]=164,[229]=165,[230]=166,[231]=167,
  [232]=168,[233]=169,[234]=170,[235]=171,[236]=172,
  [237]=173,[238]=174,[239]=175,[240]=224,[241]=225,
  [242]=226,[243]=227,[244]=228,[245]=229,[246]=230,
  [247]=231,[248]=232,[249]=233,[250]=234,[251]=235,
  [252]=236,[253]=237,[254]=238,[255]=239
}

local function AnsiToDos(s)
  local r = "";
  for i = 1, s and s:len() or 0 do
    b = s:byte(i)
    c = charset1251to866[b]
    if c then
      r = r..string.char(c)
    else
      r = r..string.char(b)
    end
  end
  return r
end



local function getEmptyArray ( sizeOfArray )
  local array = { }
  for i = 1, sizeOfArray do
    array[ i ] = 0
  end
  return array
end

local function stringToByteArray ( str, ... )
  local strLen = str and str:len() or 0
  local defLen = arg[ 1 ] or strLen
  if ( defLen < 1 ) then return { } end
  local byteArray = { str:byte( 1, ( defLen < strLen ) and defLen or strLen ) }
  if ( defLen > strLen ) then
    for i = #byteArray + 1, defLen do
      byteArray[ i ] = 0
    end
  end
  return byteArray
end

local function intToByteArrayLE ( num, ... )  -- little-endian
  if ( arg[ 1 ] and ( arg[ 1 ] < 1 ) ) then return { } end
  local byteArray = { }
  local i = 1
  repeat
    byteArray[ i ] = band( num, 0xFF )
    num = rshift( num, 8 )
    i = i + 1
    if ( arg[ 1 ] and ( i > arg[ 1 ] ) ) then return byteArray end
  until ( num == 0 )
  if ( arg[ 1 ] and ( arg[ 1 ] > #byteArray ) ) then
    for i = #byteArray + 1, arg[ 1 ] do
      byteArray[ i ] = 0
    end
  end
  return byteArray
end

local function intToByteArray ( num, ... )  -- big-endian
  if ( arg[ 1 ] and ( arg[ 1 ] < 1 ) ) then return { } end
  local byteArray = { }
  local i = 1
  repeat
    table.insert( byteArray, 1, band( num, 0xFF ) )
    num = rshift( num, 8 )
    i = i + 1
    if ( arg[ 1 ] and ( i > arg[ 1 ] ) ) then return byteArray end
  until ( num == 0 )
  if ( arg[ 1 ] and ( arg[ 1 ] > #byteArray ) ) then
    for i = #byteArray + 1, arg[ 1 ] do
      table.insert( byteArray, 1, 0 )
    end
  end
  return byteArray
end

local function byteArrayToString ( byteArray, ... )
  local startPos = arg[1] and ( ( ( arg[1] - 1 ) % #byteArray) + 1) or 1;
  local endPos = arg[2] and ( ( ( arg[2] - 1 ) % #byteArray) + 1) or #byteArray;
  local str = string.char( unpack( byteArray ) );
  return str:sub( startPos, endPos );
end

local function byteArrayToInt ( byteArray, ... )  -- big-endian
  local startPos = arg[1] and ( ( ( arg[1] - 1 ) % #byteArray) + 1) or 1;
  local endPos = arg[2] and ( ( ( arg[2] - 1 ) % #byteArray) + 1) or #byteArray;
  local int = 0;
  for i = startPos, endPos do
    if ( byteArray[i] ) then
      if ( i > startPos ) then
        int = lshift( int, 8 );
      end;
      int = bor( int, byteArray[i] );
    end;
  end;
  return int;
end

local function byteArrayToIntLE ( byteArray, ... )  -- little-endian
  local startPos = arg[1] and ( ( ( arg[1] - 1 ) % #byteArray) + 1) or 1;
  local endPos = arg[2] and ( ( ( arg[2] - 1 ) % #byteArray) + 1) or #byteArray;
  local int = 0;
  local ind;
  for i = startPos, endPos do
    ind = startPos + endPos - i;
    if ( byteArray[ind] ) then
      if ( i > startPos ) then
        int = lshift( int, 8 );
      end;
      int = bor( int, byteArray[ind] );
    end;
  end;
  return int;
end

local function stringToHexDump ( str )
    if ( str ) then
        str = string.gsub( str, "(.)",
              function ( c ) return string.format ( "#%02X", string.byte( c ) ) end )
    else
        return "nil"
    end
    return str
end

local function intToHex( int )
  return string.format ( "%X", int );
end

local function byteArrayToHexDump ( byteArray, ... )
  return stringToHexDump( byteArrayToString( byteArray, ... ) )
end


local function intToBCDByteArray( val, ... )
    local res = { };
    local size = arg[1] and arg[1]*2 or string.len( val );
    local size = size + size % 2;
    local str = string.format( "%0"..size.."d", val );
    local pos = 1;
    while (pos < size) do
        table.insert( res, #res+1, tonumber( str:sub( pos, pos+1 ), 16) );
        pos = pos + 2;
    end;
    return res;
    --return ut13.intToByteArray( tonumber( val, 16 ) );
    --[[
    atol_bcd _res;
    int ii;
    for (ii = sizeof (_res.val) - 1; ii >= 0; ii--) {
        _res.val[ii] = val % 10;
        val /= 10;
        _res.val[ii] |= val % 10 << 4;
        val /= 10;
    }
    return _res;
    --]]
end

local function BCDByteArrayToInt( byteArray, ... )
  local startPos = arg[1] and ( ( ( arg[1] - 1 ) % #byteArray) + 1) or 1;
  local endPos = arg[2] and ( ( ( arg[2] - 1 ) % #byteArray) + 1) or #byteArray;
  local int = 0;
  for i = startPos, endPos do
    if ( byteArray[i] ) then
      int = int + tonumber( string.format( "%2X", byteArray[i] ), 10 ) * 10 ^ ( ( endPos - i ) * 2 );
    end;
  end;
  return int;
end

local function loNybble( byte )
    return band( byte, 0x0F );
end

local function hiNybble( byte )
    return band( rshift( byte, 4 ), 0x0F );
end

local function getLocalIP()
  local socket = require("socket")
  local mySocket = socket.udp() --Create a UDP socket like normal
  --This is the weird part, we need to set the peer for some reason
  mySocket:setpeername("192.168.1.1", 0);
  --I believe this binds the socket
  --Then we can obtain the correct ip address and port
  local myDevicesIpAddress, somePortChosenByTheOS = mySocket:getsockname()-- returns IP and Port 

  return myDevicesIpAddress;
end

-- taken from https://stackoverflow.com/questions/14416734/lua-packing-ieee754-single-precision-floating-point-numbers
-- with some modifications
--local function packIEEE754(number)
local function floatToByteArray(number)
    if number == 0 then
        --return string.char(0x00, 0x00, 0x00, 0x00)
        return { 0x00, 0x00, 0x00, 0x00 }
    elseif number ~= number then
        --return string.char(0xFF, 0xFF, 0xFF, 0xFF)
        return { 0xFF, 0xFF, 0xFF, 0xFF }
    else
        local sign = 0x00
        if number < 0 then
            sign = 0x80
            number = -number
        end
        local mantissa, exponent = math.frexp(number)
        exponent = exponent + 0x7F
        if exponent <= 0 then
            mantissa = math.ldexp(mantissa, exponent - 1)
            exponent = 0
        elseif exponent > 0 then
            if exponent >= 0xFF then
                --return string.char(sign + 0x7F, 0x80, 0x00, 0x00)
                return { sign + 0x7F, 0x80, 0x00, 0x00 }
            elseif exponent == 1 then
                exponent = 0
            else
                mantissa = mantissa * 2 - 1
                exponent = exponent - 1
            end
        end
        mantissa = math.floor(math.ldexp(mantissa, 23) + 0.5)
        --[[
        return string.char(
                sign + math.floor(exponent / 2),
                (exponent % 2) * 0x80 + math.floor(mantissa / 0x10000),
                math.floor(mantissa / 0x100) % 0x100,
                mantissa % 0x100)
        --]]
        return { sign + math.floor(exponent / 2),
                (exponent % 2) * 0x80 + math.floor(mantissa / 0x10000),
                math.floor(mantissa / 0x100) % 0x100,
                mantissa % 0x100 }
    end
end

local function floatToByteArrayLE(number)
  local res = floatToByteArray( number )
  return { res[4], res[3], res[2], res[1] }
end


-- taken from https://stackoverflow.com/questions/14416734/lua-packing-ieee754-single-precision-floating-point-numbers
-- with some modifications
--local function unpackIEEE754(packed, ...)
local function byteArrayToFloat(packed, ...)
    --local b1, b2, b3, b4 = string.byte(packed, 1, 4)
    local pos = arg[1] or 1;
    local b1, b2, b3, b4 = packed[pos], packed[pos+1], packed[pos+2], packed[pos+3]
    local exponent = (b1 % 0x80) * 0x02 + math.floor(b2 / 0x80)
    local mantissa = math.ldexp(((b2 % 0x80) * 0x100 + b3) * 0x100 + b4, -23)
    if exponent == 0xFF then
        if mantissa > 0 then
            return 0 / 0
        else
            mantissa = math.huge
            exponent = 0x7F
        end
    elseif exponent > 0 then
        mantissa = mantissa + 1
    else
        exponent = exponent + 1
    end
    if b1 >= 0x80 then
        mantissa = -mantissa
    end
    return math.ldexp(mantissa, exponent - 0x7F)
end

local function byteArrayToFloatLE(packed, ...)
    local pos = arg[1] or 1;
    return byteArrayToFloat( { packed[pos+3], packed[pos+2], packed[pos+1], packed[pos] } )
end

-- also interesting on pack/unpack IEEE754:
-- doubles - http://lua-users.org/lists/lua-l/2015-03/msg00163.html
-- https://stackoverflow.com/questions/18886447/convert-signed-ieee-754-float-to-hexadecimal-representation
-- https://github.com/fperrad/lua-MessagePack/blob/master/src/MessagePack.lua#L320
-- https://github.com/dmccuskey/DMC-Corona-Library/blob/master/dmc_corona/lua_bytearray.lua
-- http://www.inf.puc-rio.br/~roberto/struct/
-- 




return {
  AnsiToUtf8 = AnsiToUtf8,
  Utf8ToAnsi = Utf8ToAnsi,
  AnsiToDos = AnsiToDos,
  utf8char = utf8char,
  utf8to32 = utf8to32,

  getEmptyArray = getEmptyArray,

  stringToByteArray = stringToByteArray,
  byteArrayToString = byteArrayToString,

  intToByteArray = intToByteArray,
  byteArrayToInt = byteArrayToInt,
  intToByteArrayLE = intToByteArrayLE,
  byteArrayToIntLE = byteArrayToIntLE,

  floatToByteArray = floatToByteArray,
  byteArrayToFloat = byteArrayToFloat,
  floatToByteArrayLE = floatToByteArrayLE,
  byteArrayToFloatLE = byteArrayToFloatLE,

  stringToHexDump = stringToHexDump,
  byteArrayToHexDump = byteArrayToHexDump,

  intToHex = intToHex,

  intToBCDByteArray = intToBCDByteArray,
  BCDByteArrayToInt = BCDByteArrayToInt,

  loNybble = loNybble,
  hiNybble = hiNybble,

  getLocalIP = getLocalIP
}
