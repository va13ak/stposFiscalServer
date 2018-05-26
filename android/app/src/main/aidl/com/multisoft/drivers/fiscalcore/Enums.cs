using System;
using System.ComponentModel;

//[Description()]

namespace com.multisoft.drivers.fiscalcore
{
    /// <summary>
    /// код ошибки. Является аргументом errCode функции IExceptionCallback.HandleException
    /// </summary>
    public enum ErrCode
    {
        /// <summary>
        /// стандартное исключение. Дополнительная информация в StackTrace
        /// </summary>
        [Description("Исключение")]
        Generic = 0,

        /// <summary>
        /// некорректное значение параметра || параметр не может быть прочтён
        /// при передаче даты/времени и денежных сумм
        /// </summary>
        [Description("Неправильный аргумент")]
        WrongArgument,

        /// <summary>
        /// параметр выходит за заданный диапазон, например, при использовании перечислений
        /// </summary>
        [Description("Выход за границы диапазона")]
        OutOfRange,

        /// <summary>
        /// неправильная операция || операция невыполнима при данном статусе. см. ExtStatusErr
        /// например, если пытаемся добавить товары после итога
        /// </summary>
        [Description("Неверный статус")]
        WrongStatus,

        /// <summary>
        /// ошибка оборудования: NACK или таймаут. проверьте FNState. см. ExtHardwareErr
        /// </summary>
        [Description("Ошибка оборудования")]
        Hardware,

        /// <summary>
        /// ошибка печатающего устройства. См. ExtPrinterErr
        /// </summary>
        [Description("Ошибка принтера")]
        Printer
    }

    /// <summary>
    /// расширенный код ошибки статуса.  Является аргументом extErrCode функции IExceptionCallback.HandleException
    /// </summary>
    public enum ExtStatusErr
    {
        /// <summary>
        /// Сервис не готов. проверьте IsReady() и выполните SelfTest()
        /// </summary>
        [Description("Сервис не инициализирован либо не готов к работе")]
        ServiceNotReady = 0,

        /// <summary>
        /// Смена уже открыта
        /// </summary>
        [Description("Смена уже открыта")]
        DayOpened,

        /// <summary>
        /// Смена уже закрыта
        /// </summary>
        [Description("Смена смена уже закрыта")]
        DayClosed,

        /// <summary>
        /// Смена открыта более 24 часов
        /// </summary>
        [Description("Смена открыта более 24 часов")]
        DayOpened24h,

        /// <summary>
        /// Состояние смены в ККТ и накопителе различно.
        /// </summary>
        [Description("Состояние смены в ККТ и накопителе различно")]
        DayStateDiffers,

        /// <summary>
        /// Неверное состояние чека.
        /// </summary>
        [Description("Неверное состояние чека.")]
        WrongRecState,

        /// <summary>
        /// Для выполнения данной операции необходимо закрыть чек
        /// </summary>
        [Description("Для выполнения данной операции необходимо закрыть чек")]
        NeedRecClose,

        /// <summary>
        /// Недостаточно наличных
        /// </summary>
        [Description("Недостаточно наличных")]
        NotEnoughCash,

        /// <summary>
        /// Необходимо передать реквизит
        /// </summary>
        [Description("Необходимо передать реквизит")]
        MissingProps,

        /// <summary>
        /// Неправильный тип одокумента
        /// </summary>
        [Description("Неправильный тип документа")]
        WrongRecType,

        /// <summary>
        /// Общая ошибка статуса
        /// </summary>
        [Description("Общая ошибка статуса")]
        Common,

        /// <summary>
        /// Cумма по чеку не совпадает с суммой по оплатам
        /// </summary>
        [Description("Cумма по чеку не совпадает с суммой по оплатам")]
        TotalDiffers

    }

    /// <summary>
    /// расширенный код ошибки оборудования.  Является аргументом extErrCode функции IExceptionCallback.HandleException. Для дополнительной информации см. StackTrace
    /// </summary>
    public enum ExtHardwareErr
    {
        /// <summary>
        /// Ошибка инициализации. Модуль не был инициализирован.
        /// </summary>
        [Description("Ошибка инициализации")]
        Initialization = 0,

