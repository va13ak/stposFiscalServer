//
//  @author Valery Zakharov <va13ak@gmail.com>
//  @date 2018-05-16 18:47:45
//

package com.smartlab.smarttouchmobile;

import android.util.Log;

import java.util.HashMap;

/**
 * Implements the msposFiscalCoreFunction() function in Lua.
 * <p>
 * Demonstrates how to fetch a "Lua function argument" and then call that Lua function.
 */
class MSPOSFiscalCoreFunction implements com.naef.jnlua.NamedJavaFunction {
    private static final String TAG = "smarttouchpos";

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
        try {
            MSPOSFiscalCoreBridge msposFiscalCoreBridge = new MSPOSFiscalCoreBridge();
            String funcName = luaState.checkString(1);
            Log.i(TAG, "funcName: \"" + funcName + "\"");
            System.out.println("funcName: \"" + funcName + "\"");
            /*
            switch (funcName) {
                case "init":
                    msposFiscalCoreBridge.initialize();
                    break;
                case "shutdown":
                    msposFiscalCoreBridge.deInitialize();
                    break;

                case "printXReport":
                    msposFiscalCoreBridge.printXReport();
                    break;
                case "printZReport":
                    msposFiscalCoreBridge.printZReport();
                    break;

                case "printCheque":
                    // Check if the Lua function's first argument is a Lua table.
                    // Will throw an exception if it is not a table or if no argument was given.
                    luaState.checkType(2, com.naef.jnlua.LuaType.TABLE);
                    msposFiscalCoreBridge.printCheque(extractData(luaState, 2));
                    break;

                case "cancelCheque":
                    msposFiscalCoreBridge.cancelCheque();
                    break;

                case "printEmptyCheque":
                    msposFiscalCoreBridge.printEmptyCheque();
                    break;

                case "printNonFiscalCheque":
                    msposFiscalCoreBridge.printNonFiscalCheque(luaState.checkString(2));
                    break;

                case "cashIn":
                    msposFiscalCoreBridge.cashIn(luaState.checkString(2));
                    break;
                case "cashOut":
                    msposFiscalCoreBridge.cashOut(luaState.checkString(2));
                    break;
            }
            */
            if (funcName.equals("init")) msposFiscalCoreBridge.initialize();
            else if (funcName.equals("shutdown")) msposFiscalCoreBridge.deInitialize();
            else if (funcName.equals("printXReport")) msposFiscalCoreBridge.printXReport();
            else if (funcName.equals("printZReport")) msposFiscalCoreBridge.printZReport();
            else if (funcName.equals("printCheque")) {
                // Check if the Lua function's first argument is a Lua table.
                // Will throw an exception if it is not a table or if no argument was given.
                luaState.checkType(2, com.naef.jnlua.LuaType.TABLE);
                msposFiscalCoreBridge.printCheque(extractData(luaState, 2));
            } else if (funcName.equals("cancelCheque")) msposFiscalCoreBridge.cancelCheque();
            else if (funcName.equals("printEmptyCheque")) msposFiscalCoreBridge.printEmptyCheque();
            else if (funcName.equals("printNonFiscalCheque")) msposFiscalCoreBridge.printNonFiscalCheque(luaState.checkString(2));
            else if (funcName.equals("cashIn")) msposFiscalCoreBridge.cashIn(luaState.checkString(2));
            else if (funcName.equals("cashOut")) msposFiscalCoreBridge.cashOut(luaState.checkString(2));

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

        // Return 0 since this Lua function does not return any values.
        return 1;   // nil or error message
    }
}
