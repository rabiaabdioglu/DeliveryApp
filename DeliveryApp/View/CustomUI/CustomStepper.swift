//
//  CustomStepper.swift
//  DeliveryApp
//
//  Created by Rabia Abdioğlu on 1.06.2024.
//

import Foundation
import UIKit
import SnapKit

class CustomStepper: UIView {
    
    // MARK: UI Components for custom stepper
    private let decreaseButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private let increaseButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    var value: Int = 1 {
        didSet {
            valueLabel.text = "\(value)"
            onValueChanged?(value)
        }
    }
    // Value change control for user defaults

    var onValueChanged: ((Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        layer.masksToBounds = true
        layer.cornerRadius = 14
        
        // MARK: Left decrease button
        decreaseButton.setTitle("-", for: .normal)
        decreaseButton.titleLabel?.font = UIFont(name: "Montserrat-Medium", size: 24)
        decreaseButton.titleLabel?.textAlignment = .right
        decreaseButton.backgroundColor = .clrGreen
        decreaseButton.setTitleColor(.white, for: .normal)
        decreaseButton.addTarget(self, action: #selector(decreaseValue), for: .touchUpInside)

        addSubview(decreaseButton)
        decreaseButton.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.4)
        }
        
        // MARK: Stepper value button
        valueLabel.text = "0"
        valueLabel.font = UIFont(name: "Montserrat-Medium", size: 20)
        valueLabel.textAlignment = .center
        valueLabel.textColor = .white
        valueLabel.backgroundColor = .clrGreen
        valueLabel.clipsToBounds = true
        
        addSubview(valueLabel)
        valueLabel.snp.makeConstraints { make in
            make.leading.equalTo(decreaseButton.snp.trailing)
            make.centerY.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.2)
        }
        
        // MARK: Right increase button
        increaseButton.setTitle("+", for: .normal)
        increaseButton.titleLabel?.font = UIFont(name: "Montserrat-Medium", size: 24)
        increaseButton.titleLabel?.textAlignment = .left
        increaseButton.backgroundColor = .clrGreen
        increaseButton.setTitleColor(.white, for: .normal)
        increaseButton.addTarget(self, action: #selector(increaseValue), for: .touchUpInside)

        addSubview(increaseButton)
        increaseButton.snp.makeConstraints { make in
            make.leading.equalTo(valueLabel.snp.trailing)
            make.trailing.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.4)
        }
    }
    
    
    @objc private func decreaseValue() {
        if value > 0 {
            value -= 1
        }
    }
    
    @objc private func increaseValue() {
        if value != 9 {
            value += 1
        }
    }
}
