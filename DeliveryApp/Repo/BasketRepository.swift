//
//  BasketRepository.swift
//  DeliveryApp
//
//  Created by Rabia Abdioğlu on 1.06.2024.
//
import Foundation
import RxSwift
import Alamofire

class BasketRepository: FoodBasketProtocol {
    
    var basketList = BehaviorSubject<[BasketModel]>(value: [])
    
    // MARK: Fetch basket items from server
    func fetchBasket(completion: @escaping ([BasketModel]) -> Void) {
        let parameters: [String: String] = ["kullanici_adi": "rabiaabdioglu"]
        
        AF.request("http://kasimadalan.pe.hu/yemekler/sepettekiYemekleriGetir.php", method: .post, parameters: parameters)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [String: Any],
                       let foodArray = json["sepet_yemekler"] as? [[String: String]] {
                        let foods = foodArray.map { basketDict -> BasketModel in
                            let basketId = Int(basketDict["sepet_yemek_id"]!) ?? 0
                            let foodName = basketDict["yemek_adi"]!
                            let foodImageName = basketDict["yemek_resim_adi"]!
                            let foodPrice = Int(basketDict["yemek_fiyat"]!) ?? 0
                            let moq = Int(basketDict["yemek_siparis_adet"]!) ?? 0
                            return BasketModel(basketID: basketId, foodName: foodName, foodImageName: foodImageName, foodPrice: foodPrice, moq: moq, userName: "rabiaabdioglu")
                        }

                        self.basketList.onNext(foods)
                        completion(foods)
                    }
                case .failure(let error):
                    print("Request failed with error: \(error)")
                    completion([])
                }
            }
        print("fetch basket : \(try! self.basketList.value().count)")
    }
    
    // MARK: Save basket item to server
    func saveToBasket(basket: BasketModel, completion: (() -> Void)? = nil) {
        let parameters: [String: Any] = ["yemek_adi": basket.foodName!,
                                         "yemek_resim_adi": basket.foodImageName!,
                                         "yemek_fiyat": basket.foodPrice!,
                                         "yemek_siparis_adet": basket.moq!,
                                         "kullanici_adi": "rabiaabdioglu"]
        
        AF.request("http://kasimadalan.pe.hu/yemekler/sepeteYemekEkle.php", method: .post, parameters: parameters)
            .responseDecodable(of: CRUDCevap.self) { response in
                guard let cevap = response.value else { return }
                print("Message: \(cevap.message!)")
                completion?()
            }
    }
    
    // MARK: Delete basket item from server
    func deleteBasket(basket: BasketModel, completion: (() -> Void)? = nil) {
        let parameters: [String: Any] = ["sepet_yemek_id": basket.basketID!, "kullanici_adi": "rabiaabdioglu"]
        
        AF.request("http://kasimadalan.pe.hu/yemekler/sepettenYemekSil.php", method: .post, parameters: parameters)
            .responseDecodable(of: CRUDCevap.self) { response in
                guard let cevap = response.value else { return }
                print("Message: \(cevap.message!)")
                completion?()
            }
    }
    
    // MARK: Update basket item on the server
    func updateBasket(basket: BasketModel, completion: (() -> Void)? = nil) {
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        deleteBasket(basket: basket) {
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            dispatchGroup.enter()
            self.saveToBasket(basket: basket) {
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion?()
        }
    }
    
    // MARK: Sync local basket with server
    func syncBasket() {
        fetchBasket { [self] currentBasket in
            let defaults = UserDefaults.standard
            var savedBasket: [BasketModel] = []
            
            if let savedBasketData = defaults.data(forKey: "localBasket") {
                let decoder = PropertyListDecoder()
                if let loadedBasket = try? decoder.decode([BasketModel].self, from: savedBasketData) {
                    savedBasket = loadedBasket
                }
            }
            
            var itemsToAdd: [BasketModel] = []
            var itemsToUpdate: [BasketModel] = []
            var itemsToDelete = currentBasket
            
            for savedItem in savedBasket {
                if let currentBasketItem = currentBasket.first(where: { $0.foodName == savedItem.foodName }) {
                    if currentBasketItem.moq != savedItem.moq {
                        let updatedItem = currentBasketItem
                        updatedItem.moq = savedItem.moq
                        itemsToUpdate.append(updatedItem)
                    }
                    
                    itemsToDelete.removeAll { $0.foodName == savedItem.foodName }
                } else {
                    itemsToAdd.append(savedItem)
                }
            }
            
            let dispatchGroup = DispatchGroup()
            
            for item in itemsToUpdate {
                dispatchGroup.enter()
                self.updateBasket(basket: item) {
                    dispatchGroup.leave()
                }
            }
            
            for item in itemsToAdd {
                dispatchGroup.enter()
                self.saveToBasket(basket: item) {
                    dispatchGroup.leave()
                }
            }
            
            for item in itemsToDelete {
                dispatchGroup.enter()
                self.deleteBasket(basket: item) {
                    dispatchGroup.leave()
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                self.fetchBasket { basket in
                    self.basketList.onNext(basket)
                }
            }
        }
    }

    // MARK: - User defaults functions
    
    // MARK:  Load basket from UserDefaults
    func loadBasketFromUserDefaults() -> [BasketModel] {
        if let savedBasketData = UserDefaults.standard.data(forKey: "localBasket") {
            let decoder = PropertyListDecoder()
            if let loadedBasket = try? decoder.decode([BasketModel].self, from: savedBasketData) {
                return loadedBasket
            }
        }
        return []
    }
    
    // MARK:  Save basket to UserDefaults
    func saveBasketToUserDefaults(_ basket: [BasketModel]) {
        let encoder = PropertyListEncoder()
        if let encoded = try? encoder.encode(basket) {
            UserDefaults.standard.set(encoded, forKey: "localBasket")
        }
    }
    
    // MARK:  Add food to basket
    func addFoodToBasket(food: FoodModel) {
        var savedBasket = loadBasketFromUserDefaults()
        let basketToSave = BasketModel(basketID: 0, foodName: food.name!, foodImageName: food.imageName!, foodPrice: food.price!, moq: 1, userName: "rabiaabdioglu")
        savedBasket.append(basketToSave)
        
        saveBasketToUserDefaults(savedBasket)
    }
    
    // MARK:  Update food count in basket
    func updateFoodInBasket(food: FoodModel, count: Int) {
        var savedBasket = loadBasketFromUserDefaults()
        
        if count == 0 {
            savedBasket.removeAll { $0.foodName == food.name }
        } else {
            if let index = savedBasket.firstIndex(where: { $0.foodName == food.name }) {
                savedBasket[index].moq = count
            }
            else{
                let basketToSave = BasketModel(basketID: 0, foodName: food.name!, foodImageName: food.imageName!, foodPrice: food.price!, moq: count, userName: "rabiaabdioglu")
                savedBasket.append(basketToSave)

                print("kayıtsız")
            }
        }
        
        saveBasketToUserDefaults(savedBasket)
    }
    
    // MARK:  delete Food
    func deleteFoodInBasket(basket: BasketModel){
        var savedBasket = loadBasketFromUserDefaults()
        savedBasket.removeAll { $0.foodName == basket.foodName }
        saveBasketToUserDefaults(savedBasket)
        deleteBasket(basket: basket)
    }
    func removeAllBasket() {
        var savedBasket = loadBasketFromUserDefaults()
        
        var emptyArr : [BasketModel] = []
        saveBasketToUserDefaults(emptyArr)
    }

}
