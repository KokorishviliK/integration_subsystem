﻿////////////////////////////////////////////////////////////////////////////////
// инт_ОчередьОтправкиИсходящихСообщений
//  
////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Процедура - Зарегистрировать сообщение к рассылке
// Процедура регистрирует сообщения для подписчиков
// Параметры:
//  ИдентификаторСообщения    -  УникальныйИдентификатор                - Уникальный идентификатор рассылаемого сообщения 
//  МассивПодписчиков         -  Массив        - Массив элементов СправочникСсылка.инт_Подписчики которым будет отправлено данное сообщение.
//
Процедура ЗарегистрироватьСообщениеКРассылкеПодписчикам(ИдентификаторСообщения, МассивПодписчиков) Экспорт
    Для Каждого Подписчик Из МассивПодписчиков Цикл
        ЗаписьЖурналаРегистрации("ПодсистемаИнтеграции.ОчередьОтправкиСообщений",УровеньЖурналаРегистрации.Информация,,,"Зарегистрируем сообщение по подписчику "+ Строка(Подписчик));
        ЗарегистрироватьСообщениеКРассылкеПодписчику(ИдентификаторСообщения, Подписчик);
    КонецЦикла;
    
КонецПроцедуры
  
// Процедура - Зарегистрировать сообщение к рассылке
// Процедура регистрирует сообщения для подписчиков
// Параметры:
//  ИдентификаторСообщения    -  УникальныйИдентификатор                - Уникальный идентификатор рассылаемого сообщения 
//  Подписчик         -  СправочникСсылка.инт_Подписчики        - Подписчик которому будет отправлено данное сообщение.
//
Процедура ЗарегистрироватьСообщениеКРассылкеПодписчику(ИдентификаторСообщения, Подписчик) Экспорт

    НачатьТранзакцию();
    Попытка
        Запись = РегистрыСведений.инт_ОчередьОтправкиИсходящихСообщений.СоздатьМенеджерЗаписи();
        Запись.ИдентификаторСообщения = ИдентификаторСообщения;
        Запись.Подписчик = Подписчик;
        Запись.Записать();
        
        РегистрыСведений.инт_ТекущийСтатусРассылкиСообщений.ЗаписатьСтатусСообщения(Запись.ИдентификаторСообщения,Подписчик, Перечисления.инт_СтатусыРассылкиИсходящихСообщений.Новый);
        ЗафиксироватьТранзакцию();
    Исключение
        ОтменитьТранзакцию();
        ЗаписьЖурналаРегистрации("ПодсистемаИнтеграции.ОчередьОтправкиСообщений",УровеньЖурналаРегистрации.Ошибка,,,ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
        ВызватьИсключение;
    КонецПопытки;

КонецПроцедуры

// Процедура - Сформировать сообщение
//
// Параметры:
//  Сообщение     - Структура - Структура содержащая <ИдентификаторСообщения, Подписчик> 
//
Процедура СформироватьСообщение(Сообщение) Экспорт
	ДанныеИсходящегоСообщения = РегистрыСведений.инт_ОчередьИсходящихСообщений.ПолучитьДанныеОчередиПоИдентификатору(Сообщение.ИдентификаторСообщения, "СформированноеСообщение");
    
    СериализованноеСообщение = Справочники.инт_Подписчики.СформироватьСообщениеПоПодписчику(ДанныеИсходящегоСообщения.СформированноеСообщение, Сообщение.Подписчик);
    
    НачатьТранзакцию();
    Попытка
        ЗаписатьСформированноеСообщение(Сообщение.ИдентификаторСообщения, Сообщение.Подписчик, СериализованноеСообщение);
        РегистрыСведений.инт_ТекущийСтатусРассылкиСообщений.ЗаписатьСтатусСообщения(Сообщение.ИдентификаторСообщения, Сообщение.Подписчик, Перечисления.инт_СтатусыРассылкиИсходящихСообщений.Сформирован);
        ЗафиксироватьТранзакцию();
    Исключение
        ОтменитьТранзакцию();
        ПодробноеПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
        РегистрыСведений.инт_ТекущийСтатусИсходящихСообщений.ЗаписатьСтатусСообщения(Сообщение.ИдентификаторСообщения, Сообщение.Подписчик, Перечисления.инт_СтатусыРассылкиИсходящихСообщений.ОшибкаОтправки, ПодробноеПредставлениеОшибки);
        СообщениеОбОшибке = СтрШаблон("При попытке сформировать сообщение с идентификатором <%1> для подписчика <%2> возникла ошибка.
        |
        |Информация об ошибке: %3", Сообщение.ИдентификаторСообщения, Сообщение.Подписчик, ПодробноеПредставлениеОшибки);
        ЗаписьЖурналаРегистрации("ПодсистемаИнтеграции.МенеджерПотоковОтправкиСообщений", УровеньЖурналаРегистрации.Ошибка,,,СообщениеОбОшибке);
    КонецПопытки;
    
КонецПроцедуры

// Процедура - Отправить сообщение
// Пытается отправить сообщение способом указанным в подписчике.
// Параметры:
//   Сообщение     - Структура - Структура содержащая <ИдентификаторСообщения, Подписчик>  
//
Процедура ОтправитьСообщение(Сообщение) Экспорт
    ДанныеСообщения = РегистрыСведений.инт_ОчередьОтправкиИсходящихСообщений.СоздатьМенеджерЗаписи();
    ДанныеСообщения.ИдентификаторСообщения = Сообщение.ИдентификаторСообщения;
    ДанныеСообщения.Подписчик = Сообщение.Подписчик;
    ДанныеСообщения.Прочитать();
        
    //Справочники.инт_Подписчики.ОтправитьСообщениеПодписчику(ДанныеСообщения);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

 Процедура ЗаписатьСформированноеСообщение(ИдентификаторСообщения, Подписчик, СформированноеСообщение)
  	Запись = РегистрыСведений.инт_ОчередьОтправкиИсходящихСообщений.СоздатьМенеджерЗаписи();
    Запись.ИдентификаторСообщения = ИдентификаторСообщения;
    Запись.Подписчик = Подписчик;
    Запись.Прочитать();
    Запись.СформированноеСообщение = СформированноеСообщение;
    Запись.Записать(Истина);
КонецПроцедуры

#КонецОбласти

#КонецЕсли
