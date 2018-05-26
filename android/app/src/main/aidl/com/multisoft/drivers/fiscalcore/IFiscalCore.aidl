package com.multisoft.drivers.fiscalcore;

import com.multisoft.drivers.fiscalcore.IExceptionCallback;
import com.multisoft.drivers.fiscalcore.IAuth;

/*! \mainpage Интерфейс фискального ядра IFiscalCore
 * 
 * \section intro_sec Введение
 * Данная документация описывает интерфейс фискального ядра
 * предназначена для разработчиков, выполняющих интеграцию учётных программ с фискальным ядром.
 * Необходимы базовые знания <a href="https://developers.google.com/training/courses/android-fundamentals">Adnroid</a>, 
 * <a href="https://developer.android.com/reference/android/app/Activity.html">Activity</a>, 
 * <a href="https://developer.android.com/reference/android/app/Application.html">Application</a>, 
 * <a href="https://developer.android.com/reference/android/content/Intent.html">Intent</a>, 
 * <a href="https://developer.android.com/guide/components/services.html">services</a>.
 *
 * \subsection connection_sec Подключение к фискальному ядру 
 * <para>Подключение осуществляется при помощи <a href="https://developer.android.com/reference/android/content/Intent.html">Intent</a></para>
 * <para>Имя пакета для подключения: "com.multisoft.drivers.fiscalcore"</para>
 * <para>Имя компонента для подключения: "com.multisoft.fiscalcore"</para>
 * <para>Наименование действия для Intent: "com.multisoft.drivers.fiscalcore.IFiscalCore"</para>
 * <para>После получения интерфейса фискального ядра необходимо дождаться его инициализации при помощи функции IFiscalCore.IsReady.</para>
 *
 * \subsection enums_sec Используемые перечисления
 *
 *  com.multisoft.drivers.fiscalcore
 *
 * \subsection info_sec Общая информация
 * Если в процессе выполнения функции произошло прерывание, вызывается переданный в неё коллбек IExceptionCallback (если объявлен и не null),
 * В этом случае на на выход функции передаётся, по возможности, заведомо некорректное значение.
 * Для целочисленных переменных это -1, для строк - пустая строка, для булевых - false.
 *
 * \section sreucture_sec Структура
 *
 * \subsection main_sec Основные команды ядра
 * <para>В этом блоке находятся команды запроса версии, проверки готовности интерфейса фискального ядра и автотестирования</para>
 * <para>IFiscalCore.IsReady</para>
 * <para>IFiscalCore.GetAidlVersion</para>
 * <para>IFiscalCore.SelfTest</para>
 * 
 * \subsection service_sec Сервисные команды
 * <para>IFiscalCore.SetSerial</para>
 * <para>В том числе команды для внутреннего использования (на момент 1.5.24): </para>
 * <para>IFiscalCore.GetUUID</para>
 * <para>IFiscalCore.GetFiscalModuleVersion</para>
 * 
 * \subsection local_sec Локализация
 * <para>Опционально: установка локализации перед началом работы.</para>
 * <para>По умолчанию: Ru-ru</para>
 * <para>Поддерживаемые локализации: Ru-ru, в разработке En-en</para>
 * <para>Запрос локализации осуществляется через IFiscalCore.GetLang</para>
 * <para>Установка локализации осуществляется через Intent.PutExtras перед подключением к ядру</para>
 * 
 * \subsection kktstat_sec Статус ККТ
 * <para>IFiscalCore.GetRegNum</para>
 * <para>IFiscalCore.GetSerial</para>
 * <para>IFiscalCore.GetAppVersion</para>
 * <para>IFiscalCore.GetTaxId</para>
 * <para>IFiscalCore.GetKKTRegisteredName</para>
 * 
 * \subsection fnstat_sec Чтение статуса ФН
 * <para>IFiscalCore.FNGetNumber</para>
 * <para>IFiscalCore.FNGetState</para>
 * <para>IFiscalCore.FNGetWarningFlags</para>
 * <para>IFiscalCore.FNGetCurrentDocType</para>
 * <para>IFiscalCore.FNGetDocDataStatus</para>
 * <para>IFiscalCore.FNGetLastDocDateTime</para>
 * <para>IFiscalCore.FNGetSoftwareVersion</para>
 * <para>IFiscalCore.FNGetFirmwareType</para>
 * <para>IFiscalCore.FNGetLastFDNumber</para>
 * <para>IFiscalCore.FNGetLifetime</para>
 * <para>IFiscalCore.FNGetRegistrationsMade</para>
 * <para>IFiscalCore.FNGetRegistrationsLeft</para>
 * <para>IFiscalCore.FNGetRegTimeFirst</para>
 * <para>IFiscalCore.FNGetRegTimeByNum</para>
 * <para>IFiscalCore.FNGetLastFDNum</para>
 * <para>IFiscalCore.FNGetLastFiscalSign</para>
 * <para>IFiscalCore.FNGetRegTaxSystemByNum</para>
 * <para>IFiscalCore.FNGetOpModeByNum</para>
 *
 * 
 * \subsection ofdstat_sec Состояние ОФД
 * <para>IFiscalCore.OFDGetConnectionStatus</para>
 * <para>IFiscalCore.OFDGetQueuedMessagesCount</para>
 * <para>IFiscalCore.OFDGetMessageStatus</para>
 * <para>IFiscalCore.OFDGetFirstQueuedDocNumber</para>
 * <para>IFiscalCore.OFDGetLastNotSentDocTime</para>
 * 
 * \subsection shiftstat_sec Состояние смены
 * <para>IFiscalCore.GetDayState</para>
 * <para>IFiscalCore.GetDayNumber</para>
 * <para>IFiscalCore.GetDayLastReceiptNumber</para>
 * 
 * \subsection shiftstatreports_sec Состояние смены: отчёты
 * <para>IFiscalCore.PrintXReport</para>
 * <para>IFiscalCore.GetDayCanceledTotal</para>
 * <para>IFiscalCore.GetDayPayCount</para>
 * <para>IFiscalCore.GetDayOpenDateTime</para>
 * <para>IFiscalCore.GetDayPayTotal</para>
 * <para> IFiscalCore.GetPayTotal</para>
 * 
 * \subsection reg_sec Регистрация
 * <para>IFiscalCore.Register</para>
 * <para>IFiscalCore.CorrectRegistration</para>
 * <para>IFiscalCore.CloseFiscalMode</para>
 * 
 * \subsection shift_sec Смена
 * <para>IFiscalCore.OpenDay</para>
 * <para>IFiscalCore.CloseDay</para>
 * <para>IFiscalCore.PrintCalculationsReport</para>
 * 
 * \subsection rec_sec Чек
 * <para>IFiscalCore.OpenRec</para>
 * <para>IFiscalCore.GetRecType</para>
 * <para>IFiscalCore.GetRecState</para>
 * <para>IFiscalCore.SetTaxationUsing</para>
 * <para>IFiscalCore.GetTaxation</para>
 * <para>IFiscalCore.CloseRec</para>
 * <para>IFiscalCore.PrintRecItemPay</para>
 * <para>IFiscalCore.PrintLine</para>
 * <para>IFiscalCore.RecVoid</para>
 * <para>IFiscalCore.PrintQRCode</para>
 * <para>IFiscalCore.PrintBarCode</para>
 * <para>IFiscalCore.Feed</para> 
 * 
 * \subsection payhelp_sec Вспомогательные функции для проведения оплат
 * <para>IFiscalCore.GetRecTotal</para>
 * <para>IFiscalCore.CheckDrawerCash</para>
 * <para>IFiscalCore.PrintRecTotal</para>
 * <para>IFiscalCore.SetItemTaxes</para>
 * <para>IFiscalCore.SetShowTaxes</para>
 * <para>IFiscalCore.PrintRecItem</para>
 * 
 * \subsection corrrec_sec Чек коррекции
 * <para>IFiscalCore.FNMakeCorrectionRec</para>
 * 
 * \subsection ofqueryinfo_sec Запрос информации о подтверждении документа от ОФД
 * <para>IFiscalCore.QueryOFDReceiptByNum</para>
 * <para>IFiscalCore.OfdOut_GetTime</para>
 * <para>IFiscalCore.OfdOut_GetFDNumber</para>
 * <para>IFiscalCore.OfdOut_GetFiscalSign</para>
 * <para>IFiscalCore.OfdOut_GetSize</para>
 * 
 * \subsection archive_sec Работа с архивом ФН
 * <para>IFiscalCore.QueryFiscalDocInfo</para>
 * <para>IFiscalCore.FDI_GetDocType</para>
 * <para>IFiscalCore.FDI_GetConfirmFromOFD</para>
 * <para>IFiscalCore.FDI_GetDataArray</para>
 * 
 * \subsection archiveprint_sec Печать из архива
 * <para>IFiscalCore.FNPrintDocFromArchive</para>

 * \subsection setparams_sec Запрос и установка параметров
	<para>Данный блок методов позволяет настраивать параметры ККТ в режиме реального времени.</para>
    <para>Чтобы при следующей загрузке ядра настройки были применены, их нужно сохранить функцией SaveOptions</para>
    <para>После изменения основных или некоторых дополнительных параметров необходимо провести перерегистрацию, </para>
	 <para>в причине указав соответствующие изменения.</para>
    <para>Чтобы изменить сразу несколько групп параметров, например, произвести смену ОФД и смену реквизитов пользователя,
    нужно сначала выполнить настройку этих групп последовательно, выполнив шаги 1 и 2 для каждй из групп в отдельности.</para>
    <para>То есть, сначала изменить настройки, связанные с ОФД, затем шаги 1 и 2, после чего аналогичные действия для
    реквизитов пользователя.</para>	
 *  <para>В этом блоке находятся методы для настройки аппарата перед регистрацией.</para>
 *  <para>Под "пользователем" следует понимать организацию - пользователя КТТ</para>
	
 * \subsection ofdsettings_sec Параметры ОФД
 *
 * <para><b>Установка параметров ОФД</b></para>
 * <para>IFiscalCore.SetOfdHost</para>
 * <para>IFiscalCore.SetOfdPort</para>
 * <para>IFiscalCore.SetOfdName</para>
 * <para>IFiscalCore.SetOfdTaxId</para>
 *
 * <para><b>Запрос параметров ОФД</b></para>
 * <para>IFiscalCore.GetOfdHost</para>
 * <para>IFiscalCore.GetOfdPort</para>
 * <para>IFiscalCore.GetOfdName</para>
 * <para>IFiscalCore.GetOfdTaxId</para>
	
 * \subsection mainsettings_sec Основные настройки
 *
 * <para><b>Установка основных настроек</b></para>
 * <para>IFiscalCore.SetOrgName</para>
 * <para>IFiscalCore.SetOrgAddress</para>
 * <para>IFiscalCore.SetPhysicalAddress</para>
 * <para>IFiscalCore.SetSenderEmail</para>
 * <para>IFiscalCore.SetReceiptCheckURI</para>
 * <para>IFiscalCore.SetFnsServerAddress</para>
 *
 * <para><b>Запрос основных настроек</b></para>
 * <para>IFiscalCore.GetOrgName</para>
 * <para>IFiscalCore.GetOrgAddress</para>
 * <para>IFiscalCore.GetPhysicalAddress</para>
 * <para>IFiscalCore.GetSenderEmail</para>
 * <para>IFiscalCore.GetReceiptCheckURI</para>
 * <para>IFiscalCore.GetFNSServerAddress</para>
 * <para>IFiscalCore.GetCashierTaxId</para>
 * <para>IFiscalCore.GetExtendedAutotest</para>
 * <para>IFiscalCore.GetVendingSerial</para>
	
 * \subsection addsettings_sec Дополнительные настройки
 *  <para>Нужны при регистрации ККТ только в некоторых режимах работы.</para>
 *  <para>Если испольльзуются, их необходимо указывать до вызова функции регистрации/перерегистрации.</para>
 *
 * <para><b>Установка дополнительных настроек</b></para>
 * <para>IFiscalCore.SetCashierTaxId</para>
 * <para>IFiscalCore.SetVendingSerial</para>
 * <para>IFiscalCore.SetExtendedAutotest</para>
 * <para>IFiscalCore.SetTransferOperatorName</para>
 * <para>IFiscalCore.SetTransferOperatorTaxId</para>
 * <para>IFiscalCore.SetTransferOperatorTelNum</para>
 * <para>IFiscalCore.SetTransferOperatorAddress</para>
 * <para>IFiscalCore.SetPaymentAgentTelNum</para>
 * <para>IFiscalCore.SetPaymentAgentOperation</para>
 * <para>IFiscalCore.SetCommissionAgentTelNum</para>
 * <para>IFiscalCore.SetContractorTelNum</para>
 * <para>IFiscalCore.SetCutType</para>
 * <para>IFiscalCore.SetHeaderLines</para>
 * <para>IFiscalCore.SetTrailerLines</para>
 * <para>IFiscalCore.SetPrePrintHeaderLines</para>
 * <para>IFiscalCore.SetDayCloseAutoPayOut</para>
 *
 *	<para><b>Запрос дополнительных настроек</b></para>
 * <para>IFiscalCore.GetTransferOperatorName</para>
 * <para>IFiscalCore.GetTransferOperatorTaxId</para>
 * <para>IFiscalCore.GetTransferOperatorTelNum</para>
 * <para>IFiscalCore.GetTransferOperatorAddress</para>
 * <para>IFiscalCore.GetPaymentAgentTelNum</para>
 * <para>IFiscalCore.GetPaymentAgentOperation</para>
 * <para>IFiscalCore.GetCommissionAgentTelNum</para>
 * <para>IFiscalCore.GetContractorTelNum</para>
	
 * \subsection applysettings_sec Применение настроек
 * Используется для сохранения настроек в памяти ККТ.
 * При удалении фискального ядра, а также сбросе к заводским настройкам сохранённые данные стираются.
 * <para>IFiscalCore.SaveOptions</para>
 * Основные настройки должны быть установлены и сохранены перед регистрацией ККТ.
 * 
 * \subsection othersettings_sec Временные настройки
 * Команды данной группы имеют ограниченное действие, например, только для текущего документа.
 * Либо устанавливают одиночное значение, и не имеют действия при повторном вызове.
 * <para>IFiscalCore.SetDateTime</para>
 * <para>IFiscalCore.SetUserName</para>
 * <para>IFiscalCore.SendClientAddress</para>
 * <para>IFiscalCore.ForcePrintForm</para>
 */ 
  
