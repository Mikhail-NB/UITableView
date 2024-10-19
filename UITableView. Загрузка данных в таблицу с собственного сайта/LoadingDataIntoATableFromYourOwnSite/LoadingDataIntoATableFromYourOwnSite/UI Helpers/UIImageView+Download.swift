//
//  UIImageView+Download.swift
//  LoadingDataIntoATableFromYourOwnSite
//
//  Created by Михаил on 14.10.2024.
//

import UIKit

extension UIImageView {
    
    func loadImageWithURL(url: URL, callback: @escaping (UIImage) -> ()) {
        let session = URLSession.shared
        
        let downloadTask = session.downloadTask(with: url, completionHandler: {
            [weak self] url, response, error in
            
            // Если при загрузке нет ошибок и url адрес не пустой
            if error == nil && url != nil {
                if let data = NSData(contentsOf: url!) {
                    if let image = UIImage(data: data as Data) {
                        // Так как мы используем сбегающее замыкание при котором замыкание может "избежать" область вызова функции -> вернемся в основной поток, для передачи изображения ячеке
                        DispatchQueue.main.async(execute: {
                            
                            if let strongSelf = self {
                                strongSelf.image = image
                                callback(image)
                            }
                        })
                    }
                }
            }
        })
        
        downloadTask.resume()
    }
    
}

