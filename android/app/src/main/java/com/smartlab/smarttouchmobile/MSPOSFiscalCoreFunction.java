//
//  @author Valery Zakharov <va13ak@gmail.com>
//  @date 2018-05-16 18:47:45
//

package com.smartlab.smarttouchmobile;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.util.Log;

import com.ansca.corona.CoronaActivity;
import com.ansca.corona.CoronaActivityInfo;
import com.ansca.corona.CoronaEnvironment;

import java.util.HashMap;

/**
 * Implements the msposFiscalCoreFunction() function in Lua.
 */
class MSPOSFiscalCoreFunction implements com.naef.jnlua.NamedJavaFunction {
    private static final String TAG = "smarttouchpos";
    private static String INTENT_ACTION = "com.smartlab.msposservicetool.SERVICE_TOOL_TASK";
    private static String SERVICE_TOOL_PACKAGE_NAME = "com.smartlab.msposservicetool";

    /**
     * Gets the name of the Lua function as it would appear in the Lua script.
     *
     * @return Returns the name of the custom Lua function.
     */
    @Override
    public String getName() {
        return "msposFiscalCore";
    }

    public HashMap<String, Object> extractData(com.naef.jnlua.LuaState luaState, int luaTableStackIndex) {
        //HashMap<String, Object> data = new HashMap<>();
        HashMap<String, Object> data = new HashMap();

        // Print all of the key/value paris in the Lua table.
        System.out.printf("printTable(%d)\n", luaTableStackIndex);
        System.out.println("{");
        for (luaState.pushNil(); luaState.next(luaTableStackIndex); luaState.pop(1)) {
            // Fetch the table entry's string key.
            // An index of -2 accesses the key that was pushed into the Lua stack by luaState.next() up above.
            String keyName = null;
            com.naef.jnlua.LuaType luaType = luaState.type(-2);
            switch (luaType) {
                case STRING:
                    // Fetch the table entry's string key.
                    keyName = luaState.toString(-2);
                    break;
                case NUMBER:
                    // The key will be a number if the given Lua table is really an array.
                    // In this case, the key is an array index. Do not call luaState.toString() on the
                    // numeric key or else Lua will convert the key to a string from within the Lua table.
                    keyName = Integer.toString(luaState.toInteger(-2));
                    break;
            }
            if (keyName == null) {
                // A valid key was not found. Skip this table entry.
                continue;
            }

            // Fetch the table entry's value in string form.
            // An index of -1 accesses the entry's value that was pushed into the Lua stack by luaState.next() above.
            String valueString;
            Object value;
            String valueType;
            luaType = luaState.type(-1);
            switch (luaType) {
                case STRING:
                    value = luaState.toString(-1);
                    valueString = (String) value;
                    valueType = "STRING";
                    break;
                case BOOLEAN:
                    value = luaState.toBoolean(-1);
                    valueString = Boolean.toString((Boolean) value);
                    valueType = "BOOLEAN";
                    break;
                case NUMBER:
                    value = luaState.toNumber(-1);
                    valueString = Double.toString((Double) value);
                    valueType = "NUMBER";
                    break;
                case TABLE:
                    value = extractData(luaState, -2);
                    valueString = luaType.displayText();
                    valueType = "TABLE";
                    break;
                default:
                    value = null;
                    valueString = luaType.displayText();
                    valueType = luaType.displayText();
                    break;
            }

            if (valueString == null) {
                valueString = "";
            }

            // Print the table entry to the Android logging system.
            System.out.println("   [" + keyName + "] = " + valueString + "   /   " + valueType);

            data.put(keyName, value);
        }
        System.out.println("}");

        return data;
    }

