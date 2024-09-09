﻿////////////////////////////////////////////////////////////////////////////////

// инт_Подписчики

//  

////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Функция - Сформировать сообщение по подписчику
//
// Параметры:
//  ДанныеСообщения     -   Соответствие   - Соттветствие содержащее данные для сериатизации
//  Подписчик         -  СпраочникСсылка.инт_Подписчики    - ссылка на подписчика.
// 
// Возвращаемое значение:
//  Строка - Сериализованное, котовое к отправке подписчику сообщение
//
Функция СформироватьСообщениеПоПодписчику(ДанныеСообщения, Подписчик) Экспорт
    // По типу подписчика определяется обработчик сообщения. Может быть, если добавим jsonrpc например, будем сразу там паковать имя потока и тд...
    ОбработчикСобытий = инт_ОтправкаИсходящихСообщенийПовтИсп.ОбщийМодульОбработкиСообщенийПоТипуПодписчика(Подписчик.ТипПодписчика);
    
    Возврат ОбработчикСобытий.СформироватьСообщениеПоПодписчику(ДанныеСообщения, Подписчик);
КонецФункции

// Процедура - Отправить сообщение подписчику
//
// Параметры:
//  Сообщение     - Структура - Данные сообщения 
//
Процедура ОтправитьСообщение(Сообщение) Экспорт
    Подписчик = Сообщение.Подписчик;
    ОбработчикСобытий = инт_ОтправкаИсходящихСообщенийПовтИсп.ОбщийМодульОбработкиСообщенийПоТипуПодписчика(Подписчик.ТипПодписчика);
    ОбработчикСобытий.ОтправитьСообщение(Сообщение);

КонецПроцедуры

// Процедура - Расчитать дату следующей попытки по дате
//
// Параметры:
//  ДатаНачальная         -   Дата   - Дата от которой будет Отсчитываться пауза
//  Подписчик     - СправочникСсылка.инт_Подписчики - подписчик для которого будет делаться расчет
//
Функция РасчитатьДатуСледующейПопыткиПоДате(ДатаНачальная, Подписчик) Экспорт
   Возврат Дата(ДатаНачальная+Подписчик.ПаузаМеждуПопыткамиОбработки);
КонецФункции
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти

#КонецЕсли