        /// <summary>
        /// Запрашиваемый модуль не доступен.
        /// </summary>
        [Description("Ошибка доступа")]
        Null,

        /// <summary>
        /// Ошибка подключения.
        /// </summary>
        [Description("Ошибка подключения")]
        Connection,

        /// <summary>
        /// Таймаут на выполнение команды. Запрос выполнен успешно, но нет ответа.
        /// </summary>
        [Description("Таймаут")]
        Timeout,

        /// <summary>
        /// Запрос отклонён
        /// </summary>
        [Description("Запрос отклонён")]
        Nack,

        /// <summary>
        /// Фатальная ошибка. Обратитесь к производителю.
        /// </summary>
        [Description("Фатальная ошибка")]
        Fatal

    }
    /// <summary>
    /// расширенный код ошибки принтера.  Является аргументом extErrCode функции IExceptionCallback.HandleException
    /// </summary>
    public enum ExtPrinterErr
    {
        /// <summary>
        /// бумага скоро закончится. в V1 не используется
        /// </summary>
        [Description("Бумага скоро закончится")]
        PaperNearEnd = 0,

        /// <summary>
        /// бумага закончилась. в V1 не используется
        /// </summary>
        [Description("Бумага закончилась")]
        PaperEnd,

        /// <summary>
        /// при печати документа возникла ошибка
        /// </summary>
        [Description("Ошибка при печати")]
        ErrorPrinting,

        /// <summary>
        /// принтер недоступен
        /// </summary>
        [Description("Принтер недоступен")]
        Offline
    }

    /// <summary>
    /// Фазы жизни ФН
    /// </summary>
    public enum FNState
    {
        /// <summary>
        /// Настройка
        /// </summary>
        [Description("Настройка")]
        Configuration = 0x00,

        /// <summary>
        /// Готов к фискализации
        /// </summary>
        [Description("Готов к регистрации")]
        ReadyToFiscalization = 0x01,

        /// <summary>
        /// Фискальный режим
        /// </summary>
        [Description("Фискальный режим")]
        FiscalMode = 0x03,

        /// <summary>
        /// Фискальный режим закрыт, идёт передача ОФД
        /// </summary>
        [Description(" Фискальный режим закрыт, идёт передача ОФД")]
        FiscalClosed = 0x07,

        /// <summary>
        /// Чтение данных из архива ФН
        /// </summary>
        [Description("Чтение данных из архива ФН")]
        FNArchiveRead = 0x0F,

        /// <summary>
        /// ФН не установлен
        /// </summary>
        [Description("ФН не установлен")]
        FNNotInstalled = 0xFF
    }

    /// <summary>
    /// Флаги педупреждений (битовые)
    /// </summary>
    [Flags]
    public enum WarningFlag
    {
        /// <summary>
        /// Никаких предупреждений
        /// </summary>
        [Description("Никаких предупреждений")]
        OK = 0x00,

        /// <summary>
        /// Срочная замена КС (до окончания срока действия 3 дня)
        /// </summary>
        [Description("Срочная замена КС (до окончания срока действия 3 дня)")]
        UrgentCSReplace = 0x01,

        /// <summary>
        /// Исчерпание ресурса КС (до окончания срока действия 30 дней)
        /// </summary>
        [Description("Исчерпание ресурса КС (до окончания срока действия 30 дней)")]
        CSDepletion = 0x02,
        
        /// <summary>
        /// Переполнение памяти ФН (архив ФН заполнен на 90%)
        /// </summary>
        [Description("Переполнение памяти ФН (архив ФН заполнен на 90%)")]
        FNMemoryOverflow = 0x04,

        /// <summary>
        /// Превышено время ожидания ответа ОФД
        /// </summary>
        [Description("Превышено время ожидания ответа ОФД")]
        OFDTimeout = 0x08,

        /// <summary>
        /// Критическая ошибка ФН
        /// </summary>
        [Description("Критическая ошибка ФН")]
        FatalError = 0x80
    }

    /// <summary>
    /// Текущий документ (ответ для запроса статуса ФН)
    /// </summary>
    public enum CurrentDoc
    {
        /// <summary>
        /// Нет открытого документа
        /// </summary>
        [Description("Нет открытого документа")]
        NoDoc = 0x00,

        /// <summary>
        /// Отчёт о фискализации
        /// </summary>
        [Description("Отчёт о фискализации")]
        FiscalizationReport = 0x01,

        /// <summary>
        /// Отчёт об открытии смены
        /// </summary>
        [Description("Отчёт об открытии смены")]
        DayOpenReport = 0x02,

        /// <summary>
        /// Кассовый чек
        /// </summary>
        [Description("Кассовый чек")]
       CashReceipt = 0x04,

        /// <summary>
        /// Отчёт о закрытии смены
        /// </summary>
        [Description("Отчёт о закрытии смены")]
       DayCloseReport = 0x08,

        /// <summary>
        /// Отчёт о закрытии фискального режима
        /// </summary>
        [Description("Отчёт о закрытии фискального режима")]
       FiscalCloseReport = 0x10,

        /// <summary>
        /// Бланк строгой отчётности
        /// </summary>
        [Description("Бланк строгой отчётности")]
        BSO = 0x11, //TODO: rename?

        /// <summary>
        /// Отчет об изменении параметров регистрации ККТ в связи с заменой ФН
        /// </summary>
        [Description("Отчет об изменении параметров регистрации ККТ в связи с заменой ФН")]
        ReplacedFnRegistrationReport = 0x12,

        /// <summary>
        /// Отчет об изменении параметров регистрации ККТ
        /// </summary>
        [Description(" Отчет об изменении параметров регистрации ККТ")]
        ChangedRegistrationParamsReport = 0x13,

        /// <summary>
        /// Кассовый чек коррекции
        /// </summary>
        [Description("Кассовый чек коррекции")]
        CorrectionCashReceipt = 0x14,

        /// <summary>
        /// БСО коррекции
        /// </summary>
        [Description("БСО коррекции")]
        CorrectionBSO = 0x15, //TODO: rename?

        /// <summary>
        /// Отчет о текущем состоянии расчетов
        /// </summary>
        [Description("Отчет о текущем состоянии расчетов")]
        CurrentCalculationStateReport = 0x17
    }

    /// <summary>
    /// Типы оплат
    /// </summary>
    public enum PayType
    {
        /// <summary>
        /// наличными
        /// </summary>
        [Description("НАЛИЧНЫМИ")]
        Cash = 0,

        /// <summary>
        /// электронными
        /// </summary>
        [Description("ЭЛЕКТРОННЫМИ")]
        Card,

        /// <summary>
        /// в кредит
        /// </summary>
        [Description("ПОСЛЕДУЮЩАЯ ОПЛАТА(КРЕДИТ)")]
        Bank,

        /// <summary>
        /// аванс
        /// </summary>
        [Description("ПРЕДВАРИТЕЛЬНАЯ ОПЛАТА(АВАНС)")]
        Voucher,

        /// <summary>
        /// обмен
        /// </summary>
        [Description("ИНАЯ ФОРМА ОПЛАТЫ")]
        Tare
    }

    /// <summary>
    /// Отметка о получении данных документа накопителем (ФН)
    /// </summary>
    public enum DocData
    {
        /// <summary>
        /// Данные документа не получены ФН
        /// </summary>
        [Description("Данные документа не получены ФН")]
        NoData = 0x00,

        /// <summary>
        /// Данные документа получены ФН
        /// </summary>
        [Description("Данные документа получены ФН")]
        DataAcquired = 0x01
    }


