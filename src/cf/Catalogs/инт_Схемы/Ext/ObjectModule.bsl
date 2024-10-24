﻿
////////////////////////////////////////////////////////////////////////////////
// <Заголовок модуля: краткое описание и условия применения модуля.>
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#КонецОбласти

#Область ОбработчикиСобытий
  
Процедура ПриЗаписи(Отказ)
    Если ОбменДанными.Загрузка Тогда
        Возврат;
    КонецЕсли;
    Если ЗначениеЗаполнено(ТекстСхемыJson) Тогда
        РегистрыСведений.инт_КэшированиеСхемOpenApi.ОбновитьДатуКэша(Ссылка);
	КонецЕсли;
	Если ПометкаУдаления Тогда
		Справочники.инт_Эндпоинты.УдалитьЭндпоинт(СсылкаНаСхему);
	КонецЕсли;
    ОбновитьПовторноИспользуемыеЗначения();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти

