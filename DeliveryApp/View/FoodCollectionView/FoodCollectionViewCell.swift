//
//  FoodCollectionViewCell.swift
//  DeliveryApp
//
//  Created by Rabia Abdioğlu on 1.06.2024.
//

import Foundation
import UIKit
import SnapKit

class FoodCollectionViewCell: UICollectionViewCell {
    
    private var food: FoodModel?
    var foodBasketProtocol : FoodBasketProtocol?

    // MARK: UI Components

    private let favoriteButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    var foodImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let foodNameTitleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let addButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private let stepper: CustomStepper = {
        let stepper = CustomStepper()
        return stepper
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        contentView.backgroundColor = .white
        
        // Cell for blank spaces
        let cellView = UIView()
        cellView.backgroundColor = .white
        cellView.layer.cornerRadius = 18
        cellView.layer.shadowColor = UIColor.clrLightGray.cgColor
        cellView.layer.shadowOpacity = 0.3
        cellView.layer.shadowOffset = CGSize(width: 0, height: 0)
        cellView.layer.shadowRadius = 5
        cellView.layer.masksToBounds = false
        
        contentView.addSubview(cellView)
        cellView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.95)
            make.height.equalToSuperview().multipliedBy(0.95)
            make.centerY.centerX.equalToSuperview()
        }
        
        // MARK: Add Favorite Button
        favoriteButton.setImage(UIImage(systemName: "heart")?.withTintColor(.clrGray, renderingMode: .alwaysOriginal), for: .normal)
        favoriteButton.tintColor = .clrGray
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)

        cellView.addSubview(favoriteButton)
        favoriteButton.snp.makeConstraints { make in
            make.top.right.equalToSuperview().inset(10)
            make.width.equalTo(22)
            make.height.equalTo(17)
        }
        
        // MARK: Food Image View
        foodImageView.image = UIImage(systemName: "photo.fill")?.withTintColor(.clrWhite, renderingMode: .alwaysOriginal)
        foodImageView.contentMode = .scaleAspectFit
        foodImageView.clipsToBounds = true
        
        cellView.addSubview(foodImageView)
        foodImageView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.6)
            make.height.equalToSuperview().multipliedBy(0.4)
            make.top.equalToSuperview().offset(30)
            make.centerX.equalToSuperview()
        }
        
        // MARK: Food Name Label
        foodNameTitleLabel.font = UIFont(name: "Montserrat-Semibold", size: 18)
        foodNameTitleLabel.textColor = .clrDarkGray
        foodNameTitleLabel.textAlignment = .center
        foodNameTitleLabel.numberOfLines = 1
        
        cellView.addSubview(foodNameTitleLabel)
        foodNameTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(foodImageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        // MARK: Food Price Label
        priceLabel.font = UIFont(name: "Montserrat-Medium", size: 16)
        priceLabel.textColor = .clrDarkGray
        priceLabel.textAlignment = .left
        
        cellView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(foodNameTitleLabel.snp.bottom).offset(15)
            make.left.equalToSuperview().inset(10)
        }
        
        // MARK: Add button
        addButton.setImage(UIImage(named: "plus")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        addButton.tintColor = .white
        addButton.backgroundColor = .clrGreen
        addButton.layer.masksToBounds = true
        addButton.layer.cornerRadius = 20
        
        if #available(iOS 11.0, *) {
            addButton.layer.cornerRadius = 20
            addButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
        }
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        
        cellView.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.height.width.equalTo(40)
            make.bottom.right.equalToSuperview()
        }

        // MARK: Stepper
        stepper.layer.masksToBounds = true
        stepper.layer.cornerRadius = 15
        stepper.isHidden = true

        if #available(iOS 11.0, *) {
            stepper.layer.cornerRadius = 22
            stepper.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
        }
        stepper.onValueChanged = { [weak self] count in
            self?.updateFoodCount(count)
        }
        
        cellView.addSubview(stepper)
        stepper.snp.makeConstraints { make in
            make.bottom.right.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(60)
        }
    }
    
    // MARK: Configure cell

    func configure(with food: FoodModel) {
        self.food = food
        
        foodNameTitleLabel.text = food.name
        priceLabel.text = "$ \(food.price!)"
        
        // MARK: get BASKET food and update stepper UI
        let defaults = UserDefaults.standard
        if let savedBasketData = defaults.data(forKey: "localBasket"),
           let savedBasket = try? PropertyListDecoder().decode([BasketModel].self, from: savedBasketData),
           let basketItem = savedBasket.first(where: { $0.foodName == food.name }) {
            stepper.value = basketItem.moq!
            stepper.isHidden = false
            addButton.isHidden = true
        } else {
            stepper.isHidden = true
            addButton.isHidden = false
        }
        
        // MARK: get favorite foods info and update UI
        let favoriteImage = isFavorite(foodName: food.name!) ? UIImage(systemName: "heart.fill")?.withTintColor(.clrRed, renderingMode: .alwaysOriginal) : UIImage(systemName: "heart")?.withTintColor(.clrGray, renderingMode: .alwaysOriginal)
        favoriteButton.setImage(favoriteImage, for: .normal)
    }
    
    // MARK: Add button action
    @objc private func addButtonTapped() {
        guard let food = food else { return }
        foodBasketProtocol?.addFoodToBasket(food: food)
        
        stepper.value = 1
        stepper.isHidden = false
        addButton.isHidden = true
    }
    // MARK: Stepper  value change action

    private func updateFoodCount(_ count: Int) {
        guard let food = food else { return }
        foodBasketProtocol?.updateFoodInBasket(food: food, count: count)

        if count == 0 {
            stepper.isHidden = true
            addButton.isHidden = false
        }
    }
    
    // MARK: Search food in favorites
    func isFavorite(foodName: String) -> Bool {
        let defaults = UserDefaults.standard
        if let favoriteFoods = defaults.array(forKey: "favoriteFoods") as? [String] {
            return favoriteFoods.contains(foodName)
        }
        return false
    }

    // MARK: Add or remove food from favorites
    @objc private func favoriteButtonTapped() {
        guard let foodName = food?.name else { return }
        var favoriteFoods = UserDefaults.standard.array(forKey: "favoriteFoods") as? [String] ?? []

        if isFavorite(foodName: foodName) {
            favoriteButton.setImage(UIImage(systemName: "heart")?.withTintColor(.clrGray, renderingMode: .alwaysOriginal), for: .normal)
            favoriteFoods.removeAll { $0 == foodName }
        } else {
            favoriteButton.setImage(UIImage(systemName: "heart.fill")?.withTintColor(.clrRed, renderingMode: .alwaysOriginal), for: .normal)
            favoriteFoods.append(foodName)
        }
        UserDefaults.standard.set(favoriteFoods, forKey: "favoriteFoods")
    }
}