interface IFiscalCore
{
    // **************************** Основные команды ядра **************************** //

    /// <summary>
    /// <para><b>основные команды ядра</b></para>
    /// <para>запрос версии сервиса</para>
	/// <para>формат версии: Major.Minor.Release.Build;</para>
	/// <para>Major   - старшая версия aidl, изменение версии указвает на изменение порядка функций / их сигнатур;</para>
	/// <para>Minor   - младшая версия aidl, изменение версии указвает на добавление функции, обратная совместимость;</para>
	/// <para>Release - версия приложения, инкрементируется с релизом.;</para>
	/// <para>Build   - версия сборки, выставляется автоматически в момент сборки;</para>
    /// </summary>
    /// <returns>строка, например, 1.4.18.18103</returns>
    String GetAidlVersion();

    void DirectIO(int cmd, String argument, IAuth auth, IExceptionCallback callback);

    /// <summary>
    /// <para><b>основные команды ядра</b></para>
    /// запрос готовности сервиса. Выполняется  каждый раз перед началом работы, как в примере
    /// </summary>
    /// <returns>true - сервис готов. false - не готов</returns>
    ///  <example>
    ///		пример использования, выполняется перед началом работы:
    ///     <code>
    ///         //команды подключения к сервису
    ///         while(!icore.IsReady())
    ///				Thread.Sleep(50);
    ///			icore.SelfTest(callback);
    ///			//команды открытия смены, и т.д.
    ///		</code>
    /// </example>
    boolean IsReady();

    // **************************** Автотестирование **************************** //

    /// <summary>
    /// <para><b>основные команды ядра</b></para>
    /// <para>автотестирование</para>
    /// выполняет функцию автотестирования и печатает чек автотеста.
    /// <seealso cref="SetExtendedAutotest"/> 
    /// </summary>
    /// <param name="callback"></param>
    /// <example>
    ///		пример использования, выполняется перед началом работы:
    ///     <code>
    ///         //команды подключения к сервису
    ///         while(!icore.IsReady())
    ///				Thread.Sleep(50);
    ///			icore.SelfTest(callback);
    ///			//команды открытия смены, и т.д.
    ///		</code>
    /// </example>
    void SelfTest(IExceptionCallback callback);


    // **************************** Сервисные команды **************************** //
    /// <summary>
    /// <para><b>plaftorm-specific</b></para>
    /// <para><b>Сервисные команды</b></para>
    /// запрос GUUID
    /// </summary>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <returns>строка c GUUID</returns>
    String GetUUID(IExceptionCallback callback);

    /// <summary>
    /// <para><b>plaftorm-specific</b></para>
    /// <para><b>Сервисные команды</b></para>
    /// запрос версии фискального модуля
    /// </summary>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <returns>строка c версией.</returns>
    String GetFiscalModuleVersion(IExceptionCallback callback);

    // **************************** Локализация **************************** //
    /// <summary>
    /// <para><b>локализация</b></para>
    /// Вернуть используемый язык || запрос текущей локализации. По умолчанию "Ru-ru".
    /// задаётся при подключении к сервису через параметры intent-а
    /// </summary>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <returns>"Ru-ru" или "En-en"</returns>
    /// <example>
    ///		пример установки языка, выполняется при установке соединения с сервисом:
    ///     <code>
	///         //...создание serviceIntent
    ///         Bundle bundle = new Bundle();
    ///         bundle.PutString("lang", "Ru-ru");
    ///         serviceIntent.PutExtras(bundle);
    ///         var connection = new ExtFiscalCoreServiceConnection(this);
    ///         BindService(serviceIntent, connection, Bind.AutoCreate);
    ///		</code>
    /// </example>
    String GetLang(IExceptionCallback callback);


    // **************************** Статус ККТ **************************** //
    /// <summary>
	/// <para><b>Статус ККТ</b></para></para>
    /// <para>Возвращает регистрационный номер ККТ</para>
    /// <para>если ККТ не зарегистрирована, возвращается строка, заполненная символами "X"</para>
    /// </summary>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <returns>регистрационный номер ККТ в виде строки, например, "1234567890"</returns>
    String GetRegNum(IExceptionCallback callback);

    /// <summary>
	/// <para><b>Статус ККТ</b></para>
	/// Возвращает серийный номер ККТ
    /// </summary>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <returns>строка из 10 символов</returns>
    String GetSerial(IExceptionCallback callback);

    /// <summary>
	/// <para><b>Статус ККТ</b></para>
    /// Возвращает полную версию ПО ядра (для внутреннего использования)
    /// </summary>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <returns>строка из 4 чисел формата: Major.Minor.Build.Revision</returns>
    String GetAppVersion(IExceptionCallback callback);

    /// <summary>
	/// <para><b>Статус ККТ</b></para>
    /// Вернуть ИНН, указанный при регистрации
    /// </summary>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <returns>строка - ИНН при последней регистрации.
    /// Если ККТ не зарегистрирована, возвращается строка, заполненная 'X'</returns>
    String GetTaxId(IExceptionCallback callback);

    // **************************** Чтение статуса ФН  **************************** //
    /// <summary>
    /// <para><b>Чтение статуса ФН</b></para>
    /// получить номер ФН
    /// </summary>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <returns>строка c номером ФН</returns>
    String FNGetNumber(IExceptionCallback callback);

    /// <summary>
	/// <para><b>Чтение статуса ФН</b></para>
    /// Запрос состояния ФН
    /// </summary>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <returns>состояние ФН</returns>
    /// <seealso cref="com.multisoft.drivers.fiscalcore.FNState"/>
    /// <example>пример использования:
    ///   <code>
    ///     //инициализация cashier, INN, regnum, tax, opmode, gamblingTag, lotteryTag, agent
    ///		if(icore.FNGetState(callback) == FNState.ReadyToFiscalization)
    ///     {
    ///        icore.Register(cashier, INN, regnum, tax, opmode, gamblingTag, lotteryTag, agent, callback);
    ///     }
    ///   </code>
    /// </example>
    int FNGetState(IExceptionCallback callback);

    /// <summary>
	/// <para><b>Чтение статуса ФН</b></para>
    /// Запрос флагов предупредлений ФН. Используется ККТ для запроса текущего состояния ФН.
    /// </summary>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <returns> флаги предупреждения (если есть)</returns>
	/// <seealso cref="com.multisoft.drivers.fiscalcore.WarningFlag"/>
	/// <example>проверка состояния ФН перед печатью чеков:
    ///   <code>
    ///     var warning = (WarningFlag)icore.FNGetWarningFlags(callback)
    ///     if(WarningFlag.OK == warning)
    ///         //предупреждений нет, можно работать
    ///   </code>
    /// </example>
    int FNGetWarningFlags(IExceptionCallback callback);

    /// <summary>
	/// <para><b>Чтение статуса ФН</b></para>
    /// Запрос текущего документа из ФН. Используется ККТ для запроса текущего состояния ФН.
    /// </summary>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <returns>число CurrentDoc - тип текущего документа</returns>
	/// <seealso cref="com.multisoft.drivers.fiscalcore.CurrentDoc"/>
	/// <example>пример использования: проверка, не открыт ли документ в ФН
    ///   <code>
    ///		if((CurrentDoc)icore.FNGetCurrentDocType(callback) != CurrentDoc.NoDoc)
    ///       icore.RecVoid();//отменяем документ в ККТ и в ФН
    ///   </code>
    /// </example>
    int FNGetCurrentDocType(IExceptionCallback callback);

