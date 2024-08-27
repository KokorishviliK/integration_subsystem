﻿#Область ПрограммныйИнтерфейс

// Проверяет текст запроса извлекает параметры
//
// Параметры:
//	Текст - Строка - Текст запроса
//
// Возвращаемое значение:
//	Структура - информация о проверке
//		*ТекстОшибки - Строка - Текст ошибки
//		*Параметры - ОписаниеПараметровЗапроса - Описание параметров запроса
//
Функция ПроверитьТекст(Текст) Экспорт
	
	Возврат ИТК_Запрос.ПроверитьТекст(Текст);
	
КонецФункции

// Преобразует текст запроса во вложенный дополняя ВЫБРАТЬ * ()
//
// Параметры:
//  Текст  - Строка - Текст запрос
//  ИмяЗапроса  - Строка - Имя запроса
//
// Возвращаемое значение:
//   Строка - Преобразованный текст запроса
//
Функция ПреобразоватьТекстЗапросаВоВложенный(Текст, ИмяЗапроса) Экспорт
	
	Результат = Новый Структура;
	
	ТекстОшибки = "";
	
	СхемаЗапроса = Новый СхемаЗапроса();
	
	Попытка
		
		СхемаЗапроса.УстановитьТекстЗапроса(Текст);
		
		КоличествоЗапросовВыборкиДанных = ИТК_Запрос.КоличествоВПакете(СхемаЗапроса, Истина);
		
		Если КоличествоЗапросовВыборкиДанных = 0 Тогда
			ВызватьИсключение НСтр("ru = 'Нет запроса выборки данных'; en = 'There is no query of sample data'");
		ИначеЕсли КоличествоЗапросовВыборкиДанных > 1 Тогда
			ВызватьИсключение НСтр("ru = 'Несколько запросов выборки'; en = 'A few sample requests'");
		КонецЕсли;
		
		// Получаем текст вложенного запроса
		СхемаВложенногоЗапроса = Новый СхемаЗапроса();
		СхемаВложенногоЗапроса.УстановитьТекстЗапроса(Текст);
		ПакетВложенногоЗапроса = СхемаВложенногоЗапроса.ПакетЗапросов[0];
		
		ПакетВложенногоЗапроса.ТаблицаДляПомещения = "";
		ПакетВложенногоЗапроса.АвтоПорядок = Ложь;
		ПакетВложенногоЗапроса.Порядок.Очистить();
		ПакетВложенногоЗапроса.ОбщиеИтоги = Ложь;
		ПакетВложенногоЗапроса.ВыраженияИтогов.Очистить();
		ПакетВложенногоЗапроса.КонтрольныеТочкиИтогов.Очистить();
		
		ТекстВложенногоЗапроса = СхемаВложенногоЗапроса.ПолучитьТекстЗапроса();
		
		НоваяСхемаЗапроса = Новый СхемаЗапроса();
		НовыйПакетЗапросов = НоваяСхемаЗапроса.ПакетЗапросов.Добавить(Тип("ЗапросВыбораСхемыЗапроса"));
		НовыйОператор = НовыйПакетЗапросов.Операторы.Добавить();
		НовыйПакетЗапросов.Операторы.Удалить(0);
		
		НовыйИсточник = НовыйОператор.Источники.Добавить(Тип("ВложенныйЗапросСхемыЗапроса"), ИмяЗапроса);
		НовыйИсточник.Источник.Запрос.УстановитьТекстЗапроса(ТекстВложенногоЗапроса);
		
		ПакетЗапросов = СхемаЗапроса.ПакетЗапросов[0];
		
		КолонкиПакетаЗапросов = ПакетЗапросов.Колонки;
		Для Индекс = 0 По КолонкиПакетаЗапросов.Количество() - 1 Цикл
			
			Колонка = КолонкиПакетаЗапросов[Индекс];
			НовыйОператор.ВыбираемыеПоля.Добавить(СтрШаблон("%1.%2", ИмяЗапроса, Колонка.Псевдоним));
			КолонкиПакетаЗапросов[Индекс].Псевдоним = Колонка.Псевдоним;
			
		КонецЦикла;
		
		ЗаполнитьЗначенияСвойств(НовыйПакетЗапросов, ПакетЗапросов, "ТаблицаДляПомещения, АвтоПорядок, ОбщиеИтоги");
		
		// Порядок
		Для Каждого Порядок Из ПакетЗапросов.Порядок Цикл
			
			Если ТипЗнч(Порядок.Элемент) = Тип("ВыражениеСхемыЗапроса") Тогда
				Поле = Порядок.Элемент;
			Иначе
				Поле = НовыйПакетЗапросов.Колонки.Найти(Порядок.Элемент.Псевдоним)
			КонецЕсли;
			
			НовыйПорядок = НовыйПакетЗапросов.Порядок.Добавить(Поле);
			НовыйПорядок.Направление = Порядок.Направление;
			
		КонецЦикла;
		
		// ВыраженияИтогов
		Для Каждого ВыражениеИтогов Из ПакетЗапросов.ВыраженияИтогов Цикл
			
			Колонка = НовыйПакетЗапросов.Колонки.Найти(ВыражениеИтогов.Поле.Псевдоним);
			НовыйПакетЗапросов.ВыраженияИтогов.Добавить(ВыражениеИтогов.Выражение, Колонка);
			
		КонецЦикла;
		
		// КонтрольныеТочкиИтогов
		Для Каждого КонтрольнаяТочкаИтогов Из ПакетЗапросов.КонтрольныеТочкиИтогов Цикл
			
			Колонка = НовыйПакетЗапросов.Колонки.Найти(КонтрольнаяТочкаИтогов.ИмяКолонки);
			НоваяКонтрольнаяТочкаИтогов = НовыйПакетЗапросов.КонтрольныеТочкиИтогов.Добавить(Колонка);
			ЗаполнитьЗначенияСвойств(НоваяКонтрольнаяТочкаИтогов, КонтрольнаяТочкаИтогов);
			
		КонецЦикла;
		
		Результат.Вставить("Текст", НоваяСхемаЗапроса.ПолучитьТекстЗапроса());
		
	Исключение
		
		ТекстОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		
	КонецПопытки;
	
	Результат.Вставить("Ошибка", ТекстОшибки);
	
	Возврат Результат;
	
