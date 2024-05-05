//
//  CryptoCell.swift
//  KriptoApp
//
//  Created by Erkan on 4.05.2024.
//

import UIKit

class CategoryCell: UICollectionViewCell {

    let categoryNameLabel: UILabel = {
       let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 16, weight: .black)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Category"
        label.textAlignment = .center
        return label
    }()
    
    let bottomLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .yellow
        view.isHidden = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
       
        
        setupViews()
    }
    
    private func setupViews(){
        contentView.addSubview(categoryNameLabel)
        categoryNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        categoryNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        categoryNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true


        contentView.addSubview(bottomLine)
        bottomLine.topAnchor.constraint(equalTo: categoryNameLabel.bottomAnchor, constant: 4).isActive = true
        bottomLine.heightAnchor.constraint(equalToConstant: 2).isActive = true
        bottomLine.widthAnchor.constraint(equalToConstant: 12).isActive = true
        bottomLine.centerXAnchor.constraint(equalTo: categoryNameLabel.centerXAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