    /// <summary>
    /// <para><b>Чтение статуса ФН</b></para>
    /// Запрос ФН о статусе получения данных текущего документа. Используется ККТ для запроса текущего состояния ФН.
    /// </summary>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <returns>DocData.DataAcquired или DocData.Nodata в зависимости от того, были ли данные о документе переданы в ФН</returns>
    /// <seealso cref="com.multisoft.drivers.fiscalcore.DocData"/>
    /// <example>пример использования:
    ///   <code>
	///     //Запрос статуса ФН
	///		var currentDoc = (CurrentDoc)icore.FNGetCurrentDocType(callback);
	///		string status = docType.ToString() + "\n";
	///		if(currentDoc == CurrentDoc.NoDoc)
    ///     	status += (DocData)icore.GetFNDocDataStatus(callback).ToString() + "\n";
    ///   </code>
    /// </example>
    int FNGetDocDataStatus(IExceptionCallback callback);

    /// <summary>
	/// <para><b>Чтение статуса ФН</b></para>
    /// Запрос даты и времени последнего фискального документа
    /// </summary>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <returns>строка, содержащая дату и время последнего фискального документа в формате "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'fff'Z'". 
    /// </returns>
    String FNGetLastDocDateTime(IExceptionCallback callback);

    /// <summary>
    /// <para><b>Чтение статуса ФН</b></para>
    /// Запрос версии ПО ФН
    /// </summary>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <returns>строка - версия ПО ядра</returns>
    String FNGetSoftwareVersion(IExceptionCallback callback);

    /// <summary>
	/// <para><b>Чтение статуса ФН</b></para>
    /// Запрос типа ПО ФН
    /// </summary>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <returns>тип ПО ФН: дебаг или релиз</returns>
    /// <seealso cref="com.multisoft.drivers.fiscalcore.FirmwareTypes"/>
    int FNGetFirmwareType(IExceptionCallback callback);

    /// <summary>
	/// <para><b>Чтение статуса ФН</b></para>
    /// Запрос номера последнего фискального документа из ФН (выполняет запрос в ФН)
    /// </summary>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <returns>номер последнего фискального документа</returns>
    int FNGetLastFDNumber(IExceptionCallback callback);

    /// <summary>
	/// <para><b>Чтение статуса ФН</b></para>
    /// Запрос даты и времени окончания действия ФН, по истечении которого ФН становится недействительным
    /// </summary>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <returns>строка - дата и время в формате: "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'fff'Z'"
	/// </returns>
    String FNGetLifetime(IExceptionCallback callback);

    /// <summary>
    /// <para><b>Чтение статуса ФН</b></para>
    /// Запрос количества выполненных регистраций ФН
    /// </summary>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <returns>число - количество выполненных регистраций</returns>
    int FNGetRegistrationsMade(IExceptionCallback callback);

    /// <summary>
	/// <para><b>Чтение статуса ФН</b></para>
    /// Запрос количества оставшихся регистраций ФН
    /// </summary>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <returns>число - количество оставшихся регистраций</returns>
    int FNGetRegistrationsLeft(IExceptionCallback callback);

    /// <summary>
    /// <para><b>Чтение статуса ФН</b></para>
    /// Запрос времени первой регистрации (фискализации) ФН.
    /// </summary>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <returns>строка, содержащая дату и время последней регистрации ФН в формате: "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'fff'Z'"
    /// если ККТ не зарегистрирована, возвращается "01.01.2000 0:00:00"
    ///</returns>
    String FNGetRegTimeFirst(IExceptionCallback callback);

    /// <summary>
	/// <para><b>Чтение статуса ФН</b></para>
    /// Запрос времени регистрации ФН.
    /// </summary>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <param name="regNum"> номер регистрации, положительное число</param>
    /// <returns>строка, содержащая дату и время последней регистрации ФН в формате: "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'fff'Z'"
	/// </returns>
	/// <example>пример использования:
    ///   <code>
    ///		var lastregNum = FNGetRegistrationsMade(callback);
	///		if(0 != lastregNum )
	///			SomeTextBox.Text = icore.FNGetRegTimeByNum(lastregNum);
    ///   </code>
    /// </example>
    String FNGetRegTimeByNum(int regNum, IExceptionCallback callback);


    // ****************************  Состояние ОФД ****************************

    /// <summary>
    /// <para><b>Состояние ОФД</b></para>
    /// Запрос состояния соединения с ОФД
    /// </summary>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <returns>статус соединения</returns>
    /// <seealso cref="com.multisoft.drivers.fiscalcore.ConnectionState"/>
    int OFDGetConnectionStatus(IExceptionCallback callback);

    /// <summary>
	/// <para><b>Состояние ОФД</b></para>
    /// Запрос количества документов, ожидающих отправки в ОФД
    /// </summary>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <returns>число - количество сообщений</returns>
    int OFDGetQueuedMessagesCount(IExceptionCallback callback);

    /// <summary>
	/// <para><b>Состояние ОФД</b></para>
    /// Запрос состояния чтения ответа из ОФД на преданное сообщение
    /// </summary>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <returns>true - чтение начато, false - чтение не начато</returns>
    boolean OFDGetMessageStatus(IExceptionCallback callback);

    /// <summary>
	/// <para><b>Состояние ОФД</b></para>
    /// Запрос номера документа, находящегося первым в очереди на отправку в ОФД
    /// </summary>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <returns>число - номер документа в очереди</returns>
    int OFDGetFirstQueuedDocNumber(IExceptionCallback callback);

    /// <summary>
	/// <para><b>Состояние ОФД</b></para>
    /// дата последнего непереданного в ОФД документа
    /// </summary>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <returns>строка - дата последнего непереданного документа</returns>
    String OFDGetLastNotSentDocTime(IExceptionCallback callback);


    // ****************************  Состояние смены ****************************

    /// <summary>
	/// <para><b>Cостояние смены</b></para>
    /// Вернуть состояние смены.
    /// </summary>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <returns>состояние смены:</returns>
    /// <seealso cref="com.multisoft.drivers.fiscalcore.DayState"/>
    /// <example>пример использования:
    /// <code>
    ///		SomeTextBox.Text = (icore.GetDayState(callback)
    ///                   ? context.Resources.GetString(Resource.String.Yes)
    ///                   : context.Resources.GetString(Resource.String.No)
    /// </code>
    /// </example>
    int GetDayState(IExceptionCallback callback);

    /// <summary>
    /// <para><b>Cостояние смены</b></para>
    /// Вернуть номер смены.
    /// </summary>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <returns>число - номер смены</returns>
    int GetDayNumber(IExceptionCallback callback);

    /// <summary>
	/// <para><b>Cостояние смены</b></para>
    /// Вернуть номер последнего документа в смене.
    /// </summary>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <returns>число - номер последнего документа в смене</returns>
    int GetDayLastReceiptNumber(IExceptionCallback callback);

    // ****************************  Состояние смены: отчёты ****************************
    /// <summary>
    /// <para><b>Состояние смены: отчёты</b></para>
    /// печать х-отчёта
    /// </summary>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    void PrintXReport(IExceptionCallback callback);

    /// <summary>
    /// <para><b>Состояние смены: отчёты</b></para>
    /// запрос суммы за смену по отменённым документам
    /// </summary>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <returns>строка - сумма по отменённым документам</returns>
    String GetDayCanceledTotal(IExceptionCallback callback);

    /// <summary>
    /// <para><b>Состояние смены: отчёты</b></para>
    /// запрос значения счётчика операций
    /// </summary>
    /// <param name="counterType">тип счётчика</param>
    /// <seealso cref="com.multisoft.drivers.fiscalcore.Counter"/>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <returns>количество выполненных операций</returns>
    int GetDayPayCount(int counterType, IExceptionCallback callback);

    /// <summary>
    /// <para><b>Состояние смены: отчёты</b></para>
    /// запрос даты и времени открытия смены
    /// </summary>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <returns>строка - дата и мремя открытия смены в формате "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'fff'Z'"</returns>
    String GetDayOpenDateTime(IExceptionCallback callback);

    /// <summary>
    /// <para><b>Состояние смены: отчёты</b></para>
    /// запрос суммы по типу счётчика
    /// </summary>
    /// <param name="counterType">тип счётчика</param>
    /// <seealso cref="com.multisoft.drivers.fiscalcore.Counter"/>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <returns>сумма по счётчику</returns>
    String GetDayPayTotal(int counterType, IExceptionCallback callback);

    // **************************** Регистрация ****************************
    /// <summary>
    /// <para><b>Регистрация</b></para>
    /// Регистрация (первоначальная регистрация). Выполняется 1 раз за всё время жизни ФН.
    /// </summary>
    /// <param name="cashier">строка - имя и номер кассира</param>
    /// <param name="inn">строка - ИНН пользователя при регистрации</param>
    /// <param name="reg_num">строка - регистрационный номер ККТ</param>
    /// <param name="tax">байт - код системы налогообложения - битовая маска TaxCode.
    /// Поддеживаемый тип налогов устанавливает соответствующий бит в байте. 
    /// Для корректной работы необходимо установить хотя бы один бит в 1.</param>
    /// <param name="op_mode">байт - код режима работы - битовая маска OperatingMode.
    /// Поддеживаемый режим работы устанавливает соответствующий бит в байте.
    /// Может принимать значение 0.</param>
    /// <param name="gambling">true или false - признак проведения азартных игр</param>
    /// <param name="lottery">true или false - признак проведения лотереи</param>
    /// <param name="agent">байт - код платёжного агента - битовая маска AgentTag.
    /// Поддеживаемый код платёжного агента устанавливает соответствующий бит в байте.
    /// Может принимать значение 0.</param>
    /// <seealso cref="com.multisoft.drivers.fiscalcore.TaxCode"/>
    /// <seealso cref="com.multisoft.drivers.fiscalcore.OperatingMode"/>
    /// <seealso cref="com.multisoft.drivers.fiscalcore.AgentTag"/>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <example>
    ///     <code>
    ///         //команды настройки полей:
    ///          String cashier = CashierTextBox.Text;
    ///          String INN = innTextBox.Text;
    ///          String regnum = RegNumTextBox.Text;
    ///          //настройка системы налогообложения
    ///          int tax = TaxCode.Common + TaxCode.SimplifiedWithExpense + TaxCode.ENVD;
    ///          //настройка режима работы:
    ///          int opmode = OperatingMode.Service + OperatingMode.Automatic;
    ///          bool gamblingTag = false;
    ///          bool lotteryTag = false;
    ///          //настройка агента:
    ///          int agent = AgentTag.BankPayAgent + AgentTag.BankPaySubAgent;
    ///          //установлены 1й и 2й биты, благодаря нумерации полей в AgentTag
    ///          //проверка номера перед регистрацией. выполните проверку GetExpectedRegNum
    ///          if(regnum == GetExpectedRegNum(icore.GetSerial(callback),INN))
    ///            //регистрация:
    ///            icore.Register(cashier, INN, regnum, tax, opmode, gamblingTag, lotteryTag, agent, callback);
    ///     </code>
    /// </example>
    void Register(String cashier, String inn, String reg_num, int tax, int op_mode,
boolean gambling, boolean lottery, int agent, IExceptionCallback callback);

