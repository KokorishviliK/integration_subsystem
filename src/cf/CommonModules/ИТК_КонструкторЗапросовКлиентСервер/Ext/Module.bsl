﻿#Область ПрограммныйИнтерфейс

Функция ПутьКДаннымЗаголовкаТаблицыПоля() Экспорт
	
	Возврат "ITKТаблицыПоляЗаголовок";
	
КонецФункции

Функция ПутьКДаннымЗаголовкаСвязи() Экспорт
	
	Возврат "ITKСвязиЗаголовок";
	
КонецФункции

Функция ПутьКДаннымЗаголовкаГруппировка() Экспорт
	
	Возврат "ITKГруппировкаЗаголовок";
	
КонецФункции

Функция ПутьКДаннымЗаголовкаУсловия() Экспорт
	
	Возврат "ITKУсловияЗаголовок";
	
КонецФункции

Функция ПутьКДаннымЗаголовкаДополнительно() Экспорт
	
	Возврат "ITKДополнительноЗаголовок";
	
КонецФункции

Функция ПутьКДаннымЗаголовкаОбъединить() Экспорт
	
	Возврат "ITKОбъединитьЗаголовок";
	
КонецФункции

Функция ПутьКДаннымЗаголовкаИндекс() Экспорт
	
	Возврат "ITKИндексЗаголовок";
	
КонецФункции

Функция ПутьКДаннымЗаголовкаПорядок() Экспорт
	
	Возврат "ITKПорядокЗаголовок";
	
КонецФункции

Функция ПутьКДаннымЗаголовкаИтоги() Экспорт
	
	Возврат "ITKИтогиЗаголовок";
	
КонецФункции

Функция ПутьКДаннымЗаголовкаПакетЗапросов() Экспорт
	
	Возврат "ITKПакетЗапросовЗаголовок";
	
КонецФункции

Функция ПутьКДаннымСлужебныйЗапуск() Экспорт
	
	Возврат "ITKСлужебныйЗапуск";
	
КонецФункции

Процедура ОбновитьЗаголовокСтраницыТаблицыПоля(Форма, Коллекция) Экспорт
	
	Заголовок = "";
	Если Не ЗначениеЗаполнено(Коллекция) Тогда
		
		Заголовок = "!";
		
	КонецЕсли;
	Форма[ПутьКДаннымЗаголовкаТаблицыПоля()] = Заголовок;

КонецПроцедуры

Процедура ОбновитьЗаголовокСтраницыСвязи(Форма, ЕстьСвязи, Источников) Экспорт
	
	Если Источников <= 1 Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Если ЕстьСвязи Тогда
		
		Заголовок = "*";
		
	Иначе
		
		Заголовок = "!";
		
	КонецЕсли;
	
	Форма[ИТК_КонструкторЗапросовКлиентСервер.ПутьКДаннымЗаголовкаСвязи()] = Заголовок;

КонецПроцедуры

Процедура ОбновитьЗаголовокСтраницыУсловия(Форма, Коллекция) Экспорт
	
	Форма[ПутьКДаннымЗаголовкаУсловия()] = Коллекция.Количество();

КонецПроцедуры

Процедура ОбновитьЗаголовокСтраницыДополнительно(Форма, Параметры) Экспорт
	
	ЕстьЗаголовок = Параметры.ВыбиратьРазрешенные
						ИЛИ Параметры.ВыбиратьРазличные
						ИЛИ Параметры.ВыбиратьДляИзменения
						ИЛИ ЗначениеЗаполнено(Параметры.ТаблицаДляПомещения)
						ИЛИ ЗначениеЗаполнено(Параметры.ТаблицыДляИзменения)
						ИЛИ ЗначениеЗаполнено(Параметры.КоличествоПолучаемыхЗаписей);
	
	Заголовок = "";
	Если ЕстьЗаголовок Тогда
			
		Заголовок = "*";
		
	КонецЕсли;
	
	Форма[ПутьКДаннымЗаголовкаДополнительно()] = Заголовок;

КонецПроцедуры

Функция Префикс() Экспорт
	
	Возврат "ITK";
	
КонецФункции

Функция ОсновноеИмяДействия() Экспорт
	
	Возврат Префикс() + "ПодключаемаяКоманда";

КонецФункции

Функция ПолеОтсутствует() Экспорт
	
	Возврат "<" + НСтр("ru='Отсутствует'; SYS='QueryEditor.Missing'", "ru") + ">";
	
КонецФункции

Функция Заголовок() Экспорт
	
	Возврат НСтр("ru = 'Конструктор запроса'; en = 'Query constructor'");
	
КонецФункции

Функция JoinType(Все1, Все2) Экспорт
	
	Если Все1 И Все2 Тогда
		
		Результат = "FullOuter";
		
	ИначеЕсли Все1 И Не Все2 Тогда
		
		Результат = "LeftOuter";
		
	ИначеЕсли НЕ Все1 И Все2 Тогда
		
		Результат = "RightOuter";
		
	Иначе
		
		Результат = "Inner";
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ИмяРеквизитаСвязи() Экспорт
	
	Возврат "ITKСвязи";
	
КонецФункции

Функция ИдентификаторЗначенийВнешнихИсточников() Экспорт
	
	Возврат "ITK_ЗначенияВнешнихИсточников";
	
КонецФункции

#КонецОбласти
