//
//  FavoritePageVC.swift
//  DeliveryApp
//
//  Created by Rabia Abdioğlu on 3.06.2024.
//

import Foundation
import UIKit
import SnapKit

class FavoritePageVC: UIViewController {
    
    // MARK: UI Components
    private var headerLabel: UILabel!
    private var filterStack : UIStackView!
    private var foodCollectionView: UICollectionView!
    
    // MARK: Variables
    let cellIdentifier = "FavoriteCell"
    let itemSpacing: CGFloat = 10
    let itemsPerRow = 2
    
    private var isDownSort = false
    private var filterBoolArr = [false, false , false]
    
    var foods: [FoodModel] = []
    var viewModel = FavoriteViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        
        setupUI()
        
        foodCollectionView.delegate = self
        foodCollectionView.dataSource = self
        
        _ = viewModel.favoriteFoods.subscribe(onNext: { list in
            DispatchQueue.main.async {
                self.foods = list
                self.foodCollectionView.reloadData()
            }
        })
        
    }

    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchFavoriteFoods()

    }
    func setupUI(){
 
        
        // MARK: - Header
        headerLabel = UILabel()
        headerLabel.text = "Favorite Foods."
        headerLabel.font = UIFont(name: "Montserrat-Semibold", size: 20)
        headerLabel.textColor = .clrDarkGray
        
        view.addSubview(headerLabel)
        headerLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
        }

        // MARK: - Setup Collection View
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = itemSpacing
        layout.minimumInteritemSpacing = itemSpacing
        
        let totalSpacing = itemSpacing * CGFloat(itemsPerRow - 1)
        let width = (view.frame.width - totalSpacing) / CGFloat(itemsPerRow) - 30
        
        layout.itemSize = CGSize(width: width, height: width * 1.3 )
        
        foodCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        foodCollectionView.dataSource = self
        foodCollectionView.delegate = self
        foodCollectionView.showsVerticalScrollIndicator = false
        foodCollectionView.backgroundColor = .clear
        foodCollectionView.register(FoodCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
    
        view.addSubview(foodCollectionView)
        
        foodCollectionView.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(25)
            make.bottom.equalToSuperview().inset(100)
        }
        
    }

    
}

// MARK: - Collection View extension

extension FavoritePageVC : UICollectionViewDelegate, UICollectionViewDataSource,FoodBasketProtocol{
    // MARK: Protocol Functions

    func updateFoodInBasket(food: FoodModel, count: Int) {
        viewModel.updateFoodInBasket(food: food, count: count)

    }
    
    func addFoodToBasket(food: FoodModel) {
        viewModel.addFoodToBasket(food: food)

    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foods.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? FoodCollectionViewCell else {
            fatalError("Unable to dequeue PromotionCell")
        }
        
        let item = foods[indexPath.item]

        cell.configure(with: item)
        cell.foodBasketProtocol = self

        // Fetch food Images async
        viewModel.fetchFoodImageData(imageName: item.imageName ?? "") { image in
            DispatchQueue.main.async {
                cell.foodImageView.image = image
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = FoodDetailVC()
        detailVC.food = foods[indexPath.item]
        detailVC.modalPresentationStyle = .fullScreen
        self.present(detailVC, animated: true, completion: nil)
    }
    
}