    /// <summary>
    /// Тип документа в запросе документа по номеру
    /// </summary>
    public enum DocType : byte
    {
        /// <summary>
        /// Неверный тип документа
        /// </summary>
        [Description("Тип документа не определен")]
        Null = 0x00,
        /// <summary>
        /// Итоги фискализации / Отчёт о регистрации
        /// </summary>
        [Description("Отчет о регистрации")]
        FiscalSummary = 0x01,
        /// <summary>
        /// Отчёт об открытии смены
        /// </summary>
        [Description("Отчет об открытии смены")]
        DayOpen = 0x02,
        /// <summary>
        /// Кассовый чек
        /// </summary>
        [Description("Кассовый чек")]
        CashReceipt = 0x03,
        /// <summary>
        /// Бланк строгой отчётности (БСО)
        /// </summary>
        [Description("Бланк строгой отчетности (БСО)")]
        BSO = 0x04,
        /// <summary>
        /// Отчёт о закрытии смены
        /// </summary>
        [Description("Отчёт о закрытии смены")]
        DayClose = 0x05,
        /// <summary>
        /// Отчёт о закрытии фискального режима
        /// </summary>
        [Description("Отчёт о закрытии фискального режима")]
        FiscalClose = 0x06,
        /// <summary>
        /// Подтверждение оператора
        /// </summary>
        [Description("Подтверждение оператора")]
        OFDConfirm = 0x07,
        /// <summary>
        /// Отчёт об изменении параметров регистрации
        /// </summary>
        [Description("Отчёт об изменении параметров регистрации")]
        RegistrationCorrection = 0x0B,
        /// <summary>
        /// Отчёт о текущем состоянии расчётов
        /// </summary>
        [Description("Отчёт о текущем состоянии расчётов")]
        CalculationsReport = 0x15,

        /// <summary>
        /// Чек коррекции (нет в доке на ФН, но есть в доке на ФД)
        /// </summary>
        [Description("Чек коррекции")]
        CorrectionReceipt = 0x1F,
        /// <summary>
        /// Бланк строгой отчётности коррекции (нет в доке на ФН, но есть в доке на ФД)
        /// </summary>
        [Description("Бланк строгой отчётности коррекции")]
        CorrectionBSO = 0x29
    }

    /// <summary>
    /// Тип ПО ФН
    /// </summary>
    public enum FirmwareTypes
    {
        /// <summary>
        /// Отладка
        /// </summary>
        [Description("Отладка")]
        DebugVersion = 0x00,

        /// <summary>
        /// Релиз
        /// </summary>
        [Description("Релиз")]
       ReleaseVersion = 0x01
    }

    /// <summary>
    /// Перечисление для статуса информационного обмена с ОФД, битовые флаги
    /// </summary>
    [Flags]
    public enum ConnectionState
    {
        /// <summary>
        /// Нет соединения
        /// </summary>
        [Description("Нет соединения")]
       NoConnection = 0x00,

        /// <summary>
        /// Транспортное соединение установлено
        /// </summary>
        [Description("Транспортное соединение установлено")]
       ConnectionEstablished = 0x01,

        /// <summary>
        /// Есть сообщение для передачи ОФД
        /// </summary>
        [Description("Есть сообщение для передачи ОФД")]
       MessageToOFDQueued = 0x02,

        /// <summary>
        /// Ожидание ответного сообщения (квитанции) от ОФД
        /// </summary>
        [Description("Ожидание ответного сообщения (квитанции) от ОФД")]
        WaitingOFDReceipt = 0x04,

        /// <summary>
        /// Есть команда от ОФД
        /// </summary>
        [Description("Есть команда от ОФД")]
        OFDCommandQueued = 0x08,

        /// <summary>
        /// Изменились настройки соединения с ОФД
        /// </summary>
        [Description("Изменились настройки соединения с ОФД")]
        OFDConnectionChanged = 0x10,

        /// <summary>
        /// Ожидание ответа на команду от ОФД
        /// </summary>
        [Description("Ожидание ответа на команду от ОФД")]
        WaitingForOFDResponse = 0x20
    }

    /// <summary>
    /// Состояние смены
    /// </summary>
    public enum DayState
    {
        /// <summary>
        /// Смена закрыта
        /// </summary>
        [Description("Смена закрыта")]
       DayClosed = 0x00,

        /// <summary>
        /// Смена открыта
        /// </summary>
        [Description("Смена открыта")]
       DayOpen = 0x01
    }

    /// <summary>
    /// Код системы налогообложения
    /// Используется при регистрации и перерегистрации
    /// </summary>
    [Flags]
    public enum TaxCode
    {
        /// <summary>
        /// Общая
        /// </summary>
        [Description("ОСН")]
        Common = 0x01,

