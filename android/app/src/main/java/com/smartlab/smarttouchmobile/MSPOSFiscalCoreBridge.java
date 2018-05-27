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

import java.util.HashMap;
import java.util.Map;

public class MSPOSFiscalCoreBridge {
    // IFiscalCore:  http://doc.multisoft.ru/doc/MSPOS/html/
    // Namespace Reference: //  http://doc.multisoft.ru/doc/MSPOS/html/namespacecom_1_1multisoft_1_1drivers_1_1fiscalcore.html
    // components: http://doc.multisoft.ru/doc/MSPOS/
    // wiki: http://77.243.109.96:8881/redmine/projects/mspos-k/wiki/QA

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

        int DayStateDayClosed = 0x00;   // DayState (Состояние смены): Смена закрыта
        int DayStateDayOpen = 0x01;     // DayState (Состояние смены): Смена открыта

        if (fiscalCore.GetDayState(callback) != DayStateDayOpen) {
            fiscalCore.OpenDay(CASHIER_NAME, callback);
        }
        callback.Complete();
    }

    private void checkDocState() throws Exception {
        Log.i(TAG, "checkDocState()");

        int RecStateOpened = 0; // RecState (состояние чека): открыт
        int RecStateTotal = 1;  // RecState (состояние чека): произведена оплата
        int RecStateClosed = 2; // RecState (состояние чека): закрыт

        int recState = fiscalCore.GetRecState(callback);
        if (recState != RecStateClosed) {
            fiscalCore.RecVoid(callback);
        }
        callback.Complete();
    }

    public void cashIn(String cash) throws Exception {
        Log.i(TAG, "cashIn(\"" + cash + "\")");

        int PayTypeCash = 0;    // PayType (Типы оплат): "НАЛИЧНЫМИ"

        int RecTypePayIn = 7;   // RecType (тип открытого чека): "Внесение"

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

        int PayTypeCash = 0;    // PayType (Типы оплат): "НАЛИЧНЫМИ"

        int RecTypePayOut = 8;  // RecType (тип открытого чека): "Изъятие"

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

        int PayTypeCash = 0;    // PayType (Типы оплат): "НАЛИЧНЫМИ"

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

    public void printCheque(Map<String, Object> data) throws Exception {
        Log.i(TAG, "printCheque(data)");

        String address = (String) data.get("phone_number");

        int recType = (((Boolean) data.get("is_refund")) == true) ? 3 : 1;

        int payType = 0;
        String payTypeName = "НАЛИЧНЫМИ:";
        if (((Double) data.get("pmt_type")).intValue() == 1) {
            payType = 1;
            payTypeName = "ЭЛЕКТРОННЫМИ:";
        }

        String cash = "0.00";

        // RecType { RecType.Sell = 1, RecType.SellRefund = 3, RecType.Buy = 2, RecType.BuyRefund = 4,
        //            RecType.CorrectionRec = 19, RecType.PayIn = 7, RecType.PayOut = 8, RecType.Unfiscal = 9 }
        // PayType { PayType.Cash = 0, PayType.Card, PayType.Bank, PayType.Voucher, PayType.Tare }

        checkDocState();

        fiscalCore.OpenRec(recType, callback);

        System.out.println("--->");
        HashMap<String, Object> items = (HashMap) data.get("items");
        for (Map.Entry<String, Object> row: items.entrySet()) {
            System.out.printf("===================== item no: " + row.getKey() + "\n");
            HashMap<String, Object> item = (HashMap) row.getValue();
            for (Map.Entry<String, Object> pair: item.entrySet()) {
                System.out.printf("========== item key: " + pair.getKey() + ", value: " +  pair.getValue() + "\n");
            }
            if (item != null) {
                fiscalCore.SetItemTaxes((Integer) item.get("taxGroup"), callback);
                fiscalCore.SetShowTaxes(true, callback);    // включить отрисовку налога

                Double amount = (Double) item.get("amount");
                if (amount == null) amount = .000;
                String count = String.format("%.3f", amount);

                Double discount = (Double) item.get("discount");
                if (discount == null) discount = .00;
                Double sum = (Double) item.get("price");
                if (sum == null) sum = .00;
                String total = String.format("%.2f", (sum - discount));

                Object art = item.get("code");
                String article;
                if (art instanceof String)
                    article = (String) art;
                else if (art instanceof Double)
                    article = String.format("%d", ((Double) art).intValue());
                else if (art instanceof Integer)
                    article = String.format("%d", (Integer) art);
                else
                    article = "";

                String itemName = (String) item.get("name");
                if (itemName == null) itemName = "";

                fiscalCore.PrintRecItem(count, total, itemName, article, callback);
            }
        }
        fiscalCore.PrintRecTotal(callback);
        if (address != null && !address.isEmpty()) {
            fiscalCore.SendClientAddress(address, callback);
        }
        fiscalCore.PrintRecItemPay(payType, cash, payTypeName, callback);
        fiscalCore.CloseRec(callback);
        callback.Complete();
    }


}
