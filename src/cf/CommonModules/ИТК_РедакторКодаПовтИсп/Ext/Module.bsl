﻿#Область ПрограммныйИнтерфейс

Функция ОписаниеСпискаОбъектовМетаданных(ИмяОбъекта) Экспорт
	
	Результат = Новый Структура;
	ПустаяСтруктура = Новый Структура;
	
	Для Каждого ОбъектМетаданных Из Метаданные[ИмяОбъекта] Цикл
		
		Результат.Вставить(ОбъектМетаданных.Имя, ПустаяСтруктура);
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ОписаниеОбъектаМетаданных(ИмяОбъекта) Экспорт
	
	Части = СтрРазделить(ИмяОбъекта, ".");
	ИмяКоллекцииMonaco = ИТК_РедакторКодаКлиентСерверПовтИсп.ИмяКоллекцииМетаданныхПоТипу(Части[0]);
	
	Если НЕ ЗначениеЗаполнено(ИмяКоллекцииMonaco) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ОписаниеОбъекта = Новый Структура;
	
	ОбъектМетаданных = Метаданные[Части[0]][Части[1]];
	ИмяОбъектаКоллекции = ИТК_Метаданные.ИмяОбъектаКоллекции(ОбъектМетаданных);
	
	ОписаниеРеквизитов = Новый Структура;
	ОписаниеРесурсов = Новый Структура;
	ОписаниеПредопределенных = Новый Структура;
	ОписаниеТабличныхЧастей = Новый Структура;
	ДополнительныеСвойства = Новый Структура;
	
	Кэш = Новый Соответствие;
	
	Если ИТК_МетаданныеКлиентСерверПовтИсп.ЭтоПеречисление(ИмяОбъектаКоллекции) Тогда
		
		Для Каждого ЗначениеПеречисления Из ОбъектМетаданных.ЗначенияПеречисления Цикл
			
			ОписаниеРеквизитов.Вставить(ЗначениеПеречисления.Имя, Новый Структура("name", ЗначениеПеречисления.Синоним));
			
		КонецЦикла;
		
	ИначеЕсли ИТК_МетаданныеКлиентСерверПовтИсп.ЭтоКонстанта(ИмяОбъектаКоллекции)
				ИЛИ ИТК_МетаданныеКлиентСерверПовтИсп.ЭтоОбщийМодуль(ИмяОбъектаКоллекции) Тогда
		
		ОписаниеРеквизитов.Вставить(ОбъектМетаданных.Имя, Новый Структура);
		
	Иначе
		
		Для Каждого Реквизит Из ОбъектМетаданных.Реквизиты Цикл
			
			ОписаниеРеквизитов.Вставить(Реквизит.Имя, ИТК_РедакторКода.ОписаниеПоля(Кэш, Реквизит));
			
		КонецЦикла;
		
		Если ИТК_МетаданныеКлиентСерверПовтИсп.ИмеетСтандартныеРеквизиты(ИмяОбъектаКоллекции) Тогда
			
			Для Каждого Реквизит Из ОбъектМетаданных.СтандартныеРеквизиты Цикл
				
				ОписаниеРеквизитов.Вставить(Реквизит.Имя, ИТК_РедакторКода.ОписаниеПоля(Кэш, Реквизит));
				
			КонецЦикла;
			
		КонецЕсли;
		
		Если ИТК_МетаданныеКлиентСерверПовтИсп.ОбъектCПредопределенными(ИмяОбъектаКоллекции) Тогда
			
			Предопределенные = ИТК_Метаданные.Предопределенные(ОбъектМетаданных);
			Для Каждого ОписаниеПредопределенного Из Предопределенные Цикл
				
				ОписаниеПредопределенных.Вставить(ОписаниеПредопределенного.Значение, ОписаниеПредопределенного.Представление);
				
			КонецЦикла;
			
		КонецЕсли;
		
		Если ИТК_МетаданныеКлиентСерверПовтИсп.ЭтоРегистр(ИмяОбъектаКоллекции) Тогда
			
			Для Каждого Измерение Из ОбъектМетаданных.Измерения Цикл
				
				ОписаниеРеквизитов.Вставить(Измерение.Имя, ИТК_РедакторКода.ОписаниеПоля(Кэш, Измерение));
				
			КонецЦикла;
			
			Для Каждого Ресурс Из ОбъектМетаданных.Ресурсы Цикл
				
				ОписаниеРесурсов.Вставить(Ресурс.Имя, ИТК_РедакторКода.ОписаниеПоля(Кэш, Ресурс));
				
			КонецЦикла;
			
			// Заполнение типа регистра
			ТипРегистра = "";
			
			Если ИТК_МетаданныеКлиентСерверПовтИсп.ЭтоРегистрСведений(ИмяОбъектаКоллекции) Тогда
				
				Если ОбъектМетаданных.ПериодичностьРегистраСведений = Метаданные.СвойстваОбъектов.ПериодичностьРегистраСведений.Непериодический Тогда
					ТипРегистра = "nonperiodical";
				Иначе
					ТипРегистра = "periodical";
				КонецЕсли;
				
			ИначеЕсли ИТК_МетаданныеКлиентСерверПовтИсп.ЭтоРегистрНакопления(ИмяОбъектаКоллекции) Тогда
				
				Если ОбъектМетаданных.ВидРегистра = Метаданные.СвойстваОбъектов.ВидРегистраНакопления.Остатки Тогда
					ТипРегистра = "balance";
				Иначе
					ТипРегистра = "turnovers";
				КонецЕсли;
				
			КонецЕсли;
			
			Если ЗначениеЗаполнено(ТипРегистра) Тогда
				ДополнительныеСвойства.Вставить("type", ТипРегистра);
			КонецЕсли;
			
		КонецЕсли;
		
		Если ИТК_МетаданныеКлиентСерверПовтИсп.ИмеетСтандартныеТабличныеЧасти(ИмяОбъектаКоллекции) Тогда
			
			Для Каждого ТабличнаяЧасть Из ОбъектМетаданных.СтандартныеТабличныеЧасти Цикл
				
				ДобавитьОписаниеТабличнойЧасти(Кэш, ТабличнаяЧасть, ОписаниеРеквизитов, ОписаниеТабличныхЧастей, Ложь);
				
			КонецЦикла;
			
		КонецЕсли;
		
		Если ИТК_МетаданныеКлиентСерверПовтИсп.ИмеетТабличныеЧасти(ИмяОбъектаКоллекции) Тогда
			
			Для Каждого ТабличнаяЧасть Из ОбъектМетаданных.ТабличныеЧасти Цикл
				
				ДобавитьОписаниеТабличнойЧасти(Кэш, ТабличнаяЧасть, ОписаниеРеквизитов, ОписаниеТабличныхЧастей);
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ОписаниеОбъекта.Вставить("properties", ОписаниеРеквизитов);
	ОписаниеОбъекта.Вставить("predefined", ОписаниеПредопределенных);
	
	Для Каждого ДополнительноеСвойство Из ДополнительныеСвойства Цикл
		ОписаниеОбъекта.Вставить(ДополнительноеСвойство.Ключ, ДополнительноеСвойство.Значение);
	КонецЦикла;
	
	ОписаниеОбъекта.Вставить("resources", ОписаниеРесурсов);
	ОписаниеОбъекта.Вставить("tabulars", ОписаниеТабличныхЧастей);
	
	Результат = Новый Структура;
	Результат.Вставить("ОписаниеМетаданных", ОписаниеОбъекта);
	
	ОбластьОбновления = ИмяКоллекцииMonaco + ".items." + ОбъектМетаданных.Имя;
	Результат.Вставить("ОбластьОбновления", ОбластьОбновления);
	
	Возврат Результат;
	
