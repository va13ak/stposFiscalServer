//
//  @author Valery Zakharov <va13ak@gmail.com>
//  @date 2018-05-16 18:47:45
//

package com.smartlab.smarttouchmobile;

import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.os.IBinder;
import android.os.RemoteException;
import android.util.Log;

import com.ansca.corona.CoronaEnvironment;
import com.multisoft.drivers.fiscalcore.IFiscalCore;

public class MSPOSFiscalCoreBridge {
    // IFiscalCore:  http://doc.multisoft.ru/doc/MSPOS/html/
    // Namespace Reference: //  http://doc.multisoft.ru/doc/MSPOS/html/namespacecom_1_1multisoft_1_1drivers_1_1fiscalcore.html
    // components: http://doc.multisoft.ru/doc/MSPOS/
    private static final String TAG = "smarttouchpos";

    final static String REMOTE_SERVICE_ACTION_NAME = "com.multisoft.drivers.fiscalcore.IFiscalCore";
    final static String REMOTE_SERVICE_PACKAGE_NAME = "com.multisoft.drivers.fiscalcore";
    final static String REMOTE_SERVICE_COMPONENT_NAME = "com.multisoft.fiscalcore";

    final static String CASHIER_NAME = "Кассир";

    static IFiscalCore fiscalCore;
    MSPOSFiscalCoreExceptionCallBack callback = new MSPOSFiscalCoreExceptionCallBack();

    private ServiceConnection serviceConnection = new ServiceConnection() {
        @Override
        public void onServiceConnected(ComponentName name, IBinder service) {
        	fiscalCore = IFiscalCore.Stub.asInterface(service);
        	try {
        		int i = fiscalCore.GetDayState(callback);
			} catch (RemoteException e) {
        	    Log.i(TAG, e.toString());
			}
        }

        @Override
        public void onServiceDisconnected(ComponentName name) {
			fiscalCore = null;
        }
    };

    public void initialize() {
        Log.i(TAG, "initialize()");

        if (fiscalCore == null) {
            Intent intent = new Intent();
            intent.setPackage(REMOTE_SERVICE_PACKAGE_NAME);
            intent.setAction(REMOTE_SERVICE_ACTION_NAME);
            ComponentName cn = new ComponentName(REMOTE_SERVICE_PACKAGE_NAME, REMOTE_SERVICE_COMPONENT_NAME);
            intent.setComponent(cn);

            CoronaEnvironment.getCoronaActivity().getApplicationContext().startService(intent);
            if (CoronaEnvironment.getCoronaActivity().getApplicationContext().bindService(intent, serviceConnection, Context.BIND_AUTO_CREATE)) {
                Log.i(TAG, "Service bind success");
            }

        }
    }

    public void deInitialize() {
        Log.i(TAG, "deInitialize()");

        if (fiscalCore != null)
            CoronaEnvironment.getCoronaActivity().getApplicationContext().unbindService(serviceConnection);
    }

    private void checkShift() throws Exception {
        Log.i(TAG, "checkShift()");

        /// <summary>
        /// Состояние смены
        /// </summary>
        //public enum DayState
        //{
            /// <summary>
            /// Смена закрыта
            /// </summary>
            // [Description("Смена закрыта")]
        int DayStateDayClosed = 0x00;

                /// <summary>
                /// Смена открыта
                /// </summary>
                // [Description("Смена открыта")]
        int DayStateDayOpen = 0x01;
        //}

        if (fiscalCore.GetDayState(callback) != DayStateDayOpen) {
            fiscalCore.OpenDay(CASHIER_NAME, callback);
        }
        callback.Complete();
    }

    private void checkDocState() throws Exception {
        Log.i(TAG, "checkDocState()");

        /// <summary>
        /// состояние чека
        /// </summary>
        //public enum RecState
        //{
            /// <summary>
            /// открыт
            /// </summary>
        int RecStateOpened = 0;

            /// <summary>
            /// произведена оплата
            /// </summary>
        int RecStateTotal = 1;

            /// <summary>
            /// закрыт
            /// </summary>
        int RecStateClosed = 2;
        //}
        int recState = fiscalCore.GetRecState(callback);
        if (recState != RecStateClosed) {
            fiscalCore.RecVoid(callback);
        }
        callback.Complete();
    }

