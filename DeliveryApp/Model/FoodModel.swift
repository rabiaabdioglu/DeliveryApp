//
//  FoodModel.swift
//  DeliveryApp
//
//  Created by Rabia Abdioğlu on 1.06.2024.
//

import Foundation

class FoodModel : Codable{
    var id : Int?
    var name: String?
    var imageName: String?
    var price: Int?
    
    init(id: Int, name: String, imageName: String, price: Int) {
        self.id = id
        self.name = name
        self.imageName = imageName
        self.price = price
    }

}
