﻿// BSLLS:Typo-off
////////////////////////////////////////////////////////////////////////////////
// инт_ЭндпоинтыКлиент
//  
////////////////////////////////////////////////////////////////////////////////
#Область СлужебныйПрограммныйИнтерфейс
Процедура АдресРесурсаПриИзменении(АдресРесурса, Форма) Экспорт
	ИмяГруппыЭндпоинт = инт_ЭндпоинтыКлиентСервер.ИмяГруппыЭндпоинт();
	Форма.Элементы[ИмяГруппыЭндпоинт].Заголовок = инт_ЭндпоинтыКлиентСервер.СформироватьЗаголовок(АдресРесурса);
КонецПроцедуры

Процедура ТипАвторизацииПриИзменении(ТипАвторизации, Форма) Экспорт
	Если Не ЗначениеЗаполнено(ТипАвторизации) Тогда
		Возврат;
	КонецЕсли;
	Форма.Элементы[инт_ЭндпоинтыКлиентСервер.ИмяГруппыСтраниц()].ТекущаяСтраница = Форма.Элементы[Строка(ТипАвторизации)];
КонецПроцедуры

#КонецОбласти
