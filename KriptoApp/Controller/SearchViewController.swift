//
//  SearchViewController.swift
//  KriptoApp
//
//  Created by Erkan on 7.05.2024.
//

import UIKit

class SearchViewController: UIViewController {

    var cryptoResult: CryptoResult?
    var searchResult: CryptoResult?
    
    var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchTextField.backgroundColor = UIColor(red: 45/255, green: 48/255, blue: 55/255, alpha: 1)
        searchBar.backgroundImage = UIImage()
        searchBar.placeholder = "Megadrop"
        if let searchTextField = searchBar.value(forKey: "searchField") as? UITextField {
              let attributes: [NSAttributedString.Key: Any] = [
                  .foregroundColor: UIColor.lightGray,
                  .font: UIFont.systemFont(ofSize: 17)
              ]
              searchTextField.attributedPlaceholder = NSAttributedString(string: "Megadrop", attributes: attributes)
          }
        searchBar.searchTextField.leftView?.tintColor = .gray
        searchBar.layer.zPosition = 2
        print("güncelleniyor")
        return searchBar
    }()

    @objc func backClicked(){
        navigationController?.popViewController(animated: true)
    }
    
    let searchCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(red: 38/255, green: 41/255, blue: 48/255, alpha: 1)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    lazy var cancelBottomViewButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.systemYellow, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .light)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(cancelClicked), for: .touchUpInside)
        return button
    }()
    
    @objc func cancelClicked() {
        // Animasyon
        self.searchBar.resignFirstResponder()
        
        navigationController?.popViewController(animated: true)
    }
    
    var statusBarHeight: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        
        animateSearchBar()
        setupCollectionView()
     
      /*  CryptoLogic.shared.getAllCryptos { [weak self] result in
            guard let self else{return}
            
            switch result{
            case .success(let cryptoResult):
                self.cryptoResult = cryptoResult
                self.searchResult = cryptoResult
                DispatchQueue.main.async {
                    self.searchCollectionView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }*/
        
        searchResult = cryptoResult
        self.searchCollectionView.reloadData()
    }
    
    func setupCollectionView(){
        searchCollectionView.delegate = self
        searchCollectionView.dataSource = self
        searchCollectionView.register(CryptoCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    
    
    func animateSearchBar(){
        if #available(iOS 13.0, *) {
            statusBarHeight = UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
                statusBarHeight = UIApplication.shared.statusBarFrame.height
        }
        
        view.backgroundColor = UIColor(red: 38/255, green: 41/255, blue: 48/255, alpha: 1)
        setupViews()
        
        UIView.animate(withDuration: 0.2, animations: {
            self.searchBar.frame = CGRect(x: 8, y: self.statusBarHeight+10, width: 200, height: 60)
        }) { _ in
            UIView.animate(withDuration: 0.4, animations: {
                self.searchBar.frame = CGRect(x: 8, y: self.statusBarHeight+10, width: 300, height: 60)
            }){ _ in
                self.searchBar.becomeFirstResponder()
            }
        }
    }
    

    func setupViews(){
        view.addSubview(searchBar)
        searchBar.delegate = self
        self.searchBar.frame = CGRect(x:32, y:self.statusBarHeight, width:300, height:60)
        
        view.addSubview(cancelBottomViewButton)
        cancelBottomViewButton.topAnchor.constraint(equalTo: view.topAnchor, constant: statusBarHeight+22).isActive = true
        cancelBottomViewButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        view.addSubview(searchCollectionView)
        searchCollectionView.topAnchor.constraint(equalTo: cancelBottomViewButton.bottomAnchor, constant: 16).isActive = true
        searchCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        searchCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        searchCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResult?.data.coins.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CryptoCell
        cell.configure(coin: searchResult?.data.coins[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destinationVC = DetailViewController()
        destinationVC.singleCoin = searchResult?.data.coins[indexPath.row]
        navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 60)
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        let trimmedSearchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedSearchText.isEmpty {
            // Arama metni boşsa, tüm kripto paraları göster
            searchResult = cryptoResult
        } else {
            guard let coins = cryptoResult?.data.coins else {
                return
            }
            
            // Filtreleme işlemi
            let filteredCoins = coins.filter { coin in
                if let name = coin.symbol {
                    print(name)
                    return name.localizedCaseInsensitiveContains(trimmedSearchText)
                }
                return false
            }
            
            // Filtrelenmiş sonuçları güncelle
            searchResult?.data.coins = filteredCoins
        }
        
        DispatchQueue.main.async {
           self.searchCollectionView.reloadData()
        }
    }
}
