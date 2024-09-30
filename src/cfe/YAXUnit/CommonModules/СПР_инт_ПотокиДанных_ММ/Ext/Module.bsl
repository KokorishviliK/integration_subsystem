﻿// BSLLS-off
// BSLLS:Typo-off
// @strict-types

/////////////////////////////////////////////////////////////////////////////////

// Экспортные процедуры и функции, предназначенные для использования другими 

// объектами конфигурации или другими программами

///////////////////////////////////////////////////////////////////////////////// 

#Область СлужебныйПрограммныйИнтерфейс

Процедура ИсполняемыеСценарии() Экспорт

    ЮТТесты.УдалениеТестовыхДанных().ВТранзакции()
    .ДобавитьТест("ПроверитьФормированиеСообщенияПоПотоку")
    .ДобавитьТест("ВызовФормированияСообщенияПоВходящемуПотокуВызываетИсключение")
    .ДобавитьТест("ПроверкаПолученияПодписчиковПоПотоку")
    .ДобавитьТест("ВалидацияПакетаПоПотокуУспех")
    .ДобавитьТест("ВалидацияПакетаПоПотокуСОшибками");

КонецПроцедуры

#Область События

Процедура ПередВсемиТестами() Экспорт

КонецПроцедуры

Процедура ПередКаждымТестом() Экспорт

КонецПроцедуры

Процедура ПослеКаждогоТеста() Экспорт

КонецПроцедуры

Процедура ПослеВсехТестов() Экспорт

КонецПроцедуры
#КонецОбласти

Процедура ПроверитьФормированиеСообщенияПоПотоку() Экспорт
    ПотокДанных = ГенераторТестовыхДанных.ПотокДанныхИсходящий();
    ИсходныеДанные = ГенераторТестовыхДанных.демо_Документ();
	
    СформированноеСообщение = Справочники.инт_ПотокиДанных.СформироватьСообщениеПоПотоку(ИсходныеДанные, ПотокДанных);
    
    ЮТест.ОжидаетЧто(СформированноеСообщение)
    .ИмеетТип(Тип("Соответствие"))
    .Свойство("uuid").Равно(ИсходныеДанные.УникальныйИдентификатор())
    .Свойство("text").ИмеетТип("Строка").Равно(ИсходныеДанные.ДемоРеквизитСтрока)
    .Свойство("items").ИмеетДлину(ИсходныеДанные.Товары.Количество());
    
КонецПроцедуры

Процедура ВызовФормированияСообщенияПоВходящемуПотокуВызываетИсключение() Экспорт
    
    ПотокДанных = ГенераторТестовыхДанных.ПотокДанныхВходящий();
    ИсходныеДанные = ГенераторТестовыхДанных.демо_Документ();
    
    ЮТест.ОжидаетЧто(Справочники.инт_ПотокиДанных)
    .Метод("СформироватьСообщениеПоПотоку")
    .Параметр(ИсходныеДанные)
    .Параметр(ПотокДанных)
    .ВыбрасываетИсключение("Нельзя формировать сообщения по входящим потокам данных!");
    
КонецПроцедуры

Процедура ПроверкаПолученияПодписчиковПоПотоку() ЭКспорт
    ПотокДанных = ГенераторТестовыхДанных.ПотокДанныхИсходящий();
    Подписчики = Справочники.инт_ПотокиДанных.ПолучитьПодписчиковПоПотоку(ПотокДанных);
    ЮТест.ОжидаетЧто(Подписчики)
    .имеетТип("Массив")
    .ИмеетДлину(ПотокДанных.ПодписчикиПотока.Количество())
    .Содержит(ПотокДанных.ПодписчикиПотока[0].Подписчик);
    
КонецПроцедуры

Процедура ВалидацияПакетаПоПотокуСОшибками() Экспорт
    ПотокДанных = ГенераторТестовыхДанных.ПотокДанныхИсходящий(,,,Истина);
	МассивОшибок = Новый массив;
	МассивОшибок.Добавить("Страшная ошибка");
	Мокито.Обучение(инт_ВалидаторПакетов)
	.Когда("Валидировать").Вернуть(МассивОшибок)
	.Прогон();
	 
	    ЮТест.ОжидаетЧто(Справочники.инт_ПотокиДанных)
            .Метод("ВалидироватьСообщениеПоПотоку")
                .Параметр(Новый соответствие)
                .Параметр(ПотокДанных)
                .ВыбрасываетИсключение("возникла ошибка валидации");

КонецПроцедуры

Процедура ВалидацияПакетаПоПотокуУспех() Экспорт
    ПотокДанных = ГенераторТестовыхДанных.ПотокДанныхИсходящий(,,,Истина);
	Мокито.Обучение(инт_ВалидаторПакетов)
	.Когда("Валидировать").Вернуть(Новый Массив)
	.Прогон();
	
	Справочники.инт_ПотокиДанных.ВалидироватьСообщениеПоПотоку(Новый соответствие, ПотокДанных);
КонецПроцедуры
#КонецОбласти

#Область СлужебныеПроцедурыИФункции // BSLLS:EmptyRegion-off

#КонецОбласти
