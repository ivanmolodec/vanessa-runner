Примеры автоматизации базовых операций
==
 
> beta версия 
 
Описание 
===

Пример автоматизации различных операции для работы с cf/cfe/epf файлами и простой запуск vanessa-behavior и xunitfor1c тестов. 
Основной код сосредоточен в tools/runner.os , ключ --help покажет справку по параметрам. 

В папке tools так же расположенны примеры bat файлов для легкого запуска определенных действий. 
Основной принцип - запустили bat файл с настроенными командами и получили результат.

К папке epf несколько обработок позволяющих упростить деплой для конфигураций основанных на БСП. 

Основной пример это передача через параметры /C комманды "ЗапуститьОбновлениеИнформационнойБазы;ЗавершитьРаботуСистемы" и одновременно выполняем через /Execute"ЗакрытьПредприятие.epf", т.е. при запуске с такими ключами подключается обработчик ожидания проверят наличие формы с заголовком обновление и при окончании обновления завершает предприятие. Данное действие необходимо, для полного обновления предприятия, пока действует блокировка на фоновые задачи и запуск пользователей.

**ЗагрузитьРасширение** позволяет подключать разрешение в режиме предприятия и получать результат ошибки. Предназначенно для подключения в конфигурациях основаных на БСП. В параметрах /C передается путь к расширению и путь к файлу лога подключения. 
**ЗагрузитьВнешниеОбработки** позволяет загрузить все внешние обработки и подключить в справочник "Дополнительные отчеты и обработки", т.к. их очень много то первым параметром идет каталог, вторым параметром путь к файлу лога. Все обработки обновляются согласно версиям.

Сборка
===

Для сборки обработок необходимо иметь установленный oscript в переменной PATH и платформу выше 8.3.8 , в коммандной строке перейти в каталог с проектом и выполнить ```tools\compile_epf.bat``` по окончанию в каталоге build\epf должны появиться обработки.
Вся разработка в конфигураторе делается в каталоге build, по окончанию доработок запускаем ```tools\decompile_epf.bat``` 

 
 
 
