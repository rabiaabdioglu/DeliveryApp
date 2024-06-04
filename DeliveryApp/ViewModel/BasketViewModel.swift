//
//  BasketViewModel.swift
//  DeliveryApp
//
//  Created by Rabia Abdioğlu on 1.06.2024.
//
import Foundation
import UIKit
import RxSwift

class BasketViewModel {
    var foodRepo = FoodRepository()
    var basketRepo = BasketRepository()
    var basketList = BehaviorSubject<[BasketModel]>(value: [BasketModel]())
    
    init() {
          fetchBasket()
      }
    // MARK: Basket Repo
    func fetchBasket() {
        basketRepo.fetchBasket { [self] list in
            basketList = basketRepo.basketList
        }
    }

    func syncBasket() {
         basketRepo.syncBasket()
     }

    func deleteFoodInBasket(basket: BasketModel) {
        basketRepo.deleteFoodInBasket(basket: basket)
    }

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
    
    func removeAllBasket() {
        basketRepo.removeAllBasket()
    }
}
