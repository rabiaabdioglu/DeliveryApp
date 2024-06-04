//
//  HomePageVC.swift
//  DeliveryApp
//
//  Created by Rabia Abdioğlu on 28.05.2024.
//

import UIKit
import SnapKit
class HomePageVC: UIViewController {
    
    // MARK: UI Components
    
    private  var pinIconImageView : CustomLabelWithIcon!
    
    private var headerLabel: UILabel!
    
    private var searchBar : CustomSearchBar!
    private var sortButton: UIButton!
    
    private var filterDesertButton: UIButton!
    private var filterDrinkButton: UIButton!
    private var filterFoodButton: UIButton!
    
    private var filterStack : UIStackView!
    
    private var foodCollectionView: UICollectionView!
    
    // MARK: Variables
    let cellIdentifier = "FoodCell"
    let itemSpacing: CGFloat = 10
    let itemsPerRow = 2
    
    private var isDownSort = false
    private var filterBoolArr = [false, false , false]
    
    var foods: [FoodModel] = []
    var filteredFoods: [FoodModel] = []
    var viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        
        setupUI()
        setupCollectionView()
        
        foodCollectionView.delegate = self
        foodCollectionView.dataSource = self
        
        _ = viewModel.foodList.subscribe(onNext: { list in
            self.foods = list
            self.filteredFoods = list
            DispatchQueue.main.async {
                self.foodCollectionView.reloadData()
                
            }
        })
        searchBar.searchTextField.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchFood()
        searchBar.searchTextField.text = ""
        
    }
    func setupUI(){
        
        // MARK: - Location Label and Image

        pinIconImageView = CustomLabelWithIcon()
        pinIconImageView.configure(imageName: "pin", labelText: "HOME")
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(pinIconTapped))
        pinIconImageView.addGestureRecognizer(tapRecognizer)
        view.addSubview(pinIconImageView)
        pinIconImageView.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
    
        }
        
        // MARK: - Header
        headerLabel = UILabel()
        headerLabel.text = "Find your food."
        headerLabel.font = UIFont(name: "Montserrat-Semibold", size: 20)
        headerLabel.textColor = .clrDarkGray
        
        view.addSubview(headerLabel)
        headerLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalTo(pinIconImageView.snp.bottom).offset(30)
        }
        
        // MARK: - Search Bar
        searchBar = CustomSearchBar()
        view.addSubview(searchBar)
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(12)
            make.height.equalTo(60)
        }
        
        // MARK: - Sort Button
        sortButton = UIButton()
        sortButton.setImage(UIImage(named: "upSort")?.withTintColor(.gray, renderingMode: .alwaysOriginal), for: .normal)
        sortButton.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
        
        view.addSubview(sortButton)
        sortButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(30)
            make.width.height.equalTo(30)
            make.centerY.equalTo(searchBar.snp.centerY)
        }
        
        // MARK: - Filter Buttons
        filterStack = UIStackView()
        filterStack.axis = .horizontal
        filterStack.distribution = .fill
        filterStack.spacing = 30
        
        view.addSubview(filterStack)
        filterStack.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(25)
            make.height.equalTo(50)
        }
        
        filterDesertButton = UIButton(type: .system)
        filterDesertButton.setTitle("Desert", for: .normal)
        filterDesertButton.tintColor = .clrLightGray
        filterDesertButton.addTarget(self, action: #selector(filterButtonTapped(_:)), for: .touchUpInside)
        filterStack.addArrangedSubview(filterDesertButton)
        
        filterDrinkButton = UIButton(type: .system)
        filterDrinkButton.setTitle("Drink", for: .normal)
        filterDrinkButton.tintColor = .clrLightGray
        filterDrinkButton.addTarget(self, action: #selector(filterButtonTapped(_:)), for: .touchUpInside)
        filterStack.addArrangedSubview(filterDrinkButton)
        
        filterFoodButton = UIButton(type: .system)
        filterFoodButton.setTitle("Food", for: .normal)
        filterFoodButton.tintColor = .clrLightGray
        filterFoodButton.addTarget(self, action: #selector(filterButtonTapped(_:)), for: .touchUpInside)
        filterStack.addArrangedSubview(filterFoodButton)
        
        filterStack.addArrangedSubview(UIView())
    }
    
    
    // Filter food by type : like desert drink
    @objc func filterButtonTapped(_ sender: UIButton) {
        switch sender {
        case filterDesertButton:
            filterDesertButton.setTitleColor( filterBoolArr[0] ? .clrGray : .clrGreen, for: .normal)
            filterBoolArr[0].toggle()
            
        case filterDrinkButton:
            filterDrinkButton.setTitleColor( filterBoolArr[1] ? .clrGray : .clrGreen, for: .normal)
            filterBoolArr[1].toggle()
            
        case filterFoodButton:
            filterFoodButton.setTitleColor( filterBoolArr[2] ? .clrGray : .clrGreen, for: .normal)
            filterBoolArr[2].toggle()
            
        default:
            break
        }
    }
    
    func setupCollectionView(){
        
        
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
            make.top.equalTo(filterStack.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(25)
            make.bottom.equalToSuperview().inset(102)
        }
        
    }
    // MARK: - Sort Button Action
    
    @objc func sortButtonTapped(_ sender: UIButton) {
        isDownSort.toggle()
        sortFoods()
        updateSortButtonImage()
    }
    
    func sortFoods() {
        if isDownSort {
            filteredFoods.sort { $0.price! < $1.price! }
        } else {
            filteredFoods.sort { $0.price! > $1.price! }
        }
        foodCollectionView.reloadData()
    }
    
    func updateSortButtonImage() {
        let imageName = isDownSort ? "downSort" : "upSort"
        sortButton.setImage(UIImage(named: imageName)?.withTintColor(.gray, renderingMode: .alwaysOriginal), for: .normal)
    }
    @objc func pinIconTapped() {
        let addressPage = AddressPageVC()
        self.present(addressPage, animated: true, completion: nil)
       }
}
// MARK: - UICollection View Methods

extension HomePageVC : UICollectionViewDelegate, UICollectionViewDataSource, FoodBasketProtocol{
    
    // MARK: Protocol Functions
    func updateFoodInBasket(food: FoodModel, count: Int) {
        viewModel.updateFoodInBasket(food: food, count: count)
        
    }
    
    func addFoodToBasket(food: FoodModel) {
        viewModel.addFoodToBasket(food: food)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredFoods.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? FoodCollectionViewCell else {
            fatalError("Unable to dequeue PromotionCell")
        }
        
        let item = filteredFoods[indexPath.item]
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
        detailVC.food = filteredFoods[indexPath.item]
        detailVC.modalPresentationStyle = .fullScreen
        self.present(detailVC, animated: true, completion: nil)
    }
    
}
// MARK: - SearchBar Delegate Methods

extension HomePageVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let searchText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        filterFoods(searchText: searchText)
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        
        filterFoods(searchText: "")
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func filterFoods(searchText: String) {
        
        if searchText.isEmpty {
            
            filteredFoods = foods
        } else {
            
            filteredFoods = foods.filter { $0.name!.lowercased().contains(searchText.lowercased()) }
        }
        print(filteredFoods.count)
        
        foodCollectionView.reloadData()
    }
}
