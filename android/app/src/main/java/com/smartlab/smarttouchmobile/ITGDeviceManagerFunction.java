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
            luaState.pushString("CoronaEnvironment.getCoronaActivity() is null"); // return error message
            return 1;
        }

        int luaStringDataStackIndex = 1;
        int luaFunctionStackIndex = 2;

        final String printData;

        // Check if the first argument is string with data
        // Will print a stack trace if not or if no argument was given.
        try {
            printData = luaState.checkString(luaStringDataStackIndex);
            Log.i(TAG, "printData: \"" + printData + "\"");
        }
        catch (Exception ex) {
            ex.printStackTrace();
            System.out.println(ex.toString());
            luaState.pushString(ex.getLocalizedMessage()); // return error message
            return 1;   // return 1 value
        }

        // Check if the second argument is a function.
        // Will print a stack trace if not or if no argument was given.
        try {
            luaState.checkType(luaFunctionStackIndex, com.naef.jnlua.LuaType.FUNCTION);
        }
        catch (Exception ex) {
            ex.printStackTrace();
            System.out.println(ex.toString());
            luaState.pushString(ex.getLocalizedMessage()); // return error message
            return 1;   // return 1 value
        }


        // Store the given Lua function in the Lua registry to be accessed later. We must do this because
        // the given Lua function argument will be popped off the Lua stack when we leave this Java method.
        // Note that the ref() method expects the value to be stored is at the top of the Lua stack.
        // So, we must first push the Lua function to the top. The ref() method will automatically pop off
        // the push Lua function afterwards.
        luaState.pushValue(luaFunctionStackIndex);
        final int luaFunctionReferenceKey = luaState.ref(com.naef.jnlua.LuaState.REGISTRYINDEX);

        // Set up a dispatcher which allows us to send a task to the Corona runtime thread from another thread.
        // This way we can call the given Lua function on the same thread that Lua runs in.
        // This dispatcher will only send tasks to the Corona runtime that owns the given Lua state object.
        // Once the Corona runtime is disposed/destroyed, which happens when the Corona activity is destroyed,
        // then this dispatcher will no longer be able to send tasks.
        final com.ansca.corona.CoronaRuntimeTaskDispatcher dispatcher =
                new com.ansca.corona.CoronaRuntimeTaskDispatcher(luaState);

        // Post a Runnable object on the UI thread that will call the given Lua function.
        com.ansca.corona.CoronaEnvironment.getCoronaActivity().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                // *** We are now running in the main UI thread. ***


                // Create a task that will call the given Lua function.
                // This task's execute() method will be called on the Corona runtime thread, just before rendering a frame.
                com.ansca.corona.CoronaRuntimeTask task = new com.ansca.corona.CoronaRuntimeTask() {
                    @Override
                    public void executeUsing(com.ansca.corona.CoronaRuntime runtime) {
                        // *** We are now running on the Corona runtime thread. ***
                        String errorMessage = null;
                        try {

                            CoronaActivity activity = CoronaEnvironment.getCoronaActivity();
                            if (activity != null) {
                                int requestCode = activity.registerActivityResultHandler(new ITGDeviceManagerResponseHandler(runtime, luaFunctionReferenceKey));

                                Intent intent = new Intent(INTENT_ACTION);
                                intent.putExtra(EXTRA_DATA, printData);
                                //intent.putExtra(EXTRA_DATA, TEST_DATA);
                                intent.addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP);
                                activity.startActivityForResult(intent, requestCode);

                                Log.i(TAG, "ACTIVITY JUST STARTED");
                                System.out.println("ACTIVITY JUST STARTED");
                            }

                        }
                        catch (Exception ex) {
                            ex.printStackTrace();
                            errorMessage = ex.toString();
                        }

                        if (errorMessage != null) {
                            try {

                                // Fetch the Corona runtime's Lua state.
                                com.naef.jnlua.LuaState luaState = runtime.getLuaState();

                                // Fetch the Lua function stored in the registry and push it to the top of the stack.
                                luaState.rawGet(com.naef.jnlua.LuaState.REGISTRYINDEX, luaFunctionReferenceKey);

                                // Remove the Lua function from the registry.
                                luaState.unref(com.naef.jnlua.LuaState.REGISTRYINDEX, luaFunctionReferenceKey);

                                // Call the Lua function that was just pushed to the top of the stack.
                                // The 1st argument indicates the number of arguments that we are passing to the Lua function.
                                // The 2nd argument indicates the number of return values to accept from the Lua function.
                                // Note: If you want to call the Lua function with arguments, then you need to push each argument
                                //       value to the luaState object's stack.
                                luaState.pushBoolean(false);     // operation unsuccessful
                                luaState.pushString(errorMessage);  // error message
                                luaState.pushNil();                 // empty third argument
                                luaState.call(3, 0);
                            }
                            catch (Exception ex) {
                                ex.printStackTrace();
                            }
                        }
                    }
                };

                // Send the above task to the Corona runtime asynchronously.
                // The send() method will do nothing if the Corona runtime is no longer available, which can
                // happen if the runtime was disposed/destroyed after the user has exited the Corona activity.
                dispatcher.send(task);
            }
        });

        luaState.pushNil(); // no errors here
        return 1;   // return 1 empty value
    }

    private static class ITGDeviceManagerResponseHandler implements CoronaActivity.OnActivityResultHandler {
        private com.ansca.corona.CoronaRuntime runtime;
        private int luaFunctionReferenceKey;

        public ITGDeviceManagerResponseHandler(com.ansca.corona.CoronaRuntime runtime, int luaFunctionReferenceKey) {
            this.runtime = runtime;
            this.luaFunctionReferenceKey = luaFunctionReferenceKey;
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

            String respDataString = null;
            if (data != null) {
                respDataString = data.getStringExtra(EXTRA_DATA);
                Log.i(TAG, "RESULT (" + Integer.toString(resultCode)+ ") IS: " + respDataString);
                System.out.println("RESULT (" + Integer.toString(resultCode)+ ") IS: " + respDataString);
            }

            try {

                // Fetch the Corona runtime's Lua state.
                com.naef.jnlua.LuaState luaState = runtime.getLuaState();

                // Fetch the Lua function stored in the registry and push it to the top of the stack.
                luaState.rawGet(com.naef.jnlua.LuaState.REGISTRYINDEX, luaFunctionReferenceKey);

                // Remove the Lua function from the registry.
                luaState.unref(com.naef.jnlua.LuaState.REGISTRYINDEX, luaFunctionReferenceKey);

                // Call the Lua function that was just pushed to the top of the stack.
                // The 1st argument indicates the number of arguments that we are passing to the Lua function.
                // The 2nd argument indicates the number of return values to accept from the Lua function.
                // Note: If you want to call the Lua function with arguments, then you need to push each argument
                //       value to the luaState object's stack.
                luaState.pushBoolean(true);     // operation successful
                luaState.pushInteger(resultCode);  // result code
                if (respDataString == null)
                    luaState.pushNil();             // no data
                else
                    luaState.pushString(respDataString);

                luaState.call(3, 0);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }
}
