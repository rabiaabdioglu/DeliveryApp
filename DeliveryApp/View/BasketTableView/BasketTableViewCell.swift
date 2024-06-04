//
//  BasketTableViewCell.swift
//  DeliveryApp
//
//  Created by Rabia Abdioğlu on 2.06.2024.
//

import Foundation
import UIKit
import SnapKit

class BasketTableViewCell : UITableViewCell{
    
    private var basket: BasketModel?
    var basketTableProtocol : BasketTableProtocol?

    private let deleteButton : UIButton = {
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
    
    private let priceLabel : UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let foodMoqLabel : UILabel = {
        let label = UILabel()
        return label
    }()
    private let totalPriceLabel : UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        cellView.layer.cornerRadius = 15
        cellView.layer.shadowColor = UIColor.gray.cgColor
        cellView.layer.shadowOpacity = 0.3
        cellView.layer.shadowOffset = CGSize(width: 1, height: 1)
        cellView.layer.shadowRadius = 6
        cellView.layer.masksToBounds = false
        
        contentView.addSubview(cellView)
        cellView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalToSuperview().multipliedBy(0.9)
            make.centerY.centerX.equalToSuperview()
            
        }
    
        
        // MARK: Add Favorite Button
        deleteButton.setImage(UIImage(systemName: "trash.slash")?.withTintColor(.clrRed, renderingMode: .alwaysOriginal), for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        
        cellView.addSubview(deleteButton)
        deleteButton.snp.makeConstraints { make in
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
            make.width.equalToSuperview().multipliedBy(0.3)
            make.height.equalToSuperview().multipliedBy(0.8)
            make.left.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
        }
        // MARK: Food Name Label
        foodNameTitleLabel.font = UIFont(name: "Montserrat-Semibold", size: 20)
        foodNameTitleLabel.textColor = .clrDarkGray
        foodNameTitleLabel.numberOfLines = 1
        
        cellView.addSubview(foodNameTitleLabel)
        foodNameTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.left.equalTo(foodImageView.snp.right).offset(10)
        }
        // MARK: Food Price Label
        priceLabel.font = UIFont(name: "Montserrat-Medium", size: 14)
        priceLabel.textColor = .clrDarkGray
        priceLabel.textAlignment = .left
        
        cellView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(foodNameTitleLabel.snp.bottom).offset(10)
            make.left.equalTo(foodImageView.snp.right).offset(10)
        }
        
        // MARK: Food Moq Label
        foodMoqLabel.font = UIFont(name: "Montserrat-Medium", size: 14)
        foodMoqLabel.textColor = .clrDarkGray
        foodMoqLabel.textAlignment = .left
        
        cellView.addSubview(foodMoqLabel)
        foodMoqLabel.snp.makeConstraints { make in
            
            make.top.equalTo(priceLabel.snp.bottom).offset(10)
            make.left.equalTo(foodImageView.snp.right).offset(10)
        }
        
        // MARK: Total Price Label
        totalPriceLabel.font = UIFont(name: "Montserrat-Medium", size: 18)
        totalPriceLabel.textColor = .clrDarkGray
        totalPriceLabel.textAlignment = .left
        
        cellView.addSubview(totalPriceLabel)
        totalPriceLabel.snp.makeConstraints { make in
            make.bottom.right.equalToSuperview().inset(10)
        }
        
    }
    
    func configure(with basket: BasketModel) {
          self.basket = basket
          foodNameTitleLabel.text = basket.foodName
          priceLabel.text = "Price: $\(basket.foodPrice ?? 0)"
          foodMoqLabel.text = "Moq: \(basket.moq ?? 0)"
          totalPriceLabel.text = "Total: $\(basket.foodPrice! * basket.moq! )"
      }
      
      @objc private func deleteButtonTapped() {
          guard let basket = basket else { return }
          basketTableProtocol?.deleteFood(basket: basket)
          
      }
}

