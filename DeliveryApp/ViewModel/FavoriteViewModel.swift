//
//  FavoriteViewModel.swift
//  DeliveryApp
//
//  Created by Rabia Abdioğlu on 3.06.2024.
//

import Foundation
import RxSwift
import UIKit

class FavoriteViewModel {
     var favoriteFoods = BehaviorSubject<[FoodModel]>(value: [])
    var foodRepo = FoodRepository()
    var basketRepo = BasketRepository()

    init(){
        fetchFood()
        fetchFavoriteFoods()
    }
    
    // MARK: Food Repo

     func fetchFavoriteFoods() {
         let defaults = UserDefaults.standard
         let favoriteFoodNames = defaults.array(forKey: "favoriteFoods") as? [String] ?? []

         let favoriteFoodModels = favoriteFoodNames.compactMap { foodName in
             do {
                 return try foodRepo.foodList.value().first { $0.name == foodName }
             } catch {
                 print("Error retrieving value from BehaviorSubject: \(error)")
                 return nil
             }
         }

         favoriteFoods.onNext(favoriteFoodModels)
     }
    func fetchFood(){
        foodRepo.fetchFood()
    }
    
    func fetchFoodImageData(imageName: String, completion: @escaping (UIImage?) -> Void) {
        foodRepo.fetchFoodImageData(imageName: imageName) { data in
            guard let data = data, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            completion(image)
        }
    }
    
    func ara(aramaKelimesi:String){
//        foodRepo.ara(aramaKelimesi: aramaKelimesi)
    }
    
    // MARK: Basket Repo 
    func updateFoodInBasket(food: FoodModel, count: Int) {
        basketRepo.updateFoodInBasket(food: food, count: count)
    }
    func addFoodToBasket(food: FoodModel) {
        basketRepo.addFoodToBasket(food: food)
    }


}
