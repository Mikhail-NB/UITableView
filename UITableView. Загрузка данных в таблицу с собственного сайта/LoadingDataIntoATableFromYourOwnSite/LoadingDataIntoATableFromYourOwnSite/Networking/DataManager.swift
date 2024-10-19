//
//  DaraManager.swift
//  LoadingDataIntoATableFromYourOwnSite
//
//  Created by Михаил on 18.10.2024.
//

import UIKit

struct DataManager {
    
    //********************************************************************************
    // MARK: - Вспомогательная структура для получения локального или удаленного JSON
    //********************************************************************************

    static func getStationDataWithSuccess(success: @escaping ((_ metaData: Data?) -> Void)) {
    
        // Это очень высокоприоритетная фоновая очередь.
        DispatchQueue.global(qos: .userInitiated).async {
            // Проверяем корректность указанного в SwiftRadio-Setting интернет адреса с JSON
            guard let stationDataURL = URL(string: "https://codeexamples.ru/") else {
                print("SwiftRadio-Setting/let stationDataURL не является допустимым URL-адресом")
                success(nil)
                return
            }
            
            // Загружаем данные из интернета
            loadDataFromURL(url: stationDataURL) { data, error in
                success(data)
            }
        }
    }
        
    //*************************************
    // MARK: - Загружаем данные из интернета
    //*************************************
        
    static func loadDataFromURL(url: URL, completion: @escaping (_ data: Data?, _ error: Error?) -> Void) {
            
        // TODO: Выставляем конфигурацию сессии получения данных
        let sessionConfig = URLSessionConfiguration.default
        // Разрешаем устанавливать соединение через сотовую связь
        sessionConfig.allowsCellularAccess = true
        // Устанавливаем интервал времени ожидания запроса для всех задач в секундах
        sessionConfig.timeoutIntervalForRequest = 15
        // Устанавливаем максимальное время, которое может занять запрос ресурса.
        sessionConfig.timeoutIntervalForResource = 30
        // Устанавливаем максимальное количество одновременных подключений к данному хосту.
        sessionConfig.httpMaximumConnectionsPerHost = 1
            
        let session = URLSession(configuration: sessionConfig)
            
        // TODO: Используйте URLSession для получения данных из NSURL.
        let loadDataTask = session.dataTask(with: url) { data, response, error in
                
            // FIXME: Определяем типы ошибки получения данных
            guard error == nil else {
                completion(nil, error!)
                print("API: Ошибка \(error!)")
                return
            }
                
            guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                completion(nil, nil)
                print("API: Получение кода статуса между 200 и 299, что означает сбой сервера")
                return
            }
                
            guard let data = data else {
                completion(nil, nil)
                print("API: Данные не получены")
                return
            }
                
            // FIXME: Успех, возврат данных
            completion(data, nil)
        }
            
        loadDataTask.resume()
    }
}
