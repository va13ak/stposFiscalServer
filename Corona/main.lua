--- 
-- @author Valery Zakharov <va13ak@gmail.com>
-- @date 2016-12-19 17:11:01

require("fiscal.server");
local ftp = require("ftp");
require("sensitive")

--local userProfile = { fsct_type = 5, pos_fsc_ipaddress="127.0.0.1", pos_fsc_port=sensitive.atolPort }
--local userProfile = { fsct_type = 5, pos_fsc_ipaddress="192.168.1.54", pos_fsc_port=sensitive.atolPort }
--local userProfile = { fsct_type = 8, pos_fsc_ipaddress=sensitive.kryptonId1.."@"..sensitive.kryptonRemoteHost, pos_fsc_port=sensitive.kryptonPort }
--local userProfile = { fsct_type = 8, pos_fsc_ipaddress=sensitive.kryptonId2.."@"..sensitive.kryptonRemoteHost, pos_fsc_port=sensitive.kryptonPort }
--local userProfile = { fsct_type = 9, pos_fsc_ipaddress="10.10.10.144", pos_fsc_port=0 }
--local userProfile = { fsct_type = 10 }	-- mspos
local userProfile = { fsct_type = 12 }	-- itgdevman

local ut13 = require "fiscal.utils13"
local btn13 = require "buttons13"

local curDev;

local logFile, logFileOpenErrorString;
local logPath;
local logName;

local prevButton;

local printBuffer = { lines = {}, firstIndex = 1, lastIndex = 0, tempIndex = 0 };

local function addPrintLine( ... )
	local stringForPrint = ""..os.date( "%H:%M:%S", os.time() )..": ";
	for i, v in ipairs(arg) do
		if stringForPrint ~= "" then
			stringForPrint = stringForPrint .. " ";
		end;
		stringForPrint = stringForPrint .. tostring( v );
	end;

	if logFile then
		logFile:write( stringForPrint .. "\n" );
	end;

	printBuffer.tempIndex = printBuffer.tempIndex + 1;
	printBuffer.lines[printBuffer.tempIndex] = stringForPrint;
	printBuffer.lastIndex = printBuffer.tempIndex;
end

local function addLogLine( ... )
	if logFile then
		logFile:write( stringForPrint .. "\n" );
	end;
end

local function createLogFile( ... )
	logName = tostring( system.getInfo( "deviceID" ) ) .. "_" .. os.date( "%y%m%d_%H%M%S", os.time()) .. ".log";
	logPath = system.pathForFile( logName, system.DocumentsDirectory );
	logFile, logFileOpenErrorString = io.open( logPath, "w" );
	if logFile then
		logFile:write( "--------------------------------------------------------------------------------\n" );
		local platform = tostring( system.getInfo( "platform" ) );
		logFile:write( "appName: "..tostring( system.getInfo( "appName" ) ).."\n" );
		logFile:write( "appVersionString: "..tostring( system.getInfo( "appVersionString" ) ).."\n" );
		logFile:write( "architectureInfo: "..tostring( system.getInfo( "architectureInfo" ) ).."\n" );
		logFile:write( "build: "..tostring( system.getInfo( "build" ) ).."\n" );
		logFile:write( "deviceID: "..tostring( system.getInfo( "deviceID" ) ).."\n" );
		logFile:write( "environment: "..tostring( system.getInfo( "environment" ) ).."\n" );
		logFile:write( "model: "..tostring( system.getInfo( "model" ) ).."\n" );
		logFile:write( "name: "..tostring( system.getInfo( "name" ) ).."\n" );
		logFile:write( "platform: "..platform.."\n" );
		logFile:write( "platformVersion: "..tostring( system.getInfo( "platformVersion" ) ).."\n" );
		logFile:write( "environment: "..tostring( system.getInfo( "environment" ) ).."\n" );
		if platform == "android" then
			logFile:write( "androidApiLevel: "..tostring( system.getInfo( "androidApiLevel" ) ).."\n" );
			logFile:write( "androidAppVersionCode: "..tostring( system.getInfo( "androidAppVersionCode" ) ).."\n" );
			logFile:write( "androidAppPackageName: "..tostring( system.getInfo( "androidAppPackageName" ) ).."\n" );

		elseif platform == "ios" then
			logFile:write( "iosIdentifierForVendor: "..tostring( system.getInfo( "iosIdentifierForVendor" ) ).."\n" );

		end;
		logFile:write( "--------------------------------------------------------------------------------\n" );

	else
		print( "ERROR:", "creating log file (", logFileOpenErrorString, ")" );
	end;
end

local function saveLogFile( ... )
	if logFile then
		logFile:close();
	end;
	logFile = nil;
	logFile, logFileOpenErrorString = io.open( logPath, "a" );
	if not logFile then
		print( "ERROR:", "appending log file (", logFileOpenErrorString, ")" );
	end;
end

