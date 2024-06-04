//
//  CustomSearchBar.swift
//  HepsiburadaClone
//
//  Created by Rabia Abdioğlu on 15.05.2024.
//

import Foundation
import UIKit
import SnapKit

class CustomSearchBar: UIView {

    //MARK: UI Components for custom search bar
    private let backgroundView: UIView = {
        let view = UIView()
        return view
    }()
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let searchIconImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
     let searchTextField: UITextField = {
        let textField = UITextField()
        return textField
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    // MARK: SETUP UI Components
    private func setupUI() {
        // MARK: Background View
        backgroundView.backgroundColor = .white
        backgroundView.layer.cornerRadius = 3
        backgroundView.layer.borderWidth = 1
        backgroundView.layer.borderColor = UIColor.clrGreen.cgColor
        backgroundView.clipsToBounds = true
        
        addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 60))
        }
        
        // MARK: Background Image View
        backgroundImageView.image = UIImage(named: "searchBarBG")
        backgroundImageView.tintColor = .lightGray
        
        backgroundView.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // MARK: Search Icon
        searchIconImageView.image = UIImage(systemName: "magnifyingglass")
        searchIconImageView.tintColor = .clrGreen

        backgroundView.addSubview(searchIconImageView)
        searchIconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.width.height.equalTo(20)
        }
        // MARK: Search TextField
        searchTextField.placeholder = "Search Food"
        searchTextField.font = UIFont.systemFont(ofSize: 15)
        searchTextField.textColor = .gray
        searchTextField.autocapitalizationType = .none
        searchTextField.autocorrectionType = .no
        
        backgroundView.addSubview(searchTextField)
        searchTextField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(searchIconImageView.snp.right).offset(10)
            make.right.equalToSuperview().offset(-10)
        }
    }
    

}
