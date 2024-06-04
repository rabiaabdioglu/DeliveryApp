//
//  FoodDetailVC.swift
//  DeliveryApp
//
//  Created by Rabia Abdioğlu on 28.05.2024.
//

import Foundation
import UIKit
import SnapKit

class FoodDetailVC: UIViewController {
    
    // MARK: - UI Components

    private var backButton : UIButton!
    private var pageTitleLabel : UILabel!
    private var favoriteButton : UIButton!
    
    private var backgroundView: UIView!
    private var foodImageView: UIImageView!
    private var foodNameLabel: UILabel!
    private var priceLabel: UILabel!
    private var stepper: CustomStepper!
    
    private var foodInfoStack : UIStackView!
    private var starLabel: CustomLabelWithIcon!
    private var caloriLabel: CustomLabelWithIcon!
    private var minuteLabel: CustomLabelWithIcon!

    private var ingredientsHeaderLabel: UILabel!
    private var ingredientsLabel: UILabel!
    
    private var addToCartButton : UIButton!
    
    // MARK: -  Variables
    
    var food:  FoodModel?
    var viewModel = FoodDetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clrGreen
        navigationController?.navigationBar.isHidden = true

        setupNavigationBar()
        setupUI()
        
        viewModel.fetchFoodImageData(imageName: food!.imageName ?? "") { image in
            DispatchQueue.main.async {
                self.foodImageView.image = image
            }
        }
        viewModel.fetchBasket()
        loadStepperValue()
       
        
    }
    // MARK: - Navigation Bar

    func setupNavigationBar(){
        pageTitleLabel = UILabel()
        pageTitleLabel.text = "Food Details"
        pageTitleLabel.font = UIFont(name: "Montserrat-SemiBold", size: 15)
        pageTitleLabel.textColor = .white
        
        view.addSubview(pageTitleLabel)
        pageTitleLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            
        }
        
        backButton = UIButton()
        backButton.setImage(UIImage(systemName: "chevron.left")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        backButton.backgroundColor = .white.withAlphaComponent(0.2)
        backButton.layer.masksToBounds = true
        backButton.layer.cornerRadius = 10
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.centerY.equalTo(pageTitleLabel.snp.centerY)
            make.width.height.equalTo(40)
        }
        
       
        favoriteButton = UIButton()
        favoriteButton.backgroundColor = .white.withAlphaComponent(0.2)
        favoriteButton.layer.masksToBounds = true
        favoriteButton.layer.cornerRadius = 10
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        
        // MARK:  get favorite foods info and update UI
        let favoriteImage = isFavorite(foodName: (food!.name)!) ? UIImage(systemName: "heart.fill")?.withTintColor(.clrRed, renderingMode: .alwaysOriginal) : UIImage(systemName: "heart")?.withTintColor(.clrGray, renderingMode: .alwaysOriginal)
        favoriteButton.setImage(favoriteImage, for: .normal)
        
        view.addSubview(favoriteButton)
        favoriteButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20)
            make.centerY.equalTo(pageTitleLabel.snp.centerY)
            make.width.height.equalTo(40)
        }
        
    }
    
    
    func setupUI(){
        
        // MARK: - White background view
        backgroundView = UIView()
        backgroundView.backgroundColor = .clrWhite
        backgroundView.layer.masksToBounds = true
        backgroundView.layer.cornerRadius = 20
        
        if #available(iOS 11.0, *) {
            backgroundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.7)
            make.left.right.bottom.equalToSuperview()
        }
        
        // MARK: - Food Imageview

        foodImageView = UIImageView()
        foodImageView.image = UIImage(named: "photo.fill")
        
        view.addSubview(foodImageView)
        foodImageView.snp.makeConstraints { make in
            make.width.height.equalTo(view.snp.width).multipliedBy(0.6)
            make.centerX.equalToSuperview()
            make.centerY.equalTo(backgroundView.snp.top)
        }
        
        // MARK: - Food detail Labels

        foodNameLabel = UILabel()
        foodNameLabel.text = food?.name ?? "Food Name"
        foodNameLabel.font = UIFont(name: "Montserrat-SemiBold", size: 24)
        foodNameLabel.textColor = .clrDarkGray
         
        backgroundView.addSubview(foodNameLabel)
        foodNameLabel.snp.makeConstraints { make in
            make.top.equalTo(foodImageView.snp.bottom).offset(20)
            make.left.equalToSuperview().inset(20)

        }
        
        priceLabel = UILabel()
        priceLabel.text = "$ \(Double(food?.price ?? 12))"
        priceLabel.font = UIFont(name: "Montserrat-Medium", size: 24)
        priceLabel.textColor = .clrGreen
         
        backgroundView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(foodNameLabel.snp.bottom).offset(15)
            make.left.equalToSuperview().inset(20)

        }
        
        // MARK: - Stepper

        stepper = CustomStepper()
        stepper.value = 1
        
        backgroundView.addSubview(stepper)
        stepper.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20)
            make.centerY.equalTo(foodNameLabel.snp.bottom)
            make.width.equalToSuperview().multipliedBy(0.25)
            make.height.equalTo(50)
        }
        
        // MARK: - Food info Labels ( kcal , min , star )
        foodInfoStack = UIStackView()
        foodInfoStack.axis = .horizontal
        foodInfoStack.distribution = .equalSpacing
        foodInfoStack.spacing = 30

        backgroundView.addSubview(foodInfoStack)
        foodInfoStack.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(25)
            make.height.equalTo(50)
        }
        
        starLabel = CustomLabelWithIcon()
        starLabel.configure(imageName: "star", labelText: "4.5")
        
        foodInfoStack.addArrangedSubview(starLabel)
        starLabel.snp.makeConstraints { make in
            make.height.equalToSuperview()
        }
        
        caloriLabel = CustomLabelWithIcon()
        caloriLabel.configure(imageName: "calories", labelText: "450 Kcal")
        
        foodInfoStack.addArrangedSubview(caloriLabel)
        caloriLabel.snp.makeConstraints { make in
            make.height.equalToSuperview()
        }
        
        minuteLabel = CustomLabelWithIcon()
        minuteLabel.configure(imageName: "clock", labelText: "45 min")
        
        foodInfoStack.addArrangedSubview(minuteLabel)
        minuteLabel.snp.makeConstraints { make in
            make.height.equalToSuperview()
        }
        
        // MARK: - Ingredients Label

        ingredientsHeaderLabel = UILabel()
        ingredientsHeaderLabel.text = "Ingredients"
        ingredientsHeaderLabel.font = UIFont(name: "Montserrat-SemiBold", size: 18)
        ingredientsHeaderLabel.textColor = .clrDarkGray
        
        backgroundView.addSubview(ingredientsHeaderLabel)
        ingredientsHeaderLabel.snp.makeConstraints { make in
            make.top.equalTo(foodInfoStack.snp.bottom).offset(50)
            make.left.equalToSuperview().inset(20)
        }
        
        ingredientsLabel = UILabel()
        ingredientsLabel.text = "Flour, dry yeast, water, salt, and olive oil."
        ingredientsLabel.font = UIFont(name: "Montserrat-SemiBold", size: 15)
        ingredientsLabel.textColor = .clrGray
        ingredientsLabel.numberOfLines = 0
        
        backgroundView.addSubview(ingredientsLabel)
        ingredientsLabel.snp.makeConstraints { make in
            make.top.equalTo(ingredientsHeaderLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        // MARK: - Add to basket bUTTON

        addToCartButton = UIButton()
        addToCartButton.setTitle("Add to cart", for: .normal)
        addToCartButton.setTitleColor(.clrWhite, for: .normal)
        addToCartButton.backgroundColor = .clrGreen
        addToCartButton.titleLabel?.font = UIFont(name: "Montserrat-SemiBold", size: 17)
        addToCartButton.layer.cornerRadius = 20
        addToCartButton.addTarget(self, action: #selector(addToCartButtonTapped), for: .touchUpInside)

        backgroundView.addSubview(addToCartButton)
        addToCartButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(80)
            make.height.equalTo(50)
        }
        
        
    }
    @objc func backButtonTapped(){
        self.dismiss(animated: true)
    }
    
    func loadStepperValue(){
        // MARK: get BASKET food and update stepper UI
        let defaults = UserDefaults.standard
        if let savedBasketData = defaults.data(forKey: "localBasket"),
           let savedBasket = try? PropertyListDecoder().decode([BasketModel].self, from: savedBasketData),
           let basketItem = savedBasket.first(where: { $0.foodName == food!.name }) {
            stepper.value = basketItem.moq!
        } else {
            stepper.value = 1
            
        }
        
    }
    @objc func addToCartButtonTapped(){
        if let food = food{
            viewModel.updateFoodInBasket(food: food, count: stepper.value)
            self.dismiss(animated: true)
            
        }
    }
    
    // MARK: Search  food in favorites
    func isFavorite(foodName: String) -> Bool {
        let defaults = UserDefaults.standard
        if let favoriteFoods = defaults.array(forKey: "favoriteFoods") as? [String] {
            return favoriteFoods.contains(foodName)
        }
        return false
    }
    
    // MARK: Add or remove food from favorites

    @objc private func favoriteButtonTapped() {
        guard let food = food else { return }
        var favoriteFoods = UserDefaults.standard.array(forKey: "favoriteFoods") as? [String] ?? []

        if isFavorite(foodName: food.name!) {
            favoriteButton.setImage(UIImage(systemName: "heart")?.withTintColor(.clrGray, renderingMode: .alwaysOriginal), for: .normal)
            favoriteFoods.removeAll { $0 == food.name! }
        } else {
            favoriteButton.setImage(UIImage(systemName: "heart.fill")?.withTintColor(.clrRed, renderingMode: .alwaysOriginal), for: .normal)
            favoriteFoods.append(food.name!)
        }
        UserDefaults.standard.set(favoriteFoods, forKey: "favoriteFoods")

    }
    
}
