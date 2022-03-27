#Область ОписаниеПеременных

Перем Лог;
Перем Настройки;
Перем МенеджерRac;

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура ЗарегистрироватьКоманду(Знач ИмяКоманды, Знач Парсер) Экспорт

	ТекстОписанияКоманды = "     Удалить информационную базу через ras\rac.
	|";
	ОписаниеКоманды = Парсер.ОписаниеКоманды(ИмяКоманды, ТекстОписанияКоманды);

	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--ras", "Сетевой адрес RAS. Необязательный. По умолчанию localhost:1545");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--rac", "Команда запуска RAC. Необязательный. По умолчанию находим в каталоге установки 1с");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--name", "Имя информационной базы. Обязательный.");

	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--cluster-admin", "Администратор кластера");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--cluster-pwd", "Пароль администратора кластера");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--cluster", "Идентификатор кластера");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--cluster-name", "Имя кластера");

	Парсер.ДобавитьПараметрФлагКоманды(ОписаниеКоманды, "--drop-database", "Удалить базу данных при удалении информационной базы. По умолчанию БД не удаляется.");
	Парсер.ДобавитьПараметрФлагКоманды(ОписаниеКоманды, "--clear-database", "Очистить базу данных при удалении информационной базы. По умолчанию не очищается");

	Парсер.ДобавитьКоманду(ОписаниеКоманды);

КонецПроцедуры

Функция ВыполнитьКоманду(Знач ПараметрыКоманды, Знач ДополнительныеПараметры = Неопределено) Экспорт

	Попытка
		Лог = ДополнительныеПараметры.Лог;
	Исключение
		Лог = Логирование.ПолучитьЛог(ПараметрыСистемы.ИмяЛогаСистемы());
	КонецПопытки;

	Настройки = ПрочитатьПараметры(ПараметрыКоманды);

	Если Не ПараметрыВведеныКорректно() Тогда
		Возврат МенеджерКомандПриложения.РезультатыКоманд().НеверныеПараметры;
	КонецЕсли;

	УдалитьИнформационнуюБазу();
	Возврат МенеджерКомандПриложения.РезультатыКоманд().Успех;

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПрочитатьПараметры(Знач ПараметрыКоманды)

	Результат = Новый Структура;

	ОбщиеМетоды.ПоказатьПараметрыВРежимеОтладки(ПараметрыКоманды);
	ДанныеПодключения = ПараметрыКоманды["ДанныеПодключения"];

	Результат.Вставить("АдресСервераАдминистрирования", ОбщиеМетоды.Параметр(ПараметрыКоманды, "--ras", "localhost:1545"));
	Результат.Вставить("АдминистраторИБ", ДанныеПодключения.Пользователь);
	Результат.Вставить("ПарольАдминистратораИБ", ДанныеПодключения.Пароль);
	Результат.Вставить("АдминистраторКластера", ПараметрыКоманды["--cluster-admin"]);
	Результат.Вставить("ПарольАдминистратораКластера", ПараметрыКоманды["--cluster-pwd"]);
	Результат.Вставить("ИдентификаторКластера", ПараметрыКоманды["--cluster"]);
	Результат.Вставить("ИмяКластера", ПараметрыКоманды["--cluster-name"]);
	Результат.Вставить("ИспользуемаяВерсияПлатформы", ПараметрыКоманды["--v8version"]);

	Результат.Вставить("УдалитьБД", ПараметрыКоманды["--drop-database"]);
	Результат.Вставить("ОчиститьБД", ПараметрыКоманды["--clear-database"]);
	Результат.Вставить("ИмяИБ", ПараметрыКоманды["--name"]);

	Результат.Вставить("ПутьКлиентаАдминистрирования", "");

	МенеджерRac = Новый МенеджерRAC(Результат, ПараметрыКоманды, Лог);

	// Получим путь к платформе, если вдруг не установленна
	Результат.Вставить("ПутьКлиентаАдминистрирования", МенеджерRac.ПолучитьПутьRAC());

	Возврат Результат;
КонецФункции

Функция ПараметрыВведеныКорректно()

	Успех = Истина;

	Если Не ЗначениеЗаполнено(Настройки.АдресСервераАдминистрирования) Тогда
		Лог.Ошибка("Не указан сервер администрирования");
		Успех = Ложь;
	КонецЕсли;

	Если Не ЗначениеЗаполнено(Настройки.ПутьКлиентаАдминистрирования) Тогда
		Лог.Ошибка("Не указан путь к RAC. Найти подходящий путь также не удалось.");
		Успех = Ложь;
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(Настройки.ИмяИБ) Тогда
		Лог.Ошибка("Не указано имя удаляемой ИБ");
		Успех = Ложь;
	КонецЕсли;

	Возврат Успех;

КонецФункции

/////////////////////////////////////////////////////////////////////////////////
// Взаимодействие с кластером

Процедура УдалитьИнформационнуюБазу()

	Лог.Информация("Создаю клиент-серверную информационную базу");

	ОписаниеКластера = МенеджерRAC.ОписаниеКластера();
	Лог.Отладка("Найден идентификатор кластера %1", ОписаниеКластера.Идентификатор);

	КомандаВыполнения = МенеджерRAC.СтрокаЗапускаКлиента() + "infobase drop ";

	ИдентификаторБазы = МенеджерRAC.ИдентификаторБазы();
	Если ЗначениеЗаполнено(ИдентификаторБазы) Тогда
		Командавыполнения = КомандаВыполнения + "--infobase=""" + ИдентификаторБазы + """ ";
	КонецЕсли;

	Если Настройки.УдалитьБД Тогда
		КомандаВыполнения = КомандаВыполнения + "--drop-database ";
	ИначеЕсли Настройки.ОчиститьБД Тогда
		КомандаВыполнения = КомандаВыполнения + "--clear-database ";
	КонецЕсли; // BSLLS:IfElseIfEndsWithElse-off

	ИдентификаторКластера = МенеджерRAC.ИдентификаторКластера(ОписаниеКластера);
	КомандаВыполнения = КомандаВыполнения + "--cluster=""" + ИдентификаторКластера + """ ";

	КомандаВыполнения = КомандаВыполнения + МенеджерRAC.КлючиАвторизацииВКластере();
	КомандаВыполнения = КомандаВыполнения + МенеджерRAC.КлючиАвторизацииВБазе();
	КомандаВыполнения = КомандаВыполнения + " " + Настройки.АдресСервераАдминистрирования;
	Лог.Отладка(КомандаВыполнения);

	ОбщиеМетоды.ЗапуститьПроцесс(КомандаВыполнения);

	Лог.Информация("Клиент-серверная информационная база удалена: %1", Настройки.ИмяИБ);

	Если Настройки.УдалитьБД Тогда
		ТекстПоУдалениюБД = "Также удалена база данных в СУБД";
	Иначе
		ТекстПоУдалениюБД = "Внимание: не удалена база данных в СУБД";
		Если Настройки.ОчиститьБД Тогда
			ТекстПоУдалениюБД = ТекстПоУдалениюБД + "
			|база данных полностью очищена";
		Иначе
			ТекстПоУдалениюБД = ТекстПоУдалениюБД + "
			|база данных не очищена, осталась неизменной.";
		КонецЕсли;
	КонецЕсли;
	Лог.Информация(ТекстПоУдалениюБД);
КонецПроцедуры

#КонецОбласти
