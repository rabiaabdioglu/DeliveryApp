//
//  HomeViewModel.swift
//  DeliveryApp
//
//  Created by Rabia Abdioğlu on 1.06.2024.
//

import Foundation
import RxSwift
import UIKit

class HomeViewModel {
    
    var foodRepo = FoodRepository()
    var basketRepo = BasketRepository()
    
    var foodList = BehaviorSubject<[FoodModel]>(value: [FoodModel]())
    
    init(){
        foodList = foodRepo.foodList
    }
    
    // MARK: Food Repo
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