    /// <summary>
    /// <para><b>Регистрация</b></para>
    /// Исправление регистрации || Перерегистрация
    /// </summary>
    /// <param name="corr_reason">причина перерегистрации CorrectionReason</param>
    /// <param name="inn">строка - ИНН пользователя при регистрации</param>
    /// <param name="reg_num">строка - регистрационный номер ККТ</param>
    /// <param name="tax_code">байт - код системы налогообложения - битовая маска TaxCode.
    /// Поддеживаемый тип налогов устанавливает соответствующий бит в байте.
    /// Для корректной работы необходимо установить хотя бы один бит в 1.</param>
    /// <param name="opmode">байт - код режима работы - битовая маска OperatingMode.
    /// Поддеживаемый режим работы устанавливает соответствующий бит в байте.
    /// Может принимать значение 0.</param>
    /// <param name="gambling">true или false - признак проведения азартных игр</param>
    /// <param name="lottery">true или false - признак проведения лотереи</param>
    /// <param name="agent">байт - код платёжного агента - битовая маска AgentTag.
    /// Поддеживаемый код платёжного агента устанавливает соответствующий бит в байте.
    /// Может принимать значение 0.</param>
    /// <seealso cref="com.multisoft.drivers.fiscalcore.CorrectionReason"/>
    /// <seealso cref="com.multisoft.drivers.fiscalcore.TaxCode"/>
    /// <seealso cref="com.multisoft.drivers.fiscalcore.OperatingMode"/>
    /// <seealso cref="com.multisoft.drivers.fiscalcore.AgentTag"/>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <example>
    ///     <code>
    ///       INN = innTextBox.Text;
    ///       reason = CorrResason.ChangeKKTSettings;
    ///       kktRegNum = regNumTextBox.Text;
    ///       tax = TaxCode.Common + TaxCode.SimplifiedWithExpense + TaxCode.ENVD;
    ///       opMode = OperatingMode.Service + OperatingMode.Automatic;
    ///       agentTag =  AgentTag.BankPayAgent + AgentTag.BankPaySubAgent;
    ///       gamblingTag = false;
    ///       lotteryTag = false;
    ///       if(kktRegNum == GetExpectedRegNum(icore.GetSerial(),INN))
    ///        icore.CorrectRegistration(reason, cashier.Text, INN, kktRegNum, (int)opMode,  tax, gamblingTag, lotteryTag, agentTag,callback);
    ///     </code>
    /// </example> 
    void CorrectRegistration(int corr_reason, String cashier, String inn, String reg_num, int tax_code, int op_mode,
 boolean gambling, boolean lottery, int agent, IExceptionCallback callback);

    /// <summary>
	/// <para><b>Регистрация</b></para>
    /// <para>Закрытие архива ФН. Необратимая для пользователя операция.</para>
    /// <para>После выполнения работа с ФН невозможна до следующей регистрации.</para>
    /// </summary>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    void CloseFiscalMode(IExceptionCallback callback);


    // **************************** Смена ****************************

    /// <summary>
    /// <para><b>Смена</b></para>
    /// Открыть смену
    /// </summary>
    /// <param name="cashier">имя и номер кассира</param>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <example>пример использования:
    ///   <code>
    ///       try
	///		  {
	///           //если клиентская реализация callback генерирует исключения,
	///           // то все функции работы с чеками можно поместить в один блок try-catch
	///		      icore.OpenDay(cashierTextBox.Text,callback);
	///			  callback.WaitException();//генерирует исключение, если callback был вызван
	///           //команды работы с чеками
	///		  }
	///       catch(Exception e)
	///       {
	///          DisplayNotification(e.Message);
	///          return;
	///       }
    ///       
    ///   </code>
    /// </example>
    void OpenDay(String cashier, IExceptionCallback callback);

    /// <summary>
	/// <para><b>Смена</b></para>
    /// Напечатать Z-отчёт и закрыть смену
    /// </summary>
    /// <param name="cashier">имя и номер кассира</param>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <example>пример использования:
    /// <code>
    ///     icore.OpenDay(cashierTextBox.Text,callback);
	///     //команды работы с чеками
    ///     icore.CloseDay(cashierTextBox.Text,callback);
    ///   </code>
    /// </example>
    void CloseDay(String cashier, IExceptionCallback callback);

    /// <summary>
	/// <para><b>Смена</b></para>
    /// Напечатать отчёт о состоянии расчётов
    /// </summary>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    void PrintCalculationsReport(IExceptionCallback callback);


    // **************************** Чек ****************************

    /// <summary>
	/// <para><b>Чек</b></para>
    /// <para>Открыть чек. открывает документ одного из поддерживаемых типов.</para>
	/// <para>Eсли код документа выходит за границу RecType, открывается нефискальный документ.</para>
    /// </summary>
    /// <param name="recType">код открываемого документа
    /// </param>
    /// <seealso cref="com.multisoft.drivers.fiscalcore.RecType"/>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <example>открыть чек на продажу
    ///     <code>
    ///         icore.SetUserName(Cashier.Text,callback);
    ///         recType = (int)RecType.Sell;//приход
    ///         icore.OpenRec(recType,callback);
    ///     </code>
    /// </example>
    void OpenRec(int recType, IExceptionCallback callback);

    /// <summary>
    /// <para><b>Чек</b></para>
    /// <para>Получить тип открытого документа.</para>
    /// <para>В случае, если документ закрыт, возвращает тип последнего открытого документа.</para>
    /// </summary>
    /// <returns>тип (последнего)открытого документа</returns>
    /// <seealso cref="com.multisoft.drivers.fiscalcore.RecType"/>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <example>
    ///		пример использования
    ///     <code>
    ///         if((RecState)icore.GetRecState(callback) == RecState.Opened)
    ///             docstate = icore.GetRecType(callback);
    ///     </code>
    /// </example>
    int GetRecType(IExceptionCallback callback);

    /// <summary>
    /// <para><b>Чек</b></para>
    /// Возвращает состояние документа
    /// </summary>
    /// <returns>состояние документа</returns>
    /// <seealso cref="com.multisoft.drivers.fiscalcore.RecState"/>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <example>
    ///		проверка, был ли документ уже открыт перед открытием нового документа
    ///     <code>
    ///         if((RecState)icore.GetRecState() == RecState.Opened)
    ///             throw new Exception("документ должен быть закрыт");
    ///         icore.OpenRec((int)RecType.Sell, callback);
    ///         //команды работы с чеком: добавление позиций, оплата, и т.д.
    ///     </code>
    /// </example>
    int GetRecState(IExceptionCallback callback);

    /// <summary>
	/// <para><b>Чек</b></para>
    /// <para>Установить систему налогообложения (СНО).</para>
    /// <para>Нужна при формировании чеков, если ККТ зарегистрирована с 2 и более СНО</para>
	/// <para>Вызывается до открытия чека. Если ККТ зарегистрирована с 1 СНО, факультативна.</para>
    /// </summary>
    /// <param name="tax">используемая система налогообложения</param>
    /// <seealso cref="com.multisoft.drivers.fiscalcore.TaxCode"/>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <example>пример использования:
    ///   <code>
    ///     icore.SetUserName(Cashier.Text,callback);
    ///     recType = (int)RecType.Sell;//приход
    ///     icore.SetTaxationUsing(taxationSystem,callback);//установка системы налогообложения
    ///     icore.OpenRec(recType,callback);
    /// 
    ///     //добавление первой позиции:
    ///     icore.SetItemTaxes(item.TaxNum,callback);
    ///     icore.SetShowTaxes(true,callback);
    ///     icore.PrintRecItem(item.count, item.total, item.name, item.article,callback);
    /// 
    ///     // добавление остальных позиций
    ///     //   . . .
    ///     //
	///     icore.PrintRecTotal(callback);//печать итога
    ///     icore.PrintRecItemPay((byte)PayType.Card, emoney,"ЭЛЕКТРОННЫМИ:",callback);
    ///     icore.PrintRecItemPay((byte)PayType.Cash, cash, "НАЛИЧНЫМИ:",callback);
    ///     icore.CloseRec(callback);//закрытие документа
    ///   </code>
    /// </example>
    void SetTaxationUsing(int tax, IExceptionCallback callback);
		
    /// <summary>
    /// <para>запрос зарегистрированной системы налогообложения</para>
    /// </summary>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <returns>система налогообложения, указанная при регистрации</returns>
    /// <seealso cref="com.multisoft.drivers.fiscalcore.TaxCode"/>
    int GetTaxation(IExceptionCallback callback);

    /// <summary>
    /// <para><b>Чек</b></para>
    /// Производит закрытие документа
    /// </summary>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <example>пример использования:
    ///   <code>
    ///     icore.SetUserName(Cashier.Text,callback);
    ///     recType = (int)RecType.Sell;//приход
    ///     icore.SetTaxationUsing(taxationSystem,callback);//установка системы налогообложения
    ///     icore.OpenRec(recType,callback);
    ///     // добавление позиций
	///     // . . . 
	///     icore.PrintRecTotal(callback);//печать итога
    ///     icore.PrintRecItemPay((byte)PayType.Card, emoney,"ЭЛЕКТРОННЫМИ:",callback);
    ///     icore.PrintRecItemPay((byte)PayType.Cash, cash, "НАЛИЧНЫМИ:",callback);
    ///     icore.CloseRec(callback);//закрытие документа
    ///   </code>
    /// </example>
    void CloseRec(IExceptionCallback callback);

    /// <summary>
	/// <para><b>Чек</b></para>
    /// Провести оплату по типу платежа
    /// </summary>
    /// <param name="type">байт тип оплаты. бит </param>
    /// <seealso cref="com.multisoft.drivers.fiscalcore.PayType"/>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
	/// <example>несколько типов оплат:
    ///   <code>
    ///     //команды открытия документа и добавления позиций
	///     icore.PrintRecTotal(callback);//печать итога
    ///     icore.PrintRecItemPay((byte)PayType.Tare, cash, emoney, prepay, credit, exchange, taxationSystem,callback);
    ///     icore.PrintRecItemPay((byte)PayType.Cash, cash, emoney, prepay, credit, exchange, taxationSystem,callback);
    ///     icore.CloseRec(callback);//закрытие документа
    ///   </code>
    /// </example>
    /// <param name="total">строка - сумма оплаты</param>
    /// <param name="itemText">строка - сопутствующий текст, например, тип оплаты</param>
    void PrintRecItemPay(int type, String total, String itemText, IExceptionCallback callback);