    public void cashIn(String cash) throws Exception {
        Log.i(TAG, "cashIn(\"" + cash + "\")");

        /// <summary>
        /// наличными
        /// </summary>
        // [Description("НАЛИЧНЫМИ")]
        int PayTypeCash = 0;

        /// <summary>
        /// Внесение
        /// </summary>
        // [Description("Внесение")]
        int RecTypePayIn = 7;

        checkDocState();

        fiscalCore.OpenRec(RecTypePayIn, callback);
        fiscalCore.PrintRecItem("1", cash, "НАЛИЧНЫМИ:", "", callback);
        fiscalCore.PrintRecTotal(callback);
        fiscalCore.PrintRecItemPay(PayTypeCash, cash, "НАЛИЧНЫМИ:", callback);
        fiscalCore.CloseRec(callback);
        callback.Complete();
    }

    public void cashOut(String cash) throws Exception {
        Log.i(TAG, "cashOut(\"" + cash + "\")");

        /// <summary>
        /// наличными
        /// </summary>
        // [Description("НАЛИЧНЫМИ")]
        int PayTypeCash = 0;

        /// <summary>
        /// Изъятие
        /// </summary>
        // [Description("Изъятие")]
        int RecTypePayOut = 8;

        checkDocState();

        fiscalCore.OpenRec(RecTypePayOut, callback);
        fiscalCore.PrintRecItem("1", cash, "НАЛИЧНЫМИ:", "", callback);
        fiscalCore.PrintRecTotal(callback);
        fiscalCore.PrintRecItemPay(PayTypeCash, cash, "НАЛИЧНЫМИ:", callback);
        fiscalCore.CloseRec(callback);
        callback.Complete();

    }


    public void printXReport() throws Exception {
        Log.i(TAG, "printXReport()");

        checkDocState();

        fiscalCore.PrintXReport(callback);
        callback.Complete();

    }

    public void printZReport(String cashier) throws Exception {
        Log.i(TAG, "printZReport(\"" + cashier + "\")");

        checkDocState();

        fiscalCore.CloseDay(cashier, callback);
        callback.Complete();

    }

    public void printZReport() throws Exception {

        printZReport(CASHIER_NAME);

    }


    public void cancelCheque() throws Exception {
        Log.i(TAG, "cancelCheque()");

        checkDocState();    // already cancels check if opened

        //fiscalCore.RecVoid(callback);
        //callback.Complete();

    }

    public void printEmptyCheque() throws Exception {
        Log.i(TAG, "printEmptyCheque()");

        /// <summary>
        /// наличными
        /// </summary>
        // [Description("НАЛИЧНЫМИ")]
        int PayTypeCash = 0;

        checkDocState();

        int RecTypeSell = 1;

        fiscalCore.OpenRec(RecTypeSell, callback);
        fiscalCore.PrintRecItem("1", "0.00", "ПУСТОЙ ЧЕК", "", callback);
        fiscalCore.PrintRecTotal(callback);
        fiscalCore.PrintRecItemPay(PayTypeCash, "0.00", "НАЛИЧНЫМИ:", callback);
        fiscalCore.CloseRec(callback);
        callback.Complete();
    }

    public void printNonFiscalCheque(String text) throws Exception {
        Log.i(TAG, "printNonFiscalCheque(\"" + text + "\")");

        int RecTypeUnfiscal = 9;

        // Align { Align.Left = 0, Align.Center = 1, Align.Right = 2 }
        int AlignLeft = 0;

        checkDocState();

        fiscalCore.OpenRec(RecTypeUnfiscal, callback);

        String[] subStr = text.split("\n");
        for(int i = 0; i < subStr.length; i++) {
            fiscalCore.PrintLine(AlignLeft, subStr[i], callback);
        }

        fiscalCore.CloseRec(callback);

        callback.Complete();
    }

    public void printCheque(com.naef.jnlua.LuaState luaState) throws Exception {
        Log.i(TAG, "printCheque(data)");

        luaState.checkType(2, com.naef.jnlua.LuaType.TABLE);

        checkDocState();
        callback.Complete();

    }


}
