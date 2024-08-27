﻿#Область ПрограммныйИнтерфейс

Функция ПутьКФайлам() Экспорт
	
	ВсеНастройки = ИТК_НастройкиВызовСервера.ЗагрузитьВсе();
	ОбщиеНастройки = ВсеНастройки[ИТК_НастройкиКлиентСервер.ИмяРеквизитаНастройкиОбщие()];
		
	Возврат ОбщиеНастройки["ВыгруженныеФайлы"];
	
КонецФункции

Функция ТекстМодуля(Путь, ОписаниеМодуля) Экспорт
	
	ПолноеИмяФайла = ИТК_ФайлыКонфигурацииКлиентСервер.ПолноеИмяФайлаМодуля(Путь, ОписаниеМодуля);
	
	Файл = Новый Файл(ПолноеИмяФайла);
	
	Если НЕ Файл.Существует() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	ТекстовыйДокумент.Прочитать(ПолноеИмяФайла);
	
	Возврат ТекстовыйДокумент.ПолучитьТекст();
	
КонецФункции

#КонецОбласти