    /// <summary>
    /// <para>Печать текста в любом месте документа. Необходимо вызывать при открытом документе</para>
    /// </summary>
    /// <param name="align">выравнивание.</param>
    /// <seealso cref="com.multisoft.drivers.fiscalcore.Align"/>
    /// <param name="line">строка текста для печати</param>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
	void PrintLine(int align, String line, IExceptionCallback callback);

    /// <summary>
    /// <para><b>Чек</b></para>
    /// Аннулировать чек
    /// </summary>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <example>пример использования: проверка, не открыт ли документ в ФН
    ///   <code>
    ///		if(icore.FNGetCurrentDocType(callback) != (int)CurrentDoc.NoDoc)
    ///       icore.RecVoid(callback);//отменяем документ в ККТ и в ФН
    ///   </code>
    /// </example>
    void RecVoid(IExceptionCallback callback);

    // **************************** Вспомогательные функции для проведения оплат ****************************

    /// <summary>
    /// <para><b>Вспомогательные функции для проведения оплат</b></para>
    /// Вернуть сумму по чеку
    /// </summary>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <returns>строка - сумма по чеку</returns>
    /// <example>пример использования:
    ///   <code>
    ///     BigDecimal recTotal = new BigDecimal(icore.GetRecTotal(callback));
    ///     icore.CheckDrawerCash(recTotal.ToString(),callback);
    ///     if (payment >= recTotal)
    ///     {
    ///         icore.PrintRecTotal(callback);//печать итога
    ///         icore.PrintRecItemPay(PayType.Cash, cash, "НАЛИЧНЫМИ:",callback);
    ///         icore.CloseRec(callback);
    ///     }
    ///   </code>
    /// </example>
    String GetRecTotal(IExceptionCallback callback);

    /// <summary>
	/// <para><b>Вспомогательные функции для проведения оплат</b></para>
    /// <para>Проверить наличие денег в денежном ящике.</para>
    /// <para>Нужна для работы вс документами "Расход" и "Возврат прихода".</para>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// </summary>
    /// <example>
    ///     <code>
    ///        BigDecimal recTotal = new BigDecimal(icore.GetRecTotal(callback));
    ///         icore.CheckDrawerCash(recTotal.ToString(),callback);
    ///         if (payment >= recTotal)
    ///         {
    ///             icore.PrintRecTotal(callback);//печать итога
    ///             icore.PrintRecItemPay(PayType.Cash, cash, "НАЛИЧНЫМИ:",callback);
    ///             icore.CloseRec(callback);
    ///         }
    ///     </code>
    /// </example>
    /// <param name="total">сумма для выдачи из кассы</param>
    void CheckDrawerCash(String total, IExceptionCallback callback);

    /// <summary>
	/// <para><b>Вспомогательные функции для проведения оплат</b></para>
    /// печать итога.
    /// </summary>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <example>производим оплату только когда сумма оплаты (payment) больше суммы по чеку
    ///     <code>
    ///         icore.SetUserName(Cashier.Text,callback);
    ///         recType = (int)RecType.Sell;//приход
    ///         icore.SetTaxationUsing(taxationSystem,callback);//установка системы налогообложения
    ///         icore.OpenRec(recType,callback);
    ///         //добавление первой позиции:
    ///         icore.SetItemTaxes(item.TaxNum,callback);
    ///         icore.SetShowTaxes(true,callback);
    ///         icore.PrintRecItem(item.count, item.total, item.name, item.article,callback);
    ///         // добавление остальных позиций
    ///         // . . .
    ///         //
	///         //установка адреса клиента. выполняется до CloseRec()
	///         icore.SendClientAddress(clientAddress,callback);
	///         icore.PrintRecTotal(callback);//печать итога
    ///         icore.PrintRecItemPay((byte)PayType.Cash, cash, "НАЛИЧНЫМИ:",callback);
    ///         icore.CloseRec(callback);//закрытие документа
    ///     </code>
    /// </example>
    void PrintRecTotal(IExceptionCallback callback);

    /// <summary>
    /// <para><b>Вспомогательные функции для проведения оплат</b></para>
    /// <para>Устанавливает налог по его порядоковому номеру. </para>
    /// <para>необходимо вызывать перед PrintRecItem.</para>
    /// </summary>
    /// <param name="taxNum">порядокуовый номер используемого налога</param>
    /// <seealso cref="com.multisoft.drivers.fiscalcore.TaxNum"/>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <example>пример использования:
    ///   <code>
    ///     icore.SetUserName(Cashier.Text,callback);
    ///     recType = (int)RecType.Sell;//приход
    ///     icore.SetTaxationUsing(taxationSystem,callback);//установка системы налогообложения
    ///     icore.OpenRec(recType,callback);
    ///     foreach(item in items)
    ///     {
    ///        icore.SetItemTaxes(item.TaxNum,callback);
    ///        icore.SetShowTaxes(true,callback);
    ///        icore.PrintRecItem(item.count, item.total, item.name, item.article,callback);
    ///     }
	///     icore.PrintRecTotal(callback);//печать итога
    ///     icore.PrintRecItemPay((byte)PayType.Card, emoney,"ЭЛЕКТРОННЫМИ:",callback);
    ///     icore.PrintRecItemPay((byte)PayType.Cash, cash, "НАЛИЧНЫМИ:",callback);
    ///     icore.CloseRec(callback);//закрытие документа
    ///   </code>
    /// </example>
    void SetItemTaxes(int taxNum, IExceptionCallback callback);

    /// <summary>
	/// <para><b>Вспомогательные функции для проведения оплат</b></para>
    /// <para>Управляет отрисовкой налога.</para>
    /// <para>Необходимо вызывать в открытом документе перед PrintRecItem</para>
    /// </summary>
    /// <param name="val">true - показывать, false  - не показывать</param>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <example>пример использования:
    /// <code>
    ///     // ... открытие документа, добавление позиций
	///		icore.SetItemTaxes(1,callback);
    ///     icore.SetShowTaxes(true,callback);
    ///     icore.PrintRecItem(count, total, name,atricle,callback);
    ///     // ... закрытие документа
    /// </code>
    /// </example>
    void SetShowTaxes(boolean val, IExceptionCallback callback);

    /// <summary>
	/// <para><b>Вспомогательные функции для проведения оплат</b></para>
    /// Добавление товарной позиции в открытом документе
    /// </summary>
    /// <param name="count">строка - количество. может принимать как целые, так и дробные значения</param>
    /// <param name="total">строка - сумма за единицу количества</param>
    /// <param name="itemname">строка - наименование товара</param>
    /// <param name="article">строка - артикул</param>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
	/// <example>правильная последовательность печати позиции с налогом
    ///   <code>
    ///     // ... открытие документа, добавление позиций
	///		icore.SetItemTaxes(1,callback);
    ///     icore.SetShowTaxes(true,callback);
    ///     icore.PrintRecItem(count, total, name,atricle,callback);
    ///     // ... закрытие документа
    ///   </code>
    /// </example>
    void PrintRecItem(String count, String total, String itemname, String article, IExceptionCallback callback);

    // **************************** Чек коррекции ****************************

    /// <summary>
    /// <para><b>Чек коррекции</b></para>
    /// <para>Напечатать чек коррекции.</para>
    /// <para>Вызывается однократно для каждого чека коррекции</para>
    /// </summary>
    /// <param name="opertation">тип операции - RecType, только для RecType.Sell, RecType.Buy (Приход, Расход)</param>
    /// <param name="cash">сумма наличными</param>
    /// <param name="emoney">сумма электронными</param>
    /// <param name="advance">сумма авансом</param>
    /// <param name="credit">сумма в кредит</param>
    /// <param name="other">сумма обменом</param>
    /// <param name= "tax">используемая система налогообложения</param>
    /// <param name="corrType">тип коррекци CorrectionRecType</param>
    /// <seealso cref="com.multisoft.drivers.fiscalcore.RecType"/>
    /// <seealso cref="com.multisoft.drivers.fiscalcore.CorrectionRecType"/>
    /// <param name="docName">строка, наименование основания для коррекции</param>
    /// <param name="docDate">строка, дата документа основания документа в формате "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'fff'Z'"</param>
    /// <param name="docNum">строка, номер документа основания</param>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    ///  <example>
    ///     работа с чеком коррекции:
    ///     <code>
    ///         icore.SetUserName(cashier,callback);
    ///         icore.SetTaxationUsing(taxation,callback);
    ///         icore.OpenRec(RecType.CorrectionReceipt,callback);
    ///         icore.FNMakeCorrectionRec(operation,cash,emony,advance,credit,other,tax,corrtype,docName,docNum,callback);
    ///         icore.CloseRec(callback);
    ///     </code>
    /// </example>
    void FNMakeCorrectionRec(int operation, String cash, String emoney, String advance, String credit,
        String other, int tax, int corrType, String docName, String docDate, String docNum, IExceptionCallback callback);

    // ****************************  Запрос информации о подтверждении документа от ОФД ****************************

    /// <summary>
    /// <para><b>Запрос информации о подтверждении документа от ОФД</b></para>
    /// <para>Запросить информацию о подтверждении от ОФД  по номеру документа.</para>
    /// <para>За 1 запрос сохраняется информация об 1 подтверждении фискального документа.</para>
    /// <para>При последующем запросе информация о предыдущем удаляется.</para>
    /// <para>Выполняется для каждого запрашиваемого подтверждения перед вызовом остальных функций, относящихся к разделу "<b>Запрос информации о подтверждении документа от ОФД</b>".</para>
    /// <para>Вызывается перед чтением информации о подтверждении.</para>
    /// <para>Для чтения информации о другом подтверждении необходимо выполнить эту команду снова, указав соответствующий номер.</para>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// </summary>
    /// <example> Запрос информации о подтверждении документов с номерами 1 и 2
    ///     <code>
    ///         //запросить информацию о чеке с номером 1
    ///         icore.QueryOFDReceiptByNum(1,callback);
    ///         //считать время из документа с номером 1
    ///         var first = icore.OfdOut_GetTime(callback);
    ///         //запросить информацию о чеке с номером 2
    ///         icore.QueryOFDReceiptByNum(2,callback);
    ///         //считать время из документа с номером 2
    ///         var second = icore.OfdOut_GetTime(callback);
    ///     </code>
    /// </example>
    /// <param name="docnum">номер переданного в ОФД фискального документа</param>
    void QueryOFDReceiptByNum(int docnum, IExceptionCallback callback);

    /// <summary>
	/// <para><b>Запрос информации о подтверждении документа от ОФД</b></para>
    /// Показать время подтверждения документа
    /// </summary>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <returns>строка - время</returns>
    /// <example>
    ///     <code>
    ///         icore.QueryOFDReceiptByNum(1,callback);
    ///         var first = icore.OfdOut_GetTime(callback);
    ///     </code>
    /// </example>
    String OfdOut_GetTime(IExceptionCallback callback);

