//
//  StationTableViewCell.swift
//  LoadingDataIntoATableFromYourOwnSite
//
//  Created by Михаил on 14.10.2024.
//

import UIKit

class StationTableViewCell: UITableViewCell {

    @IBOutlet weak var stationImageView: UIImageView!
    @IBOutlet weak var stationNameLabel: UILabel!
    
    func configureStationCell(station: RadioStation) {
    
        stationNameLabel.text = station.name
        
        let imageURL = station.imageURL as NSString
        
        if imageURL.contains("http") {
            
            if let url = URL(string: station.imageURL) {
                    stationImageView.loadImageWithURL(url: url) { (image) in
                        // изображение станции загружено
                }
            }
                
        }  else {
            stationImageView.image = UIImage(named: "stationImage")
        }
    }
}