        /// <summary>
        /// Упрощённая Доход
        /// </summary>
        [Description("УСН доход")]
        Simplified = 0x02,

        /// <summary>
        /// Упрощённая Доход минус Расход
        /// </summary>
        [Description("УСН доход - расход")]
        SimplifiedWithExpense = 0x04,

        /// <summary>
        /// Единый налог на вмененный доход
        /// </summary>
        [Description("ЕНВД")]
        ENVD = 0x08,

        /// <summary>
        /// Единый сельскохозяйственный налог
        /// </summary>
        [Description("ЕСН")]
        CommonAgricultural = 0x10,

        /// <summary>
        /// Патентная система налогообложения
        /// </summary>
        [Description("Патент")]
        Patent = 0x20
    }

    /// <summary>
    /// Код налога
    /// Используется при оплате и в чеке коррекции.
    /// </summary>
    [Flags]
    public enum TaxNum
    {
        /// <summary>
        /// 0 - НДС 18%
        /// </summary>
        [Description("НДС 18%")]
        _18 = 0,

        /// <summary>
        /// НДС 10%
        /// </summary>
        [Description("НДС 10%")]
        _10,

        /// <summary>
        /// НДС 18/118
        /// </summary>
        [Description("НДС 18/118")]
        _18_118,

        /// <summary>
        /// НДС 10/110
        /// </summary>
        [Description("НДС 10/110")]
        _10_110,

        /// <summary>
        /// НДС 0%
        /// </summary>
        [Description("НДС 0%")]
        _0,

        /// <summary>
        /// БЕЗ НДС
        /// </summary>
        [Description("БЕЗ НДС")]
        _NO
    }

    /// <summary>
    /// Режимы работы
    /// </summary>
    [Flags]
    public enum OperatingMode
    {
        /// <summary>
        /// Основной режим работы
        /// </summary>
        [Description("0 Основной")]
        Default = 0x00,

        /// <summary>
        /// Шифрование
        /// </summary>
        [Description("1  Шифрование")]
        Encryption = 0x01,

        /// <summary>
        /// Автономный режим
        /// </summary>
        [Description("2  Автономный режим")]
        Autonomous = 0x02,

        /// <summary>
        /// Автоматический режим
        /// </summary>
        [Description("4  Автоматический режим")]
        Automatic = 0x04,

        /// <summary>
        /// Применение в сфере услуг
        /// </summary>
        [Description("8  Применение в сфере услуг")]
        Service = 0x08,

        /// <summary>
        /// Режим БСО (иначе - режим чеков)
        /// </summary>
        [Description("16 Режим БСО (иначе – режим чеков)")]
        BSOMode = 0x10,

        /// <summary>
        /// Применение в Интернет
        /// </summary>
        [Description("32 Применение в Интернет")]
        InternetUsing = 0x20
    }

    /// <summary>
    /// тип открытого чека
    /// </summary>
    public enum RecType
    {
        /// <summary>
        /// Приход
        /// </summary>
        [Description("ПРИХОД")]
        Sell = 1,

        /// <summary>
        /// Bозврат прихода
        /// </summary>
        [Description("ВОЗВРАТ ПРИХОДА")]
        SellRefund = 3,

        /// <summary>
        /// Расход
        /// </summary>
        [Description("РАСХОД")]
        Buy = 2,

        /// <summary>
        /// Возврат расхода
        /// </summary>
        [Description("ВОЗВРАТ РАСХОДА")]
        BuyRefund = 4,

        /// <summary>
        /// Чек коррекции
        /// </summary>
        [Description("Чек коррекции")]
        CorrectionRec = 19,

        /// <summary>
        /// Внесение
        /// </summary>
        [Description("Внесение")]
        PayIn = 7,

        /// <summary>
        /// Изъятие
        /// </summary>
        [Description("Изъятие")]
        PayOut = 8,

        /// <summary>
        /// Нефискальный
        /// </summary>
        [Description("Нефискальный")]
        Unfiscal = 9
    }


