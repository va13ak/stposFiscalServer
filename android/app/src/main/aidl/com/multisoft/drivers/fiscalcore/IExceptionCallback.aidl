// IExceptionCallback.aidl
package com.multisoft.drivers.fiscalcore;

interface IExceptionCallback {
    void HandleException(int errCode, String message, int extErrCode, String stack);
}
