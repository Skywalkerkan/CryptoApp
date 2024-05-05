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
        return collectionView
    }()
    
    var categories = ["Favorites", "Hot", "Gainers", "Losers", "24h Volume", "Market Cap"]
    var selectedCategoryIndex: IndexPath? = [0, 1]

    
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
        
        
        headerView.addSubview(balanceStackView)
        balanceStackView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 0).isActive = true
        balanceStackView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16).isActive = true
        balanceStackView.addArrangedSubview(balanceLabel)

        headerView.addSubview(usdStackView)
        usdStackView.topAnchor.constraint(equalTo: balanceStackView.bottomAnchor, constant: 10).isActive = true
        usdStackView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16).isActive = true
        
        usdStackView.addArrangedSubview(totalBalanceLabelUsdt)
        usdStackView.addArrangedSubview(totalBalanceLabelUsd)
        
        
        
        
        headerView.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: usdStackView.bottomAnchor, constant: 10).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
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
        cell.categoryNameLabel.text = categories[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(categories[indexPath.row])
        var chosenCategory = categories[indexPath.row]
        NotificationCenter.default.post(name: Notification.Name("CustomNotification"), object: chosenCategory)
        
        if let previousIndex = selectedCategoryIndex {
            if let previousCell = collectionView.cellForItem(at: previousIndex) as? CategoryCell {
                previousCell.bottomLine.isHidden = true
                previousCell.categoryNameLabel.textColor = .gray
            }
        }
        // Seçilen hücrenin alt çizgisini göster
        if let cell = collectionView.cellForItem(at: indexPath) as? CategoryCell {
            cell.bottomLine.isHidden = false
            cell.categoryNameLabel.textColor = .white
            selectedCategoryIndex = indexPath // Seçilen hücrenin indexPath'ini sakla
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
        
        
    }
    
    // Koleksiyon hücrelerinin boyutunu belirleyin
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