    /// <summary>
    /// Тип операции
    /// </summary>
    public enum OperationType : byte
    {
        /// <summary>
        /// Приход
        /// </summary>
        [Description("ПРИХОД")]
        Sell = 0x01,
        /// <summary>
        /// Возврат прихода
        /// </summary>
        [Description("ВОЗВРАТ ПРИХОДА")]
        SellRefund = 0x02,
        /// <summary>
        /// Расход
        /// </summary>
        [Description("РАСХОД")]
        Buy = 0x03,
        /// <summary>
        /// Возврат расхода
        /// </summary>
        [Description("ВОЗВРАТ РАСХОДА")]
        BuyRefund = 0x04
    }

    /// <summary>
    /// тип коррекции. применяется в чеке коррекции
    /// </summary>
    public enum CorrectionRecType
    {
        /// <summary>
        /// Самостоятельная
        /// </summary>
        [Description("Самостоятельная")]
        Independent = 0,

        /// <summary>
        /// По предписанию
        /// </summary>
        [Description("По предписанию")]
        ByOrder
    }

    /// <summary>
    /// Признак агента
    /// </summary>
    [Flags]
    public enum AgentTag
    {
        /// <summary>
        /// Агентом не является
        /// </summary>
        None = 0,

        /// <summary>
        /// Банковский платёжный агент
        /// </summary>
        BankPayAgent = 1,

        /// <summary>
        /// Банковский платёжный субагент
        /// </summary>
        BankPaySubAgent = 2,

        /// <summary>
        /// Платёжный агент
        /// </summary>
        PayAgent = 4,

        /// <summary>
        /// Платёжный субагент
        /// </summary>
        PaySubAgent = 8,

        /// <summary>
        /// Поверенный
        /// </summary>
        Attorney = 16,

        /// <summary>
        /// Комиссионер
        /// </summary>
        CommissionAgent = 32,

        /// <summary>
        /// Иной агент
        /// </summary>
        Agent = 64
    }

    /// <summary>
    /// Причина коррекции. Применяется при перерегистрации
    /// </summary>
    public enum CorrectionReason
    {
        /// <summary>
        /// регистрация
        /// </summary>
        [Description("0 - регистрация")]
        Register = 0,

        /// <summary>
        /// замена ФН
        /// </summary>
        [Description("1 - замена ФН")]
        ChangeFN = 1,

        /// <summary>
        /// смена ОФД
        /// </summary>
        [Description("2 - смена ОФД")]
        ChangeOFD = 2,

        /// <summary>
        /// смена реквизитов пользователя
        /// </summary>
        [Description("3 - смена реквизитов пользователя")]
        ChangeUserAttr = 3,

        /// <summary>
        /// смена настроек ккт
        /// </summary>
        [Description("4 - смена настроек ккт")]
        ChangeKKTSettings = 4
    }

    /// <summary>
    /// флаги отрезки
    /// </summary>
    public enum CutType
    {
        /// <summary>
        /// отключена
        /// </summary>
        Off = 0,

        /// <summary>
        /// полная
        /// </summary>
        Full,

        /// <summary>
        /// частичная
        /// </summary>
        Partial
    }

    /// <summary>
    /// состояние чека
    /// </summary>
    public enum RecState
    {
        /// <summary>
        /// открыт
        /// </summary>
        Opened = 0,

        /// <summary>
        /// произведена оплата
        /// </summary>
        Total,

        /// <summary>
        /// закрыт
        /// </summary>
        Closed
    }

    /// <summary>
    /// выравнивание
    /// </summary>
    public enum Align
    {
        /// <summary>
        /// выравнивание влево
        /// </summary>
        Left = 0,

        /// <summary>
        /// выравнивание по центру
        /// </summary>
        Center = 1,

        /// <summary>
        /// выравнивание вправо
        /// </summary>
        Right = 2
    }


