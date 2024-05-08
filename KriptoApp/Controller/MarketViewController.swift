//
//  MarketViewController.swift
//  KriptoApp
//
//  Created by Erkan on 8.05.2024.
//

import UIKit

class MarketViewController: UIViewController {

    var collectionViewCrypto: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()




    }
    

}
