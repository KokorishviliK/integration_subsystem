﻿#Область ПрограммныйИнтерфейс

Функция ДоступенИнструмент(Инструмент) Экспорт
	
	Если Инструмент = ИТК_Перечисления.ИнструментЖурналРегистрации() Тогда
		
		Результат = ИТК_БСП.Поддерживается();
		
	ИначеЕсли Инструмент = ИТК_Перечисления.ИнструментРедакторОбъекта() Тогда
		
		Результат = ПравоДоступа("Использование", Метаданные.Обработки.ИТК_РедакторОбъекта);
		
	ИначеЕсли Инструмент = ИТК_Перечисления.ИнструментРедакторКонстант() Тогда
		
		Результат = ПравоДоступа("Использование", Метаданные.Обработки.ИТК_РедакторКонстант);
		
	ИначеЕсли Инструмент = ИТК_Перечисления.ИнструментРедакторПараметровСеанса() Тогда
		
		Результат = ПравоДоступа("Использование", Метаданные.Обработки.ИТК_РедакторПараметровСеанса);
		
	ИначеЕсли Инструмент = ИТК_Перечисления.ИнструментПоискСсылокНаОбъект() Тогда
		
		Результат = ПравоДоступа("Использование", Метаданные.Обработки.ИТК_ПоискСсылокНаОбъект);
		
	ИначеЕсли Инструмент = ИТК_Перечисления.ИнструментПоискИЗаменаСсылок() Тогда
		
		Результат = ПравоДоступа("Использование", Метаданные.Обработки.ИТК_ПоискИЗаменаСсылок);
		
	ИначеЕсли Инструмент = ИТК_Перечисления.ИнструментПодпискиНаСобытия() Тогда
		
		Результат = ПравоДоступа("Использование", Метаданные.Обработки.ИТК_ПодпискиНаСобытия);
		
	ИначеЕсли Инструмент = ИТК_Перечисления.ИнструментКонсольРазработчика()
				ИЛИ Инструмент = ИТК_Перечисления.ИнструментКонсольЗапросов()
				ИЛИ Инструмент = ИТК_Перечисления.ИнструментКонсольСхемКомпоновкиДанных()
				ИЛИ Инструмент = ИТК_Перечисления.ИнструментКонсольКода() Тогда
		
		Результат = ПравоДоступа("Использование", Метаданные.Обработки.ИТК_КонсольРазработчика);
		
	ИначеЕсли Инструмент = ИТК_Перечисления.ИнструментМониторЛицензий() Тогда
		
		Результат = ПравоДоступа("Использование", Метаданные.Отчеты.ИТК_МониторЛицензий);
		
	ИначеЕсли Инструмент = ИТК_Перечисления.ИнструментПользователи() Тогда
		
		Результат = ПравоДоступа("Использование", Метаданные.Обработки.ИТК_Пользователи);
		
	ИначеЕсли Инструмент = ИТК_Перечисления.ИнструментРегламентныеИФоновыеЗадания() Тогда
		
		Результат = ПравоДоступа("Использование", Метаданные.Обработки.ИТК_РегламентныеИФоновыеЗадания);
		
	Иначе
		
		Результат = Истина;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ОбъектОбработкиИнструмента(Инструмент, Объект) Экспорт
	
	Если Объект = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если Инструмент = ИТК_Перечисления.ИнструментПоискИЗаменаСсылок()
			ИЛИ Инструмент = ИТК_Перечисления.ИнструментСравнениеОбъектов()	Тогда
			
		// Необходимо обработать и оставить только ссылочные объекты
		ИсключаяПеречисления = (Инструмент = ИТК_Перечисления.ИнструментСравнениеОбъектов());
		Результат = ИзОбъектаТолькоСсылки(Объект, ИсключаяПеречисления);
			
	Иначе
		
		Результат = Объект;
		
	КонецЕсли;

	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ИзОбъектаТолькоСсылки(Объект, ИсключаяПеречисления = Ложь)
	
	ТипЗначенияОбъекта = ТипЗнч(Объект);
	
	Если ТипЗначенияОбъекта = Тип("СписокЗначений") Тогда
		
		Результат = Новый СписокЗначений;
		Для Каждого ЭлементСписка Из Объект Цикл
			
			Значение = ЭлементСписка.Значение;
			Если НЕ ИТК_ТипыКлиентСервер.ЭтоСсылочный(ТипЗнч(Значение)) Тогда
				Продолжить;
			КонецЕсли;
			
			Результат.Добавить(Значение);
			
		КонецЦикла;
		
	Иначе
		
		Если ИТК_ТипыКлиентСервер.ЭтоСсылочный(ТипЗначенияОбъекта) Тогда
			Результат = Объект;
		Иначе
			Результат = Неопределено;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