КонецФункции

Функция RefКоллекции(Имя) Экспорт
	
	Если ИТК_МетаданныеКлиентСерверПовтИсп.ЭтоСправочник(Имя) Тогда
		
		Результат = "catalogs";
		
	ИначеЕсли ИТК_МетаданныеКлиентСерверПовтИсп.ЭтоДокумент(Имя) Тогда
		
		Результат = "documents";
		
	ИначеЕсли ИТК_МетаданныеКлиентСерверПовтИсп.ЭтоРегистрСведений(Имя) Тогда
		
		Результат = "infoRegs";
		
	ИначеЕсли ИТК_МетаданныеКлиентСерверПовтИсп.ЭтоРегистрНакопления(Имя) Тогда
		
		Результат = "accumRegs";
		
	ИначеЕсли ИТК_МетаданныеКлиентСерверПовтИсп.ЭтоРегистрБухгалтерии(Имя) Тогда
		
		Результат = "accountRegs";
		
	ИначеЕсли ИТК_МетаданныеКлиентСерверПовтИсп.ЭтоПеречисление(Имя) Тогда
		
		Результат = "enums";
		
	ИначеЕсли ИТК_МетаданныеКлиентСерверПовтИсп.ЭтоПланСчетов(Имя) Тогда
		
		Результат = "сhartsOfAccounts";
		
	ИначеЕсли ИТК_МетаданныеКлиентСерверПовтИсп.ЭтоБизнесПроцесс(Имя) Тогда
		
		Результат = "businessProcesses";
		
	ИначеЕсли ИТК_МетаданныеКлиентСерверПовтИсп.ЭтоЗадача(Имя) Тогда
		
		Результат = "tasks";
		
	ИначеЕсли ИТК_МетаданныеКлиентСерверПовтИсп.ЭтоПланОбмена(Имя) Тогда
		
		Результат = "exchangePlans";
		
	ИначеЕсли ИТК_МетаданныеКлиентСерверПовтИсп.ЭтоПланВидовХарактеристик(Имя) Тогда
		
		Результат = "chartsOfCharacteristicTypes";
		
	ИначеЕсли ИТК_МетаданныеКлиентСерверПовтИсп.ЭтоПланВидовРасчета(Имя) Тогда
		
		Результат = "chartsOfCalculationTypes";
		
	//	Результат = "dataProc";
	//	Результат = "reports";
	//	Результат = "commonModules";
		
	Иначе
		
		Результат = "";
		
	КонецЕсли;

	Возврат Результат;
	
