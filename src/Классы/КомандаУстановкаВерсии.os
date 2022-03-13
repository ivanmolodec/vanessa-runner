///////////////////////////////////////////////////////////////////
//
// Служебный модуль с реализацией работы команды set-version
//
// Структура модуля реализована в соответствии с рекомендациями
// oscript-app-template (C) EvilBeaver
//
///////////////////////////////////////////////////////////////////

#Использовать logos

Перем Лог;

Процедура ЗарегистрироватьКоманду(Знач ИмяКоманды, Знач Парсер) Экспорт

	ОписаниеКоманды = Парсер.ОписаниеКоманды(ИмяКоманды, "     Установка номера версии файлов 1С (конфигурации, расширения, внешние обработки\отчеты).");

	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--new-version",
		"Номер версии, который нужно установить");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--src",
		"Путь Configuration.xml или каталога, содержащего этот файл, или корневого каталога для поиска в подкаталогах - для исходников конфигурации или расширения");

	Парсер.ДобавитьКоманду(ОписаниеКоманды);

КонецПроцедуры // ЗарегистрироватьКоманду

// Выполняет логику команды
//
// Параметры:
//   ПараметрыКоманды - Соответствие - Соответствие ключей командной строки и их значений
//   ДополнительныеПараметры - Соответствие - дополнительные параметры (необязательно)
//
Функция ВыполнитьКоманду(Знач ПараметрыКоманды, Знач ДополнительныеПараметры) Экспорт

	Лог = ДополнительныеПараметры.Лог;

	НомерВерсии = ПараметрыКоманды["--new-version"];
	ПутьФайла = ПараметрыКоманды["--src"];

	Лог.Информация("Изменяю версию в исходниках конфигурации 1С на %1 - %2", НомерВерсии, ПутьФайла);

	МенеджерВерсийФайлов1С = Новый МенеджерВерсийФайлов1С;
	СтарыеВерсии = МенеджерВерсийФайлов1С.УстановитьВерсиюКонфигурации(ПутьФайла, НомерВерсии);

	Для каждого КлючЗначение Из СтарыеВерсии Цикл
		Лог.Информация("    Старая версия %1, файл - %2", КлючЗначение.Значение, КлючЗначение.Ключ);
	КонецЦикла;

	Возврат МенеджерКомандПриложения.РезультатыКоманд().Успех;

КонецФункции // ВыполнитьКоманду