КонецФункции

// Получает дату из описания границы (значение сложного параметра)
//
// Параметры:
//  ОписаниеГраницы  - Структура - Описание границы (значение сложного параметра)
//
// Возвращаемое значение:
//   Дата - Дата
//
Функция ДатаИзОписанияГраницы(ОписаниеГраницы) Экспорт
	
	Возврат ИТК_Запрос.ДатаИзОписанияГраницы(ОписаниеГраницы);
	
КонецФункции

// Получает момент времени из описания границы (значение сложного параметра)
//
// Параметры:
//  ОписаниеГраницы  - Структура - Описание границы (значение сложного параметра)
//
// Возвращаемое значение:
//   Дата - Дата
//
Функция МоментВремениИзОписанияГраницы(ОписаниеГраницы) Экспорт
	
	Возврат ИТК_Запрос.МоментВремениИзОписанияГраницы(ОписаниеГраницы);
	
КонецФункции

// Возвращает описание границы
//
// Параметры:
//  Граница - Граница - Граница
//
// Возвращаемое значение:
//   Структура - Описание границы
//
Функция ОписаниеИзГраницы(Граница) Экспорт
	
	Возврат ИТК_Запрос.ОписаниеИзГраницы(Граница);
	
КонецФункции

// Возвращает границу из момента времени
//
// Параметры:
//  МоментВремени - МоментВремени - Момент времени
//
// Возвращаемое значение:
//   Граница - Граница
//
Функция ГраницаИзМоментаВремени(МоментВремени) Экспорт
	
	Возврат Новый Граница(МоментВремени);
	
КонецФункции

// Возвращает дату из момента времени
//
// Параметры:
//  МоментВремени - МоментВремени - Момент времени
//
// Возвращаемое значение:
//   Дата - Дата
//
Функция ДатаИзМоментаВремени(МоментВремени) Экспорт
	
	Возврат МоментВремени.Дата;
	
КонецФункции

Функция АнализПреобразованияПараметраВЗначение(Данные, Имя) Экспорт
	
	Потеряно = 0; Преобразуется = 0;
	
	Значение = ИТК_Запрос.ЗначениеПараметра(Данные, Имя);
	
	Если ТипЗнч(Значение) = Тип("СписокЗначений") Тогда
		
		Для Каждого ОписаниеЗначения Из Значение Цикл
			
			АнализПреобразованияЗначенияПараметраВЗначение(ОписаниеЗначения.Значение, Потеряно, Преобразуется);
			
		КонецЦикла;
		
	Иначе
		
		АнализПреобразованияЗначенияПараметраВЗначение(Значение, Потеряно, Преобразуется);
		
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("Потеряно", Потеряно);
	Результат.Вставить("Преобразуется", Преобразуется);
	
	Возврат Результат;
	
