﻿
////////////////////////////////////////////////////////////////////////////////

// <Заголовок модуля: краткое описание и условия применения модуля.>

//  

////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

Процедура ПередЗаписью(Отказ, Замещение)
	Для Каждого Запись Из ЭтотОбъект Цикл
		Если Перечисления.инт_СтатусыРассылкиИсходящихСообщений.ЭтоОшибочныйСтатус(Запись.СтатусСообщения)
			И Не ЗначениеЗаполнено(Запись.ТекстОшибки) Тогда
			ВызватьИсключение "При попытке зафиксировать ошибочный статус - не заполнен текст ошибки!";
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	Для Каждого Запись Из ЭтотОбъект Цикл
		РегистрыСведений.инт_ИсторияСтатусовРассылкиСообщений.ЗаписатьСтатусВИсторию(Запись.ИдентификаторСообщения,
		Запись.Подписчик,
		Запись.СтатусСообщения,
		Запись.ТекстОшибки);
		
		Если Запись.СтатусСообщения = Перечисления.инт_СтатусыРассылкиИсходящихСообщений.Отправлен Тогда
			Запрос = Новый Запрос;
			Запрос.Текст = "ВЫБРАТЬ
			               |	инт_ТекущийСтатусРассылкиСообщений.ИдентификаторСообщения КАК ИдентификаторСообщения
			               |ИЗ
			               |	РегистрСведений.инт_ТекущийСтатусРассылкиСообщений КАК инт_ТекущийСтатусРассылкиСообщений
			               |ГДЕ
			               |	инт_ТекущийСтатусРассылкиСообщений.ИдентификаторСообщения = &ИдентификаторСообщения
						   |	И НЕ инт_ТекущийСтатусРассылкиСообщений.СтатусСообщения = ЗНАЧЕНИЕ(Перечисление.инт_СтатусыРассылкиИсходящихСообщений.Отправлен)";
			Запрос.УстановитьПараметр("ИдентификаторСообщения", Запись.ИдентификаторСообщения);
			Если запрос.Выполнить().Пустой() Тогда
				// Больше неотправленных сообщений нет.
				РегистрыСведений.инт_СообщенияКУдалению.ЗарегистрироватьСообщениеКУдалению(Запись.ИдентификаторСообщения, Перечисления.инт_НаправлениеПотокаДанных.Исходящий);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