КонецФункции

Функция ОписаниеОбщихМодулейJSON(Клиент, Сервер) Экспорт
	
	Результат = Новый Соответствие;
	ПустаяСтруктура = Новый Структура;
	
	Для Каждого ОбщийМодуль Из Метаданные.ОбщиеМодули Цикл
		
		Если ОбщийМодуль.Глобальный Тогда
			Продолжить;
		КонецЕсли;
		
		Если (Клиент И ОбщийМодуль.КлиентУправляемоеПриложение)
				ИЛИ (Сервер И ОбщийМодуль.Сервер) Тогда
				
			Результат.Вставить(ОбщийМодуль.Имя, ПустаяСтруктура);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ИТК_ОбщийКлиентСервер.КоллекциюВJSONСтроку(Результат);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ДобавитьОписаниеТабличнойЧасти(Кэш, ТабличнаяЧасть, ОписаниеРеквизитов, ОписаниеТабличныхЧастей, УчитыватьРеквизиты = Истина)
	
	ОписаниеРеквизитов.Вставить(ТабличнаяЧасть.Имя, Новый Структура("name", "ТЧ: " + ТабличнаяЧасть.Синоним));
	
	ОписаниеТабличнойЧасти = ОписаниеТабличнойЧасти(Кэш, ТабличнаяЧасть, УчитыватьРеквизиты);
	
	Если ЗначениеЗаполнено(ОписаниеТабличнойЧасти) Тогда
		ОписаниеТабличныхЧастей.Вставить(ТабличнаяЧасть.Имя, ОписаниеТабличнойЧасти);
	КонецЕсли;
	
КонецПроцедуры

Функция ОписаниеТабличнойЧасти(Кэш, ТабличнаяЧасть, УчитыватьРеквизиты = Истина)
	
	Результат = Новый Структура;
	
	Для Каждого РеквизитТЧ Из ТабличнаяЧасть.СтандартныеРеквизиты Цикл
		
		Результат.Вставить(РеквизитТЧ.Имя, РеквизитТЧ.Синоним);
		
	КонецЦикла;
	
	Если УчитыватьРеквизиты Тогда
		
		Для Каждого РеквизитТЧ Из ТабличнаяЧасть.Реквизиты Цикл
			
			Результат.Вставить(РеквизитТЧ.Имя, ИТК_РедакторКода.ОписаниеПоля(Кэш, РеквизитТЧ));
			
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