КонецФункции

Функция ЗначениеПараметраВТекст(Данные, Имя) Экспорт
	
	Язык = ИТК_Общий.КодЯзыкаПрограммирования();
	
	Значение = ИТК_Запрос.ЗначениеПараметра(Данные, Имя);
	
	Если ТипЗнч(Значение) = Тип("СписокЗначений") Тогда
		
		Значения = Новый Массив;
		Для Каждого ОписаниеЗначения Из Значение Цикл
			
			ЗначениеТекст = ИТК_Запрос.ЗначениеПараметраВТекст(ОписаниеЗначения.Значение, Язык);
			
			Если ЗначениеТекст <> Неопределено
					И Значения.Найти(ЗначениеТекст) = Неопределено Тогда
				
				Значения.Добавить(ЗначениеТекст);
				
			КонецЕсли;
			
		КонецЦикла;
		
		Результат = СтрСоединить(Значения, ", ");
		
	Иначе
		
		Результат = ИТК_Запрос.ЗначениеПараметраВТекст(Значение, Язык);
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ПоИсточнику(Параметры) Экспорт
	
	Колонки = Параметры.Колонки;
	Язык = Параметры.Язык;
	ДобавлятьИндексы = Параметры.ДобавлятьИндексы;
	ВыразитьТипы = Параметры.ВыразитьТипы;
	Псевдоним = Параметры.Псевдоним;
	
	СхемаЗапроса = Новый СхемаЗапроса;
	Запрос = СхемаЗапроса.ПакетЗапросов[0];
	Оператор = Запрос.Операторы[0];
	Источник = Оператор.Источники.Добавить(Тип("ОписаниеВременнойТаблицыСхемыЗапроса"), Параметры.Источник, Псевдоним);
	Запрос.ТаблицаДляПомещения = СтрШаблон(НСтр("ru = 'ВременнаяТаблица%1'; en = 'TemporaryTable%1'", Язык), Псевдоним);
	
	ДоступныеПоля = Источник.Источник.ДоступныеПоля;
	
	Индекс = 0;
	Для Каждого ОписаниеКолонки Из Колонки Цикл
		
		ДоступныеПоля.Добавить(ОписаниеКолонки.Представление);
		
		// Добавление выражений полей
		Выражение = СтрШаблон("%1.%2", Псевдоним, ОписаниеКолонки.Представление);
		Если ВыразитьТипы Тогда
			
			ТипВыражения = ИТК_Запрос.ЗначениеВТекст(ОписаниеКолонки.Значение, Язык);
				
			Если ЗначениеЗаполнено(ТипВыражения) Тогда
				
				Выражение = СтрШаблон(НСтр("ru = 'ВЫРАЗИТЬ(%1 КАК %2)'; en = 'CAST(%1 AS %2)'", Язык), Выражение, ТипВыражения);
				
			КонецЕсли;
			
		КонецЕсли;
		
		ВыбираемыеПоля = Оператор.ВыбираемыеПоля;
		НовоеВыражение = ВыбираемыеПоля.Добавить(Выражение);
		ИндексКолонки = ВыбираемыеПоля.Индекс(НовоеВыражение);
		
		НоваяКолонка = Запрос.Колонки.Получить(ИндексКолонки);
		НоваяКолонка.Псевдоним = ОписаниеКолонки.Представление;
		
		// Добавление индексированных полей
		Если ОписаниеКолонки.Пометка И ДобавлятьИндексы Тогда
			
			Запрос.Индекс.Добавить(ОписаниеКолонки.Представление);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат СхемаЗапроса.ПолучитьТекстЗапроса();
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура АнализПреобразованияЗначенияПараметраВЗначение(Значение, Потеряно, Преобразуется)
	
	Результат = ИТК_Запрос.ЗначениеПараметраВТекст(Значение);
	Если Результат = Неопределено Тогда
		
		Потеряно = Потеряно + 1;
		
	Иначе
		
		Преобразуется = Преобразуется + 1;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
