﻿///////////////////////////////////////////////////////////////////////////////
// инт_РаботаССообщениямиПодсистемаИнтеграции
//  
////////////////////////////////////////////////////////////////////////////////

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
    // Пока так. 
    // В теории тут могут быть манипуляции с сообщением. Сериализация в xml, подсовывание других параметров сериализации(не знаю, форматы дат-там другие и тд)
    // но пока просто в json для mvp
    Возврат инт_КоннекторHTTP.ОбъектВJson(ДанныеСообщения);
		
КонецФункции

// Процедура - Отправить сообщение подписчику
//
// Параметры:
//  Сообщение     - Структура - Данные сообщения 
//
Процедура ОтправитьСообщение(Сообщение) Экспорт

    ВызватьИсключение "Пока не готово";

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти
