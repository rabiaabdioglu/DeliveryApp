//
//  CustomLabelWithIcon.swift
//  DeliveryApp
//
//  Created by Rabia Abdioğlu on 2.06.2024.
//

import Foundation
import UIKit
import SnapKit

class CustomLabelWithIcon: UIView {

    private let leftIconImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = UIColor.clrLightGray.withAlphaComponent(0.1)
        layer.cornerRadius = 12
        
        leftIconImageView.contentMode = .scaleAspectFit
        addSubview(leftIconImageView)
        leftIconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(snp.height).multipliedBy(0.5)
        }
        
        titleLabel.textColor = .clrGray
        titleLabel.font = UIFont(name: "Montserrat-Regular", size: 15)
       
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(leftIconImageView.snp.trailing).offset(5)
            make.trailing.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
        }
    }
    
    func configure(imageName: String, labelText: String) {
        leftIconImageView.image = UIImage(named: imageName)
        titleLabel.text = labelText
    }
}