    /// <summary>
    /// <para><b>Запрос информации о подтверждении документа от ОФД</b></para>
    /// Показать номер выбранного подтверждения документа
    /// </summary>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <returns>число - номер фискального документа</returns>
    /// <example>
    ///     <code>
    ///         icore.QueryOFDReceiptByNum(1,callback);
    ///         var first = icore.OfdOut_GetFDNumber(callback);
    ///     </code>
    /// </example>
    long OfdOut_GetFDNumber(IExceptionCallback callback);

    /// <summary>
    /// <para><b>Запрос информации о подтверждении документа от ОФД</b></para>
    /// Показать фискальный признак подтверждения документа
    /// </summary>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <returns>строка - фискальный признак, полученный от ОФД</returns>
    /// <example>
    ///     <code>
    ///         icore.QueryOFDReceiptByNum(1,callback);
    ///         var first = icore.OfdOut_GetFiscalSign(callback);
    ///     </code>
    /// </example>
    String OfdOut_GetFiscalSign(IExceptionCallback callback);

    /// <summary>
	/// <para><b>Запрос информации о подтверждении документа от ОФД</b></para>
    /// Показать размер подтверждения документа
    /// </summary>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <returns>число - размер документа</returns>
    /// <example>
    ///     <code>
    ///         icore.QueryOFDReceiptByNum(1,callback);
    ///         var first = icore.OfdOut_GetSize(callback);
    ///     </code>
    /// </example>
    int OfdOut_GetSize(IExceptionCallback callback);


    // ****************************  Работа с архивом ФН ****************************

    /// <summary>
	/// <para><b>Работа с архивом ФН</b></para>
    /// <para>Запроосить информацию о документе из архива ФН по номеру.</para>
	/// <para>За 1 запрос сохраняется информация об 1 фискальном документе.</para>
    /// <para>При последующем запросе информация о предыдущем удаляется.</para>
    /// <para>Выполняется для каждого запрашиваемого документа перед вызовом остальных функций, относящихся к разделу "<b>Работа с архивом ФН</b>".</para>
    /// <para>После этого становятся доступными функции с префиксом FDI, </para>
    /// <para>которые отображают информацию из запрошенного документа.</para>
	/// <para>Для чтения информации о другом документе необходимо выполнить эту команду снова c указанием нужного номера документа. </para>
    /// </summary>
    /// <param name="docNum">число - номер документа</param>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
	/// <example>
    ///     <code>
    ///         //запросить из архива ФД с номером 1
    ///         icore.QueryFiscalDocInfo(1,callback);
    ///         //считать время из документа с номером 1
	///			var doctype = icore.FDI_GetDocType(callback);
	///			//запросить из архива ФД с номером 2
    ///         icore.QueryFiscalDocInfo(2,callback);
    ///         //считать время из документа с номером 2
	///			var doctype = icore.FDI_GetDocType(callback);
    ///     </code>
    /// </example>
    void QueryFiscalDocInfo(int docNum, IExceptionCallback callback);

    /// <summary>
	/// <para><b>Работа с архивом ФН</b></para>
    /// Показать тип документа, выбранного с помощью QueryFiscalDocInfo
    /// </summary>
    /// <seealso cref="com.multisoft.drivers.fiscalcore.DocType"/>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <returns>тип документа</returns>
    /// <example>
    ///     <code>
    ///         icore.QueryFiscalDocInfo(1,callback);
	///			var first = icore.FDI_GetDocType(callback);
    ///     </code>
    /// </example>
    int FDI_GetDocType(IExceptionCallback callback);

    /// <summary>
	/// <para><b>Работа с архивом ФН</b></para>
    /// Показать флаг о наличии подтверждения документа, выбранного с помощью QueryFiscalDocInfo, от ОФД
    /// </summary>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <returns>true - документ был подтверждён, false - документ не был подтверждён</returns>
    /// <example>
    ///     <code>
    ///         icore.QueryFiscalDocInfo(1,callback);
	///			var first = icore.FDI_GetConfirmFromOFD(callback);
    ///     </code>
    /// </example>
    boolean FDI_GetConfirmFromOFD(IExceptionCallback callback);

    /// <summary>
	/// <para><b>Работа с архивом ФН</b></para>
    /// Показать байты документа, выбранного с помощью QueryFiscalDocInfo
    /// </summary>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <returns>строка - байт-код документа в HEX-формате</returns>
    /// <example>
    ///     <code>
    ///         icore.QueryFiscalDocInfo(1,callback);
	///			var first = icore.FDI_GetDataArray(callback);
    ///     </code>
    /// </example>
    String FDI_GetDataArray(IExceptionCallback callback);

    // **************************** Печать из архива ****************************

    /// <summary>
	/// <para><b>Печать их архива</b></para>
    /// Вывести на печать документ из архива по номеру
    /// </summary>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <param name="docNum">положительное целое число - номер документа</param>
    void FNPrintDocFromArchive(int docNum, IExceptionCallback callback);

    // ****************************  Запрос параметров ****************************

    // В этом блоке находятся методы для настройки аппарата перед регистрацией.
    // Под "пользователем" следует понимать организацию - пользователя КТТ

    // **************************** Параметры ОФД ****************************

    /// <summary>
    /// <para><b>Запрос параметров ОФД</b></para>
    /// Запрос адреса сервера ОФД
    /// </summary>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <returns>адрес сервера, например "test.server.ofd"  или "11.2.222.11"</returns>
    String GetOfdHost(IExceptionCallback callback);

    /// <summary>
	/// <para><b>Запрос параметров ОФД</b></para>
    /// Запрос порта ОФД
    /// </summary>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <returns>порт сервера, например, 12345</returns>
    int GetOfdPort(IExceptionCallback callback);

    /// <summary>
    /// <para><b>Запрос параметров ОФД</b></para>
    /// Запрос полного наименования оператора фискальных данных
    /// </summary>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <returns>строка - наименование ОФД</returns>
    String GetOfdName(IExceptionCallback callback);

    /// <summary>
	/// <para><b>Запрос параметров ОФД</b></para>
    /// Запрос ИНН ОФД
    /// </summary>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <returns>строка - ИНН ОФД</returns>
    String GetOfdTaxId(IExceptionCallback callback);


    // **************************** Основные настройки ****************************

    /// <summary>
    /// <para><b>Запрос основных настроек</b></para>
    /// Запрос имени организации (пользователя)
    /// </summary>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <returns>строка - имя организации</returns>
    String GetOrgName(IExceptionCallback callback);

    /// <summary>
	/// <para><b>Запрос основных настроек</b></para>
    /// Запрос адреса организации (пользователя)
    /// </summary>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <returns>строка - адрес организации</returns>
    String GetOrgAddress(IExceptionCallback callback);

    /// <summary>
	/// <para><b>Запрос основных настроек</b></para>
    /// Запрос места расчётов.
    /// Место осуществления расчетов между пользователем и покупателем (клиентом)
    /// </summary>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <returns>строка - физическое место расчётов</returns>
    String GetPhysicalAddress(IExceptionCallback callback);

    /// <summary>
	/// <para><b>Запрос основных настроек</b></para>
    /// Запрос email-а отправителя чеков
    /// </summary>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <returns>строка - email отправителя чеков </returns>
    String GetSenderEmail(IExceptionCallback callback);

    /// <summary>
	/// <para><b>Запрос основных настроек</b></para>
    /// Запрос адреса сайта для проверки фискального признака
    /// </summary>
    /// <returns>строка - адрес сайта для проверки фискального признака</returns>
    String GetReceiptCheckURI(IExceptionCallback callback);

    /// <summary>
	/// <para><b>Запрос основных настроек</b></para>
    /// Запрос сайта налогового органа
    /// </summary>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <returns>строка - сайт налогового органа</returns>
    String GetFNSServerAddress(IExceptionCallback callback);

    /// <summary>
	/// <para><b>Запрос основных настроек</b></para>
    /// Запрос ИНН кассира
    /// </summary>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <returns>строка - инн кассира</returns>
    String GetCashierTaxId(IExceptionCallback callback);

    /// <summary>
	/// <para><b>Запрос основных настроек</b></para>
    /// <para>Запрос флага расширенного автотеста.</para>
    /// <para>Если true, печатается чек расширенного автотестирования.</para>
    /// <para>Если false, чек расширенного автотестирования не печатается</para>
    /// </summary>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <returns>true или false</returns>
    boolean GetExtendedAutotest(IExceptionCallback callback);

    /// <summary>
	/// <para><b>Запрос основных настроек</b></para>
    /// Запрос номера автомата. Необходим только в автоматическом режиме.
    /// <seealso cref="com.multisoft.drivers.fiscalcore.OperatingMode"/>
    /// </summary>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <returns>строка - номер автомата</returns>
    String GetVendingSerial(IExceptionCallback callback);


    // **************************** Дополнительные настройки ****************************

    /// <summary>
    /// <para><b>Запрос дополнительных настроек</b></para>
    /// Запрос наименования оператора перевода, для банковских платежных агентов (субагентов)
    /// <seealso cref="com.multisoft.drivers.fiscalcore.AgentTag"/>
    /// </summary>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <returns>строка - наименование оператора перевода</returns>
    String GetTransferOperatorName(IExceptionCallback callback);

    /// <summary>
	/// <para><b>Запрос дополнительных настроек</b></para>
    /// Запрос ИНН оператора перевода, для банковских платежных агентов (субагентов)
    /// <seealso cref="com.multisoft.drivers.fiscalcore.AgentTag"/>
    /// </summary>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <returns>строка - ИНН оператор перевода</returns>
    String GetTransferOperatorTaxId(IExceptionCallback callback);

    /// <summary>
	/// <para><b>Запрос дополнительных настроек</b></para>
    /// Запрос телефона оператора перевода
    /// </summary>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <returns>строка - номера телефонов оператора по переводу денежных средств</returns>
    String GetTransferOperatorTelNum(IExceptionCallback callback);

    /// <summary>
	/// <para><b>Запрос дополнительных настроек</b></para>
    /// Запрос адреса оператора перевода, для банковских платежных агентов (субагентов)
    /// <seealso cref="com.multisoft.drivers.fiscalcore.AgentTag"/>
    /// </summary>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <returns>строка - адрес оператора перевода</returns>
    String GetTransferOperatorAddress(IExceptionCallback callback);

    /// <summary>
	/// <para><b>Запрос дополнительных настроек</b></para>
    /// Запрос номера телефонов платежного агента, платежного субагента,
    /// банковского платежного агента,банковского платежного субагента
    /// <seealso cref="com.multisoft.drivers.fiscalcore.AgentTag"/>
    /// </summary>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <returns>строка - номера телефонов платежного агента, платежного субагента,
    /// банковского платежного агента, банковского платежного субагента</returns>
    String GetPaymentAgentTelNum(IExceptionCallback callback);