    public void runServiceTool(com.naef.jnlua.LuaState luaState) {
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

                try {

                    CoronaActivity activity = CoronaEnvironment.getCoronaActivity();
                    if (activity != null) {
                        Intent intent = CoronaEnvironment.getApplicationContext().getPackageManager().getLaunchIntentForPackage(SERVICE_TOOL_PACKAGE_NAME);
                        //Intent intent = new Intent(INTENT_ACTION);
                        if (intent != null) {
                            //intent.putExtra(EXTRA_DATA, TEST_DATA);
                            intent.addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP);
                            activity.startActivity(intent);

                            Log.i(TAG, "ACTIVITY JUST STARTED");
                            System.out.println("ACTIVITY JUST STARTED");
                        } else {
                            AlertDialog.Builder dialog = new AlertDialog.Builder(activity);
                            dialog.setMessage("Service tool is not installed!").setPositiveButton("OK", new DialogInterface.OnClickListener() {
                                @Override
                                public void onClick(DialogInterface dialog, int which) {
                                    // DO NOTHING
                                }
                            });
                            dialog.show();
                        }
                    }

                }
                catch (Exception ex) {
                    ex.printStackTrace();
                }

//                // Create a task that will call the given Lua function.
//                // This task's execute() method will be called on the Corona runtime thread, just before rendering a frame.
//                com.ansca.corona.CoronaRuntimeTask task = new com.ansca.corona.CoronaRuntimeTask() {
//                    @Override
//                    public void executeUsing(com.ansca.corona.CoronaRuntime runtime) {
//                        // *** We are now running on the Corona runtime thread. ***
//                        String errorMessage = null;
//                        try {
//
//                            CoronaActivity activity = CoronaEnvironment.getCoronaActivity();
//                            if (activity != null) {
//                                Intent intent = CoronaEnvironment.getApplicationContext().getPackageManager().getLaunchIntentForPackage(INTENT_ACTION);
//                                if (intent != null) {
//                                    //Intent intent = new Intent(INTENT_ACTION);
//                                    //intent.putExtra(EXTRA_DATA, TEST_DATA);
//                                    intent.addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP);
//                                    activity.startActivity(intent);
//
//                                    Log.i(TAG, "ACTIVITY JUST STARTED");
//                                    System.out.println("ACTIVITY JUST STARTED");
//                                } else {
//                                    AlertDialog.Builder dialog = new AlertDialog.Builder(activity);
//                                    dialog.setMessage("Service tool is not installed!").setPositiveButton("OK", new DialogInterface.OnClickListener() {
//                                        @Override
//                                        public void onClick(DialogInterface dialog, int which) {
//                                            // DO NOTHING
//                                        }
//                                    });
//                                    dialog.show();
//                                }
//                            }
//
//                        }
//                        catch (Exception ex) {
//                            ex.printStackTrace();
//                            errorMessage = ex.toString();
//                        }
//
//                        if (errorMessage != null) {
////                            try {
////
////                                // Fetch the Corona runtime's Lua state.
////                                com.naef.jnlua.LuaState luaState = runtime.getLuaState();
////
////                                // Fetch the Lua function stored in the registry and push it to the top of the stack.
////                                luaState.rawGet(com.naef.jnlua.LuaState.REGISTRYINDEX, luaFunctionReferenceKey);
////
////                                // Remove the Lua function from the registry.
////                                luaState.unref(com.naef.jnlua.LuaState.REGISTRYINDEX, luaFunctionReferenceKey);
////
////                                // Call the Lua function that was just pushed to the top of the stack.
////                                // The 1st argument indicates the number of arguments that we are passing to the Lua function.
////                                // The 2nd argument indicates the number of return values to accept from the Lua function.
////                                // Note: If you want to call the Lua function with arguments, then you need to push each argument
////                                //       value to the luaState object's stack.
////                                luaState.pushBoolean(false);     // operation unsuccessful
////                                luaState.pushString(errorMessage);  // error message
////                                luaState.pushNil();                 // empty third argument
////                                luaState.call(3, 0);
////                            }
////                            catch (Exception ex) {
////                                ex.printStackTrace();
////                            }
//                        }
//                    }
//                };
//
//                // Send the above task to the Corona runtime asynchronously.
//                // The send() method will do nothing if the Corona runtime is no longer available, which can
//                // happen if the runtime was disposed/destroyed after the user has exited the Corona activity.
//                dispatcher.send(task);
            }
        });

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
        String result1 = null;
        int resCount = 0;

        try {

            String funcName = luaState.checkString(1);
            Log.i(TAG, "funcName: \"" + funcName + "\"");
            System.out.println("funcName: \"" + funcName + "\"");

            if (funcName.equals("runServiceTool")) runServiceTool(luaState);   // 20181031
            else {
                MSPOSFiscalCoreBridge msposFiscalCoreBridge = new MSPOSFiscalCoreBridge();

                if (funcName.equals("init")) msposFiscalCoreBridge.initialize();
                else if (funcName.equals("shutdown")) msposFiscalCoreBridge.deInitialize();
                else if (funcName.equals("printXReport")) msposFiscalCoreBridge.printXReport();
                else if (funcName.equals("printZReport")) msposFiscalCoreBridge.printZReport();
                else if (funcName.equals("printCorrectionCheque")) {
                    // Check if the Lua function's first argument is a Lua table.
                    // Will throw an exception if it is not a table or if no argument was given.
                    luaState.checkType(2, com.naef.jnlua.LuaType.TABLE);
                    msposFiscalCoreBridge.printCorrectionCheque(extractData(luaState, 2));
                } else if (funcName.equals("printCheque")) {
                    // Check if the Lua function's first argument is a Lua table.
                    // Will throw an exception if it is not a table or if no argument was given.
                    luaState.checkType(2, com.naef.jnlua.LuaType.TABLE);
                    msposFiscalCoreBridge.printCheque(extractData(luaState, 2));
                } else if (funcName.equals("cancelCheque")) msposFiscalCoreBridge.cancelCheque();
                else if (funcName.equals("printEmptyCheque")) msposFiscalCoreBridge.printEmptyCheque();
                else if (funcName.equals("printNonFiscalCheque")) msposFiscalCoreBridge.printNonFiscalCheque(luaState.checkString(2));
                else if (funcName.equals("cashIn")) msposFiscalCoreBridge.cashIn(luaState.checkString(2));
                else if (funcName.equals("cashOut")) msposFiscalCoreBridge.cashOut(luaState.checkString(2));
                else if (funcName.equals("getTaxation")) result1 = msposFiscalCoreBridge.getTaxation();
            }

//            // Check if the first argument is a function.
//            // Will throw an exception if not or if no argument is given.
//            int luaFunctionStackIndex = 1;
//            luaState.checkType(luaFunctionStackIndex, com.naef.jnlua.LuaType.FUNCTION);
//
//            // Push the given Lua function to the top of the Lua state's stack. We need to do this because the
//            // because the call() method below expects this Lua function to be a the top of the stack.
//            luaState.pushValue(luaFunctionStackIndex);
//
//            // Call the given Lua function.
//            // The first argument indicates the number of arguments that we are passing to the Lua function.
//            // The second argument indicates the number of return values to accept from the Lua function.
//            // In this case, we are calling this Lua function with no arguments and are accepting no return values.
//            // Note: If you want to call the Lua function with arguments, then you need to push each argument
//            //       value to the luaState object's stack.
//            luaState.call(0, 0);

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

        if ( result1 != null ) {
            luaState.pushString( result1.toString() );
            resCount++;
        }

        // Return 0 since this Lua function does not return any values.
        return 1 + resCount;   // nil or error message
    }
}
