﻿////////////////////////////////////////////////////////////////////////////////
// ФормаРедактированияОбработчика
//  
////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы
&НаКлиенте
Процедура ПриОткрытии(Отказ)
    ИТКВ_РедакторКодаКлиент.Инициализация(ЭтотОбъект, "РедакторКода");
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Сохранять = Ложь;
	ТекстОбработчика = Параметры.ТекстОбработчика;
    ДополнительныеПараметры = Новый Структура;
    ДополнительныеПараметры.Вставить("ВсегдаИспользоватьMonaco", Истина);
    ДополнительныеПараметры.Вставить("Подсказка", ТекстПодсказки());
    ИТКВ_РедакторКода.Инициализация(ЭтотОбъект, "РедакторКода", ЭтотОбъект, ДополнительныеПараметры);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти

#Область ОбработчикиКомандФормы

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
&НаСервере
Функция ТекстПодсказки()
	Возврат "В пост обработчике доступны следущие объекты:
	| 1. Ответ - Ответ полученный от удаленной системы. Подробнее см. инт_КоннекторHTTP.ВызватьМетод
	| 2. ИсходныеДанные - Ссылка но объект ИБ который указан в исходящем сообщении
	|";
КонецФункции

&НаКлиенте
Процедура ИТКВ_ПодключаемыйДокументСформирован(Элемент)
    ДополнительныеПараметры = Новый Структура;//("ПользовательскиеОбъекты", СобратьПользовательскиеОбъекты());
         
    ИТКВ_РедакторКодаКлиент.ДополнительнаяИнициализация(ЭтотОбъект, Элемент, ДополнительныеПараметры);
    ПодключаемыйЗагрузитьСостояниеРедактораКода();
    
КонецПроцедуры

&НаКлиенте
Процедура ИТКВ_ПодключаемыйВосстановлениеФокусаРедактора() Экспорт
	
	ИТКВ_РедакторКодаКлиент.ВосстановлениеФокусаРедактора(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодключаемыйЗагрузитьСостояниеРедактораКода()

	ЭлементТекст = Элементы.РедакторКода;
	
	Если ЭлементТекст = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ИТКВ_РедакторКодаКлиент.Инициализирован(ЭлементТекст) Тогда
		
		ПодключитьОбработчикОжидания("ПодключаемыйЗагрузитьСостояниеРедактораКода", 0.1, Истина);
		Возврат;
		
    КонецЕсли;
    
	ИТКВ_РедакторКодаКлиент.УстановитьДоступностьРедактирования(ЭтотОбъект, ЭлементТекст, Истина);
	ИТКВ_РедакторКодаКлиент.УстановитьТекст(ЭтотОбъект, ЭлементТекст, ТекстОбработчика);
		
КонецПроцедуры

&НаКлиенте
Процедура ИТКВ_ПодключаемыйПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
			ИмяОбработчика = "ОбработкаКодПриИзменении";
	
	ОписаниеОповещения = Новый ОписаниеОповещения(ИмяОбработчика, ЭтотОбъект);
	ИТКВ_РедакторКодаКлиент.ОбработкаСобытий(ЭтотОбъект, Элемент, ДанныеСобытия, СтандартнаяОбработка, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ИТКВ_ПодключаемаяКомандаРедакторКодаОбработчик(Команда)
	
	ДополнительныеПараметры = Новый Структура;
    //ДополнительныеПараметры.Вставить("UID", ТекущаяСтрока.UID);
	
	Данные = ИТКВ_КонсольРазработчикаДанныеКлиентСервер.НовыйЭлемент(ИТКВ_Перечисления.ЭлементДанныхКод());
    Данные.Вставить("Текст", ИТКВ_РедакторКодаКлиент.Текст(ЭтотОбъект, "РедакторКода"));
	ДополнительныеПараметры.Вставить("Данные", Данные);
	
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ОбработкаКомандыРедактораКодаЗавершена", ЭтотОбъект, ДополнительныеПараметры);
	
	ИмяКоманды = Команда.Имя;
	ИТКВ_РедакторКодаКлиент.ПодключаемыйОбработчикКоманд(ЭтотОбъект, ИмяКоманды, ОповещениеОЗавершении);
	
	Если СтрНайти(ИмяКоманды, "ЗафиксироватьИзменения") Тогда
		ИТКВ_КонсольРазработчикаДанныеКлиентСервер.СброситьОригинальныйТекст(Данные);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаКомандыРедактораКодаЗавершена(Результат, ДополнительныеПараметры) Экспорт

	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИТКВ_РедакторКодаКлиент.СтандартныйОбработчикЗавершенияКоманды(Результат, ДополнительныеПараметры);
		
	ИзменяемыеПоля = Новый Структура;
	ИзменяемыеПоля.Вставить("Текст", Результат);
	ИзменяемыеПоля.Вставить("ТребуетсяПроверка", Истина);
	ИзменяемыеПоля.Вставить("Ошибка", Неопределено);
	
	ПодключаемыйЗагрузитьСостояниеРедактораКода();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаКодПриИзменении(Результат, ДополнительныеПараметры) Экспорт
	
	ТекстКод = ИТКВ_РедакторКодаКлиент.Текст(ЭтотОбъект, "РедакторКода");

КонецПроцедуры

&НаКлиенте
Процедура СохранитьИЗакрыть(Команда)
	ТекстОбработчика = ИТКВ_РедакторКодаКлиент.Текст(ЭтотОбъект, "РедакторКода");
	Закрыть(ТекстОбработчика);
КонецПроцедуры

#КонецОбласти
