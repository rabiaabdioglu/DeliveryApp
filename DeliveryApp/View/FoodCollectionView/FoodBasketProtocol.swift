//
//  FoodBasketProtocol.swift
//  DeliveryApp
//
//  Created by Rabia Abdioğlu on 4.06.2024.
//

import Foundation
protocol FoodBasketProtocol {
    func updateFoodInBasket(food: FoodModel, count: Int)
    func addFoodToBasket(food: FoodModel)
    
}

