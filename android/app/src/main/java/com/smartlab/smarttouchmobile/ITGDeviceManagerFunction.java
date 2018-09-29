//
//  @author Valery Zakharov <va13ak@gmail.com>
//  @date 2018-09-28 13:57:00
//
package com.smartlab.smarttouchmobile;

import android.app.Activity;
import android.content.Intent;
import android.util.Log;

import com.ansca.corona.CoronaActivity;
import com.ansca.corona.CoronaEnvironment;

/**
 * Implements the itgDeviceManagerFunction() function in Lua.
 */
public class ITGDeviceManagerFunction implements com.naef.jnlua.NamedJavaFunction {
    private static final String TAG = "smarttouchpos";
    private static String EXTRA_DATA = "JSONDATA";
    private static String INTENT_ACTION = "com.itekgold.stpos.DEVICE_MANAGER_TASK";
    private static String TEST_DATA = "{sdfsdvsd}";

    private static int respRequestCode;
    private static int respResultCode;
    private static String respDataString;

    /**
     * Gets the name of the Lua function as it would appear in the Lua script.
     *
     * @return Returns the name of the custom Lua function.
     */
    @Override
    public String getName() {
        return "itgDeviceManager";
    }

    /**
     * This method is called when the Lua function is called.
     * <p>
     * Warning! This method is not called on the main UI thread.
     *
     * @param luaState Reference to the Lua state.
     *                 Needed to retrieve the Lua function's parameters and to return values back to Lua.
     * @return Returns the number of values to be returned by the Lua function.
     */
    @Override
    public int invoke(com.naef.jnlua.LuaState luaState) {
        CoronaActivity activity = CoronaEnvironment.getCoronaActivity();
        if (activity == null) {
            return 0;
        }

        int resCount = 0;

        try {
            String printData = luaState.checkString(1);
            Log.i(TAG, "printData: \"" + printData + "\"");

            respDataString = null;
            respRequestCode = 0;
            respResultCode = 0;

            int requestCode = activity.registerActivityResultHandler(new ITGDeviceManagerResponseHandler());

            Intent intent = new Intent(INTENT_ACTION);
            intent.putExtra(EXTRA_DATA, printData);
            intent.addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP);
            activity.startActivityForResult(intent, requestCode);

            Log.i(TAG, "ACTIVITY JUST STARTED");
            System.out.println("ACTIVITY JUST STARTED");

            while (respDataString == null) {
                System.out.println( System.currentTimeMillis() );
                Thread.sleep(200);
            }

            Log.i(TAG, "AGAIN RESULT IS respDataDataString");
            System.out.println("AGAIN RESULT IS respDataDataString");

            luaState.pushNil(); // no errors here

        } catch (Exception ex) {
            // An exception will occur if the following happens:
            // 1) No argument was given.
            // 2) The argument was not a Lua function.
            // 3) The Lua function call failed, likely because the Lua function could not be found.
            ex.printStackTrace();
            System.out.println(ex.toString());

            //luaState.pushString(ex.toString()); // return error message
            luaState.pushString(ex.getLocalizedMessage()); // return error message

        }

        if ( respDataString != null ) {
            luaState.pushString( respDataString.toString() );
            resCount++;
        }

        // Return 0 since this Lua function does not return any values.
        return 1 + resCount;   // nil or error message
    }

    private static class ITGDeviceManagerResponseHandler implements CoronaActivity.OnActivityResultHandler {
        public ITGDeviceManagerResponseHandler() {
        }

        @Override
        public void onHandleActivityResult(
                CoronaActivity activity, int requestCode, int resultCode, android.content.Intent data)
        {
            // Unregister this handler.
            activity.unregisterActivityResultHandler(this);

            // Handle the result...
            Log.i(TAG, "ACTIVITY JUST FINISHED");
            System.out.println("ACTIVITY JUST FINISHED");

            //if (requestCode==REQUEST_CODE && resultCode== Activity.RESULT_OK && data!=null) {
            if (resultCode == Activity.RESULT_OK && data != null) {
                respDataString = data.getStringExtra(EXTRA_DATA);
                respResultCode = resultCode;
                respRequestCode = requestCode;

                Log.i(TAG, "RESULT IS: " + respDataString);
                System.out.println("RESULT IS: " + respDataString);
            }
        }
    }
}
