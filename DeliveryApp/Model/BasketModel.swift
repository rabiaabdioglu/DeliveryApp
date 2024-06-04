//
//  BasketModel.swift
//  DeliveryApp
//
//  Created by Rabia Abdioğlu on 1.06.2024.
//

import Foundation

class BasketModel : Codable{
    var basketID : Int?
    var foodName : String?
    var foodImageName : String?
    var foodPrice: Int?
    var moq : Int?
    var userName: String?
    
    init(basketID: Int, foodName: String, foodImageName: String, foodPrice: Int, moq: Int, userName: String) {
        self.basketID = basketID
        self.foodName = foodName
        self.foodImageName = foodImageName
        self.foodPrice = foodPrice
        self.moq = moq
        self.userName = userName
    }

}
