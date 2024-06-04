//
//  BasketPageVC.swift
//  DeliveryApp
//
//  Created by Rabia Abdioğlu on 1.06.2024.
//

import Foundation
import UIKit
import SnapKit

class BasketPageVC: UIViewController {
    
    // MARK: UI Components
    private var headerLabel: UILabel!
    private var basketTableView: UITableView!
    private var totalPriceLabel: UILabel!
    private var checkoutButton: UIButton!
    private var noFoodInBasket : UILabel!
    
    // MARK: Variables
    let cellIdentifier = "BasketCell"
    var basket: [BasketModel] = []
    var viewModel = BasketViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        
        setupUI()
        setupFooter()
        
        basketTableView.delegate = self
        basketTableView.dataSource = self
        basketTableView.register(BasketTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        _ = viewModel.basketList.subscribe(onNext: { list in
            self.basket = list
            self.updateTotalPrice()
            self.basketTableView.reloadData()
            DispatchQueue.main.async { [self] in
                self.updateTotalPrice()
                self.basketTableView.reloadData()

                if self.basket.count == 0 {
                    noFoodInBasket.isHidden = false
                    basketTableView.isHidden = true
                    checkoutButton.isEnabled = false
                    checkoutButton.backgroundColor = .clrLightGray
                }
                else{
                    noFoodInBasket.isHidden = true
                    basketTableView.isHidden = false
                    checkoutButton.isEnabled = true
                   checkoutButton.backgroundColor = .clrGreen
                }
                
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.syncBasket()
        
    }
    
    func setupUI() {
        // MARK: - Header
        headerLabel = UILabel()
        headerLabel.text = "Basket"
        headerLabel.font = UIFont(name: "Montserrat-Semibold", size: 20)
        headerLabel.textColor = .clrDarkGray
        
        view.addSubview(headerLabel)
        headerLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
        }
        
        
        // MARK: No data Label
        noFoodInBasket = UILabel()
        noFoodInBasket.text = "Basket is empty."
        noFoodInBasket.font = UIFont(name: "Montserrat-Semibold", size: 22)
        noFoodInBasket.textColor = .clrDarkYellow
        noFoodInBasket.textAlignment = .center
        noFoodInBasket.isHidden = true
        
        view.addSubview(noFoodInBasket)
        
        noFoodInBasket.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.right.equalToSuperview().inset(10)
        }
        
        
        // MARK: - Table View
        basketTableView = UITableView()
        basketTableView.showsVerticalScrollIndicator = false
        basketTableView.backgroundColor = .clear
        basketTableView.separatorStyle = .none
        basketTableView.showsVerticalScrollIndicator = false
        
        view.addSubview(basketTableView)
        
        basketTableView.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(10)
            make.height.equalToSuperview().multipliedBy(0.6)
        }
    }
    
    func setupFooter() {
        
        // MARK: - Confirm Basket button
        checkoutButton = UIButton()
        checkoutButton.setTitle("Confirm Basket", for: .normal)
        checkoutButton.backgroundColor = .clrGreen
        checkoutButton.titleLabel?.font = UIFont(name: "Montserrat-Semibold", size: 18)
        checkoutButton.setTitleColor(.white, for: .normal)
        checkoutButton.layer.cornerRadius = 15
        checkoutButton.addTarget(self, action: #selector(checkoutButtonTapped), for: .touchUpInside)
        
        view.addSubview(checkoutButton)
        checkoutButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(25)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-30)
            make.height.equalTo(50)
        }
        
        // MARK: Total price label
        var totalLabel = UILabel()
        totalLabel.font = UIFont(name: "Montserrat-Regular", size: 14)
        totalLabel.textColor = .clrDarkGray
        totalLabel.textAlignment = .left
        totalLabel.text = "Total Price: "
        
        view.addSubview(totalLabel)
        totalLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(27)
            make.bottom.equalTo(checkoutButton.snp.top).offset(-20)
        }
        
        totalPriceLabel = UILabel()
        totalPriceLabel.font = UIFont(name: "Montserrat-Semibold", size: 18)
        totalPriceLabel.textColor = .clrDarkGray
        totalPriceLabel.textAlignment = .right
        totalPriceLabel.text = "$ 0 "
        
        view.addSubview(totalPriceLabel)
        totalPriceLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(27)
            make.bottom.equalTo(checkoutButton.snp.top).offset(-20)
        }
        
        
    }
    
    // MARK: Update total price
    func updateTotalPrice() {
        let totalPrice = basket.reduce(0) { $0 + ($1.foodPrice! * $1.moq!) }
        totalPriceLabel.text = "$ \(totalPrice)"
    }
    
    @objc func checkoutButtonTapped() {
        let confirmBasket = PurchaseBasketVC()
        confirmBasket.modalPresentationStyle = .fullScreen
        self.present(confirmBasket, animated: true, completion: nil)

    }
}



// MARK: Table view extensions

extension BasketPageVC: UITableViewDelegate, UITableViewDataSource ,BasketTableProtocol{
    
    // MARK: Protocol Functions
    func deleteFood(basket: BasketModel) {
        viewModel.deleteFoodInBasket(basket: basket)
        viewModel.syncBasket() 
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, _ in
            guard let self = self else { return }
            let basketItem = self.basket[indexPath.row]
            self.deleteFood(basket: basketItem)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return basket.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? BasketTableViewCell else {
            fatalError("Unable to dequeue BasketCell")
        }
        
        let item = basket[indexPath.row]
        cell.configure(with: item)
        cell.basketTableProtocol = self
        
        viewModel.fetchFoodImageData(imageName: item.foodImageName ?? "") { image in
            DispatchQueue.main.async {
                cell.foodImageView.image = image
            }
        }
        return cell
    }
}