    /// <summary>
	/// <para><b>Запрос дополнительных настроек</b></para>
    /// Запрос операции платежного агента.
    /// <seealso cref="com.multisoft.drivers.fiscalcore.AgentTag"/>
    /// </summary>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <returns>строка - наименование операции банковского платежного агента или банковского платежного субагента </returns>
    String GetPaymentAgentOperation(IExceptionCallback callback);

    /// <summary>
	/// <para><b>Запрос дополнительных настроек</b></para>
    /// <para>Запрос телефона оператора по приёму платежей.</para>
    /// <para>При осуществлении деятельности платежного агента и платежного субагента.</para>
    /// <seealso cref="com.multisoft.drivers.fiscalcore.AgentTag"/>
    /// </summary>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <returns>строка - номер телефона оператора по приёму платежей</returns>
    String GetCommissionAgentTelNum(IExceptionCallback callback);

    /// <summary>
	/// <para><b>Запрос дополнительных настроек</b></para>
    /// <para>Запрос номера телефона поставщика</para>
    /// <para>Для платежного агента и платежного субагента</para>
    /// <seealso cref="com.multisoft.drivers.fiscalcore.AgentTag"/>
    /// </summary>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <returns>строка - номер телефона поставщика </returns>
    String GetContractorTelNum(IExceptionCallback callback);


    // **************************** Применение настроек ****************************

    /// <summary>
    /// <para><b>Применение настроек</b></para>
    /// <para>Инициировать сохранение текущих настроек в память ККТ, </para>
    /// <para>чтобы они были применены при следующей инициализации ядра.</para>
    /// </summary>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    void SaveOptions(IExceptionCallback callback);

    // ****************************  Установка параметров ****************************
    // Данный блок методов позволяет настраивать параметры ККТ в режиме реального времени.
    // Чтобы при следующей загрузке ядра настройки были применены, их нужно сохранить функцией SaveOptions()
    // После изменения параметров необходимо применить их и провести перерегистрацию, в причине указав соответствующие изменения.
    // Чтобы изменить сразу несколько групп параметров, например, произвести смену ОФД и смену реквизитов пользователя,
    // нужно сначала выполнить настройку этих групп последовательно, выполнив шаги 1 и 2 для каждй из групп в отдельности.
    // То есть, сначала изменить настройки, связанные с ОФД, затем шаги 1 и 2, после чего аналогичные действия для
    // реквизитов пользователя.


    // **************************** Параметры ОФД ****************************
    // Необходимо указывать до вызова функции регистрации.

    /// <summary>
    /// <para><b>Установка параметров ОФД</b></para>
    /// Установка адреса сервера ОФД для подключения
    /// </summary>
    /// <param name="host">сервер ОФД, например, "test.server.ofd"  или "11.2.222.11"</param>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    void SetOfdHost(String host, IExceptionCallback callback);

    /// <summary>
	/// <para><b>Установка параметров ОФД</b></para>
    /// Установка порта сервера ОФД для подключения
    /// </summary>
    /// <param name="port">порт, например 9999</param>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    void SetOfdPort(int port, IExceptionCallback callback);

    /// <summary>
    /// <para><b>Установка параметров ОФД</b></para>
    /// Установить полное наименование оператора фискальных данных
    /// </summary>
    /// <param name="text">наименование ОФД</param>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    void SetOfdName(String text, IExceptionCallback callback);

    /// <summary>
	/// <para><b>Установка параметров ОФД</b></para>
    /// Установить ИНН ОФД
    /// </summary>
    /// <param name="text"> ИНН ОФД </param>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    void SetOfdTaxId(String text, IExceptionCallback callback);


    // **************************** Основные настройки ****************************
    // Необходимо указывать до вызова функции регистрации.

    /// <summary>
    /// <para><b>Установка основных настроек</b></para>
    /// Установить имя организации (пользователя)
    /// </summary>
    /// <param name="text">имя организации</param>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    void SetOrgName(String text, IExceptionCallback callback);

    /// <summary>
	/// <para><b>Установка основных настроек</b></para>
    /// Установить адрес организации(адрес расчётов)
    /// </summary>
    /// <param name="text">адрес организации </param>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    void SetOrgAddress(String text, IExceptionCallback callback);

    /// <summary>
	/// <para><b>Установка основных настроек</b></para>
    /// Установить место расчётов
    /// </summary>
    /// <param name="text">(физическое) место расчётов,
	/// место осуществления расчетов между пользователем и покупателем (клиентом)</param>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    void SetPhysicalAddress(String text, IExceptionCallback callback);

    /// <summary>
	/// <para><b>Установка основных настроек</b></para>
    /// Установить email отправителя чеков
    /// </summary>
    /// <param name="text">email отправителя чеков</param>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    void SetSenderEmail(String text, IExceptionCallback callback);

    /// <summary>
	/// <para><b>Установка основных настроек</b></para>
    /// Установить адрес сайта для проверки фискального признака
    /// </summary>
    /// <param name="text">адрес сайта для проверки фискального признака</param>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    void SetReceiptCheckURI(String text, IExceptionCallback callback);

    /// <summary>
	/// <para><b>Установка основных настроек</b></para>
    /// Установить адрес сайт налогового органа
    /// </summary>
    /// <param name="text">адрес сайта налогового органа</param>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    void SetFnsServerAddress(String text, IExceptionCallback callback);
	
	
    // **************************** Дополнительные настройки ****************************
    // Нужны при регистрации ККТ только в некоторых режимах работы.
    // Если испольльзуются, их необходимо указывать и применять до вызова функции регистрации/перерегистрации.

    /// <summary>
	/// <para><b>Установка дополнительных настроек</b></para>
    /// Установить ИНН кассира
    /// </summary>
    /// <param name="text">ИНН кассира</param>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    void SetCashierTaxId(String text, IExceptionCallback callback);

    /// <summary>
	/// <para><b>Установка дополнительных настроек</b></para>
    /// <para>Установить флаг расширенного автотеста.</para>
    /// <para>Если true, печатается чек расширенного автотестирования.</para>
    /// <para>Если false, чек расширенного автотестирования не печатается</para>
    /// </summary>
    /// <param name="newstate">новое состояние</param>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    void SetExtendedAutotest(boolean newstate, IExceptionCallback callback);

    /// <summary>
	/// <para><b>Установка дополнительных настроек</b></para>
    /// Установить номер автомата. Необходим только в автоматическом режиме.
    /// <seealso cref="com.multisoft.drivers.fiscalcore.OperatingMode"/>
    /// </summary>
    /// <param name="text">номер автомата</param>
    /// <param name="callback">функция обратного вызова дял передачи параметров ошибки</param>
    void SetVendingSerial(String text, IExceptionCallback callback);
	
    /// <summary>
    /// <para><b>Установка дополнительных настроек</b></para>
    /// Установить наименование оператора перевода, для банковских платежных агентов (субагентов)
    /// <seealso cref="com.multisoft.drivers.fiscalcore.AgentTag"/>
    /// </summary>
    /// <param name="text">наименование оператора перевода</param>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    void SetTransferOperatorName(String text, IExceptionCallback callback);

    /// <summary>
	/// <para><b>Установка дополнительных настроек</b></para>
    /// Установить ИНН оператора перевода, для банковских платежных агентов (субагентов)
    /// <seealso cref="com.multisoft.drivers.fiscalcore.AgentTag"/>
    /// </summary>
    /// <param name="text">ИНН оператор перевода</param>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    void SetTransferOperatorTaxId(String text, IExceptionCallback callback);

    /// <summary>
	/// <para><b>Установка дополнительных настроек</b></para>
    /// <para>Установить номера телефонов оператора по переводу денежных средств</para>
    /// </summary>
    /// <param name="text">строка - номер телефона оператора перевода</param>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    void SetTransferOperatorTelNum(String text, IExceptionCallback callback);

    /// <summary>
	/// <para><b>Установка дополнительных настроек</b></para>
    /// <para>Установить адрес оператора перевода, для банковских платежных агентов (субагентов)</para>
    /// <seealso cref="com.multisoft.drivers.fiscalcore.AgentTag"/>
    /// </summary>
    /// <param name="text">адрес оператора перевода</param>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    void SetTransferOperatorAddress(String text, IExceptionCallback callback);

    /// <summary>
	/// <para><b>Установка дополнительных настроек</b></para>
    /// <para>Установить номера телефонов платежного агента, платежного субагента,</para>
    /// <para>банковского платежного агента, банковского платежного субагента</para>
    /// <seealso cref="com.multisoft.drivers.fiscalcore.AgentTag"/>
    /// </summary>
    /// <param name="text">строка - телефонный номер</param>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    void SetPaymentAgentTelNum(String text, IExceptionCallback callback);

    /// <summary>
	/// <para><b>Установка дополнительных настроек</b></para>
    /// <para>Установить наименование операции банковского платежного агента или банковского платежного субагента</para>
    /// <seealso cref="com.multisoft.drivers.fiscalcore.AgentTag"/>
    /// </summary>
    /// <param name="text">операция платежного агента</param>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    void SetPaymentAgentOperation(String text, IExceptionCallback callback);

    /// <summary>
	/// <para><b>Установка дополнительных настроек</b></para>
    /// <para>Установить номер телефона оператора по приёму платежей.</para>
    /// <para>При осуществлении деятельности платежного агента и платежного субагента.</para>
    /// <seealso cref="com.multisoft.drivers.fiscalcore.AgentTag"/>
    /// </summary>
    /// <param name="text">номер телефона оператора по приёму платежей</param>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    void SetCommissionAgentTelNum(String text, IExceptionCallback callback);

    /// <summary>
	/// <para><b>Установка дополнительных настроек</b></para>
    /// <para>Установить номер телефона поставщика</para>
    /// <para>Для платежного агента и платежного субагента</para>
    /// <seealso cref="com.multisoft.drivers.fiscalcore.AgentTag"/>
    /// </summary>
    /// <param name="text">номер телефона поставщика</param>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    void SetContractorTelNum(String text, IExceptionCallback callback);


    // **************************** Временные настройки ****************************
    /// <summary>
    /// <para><b>Временные настройки</b></para>
    /// Установить дату и время. Используется для начальной настройки ККТ и корретировки часов ККТ в процессе работы.
    /// </summary>
    /// <param name="datetime">дата и время в формате "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'fff'Z'"</param>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <example>установка серийного номера предполагает перед этим установку даты и времени
    ///   <code>
    ///     var date = DateTime.Now.ToUniversalTime().ToString(Const.DATETIME_UTC_Z);
    ///     icore.SetDateTime(date,callback);//установка даты и времени
    ///     icore.SetSerial(sn.Text,callback);//установка серийного номера
    ///   </code>
    /// </example>
    void SetDateTime(String datetime, IExceptionCallback callback);
	