    /// <summary>
    /// счётчики
    /// </summary>
    public enum Counter
    {
        /// <summary>
        /// Аннулирования
        /// </summary>
        [Description("Аннулирования")]
        VOID = 0,
        /// <summary>
        /// Приход
        /// </summary>
        [Description("Приход")]
        SELL = 1,
        /// <summary>
        /// Возврат прихода
        /// </summary>
        [Description("Возврат прихода")]
        SELL_REFUND = 2,
        /// <summary>
        /// Расход
        /// </summary>
        [Description("Расход")]
        BUY = 3,
        /// <summary>
        /// Возврат расхода
        /// </summary>
        [Description("Возврат расхода")]
        BUY_REFUND = 4,
        /// <summary>
        /// Наличные
        /// </summary>
        [Description("Наличные")]
        CASH = 5,
        /// <summary>
        /// Электронные
        /// </summary>
        [Description("Электронные")]
        CARD = 6,
        /// <summary>
        /// Кредит
        /// </summary>
        [Description("Последующая оплата(Кредит)")]
        BANK = 7,
        /// <summary>
        /// Иная форма оплаты
        /// </summary>
        [Description("Иная форма оплаты")]
        TARE = 8,
        /// <summary>
        /// Аванс
        /// </summary>
        [Description("Предварительная оплата(Аванс)")]
        VOUCHER = 9,
        /// <summary>
        /// Внесение
        /// </summary>
        [Description("Внесение")]
        PAID_IN = 10,
        /// <summary>
        /// Изъятие
        /// </summary>
        [Description("Изъятие")]
        PAID_OUT = 11,
        /// <summary>
        /// X-отчёт
        /// </summary>
        [Description("X-отчёт")]
        X_REPORT = 14,
        /// <summary>
        /// Z-отчёт
        /// </summary>
        [Description("Отчёт о закрытии смены")]
        Z_REPORT = 15,
        /// <summary>
        /// Отмены
        /// </summary>
        [Description("Отмены")]
        CANCEL = 16,
        /// <summary>
        /// Документы
        /// </summary>
        [Description("Документы")]
        NUMBER = 17,
        /// <summary>
        /// Коррекции
        /// </summary>
        [Description("Коррекции")]
        CORRECTION = 18
    }

    public enum BarCode
    {
        /// <summary>
        /// UPC-A
        /// </summary>
        UpcA = 0,
        /// <summary>
        /// UPC-E
        /// </summary>
        UpcE = 1,
        /// <summary>
        /// JAN13(EAN13)
        /// </summary>
        Ean13 = 2,
        /// <summary>
        /// JAN8(EAN8)
        /// </summary>
        Ean8 = 3,
        /// <summary>
        /// CODE39
        /// </summary>
        Code39 = 4,
        /// <summary>
        /// ITF
        /// </summary>
        Itf = 5,
        /// <summary>
        /// CODABAR
        /// </summary>
        Codabar = 6,
        /// <summary>
        /// CODE93
        /// </summary>
        Code93 = 7,
        /// <summary>
        /// CODE128
        /// </summary>
        Code128 = 10
    }

    /// <summary>
    /// тег. аргумент функции IFiscalCore.SetTagAttribute
    /// </summary>
    public enum Tag
    {
        /// <summary>
        /// Признак предмета расчёта
        /// </summary>
        [Description("Признак предмета расчёта")]
        ItemProperty = 1212,
        /// <summary>
        /// Признак способа расчёта
        /// </summary>
        [Description("Признак способа расчёта")]
        PaymentProperty = 1214
    }

    /// <summary>
    /// Режим работы. Аргумент IAuth.Exchange при запросе DirectIO(-2, "", auth, callback)
    /// </summary>
    public enum Mode
    {
        /// <summary>
        /// ОФД
        /// </summary>
        [Description("ОФД")]
        OFD = 0,
        /// <summary>
        /// ЕНВД без ФН (до 1.07.2018)
        /// </summary>
        [Description("ЕНВД без ФН (до 1.07.2018)")]
        ENVD = 1
    }

    /// <summary>
    /// код команды DirectIO.
    /// Для ChangeMode и GetMode в результате успешного выполнения IFisalCore.DirectIO в аргументе IAuth.Result передаётся код нового режима работы (Mode.OFD или Mode.ENVD)
    /// </summary>
    public enum DirectIOCmd
    {
        /// <summary>
        /// смена режима работы. 
        /// </summary>
        ChangeMode = -2,
        /// <summary>
        /// запрос режима работы. 
        /// </summary>
        GetMode = -1,
    }
}