local function uploadLogToFTP( ... )
	if logFile then
		logFile:close();
		logFile = nil;
	else
		return;
	end;

	local connection = ftp.newConnection{ 
					timeout = sensitive.ftp.timeout,
	                host = sensitive.ftp.host, 
	                user = sensitive.ftp.user, 
	                password = sensitive.ftp.password, 
	                port = sensitive.ftp.port

	        }
	 
	local onUploadSuccess = function(event)
	        print("File uploaded to " .. event.path)
	end
	 
	local onDownloadSuccess = function(event)
	    print("File downloaded to " .. event.path);
	end
	 
	local onAppendSuccess = function(event)
	    print("File appended");
	end
	 
	local onError = function(event)
		if event.error ~= "closed" then
	        print("Error: " .. event.error);
	    end;
	end
	 
	connection:upload{
	        localFile = logPath,
	        remoteFile =  "/debug/fiscal/server/"..logName,
	        onSuccess = onUploadSuccess,
	        onError = onError
	}
	--[[
	connection:download{
	        remoteFile = "/public_html/image.jpg",
	        localFile = "image2.jpg",
	        onSuccess = onDownloadSuccess,
	        onError = onError
	}
	        
	connection:append{
	        localFile = system.pathForFile("todaysLog.txt", system.ResourcesDirectory),
	        remoteFile = "/public_html/completeLog.txt",
	        onSuccess = onAppendSuccess,
	        onError = onError
	}
	--]]
end

local function sendEmail()
	if logFile then
		logFile:close();
		logFile = nil;
	else
		return;
	end;

	-- Get device info
    local deviceInfo = 	"Platform: " .. system.getInfo("platformName") .. " " .. system.getInfo("platformVersion") .. 
    					", Device: " .. system.getInfo("name") .. " - " .. system.getInfo("model") .. 
    					", Arhitecure: " .. system.getInfo("architectureInfo")

	-- Add log files as attachments
	local attachments = {
					      { baseDir=system.DocumentsDirectory, filename=logName, type="text/plain" },
					  }

	local messageBody = deviceInfo;
	local messageSubject = system.getInfo("appName");

	-- Send email to administrator
    local options =
		{
		   to = { "va13ak@gmail.com" },
		   subject = messageSubject,
		   isBodyHtml = false,
		   body = messageBody,
		   attachment = attachments
		}
	native.showPopup("mail", options);
end


do
	local old = print
	print = function ( ... )
		-- btn13.sVprint ( "" .. os.date( "%H:%M:%S", os.time()) .. ": ", ... );
		-- return old( "" .. os.date( "%H:%M:%S", os.time()) .. ":", ... );
		
		local stringForPrint = ""..os.date( "%H:%M:%S", os.time() )..":";
		for i, v in ipairs(arg) do
			if stringForPrint ~= "" then
				stringForPrint = stringForPrint .. " ";
			end;
			stringForPrint = stringForPrint .. tostring( v );
		end;

		if logFile then
			logFile:write( stringForPrint .. "\n" );
		end;

		btn13.sVprint ( stringForPrint );

		return old( stringForPrint );
	end
end

local buttonHandler = function( event ) 
	-- print ( "id = " .. event.target.id .. ", phase = " .. event.phase )
	if event.phase == "began" then
		if event.target.id:sub(1,2) ~= "dt" then
			prevButton = event.target.id;
			btn13.markButton(prevButton, true);
		end;

	elseif event.phase == "cancelled" then
		if event.target.id:sub(1,2) == "dt" then
		elseif ( prevButton ) then
			btn13.markButton(prevButton, false);
			prevButton = nil;
		end;

	elseif event.phase == "ended" then
		print ( "\n-\n--\n--- action: " .. event.target.id .. " ---");
		if event.target.id:sub(1,2) == "dt" then
			fiscalServer:shutdown();

			btn13.markButton("dt"..curDev, false);
			curDev = tonumber(event.target.id:sub(3));
			btn13.markButton("dt"..curDev, true);

			userProfile.pos_fsc_ipaddress = btn13.getButton("host").text;
			userProfile.pos_fsc_port = tonumber( btn13.getButton("port").text );
			userProfile.fsct_type = curDev;
			fiscalServer:init(userProfile);
			fiscalServer:setDevice(userProfile)	-- 20180413

		elseif ( prevButton ) then
			btn13.markButton(prevButton, false);
			prevButton = nil;
		end;

		if event.target.id == "getSerial" then
			fiscalServer:getSerial();
			--fiscalServer:printInfo();
			--fiscalServer:printArtsReport();
			fiscalServer:printNonFiscalCheque( "hello, Dolly\r\nthis is not fiscal cheque\n\ni think it would be interesting\r\n0123456789012345678901234567890123456789012345678901234567890123456789" );
			--fiscalServer:printPeriodicalReportByNo( nil, nil, true )
			--fiscalServer:printPeriodicalReportByDate( nil, nil, true )
			--fiscalServer:printPeriodicalReportByNo( 0, 3)
			--fiscalServer:printPeriodicalReportByNo( 0, 3, true)
		end;
		if event.target.id == "emptyCheque" then
			fiscalServer:printEmptyCheque();
		end;
		if event.target.id == "testCheque" then
			--fiscalServer:printTestCheque();
			--fiscalServer:printTestCheque( true);
			--fiscalServer:printTestCheque( true, 0, sensitive.testPhoneNumber );
			fiscalServer:printTestCheque( true, 0 );
			--fiscalServer:printTestCheque( false, 0, sensitive.testPhoneNumber );
			--fiscalServer:printTestCheque( false, 0, sensitive.testEmail );
		end;
		if event.target.id == "cancelCheque" then
			fiscalServer:cancelCheque();
		end;
		if event.target.id == "copyCheque" then
			fiscalServer:printChequeCopy();
		end;
		if event.target.id == "xReport" then
			fiscalServer:printXReport();
		end;
		if event.target.id == "zReport" then
			fiscalServer:printZReport();
		end;
		if event.target.id == "cashIn" then
			fiscalServer:cashIn( 12.51 );
		end
		if event.target.id == "cashOut" then
			fiscalServer:cashOut( 12.51 );
		end

		if event.target.id == "quit" then
			native.requestExit();
		end
		if event.target.id == "email" then
			sendEmail();
		end
		if event.target.id == "ftp" then
			uploadLogToFTP();
		end
		saveLogFile();
	end;
