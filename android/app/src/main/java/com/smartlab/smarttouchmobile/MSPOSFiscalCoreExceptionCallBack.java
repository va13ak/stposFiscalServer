//
//  @author Valery Zakharov <va13ak@gmail.com>
//  @date 2018-05-16 18:47:45
//

package com.smartlab.smarttouchmobile;

import android.util.Log;

import com.multisoft.drivers.fiscalcore.IExceptionCallback;

public class MSPOSFiscalCoreExceptionCallBack extends IExceptionCallback.Stub {
        private static final String TAG = "smarttouchpos";

        private int Uninitialized = 0xFF;
        String msg;
        int err = Uninitialized;
        int exterr;
        String trace;

        @Override
        public void HandleException ( int errCode, String message,int extErrCode, String stackTrace) {
            msg = message;
            err = errCode;
            exterr = extErrCode;
            trace = stackTrace;

            Log.e(TAG, String.format("(%n) %s (%s)/n%s", errCode, message, extErrCode, stackTrace));
        }

        public void Complete () throws Exception {
        if (err != Uninitialized) {
            Exception e = new Exception(msg);
            err = Uninitialized;
            throw e;
        }

    }

}
