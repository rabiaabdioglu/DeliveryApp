//
//  FoodRepository.swift
//  DeliveryApp
//
//  Created by Rabia Abdioğlu on 1.06.2024.
//


import Foundation
import RxSwift
import Alamofire
import UIKit
import Kingfisher

class FoodRepository {
    var foodList = BehaviorSubject<[FoodModel]>(value: [])
    
    // MARK: Fetch Food
    func fetchFood() {
        
        AF.request("http://kasimadalan.pe.hu/yemekler/tumYemekleriGetir.php")
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [String: Any],
                       let foodArray = json["yemekler"] as? [[String: String]] {
                        
                        let foods = foodArray.map { foodDict -> FoodModel in
                            let id = Int(foodDict["yemek_id"] ?? "") ?? 0
                            let name = foodDict["yemek_adi"] ?? ""
                            let imageName = foodDict["yemek_resim_adi"] ?? ""
                            let price = Int(foodDict["yemek_fiyat"] ?? "") ?? 0
                            return FoodModel(id: id, name: name, imageName: imageName, price: price)
                        }
                        
                        self.foodList.onNext(foods)
                    }
                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
            }
    }
    
    // MARK: Fetch Food Image
    func fetchFoodImageData(imageName: String, completion: @escaping (Data?) -> Void) {
        let imageUrlString = "http://kasimadalan.pe.hu/yemekler/resimler/\(imageName)"
        
        guard let imageUrl = URL(string: imageUrlString) else {
            completion(nil)
            return
        }
        
        // Kingfisher
        let imageView = UIImageView()
        imageView.kf.setImage(with: imageUrl) { result in
            switch result {
            case .success(let value):
                completion(value.data())
            case .failure(let error):
                print("Error loading image: \(error)")
                completion(nil)
            }
        }
    }
    
}