end



local function myUnhandledErrorListener( event )
 
    local iHandledTheError = true
 
    if iHandledTheError then
        print( "Handling the unhandled error", event.errorMessage )
    else
        print( "Not handling the unhandled error", event.errorMessage )
    end

    saveLogFile();
    
    return iHandledTheError
end
 
Runtime:addEventListener("unhandledError", myUnhandledErrorListener)



local function onSystemEvent( event )
    
    if (event.type == "applicationStart") then
        
        print("Application started")

    elseif (event.type == "applicationExit") then 
    
        print("Application exited")

		fiscalServer:shutdown();

		saveLogFile();
		
		uploadLogToFTP();
        
    elseif ( event.type == "applicationSuspend" ) then
        
        print("Application suspended")        
		saveLogFile();
    
    elseif event.type == "applicationResume" then
        
        print("Application resumed from suspension")              
		saveLogFile();

    end

end

--setup the system listener to catch applicationExit etc
Runtime:addEventListener( "system", onSystemEvent )



createLogFile();



btn13.setButtonHandler( buttonHandler )

btn13.setColButtonsNumber( 4 )
btn13.addButton( 1, 1, "cashIn", "cash in" )
btn13.addButton( 1, 2, "cashOut", "cash out" )
btn13.addButton( 1, 3, "emptyCheque", "empty cheque", 2 )

btn13.setColButtonsNumber( 3 )
btn13.addButton( 2, 1, "cancelCheque", "cancel cheque" )
btn13.addButton( 2, 2, "copyCheque", "cheque copy" )
btn13.addButton( 2, 3, "testCheque", "test receipt" )

btn13.addButton( 3, 1, "getSerial", "get serial" )
btn13.addButton( 3, 2, "xReport", "x-report" )
btn13.addButton( 3, 3, "zReport", "z-report" )

btn13.setColButtonsNumber( 2 )
--btn13.addTextField( 4, 1, "host", nil, "localhost" )
--btn13.addTextField( 4, 2, "port", nil, "5555" )
btn13.addTextField( 4, 1, "host", nil, sensitive.kryptonId1 )
btn13.addTextField( 4, 2, "port", nil, "" )

local cnt = 0;
for k,v in pairs(fiscalServer.devTypes) do
	cnt = cnt + 1;
end;
btn13.setColButtonsNumber( cnt );
cnt = 0;
for k,v in pairs(fiscalServer.devTypes) do
	cnt = cnt + 1;
	local ind = "dt"..k;
	btn13.addButton (5, cnt, ind, v);
	--devTypes[ind] = k
	print(k, v);
end
if not curDev then
	curDev = userProfile.fsct_type;
	btn13.markButton("dt"..curDev, true);
	btn13.getButton("port").text = userProfile.pos_fsc_port and string.format("%d", userProfile.pos_fsc_port) or ""
	btn13.getButton("host").text = userProfile.pos_fsc_ipaddress or "";
	fiscalServer:init( userProfile );
	fiscalServer:setDevice(userProfile)	-- 20180413
end;

btn13.setColButtonsNumber( 4 )
btn13.addButton( 6, 1, "email", "email" )
btn13.addButton( 6, 2, "ftp", "ftp" )
btn13.addButton( 6, 3, "quit", "quit", 2 )

--[[
Runtime:addEventListener("enterFrame",
	function()
		if ( printBuffer.firstIndex < printBuffer.lastIndex ) then
			local i = printBuffer.firstIndex;
			while ( i <= printBuffer.lastIndex ) do
				printBuffer.firstIndex = i;
				btn13.sVprint ( ""..os.date( "%H:%M:%S", os.time() ).." | ", printBuffer.lines[i] );
				printBuffer.lines[i] = nil;
				i = i + 1;
			end;
		end;
	end);
--]]

