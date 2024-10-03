﻿///////////////////////////////////////////////////////////////////////////////
// инт_РаботаССообщениямиПодсистемаИнтеграции
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Функция - Сформировать сообщение по подписчику
//
// Параметры:
//  ДанныеСообщения        - Соответствие                   - Соответствие содержащее данные для сериализации
//  Подписчик              - СпраочникСсылка.инт_Подписчики - Ссылка на подписчика
//  ИдентификаторСообщения - УникальныйИдентификатор        - УИД сообщения
// 
// Возвращаемое значение:
//  Строка - Сериализованное, котовое к отправке подписчику сообщение
//
Функция СформироватьСообщениеПоПодписчику(ДанныеСообщения, Подписчик, ИдентификаторСообщения) Экспорт
    // Пока так. 
    // В теории тут могут быть манипуляции с сообщением. Например подсовывание других параметров сериализации(не знаю, форматы дат-там другие и тд)
	СоответствиеJRPC = СформироватьСоответствиеJRPC(ДанныеСообщения, ИдентификаторСообщения);
	
	Возврат инт_КоннекторHTTP.ОбъектВJson(СоответствиеJRPC);
	
КонецФункции

// Процедура - Отправить сообщение подписчику
//
// Параметры:
//  Сообщение     - Структура - Данные сообщения 
//
Процедура ОтправитьСообщение(Сообщение) Экспорт
	
	ДанныеСообщения = РегистрыСведений.инт_ОчередьИсходящихСообщений.ПолучитьДанныеОчередиПоИдентификатору(Сообщение.ИдентификаторСообщения, "ИсходныеДанные");

	Если ДанныеСообщения = Неопределено Тогда
		ВызватьИсключение СтрШаблон("Данные сообщения с идентификатором <%1> не найдены.", Сообщение.ИдентификаторСообщения);
	КонецЕсли;

	Подписчик		= Сообщение.Подписчик;
	url				= Подписчик.СсылкаНаСервис;
	
	Если НЕ ЗначениеЗаполнено(url) Тогда
		ВызватьИсключение СтрШаблон("Не заполнена ссылка на сервис для подписчика <%1>", Подписчик);
	КонецЕсли;
	
	Сессия = инт_КоннекторHTTP.СоздатьСессию();
	
	Если ЗначениеЗаполнено(Подписчик.Пользователь) Тогда
		Аутентификация = Справочники.инт_Подписчики.ПолучитьСтруктуруАутентификацииПодписчика(Подписчик);
		Сессия.Вставить("Аутентификация", Аутентификация);
	КонецЕсли;
	
	Ответ = инт_КоннекторHTTP.Post(url, Сообщение.СформированноеСообщение, , Сессия);
	
	Справочники.инт_Подписчики.ВыполнитьПостОбработку(Подписчик, Ответ, ДанныеСообщения.ИсходныеДанные);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СформироватьСоответствиеJRPC(ДанныеСообщения, ИдентификаторСообщения)
	
	ПотокДанных			= РегистрыСведений.инт_ОчередьИсходящихСообщений.ПолучитьДанныеОчередиПоИдентификатору(ИдентификаторСообщения, "ПотокДанных");
	ИдентификаторПотока = ИТКВ_Общий.ЗначениеРеквизитаОбъекта(ПотокДанных, "Код");
	
	СоответствиеJRPC = Новый Структура;
	СоответствиеJRPC.Вставить("jsonrpc",	"2.0");
	СоответствиеJRPC.Вставить("method",		Строка(ИдентификаторПотока));
	СоответствиеJRPC.Вставить("params",		ДанныеСообщения);
	СоответствиеJRPC.Вставить("id",			Строка(ИдентификаторСообщения));
	
	Возврат СоответствиеJRPC;
	
КонецФункции

#КонецОбласти
