//
//  FoodDetailViewModel.swift
//  DeliveryApp
//
//  Created by Rabia Abdioğlu on 1.06.2024.
//

import Foundation

import RxSwift
import UIKit

class FoodDetailViewModel {
    var foodRepo = FoodRepository()
    var basketRepo = BasketRepository()

    // MARK: Food Repo
    func fetchFoodImageData(imageName: String, completion: @escaping (UIImage?) -> Void) {
        foodRepo.fetchFoodImageData(imageName: imageName) { data in
            guard let data = data, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            completion(image)
        }
    }
    
    // MARK: Basket Repo

    func fetchBasket(){
        basketRepo.fetchBasket{ _ in
        }
    }
    
    func updateFoodInBasket(food: FoodModel, count: Int) {
        basketRepo.updateFoodInBasket(food: food, count: count)

    }
}
