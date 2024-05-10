//
//  HeaderReusableView.swift
//  KriptoApp
//
//  Created by Erkan on 5.05.2024.
//

import UIKit


class HeaderReusableView: UICollectionReusableView {
    
    static let reuseIdentifier = "HeaderReusableView"
    
    let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let balanceStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let usdStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 8
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let balanceLabel: UILabel = {
       let label = UILabel()
        label.text = "Total Balance (USDT)"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let totalBalanceLabelUsdt: UILabel = {
       let label = UILabel()
        label.text = "21,135.90"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let depositButton: UIButton = {
       let button = UIButton()
        button.setTitle("Deposit", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemYellow
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let totalBalanceLabelUsd: UILabel = {
       let label = UILabel()
        label.text = "≈ 21,135.9 $"
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    let seperator: UIView = {
       let view = UIView()
        view.backgroundColor = .gray
        view.alpha = 0.5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let nameLabel: UILabel = {
       let label = UILabel()
        label.text = "Name"
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let priceLabel: UILabel = {
       let label = UILabel()
        label.text = "Last price"
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let changeLabel: UILabel = {
       let label = UILabel()
        label.text = "24h chg%"
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var categories = ["Favorites", "Gainers", "Losers", "24h Volume", "Market Cap"]
    var selectedCategoryIndex: IndexPath? = [0, 0]

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(headerView)
        
        headerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        headerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        headerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        headerView.addSubview(depositButton)
        depositButton.topAnchor.constraint(equalTo: topAnchor, constant: 24).isActive = true
        depositButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        depositButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        depositButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16).isActive = true
        
        headerView.addSubview(balanceStackView)
        balanceStackView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 0).isActive = true
        balanceStackView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16).isActive = true
        balanceStackView.addArrangedSubview(balanceLabel)

        headerView.addSubview(usdStackView)
        usdStackView.topAnchor.constraint(equalTo: balanceStackView.bottomAnchor, constant: 10).isActive = true
        usdStackView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16).isActive = true
        
        usdStackView.addArrangedSubview(totalBalanceLabelUsdt)
        usdStackView.addArrangedSubview(totalBalanceLabelUsd)
        
        headerView.addSubview(seperator)
        seperator.topAnchor.constraint(equalTo: usdStackView.bottomAnchor, constant: 16).isActive = true
        seperator.leadingAnchor.constraint(equalTo: headerView.leadingAnchor).isActive = true
        seperator.trailingAnchor.constraint(equalTo: headerView.trailingAnchor).isActive = true
        seperator.heightAnchor.constraint(equalToConstant: 1).isActive = true

        headerView.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: seperator.bottomAnchor, constant: 10).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        headerView.addSubview(nameLabel)
        nameLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 0).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16).isActive = true
        
        headerView.addSubview(changeLabel)
        changeLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 0).isActive = true
        changeLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16).isActive = true
        
        headerView.addSubview(priceLabel)
        priceLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 0).isActive = true
        priceLabel.trailingAnchor.constraint(equalTo: changeLabel.leadingAnchor, constant: -45).isActive = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: "cell3")
    }
}

extension HeaderReusableView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell3", for: indexPath) as! CategoryCell
        if categories[indexPath.row] == "Favorites"{
            cell.bottomLine.isHidden = false
            cell.categoryNameLabel.textColor = .white
        }
        cell.categoryNameLabel.text = categories[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let chosenCategory = categories[indexPath.row]
        NotificationCenter.default.post(name: Notification.Name("CustomNotification"), object: chosenCategory)
        
        if let previousIndex = selectedCategoryIndex {
            if let previousCell = collectionView.cellForItem(at: previousIndex) as? CategoryCell {
                previousCell.bottomLine.isHidden = true
                previousCell.categoryNameLabel.textColor = .gray
            }
        }
        if let cell = collectionView.cellForItem(at: indexPath) as? CategoryCell {
            cell.bottomLine.isHidden = false
            cell.categoryNameLabel.textColor = .white
            selectedCategoryIndex = indexPath
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
                return CGSize(width: 50, height: 50)
            }
        let collectionViewWidth = collectionView.frame.width
        let sectionInset = layout.sectionInset
        let availableWidth = collectionViewWidth - sectionInset.left - sectionInset.right
                
        let content = categories[indexPath.item]
        let labelSize = (content as NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])
                
        let cellWidth = min(labelSize.width + 16, availableWidth)
                
        return CGSize(width: cellWidth, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 16)
    }
}