    // **************************** Сервисные команды ****************************
    /// <summary>
    /// <para><b>Сервисные команды</b></para>
    /// <para>Установить серийный номер ККТ</para>
    /// <para>Выполняется 1 раз для каждой ккт перед началом регистрации при производстве.</para>
    /// <para>В процессе эксплуатации может возникнуть необходимость ввести серийный номер ККТ заново.</para>
    /// </summary>
    /// <param name="serial">строка - серийный номер ККТ, состоящий из цифр</param>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <example>установка серийного номера предполагает перед этим установку даты и времени
    ///     <code>
    ///         icore.SetDateTime(DateTime.Now.ToUniversalTime().ToString(Const.DATETIME_UTC_Z),callback);
    ///         icore.SetSerial("0000000001",callback);
    ///     </code>
    /// </example>
    void SetSerial(String serial, IExceptionCallback callback);
	
    // **************************** Временные настройки ****************************
    /// <summary>
	/// <para><b>Временные настройки</b></para>
    /// <para>Установить имя кассира.</para>
    /// <para>Используется для печати чеков и отчётов от чьего-либо имени.</para>
    /// <para>Не является опцией.</para>
    /// <para>Рекомендуется задавать перед началом печати чеков/отчётов либо при смене кассира, обслуживающего ККТ.</para>
    /// </summary>
    /// <param name="cashier">строка - имя и номер кассира</param>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <example>открыть чек на продажу
    ///     <code>
    ///         icore.SetUserName(Cashier.Text,callback);
    ///         recType = (int)RecType.Sell;//приход
    ///         icore.OpenRec(recType,callback);
    ///     </code>
    /// </example>
    void SetUserName(String cashier, IExceptionCallback callback);

    /// <summary>
    /// <para><b>Временные настройки</b></para>
    /// <para>Опция - настройка флага отрезки.</para>
    /// <para>Устанавливать перед закрытием документа, если нужно сменить тип отрезки.</para>
    /// <para>Возможные значения, если отрезка поддерживается:</para>
    /// </summary>
    /// <seealso cref="com.multisoft.drivers.fiscalcore.CutType"/>
    /// <param name="newvalue">новое значение флага отрезки</param>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param> 
    void SetCutType(int newValue, IExceptionCallback callback);

    /// <summary>
    /// <para><b>Временные настройки</b></para>
    /// <para>Установка адреса и/или номера телефона клиента.</para>
    /// <para>Для фискального режима, если открыт чек (RecState.Opened) на приход/возврат прихода/расход/возврат расхода. </para>
    /// <para>Если перед OpenRec была вызвана функция com.multisoft.drivers.fiscalcore.ForcePrintForm() с параметром false, вызов SendClientAddress обязателен</para>
    /// <param name="addr">адрес и/или номер телефона клиента</param>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
	/// </summary>
    /// <returns>true в случае успеха, иначе false </returns>
    /// <seealso cref="com.multisoft.drivers.fiscalcore.ForcePrintForm()"/>
    /// <example>
    ///     <code>
    ///         icore.SetUserName(Cashier.Text,callback);
    ///         recType = (int)RecType.Sell;//приход
    ///         icore.SetTaxationUsing(taxationSystem,callback);//установка системы налогообложения
    ///         icore.OpenRec(recType,callback);
    ///         //добавление первой позиции:
    ///         icore.SetItemTaxes(item.TaxNum,callback);
    ///         icore.SetShowTaxes(true,callback);
    ///         icore.PrintRecItem(item.count, item.total, item.name, item.article,callback);
    ///         // добавление остальных позиций
    ///         // . . .
    ///         //
    ///         //установка адреса клиента. выполняется до CloseRec()
    ///         icore.SendClientAddress(clientAddress,callback);
    ///         icore.PrintRecTotal(callback);//печать итога
    ///         icore.PrintRecItemPay((byte)PayType.Cash, cash, "НАЛИЧНЫМИ:",callback);
    ///         icore.CloseRec(callback);//закрытие документа
    ///     </code>
    /// </example> 
    void SendClientAddress(String addr, IExceptionCallback callback);
		
		
    // **************************** Дополнительные настройки ****************************
    /// <summary>
	/// <para><b>Установка дополнительных настроек</b></para>
    /// Установка заголовка чека - строк, печатающихся до чека
    /// </summary>
    /// <param name="header">список строк для заговлока</param>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
	void SetHeaderLines(in List<String> header, IExceptionCallback callback);
	
    /// <summary>
	/// <para><b>Установка дополнительных настроек</b></para>
    /// Установка дополнительных строк, печатающихся после чека
    /// </summary>
    /// <param name="trailer">список строк</param>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
	void SetTrailerLines(in List<String> trailer, IExceptionCallback callback);
	
    /// <summary>
	/// <para><b>Установка дополнительных настроек</b></para>
    /// Установка упреждающей печати заголовка.
    /// <para>если true, заголовок следующего чека печатается после окончания печати предыдущего</para>
    /// <para>если false, заголовок печатается перед печатью чека.</para>
    /// Если флаг установлен (true), 
    /// </summary>
    /// <param name="newState">true - печатать заголовок сразу после </param>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
	void SetPrePrintHeaderLines(boolean newState, IExceptionCallback callback);
	
    /// <summary>
	/// <para><b>Установка дополнительных настроек</b></para>
    /// <para>Автоинкассация при закрытии смены. Выполняется перед закрытием смены.</para>
	/// <para>Закрытие смены, выполненное после этой функции, произойдёт с автоматическим обнулением счётчика наличности в денежном ящике.</para>
    /// </summary>
    /// <param name="newState">true - автоинкассация включена, false - выключена</param>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
	void SetDayCloseAutoPayOut(boolean newState, IExceptionCallback callback);
		
		
    // **************************** Чек ****************************
    /// <summary>
	/// <para><b>Чек</b></para>
    /// <para>Печать QR-кода. Выполняется при открытом документе.</para>
    /// </summary>
    /// <param name="value">строка - контент</param>
    /// <param name="align">выравнивание</param>
    /// <seealso cref="com.multisoft.drivers.fiscalcore.Align"/>
	void PrintQRCode(String value, int align, IExceptionCallback callback);
	
	
	// **************************** Чтение статуса ФН ****************************
    /// <summary>
	/// <para><b>Чтение статуса ФН</b></para>
    /// <para>Вернуть номер последнего фискального документа (кешируется). </para>
    /// <para>Функция аналогична FNGetLastFDNumber, но выполняется быстрее.</para>
    /// </summary>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <returns>номер последнего фискального документа</returns>
	long FNGetLastFDNum(IExceptionCallback callback);
	
    /// <summary>
	/// <para><b>Чтение статуса ФН</b></para>
    /// <para>Вернуть ФП последнего фискального документа (кешируется)</para>
    /// </summary>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <returns>фискальный признак</returns>
	long FNGetLastFiscalSign(IExceptionCallback callback);

	// **************************** Статус ККТ ****************************
	/// <summary>
	/// <para><b>Статус ККТ</b></para></para>
	/// <para>Название ККТ в реестре</para>
    /// </summary>
	/// <returns>название ККТ</returns>
	String GetKKTRegisteredName();
	
    // **************************** Временные настройки ****************************
	/// <summary>
    /// <para><b>Временные настройки</b></para>
	/// <para>Принудительно отключить печать следующего документа</para>
    /// </summary>
	/// <param name="printNextDocument">false - отключить печать следующего документа. true - ничего не предпринимать.</param>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>    
	/// <example>
    ///     <code>
    ///         icore.ForcePrintForm(false,callback);
    ///         recType = (int)RecType.Sell;//приход
    ///         icore.SetTaxationUsing(taxationSystem,callback);//установка системы налогообложения
    ///         icore.OpenRec(recType,callback);
    ///         // добавление позиций
    ///         // . . .
    ///         //установка адреса клиента. Обязательна для Sell, SellRefund, Buy, BuyRefund
    ///         icore.SendClientAddress(clientAddress,callback);
    ///         icore.PrintRecTotal(callback);//печать итога
    ///         icore.PrintRecItemPay((byte)PayType.Cash, cash, "НАЛИЧНЫМИ:",callback);
    ///         icore.CloseRec(callback);//закрытие документа
    ///     </code>
    /// </example> 
	void ForcePrintForm(boolean printNextDocument, IExceptionCallback callback);
		
	// **************************** Чтение статуса ФН ****************************
    /// <summary> 
    /// <para><b>Чтение статуса ФН</b></para>
    /// <para>Вернуть систему налогообложения, указанную при регистрации, по номеру</para>
    /// </summary>
    /// <param name="regNum">номер регистрации</param>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <returns>код системы налогообложения, указанной при регистрации</returns>
    /// <seealso cref="com.multisoft.drivers.fiscalcore.TaxCode"/>
	int FNGetRegTaxSystemByNum(int regNum, IExceptionCallback callback);

	/// <summary> 
    /// <para><b>Чтение статуса ФН</b></para>
    /// <para>Вернуть режим работы, указанный при регистрации, по номеру</para>
    /// </summary>
    /// <param name="regNum">номер регистрации</param>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <returns>режим работы, указанный при регистрации</returns>
    /// <seealso cref="com.multisoft.drivers.fiscalcore.OperatingMode"/>
	int FNGetOpModeByNum(int regNum, IExceptionCallback callback);
	
    // ****************************  Состояние смены ****************************
	/// <summary>
    /// <para><b>Состояние смены: отчёты</b></para>
    /// Запрос суммы оплат с учетом остатка на начало смены по типу счётчика
    /// </summary>
    /// <param name="counterType">тип счётчика</param>
    /// <seealso cref="com.multisoft.drivers.fiscalcore.Counter"/>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
    /// <returns>сумма по счётчику</returns>
    String GetPayTotal(int counterType, IExceptionCallback callback);
	
    // **************************** Чек ****************************
    /// <summary>
	/// <para><b>Чек</b></para>
    /// <para>Вывести на печать штрих-код. Выполняется при открытом документе.</para>
    /// </summary>
    /// <param name="type">тип штрих-кода BarCode</param>
    /// <param name="align">выравнивание Align, вне зависимости от передаваемого значения будет выполнено выравнивание по левому краю (1.7.27)</param>
    /// <seealso cref="com.multisoft.drivers.fiscalcore.BarCode"/>
	/// <seealso cref="com.multisoft.drivers.fiscalcore.Align"/>
    /// <param name="value">строка - контент</param>
    /// <param name="callback">функция обратного вызова для передачи информации об ошибке</param>
	void PrintBarCode(int type, int align, String value, IExceptionCallback callback);
	
    /// <summary>
	/// <para><b>Чек</b></para>
    /// Протяжка чековой ленты на count строк, если count > 0, иначе протяжка по умолчанию. Выполняется при открытом документе.
    /// </summary>
    /// <param name="count">количество строк для протяжки</param>
    /// <param name="callback"></param>
	void Feed(int count, IExceptionCallback callback);
}