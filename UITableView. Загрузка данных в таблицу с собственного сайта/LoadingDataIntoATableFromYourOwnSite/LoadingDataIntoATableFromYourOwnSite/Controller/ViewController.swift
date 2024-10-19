//
//  ViewController.swift
//  LoadingDataIntoATableFromYourOwnSite
//
//  Created by Михаил on 14.10.2024.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
   
    // MARK: - Outlet
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Списки каналов
    var stations = [RadioStation]() {
        didSet {
            guard stations != oldValue else { return }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
                
            }
        }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Регистрируем ячейку "Ничего не найдено" xib
        let cellNib = UINib(nibName: "NothingFoundCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "NothingFound")
        
        // Настройка таблицы
        tableView.backgroundColor = .clear
        tableView.backgroundView = nil
        tableView.separatorStyle = .none
        
        // Загрузка данных
        loadStationsFromJSON()

        tableView.dataSource = self
    }

    // MARK: - TableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stations.isEmpty ? 1 : stations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if stations.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NothingFound", for: indexPath)
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StationCell", for: indexPath) as! StationTableViewCell
            
            // альтернативный цвет фона
            cell.backgroundColor = (indexPath.row % 2 == 0) ? UIColor.clear : UIColor.black.withAlphaComponent(0.1)
            
            let station = stations[indexPath.row]
            cell.configureStationCell(station: station)
            
            
            return cell
        }
    }
    
    //************************************
    // MARK: - Загрузка данных в stations
    //************************************
    
    func loadStationsFromJSON() {
        
        // Получить радиостанции
        DataManager.getStationDataWithSuccess() { (data) in
 
            print("Станции найдены в формате JSON")
            
            guard let data = data, let jsonDictionary = try? JSONDecoder().decode([String: [RadioStation]].self, from: data), let stationsArray = jsonDictionary["station"] else {
                    print("Ошибка загрузки станции JSON")
                return
            }
            self.stations = stationsArray
        }
    }
}

