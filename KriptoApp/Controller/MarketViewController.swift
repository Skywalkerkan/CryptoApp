//
//  MarketViewController.swift
//  KriptoApp
//
//  Created by Erkan on 8.05.2024.
//

import UIKit

class MarketViewController: UIViewController {

    let activityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.startAnimating()
        view.hidesWhenStopped = true
        view.color = .white
        view.style = .large
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var collectionViewCrypto: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    //Name
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let upNameImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "arrowtriangle.up.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.gray)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let downNameImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "arrowtriangle.down.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.gray)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let stackViewNameImages: UIStackView = {
       let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    
    let stackViewName: UIStackView = {
       let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 2
        stackView.axis = .horizontal
        return stackView
    }()
    
    //Vol
    let volLabel: UILabel = {
        let label = UILabel()
        label.text = "Vol"
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let upVolImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "arrowtriangle.up.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.gray)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let downVolImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "arrowtriangle.down.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.gray)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let stackViewVolImages: UIStackView = {
       let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    
    let stackViewVol: UIStackView = {
       let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 2
        stackView.axis = .horizontal
        return stackView
    }()

    //LastPrice
    
    let lastPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "Last Price"
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let upLastPriceImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "arrowtriangle.up.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.gray)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let downLastPriceImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "arrowtriangle.down.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.gray)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let stackViewLastPriceImages: UIStackView = {
       let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    
    let stackViewLastPrice: UIStackView = {
       let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 2
        stackView.axis = .horizontal
        return stackView
    }()
    
    //24H Change
    let changeLabel: UILabel = {
        let label = UILabel()
        label.text = "24h Chg%"
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let upChangeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "arrowtriangle.up.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.gray)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let downChangeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "arrowtriangle.down.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.gray)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let stackViewChangeImages: UIStackView = {
       let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    
    let stackViewChange: UIStackView = {
       let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 2
        stackView.axis = .horizontal
        return stackView
    }()
    
    var cryptoResult: CryptoResult?
    var sortedResult: CryptoResult?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupCollectionView()
        
        CryptoLogic.shared.getAllCryptos { [weak self] result in
            guard let self else{return}
            
            switch result{
            case .success(let cryptoResult):
                self.cryptoResult = cryptoResult
                self.sortedResult = cryptoResult
                DispatchQueue.main.async {
                    self.collectionViewCrypto.reloadData()
                    self.activityIndicatorView.stopAnimating()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        view.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicatorView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        activityIndicatorView.widthAnchor.constraint(equalToConstant: 120).isActive = true
    }
    
    func setupCollectionView(){
        collectionViewCrypto.delegate = self
        collectionViewCrypto.dataSource = self
        collectionViewCrypto.register(CryptoCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    func setupViews(){
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = UIColor(red: 38/255, green: 41/255, blue: 48/255, alpha: 1)
        view.addSubview(collectionViewCrypto)
        collectionViewCrypto.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        collectionViewCrypto.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionViewCrypto.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionViewCrypto.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true

        //Name
        view.addSubview(stackViewNameImages)
        stackViewNameImages.addArrangedSubview(upNameImageView)
        upNameImageView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        upNameImageView.widthAnchor.constraint(equalToConstant: 10).isActive = true
        stackViewNameImages.addArrangedSubview(downNameImageView)
        downNameImageView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        downNameImageView.widthAnchor.constraint(equalToConstant: 10).isActive = true
        view.addSubview(stackViewName)
        stackViewName.addArrangedSubview(nameLabel)
        stackViewName.addArrangedSubview(stackViewNameImages)
        stackViewName.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        stackViewName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        
        //Vol
        view.addSubview(stackViewVolImages)
        stackViewVolImages.addArrangedSubview(upVolImageView)
        upVolImageView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        upVolImageView.widthAnchor.constraint(equalToConstant: 10).isActive = true
        stackViewVolImages.addArrangedSubview(downVolImageView)
        downVolImageView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        downVolImageView.widthAnchor.constraint(equalToConstant: 10).isActive = true
        view.addSubview(stackViewVol)
        stackViewVol.addArrangedSubview(volLabel)
        stackViewVol.addArrangedSubview(stackViewVolImages)
        stackViewVol.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        stackViewVol.leadingAnchor.constraint(equalTo: stackViewName.trailingAnchor, constant: 8).isActive = true
        
        //Change
        view.addSubview(stackViewChangeImages)
        stackViewChangeImages.addArrangedSubview(upChangeImageView)
        upChangeImageView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        upChangeImageView.widthAnchor.constraint(equalToConstant: 10).isActive = true
        stackViewChangeImages.addArrangedSubview(downChangeImageView)
        downChangeImageView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        downChangeImageView.widthAnchor.constraint(equalToConstant: 10).isActive = true
        view.addSubview(stackViewChange)
        stackViewChange.addArrangedSubview(changeLabel)
        stackViewChange.addArrangedSubview(stackViewChangeImages)
        stackViewChange.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        stackViewChange.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        //Price
        view.addSubview(stackViewLastPriceImages)
        stackViewLastPriceImages.addArrangedSubview(upLastPriceImageView)
        upLastPriceImageView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        upLastPriceImageView.widthAnchor.constraint(equalToConstant: 10).isActive = true
        stackViewLastPriceImages.addArrangedSubview(downLastPriceImageView)
        downLastPriceImageView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        downLastPriceImageView.widthAnchor.constraint(equalToConstant: 10).isActive = true
        view.addSubview(stackViewLastPrice)
        stackViewLastPrice.addArrangedSubview(lastPriceLabel)
        stackViewLastPrice.addArrangedSubview(stackViewLastPriceImages)
        stackViewLastPrice.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        stackViewLastPrice.trailingAnchor.constraint(equalTo: stackViewChange.leadingAnchor, constant: -35).isActive = true
        
        let nameStackViewGR = UITapGestureRecognizer(target: self, action: #selector(nameClicked))
        stackViewName.addGestureRecognizer(nameStackViewGR)
        let volStackViewGR = UITapGestureRecognizer(target: self, action: #selector(volClicked))
        stackViewVol.addGestureRecognizer(volStackViewGR)
        let priceStackViewGR = UITapGestureRecognizer(target: self, action: #selector(priceClicked))
        stackViewLastPrice.addGestureRecognizer(priceStackViewGR)
        let changeStackViewGR = UITapGestureRecognizer(target: self, action: #selector(changeClicked))
        stackViewChange.addGestureRecognizer(changeStackViewGR)
    }
    
    var constant = 0
    var isActive = false
    var lastImageView = UIImageView()
    var activeSort: String = ""
    var activeSort2 = ""
    @objc func nameClicked(){
        
        guard let result = cryptoResult else {
            return
        }
        var coins = result.data.coins
       
        if activeSort != "Name" && activeSort != ""{
            print("geçildi")
            if let image = lastImageView.image {
                lastImageView.image = image.withRenderingMode(.alwaysTemplate)
                lastImageView.tintColor = UIColor.gray
            }
            constant = 0
            activeSort = ""
        }
        
        if constant != 2{
            if activeSort != "Name"{
                downNameImageView.image = UIImage(systemName: "arrowtriangle.down.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.white)
                lastImageView = downNameImageView
                coins = coins.sorted { coin1, coin2 in
                    guard let name1 = coin1.symbol, let name2 = coin2.symbol else {
                        return false
                    }
                    return name1 > name2
                }
            }else{
                upNameImageView.image = UIImage(systemName: "arrowtriangle.up.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.white)
                lastImageView = upNameImageView
                downNameImageView.image = UIImage(systemName: "arrowtriangle.down.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.gray)

                coins = coins.sorted { coin1, coin2 in
                    guard let name1 = coin1.symbol, let name2 = coin2.symbol else {
                        return false
                    }
                    return name1 < name2
                }
            }
            activeSort = "Name"
            constant += 1
        }else{
            constant = 0
            activeSort = ""
            isActive = false
            upNameImageView.image = UIImage(systemName: "arrowtriangle.up.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.gray)
            coins = result.data.coins
        }
        reloadData(result: result, coins: coins)
    }
    @objc func volClicked(){
        guard let result = cryptoResult else {
            return
        }
        var coins = result.data.coins
        
        if activeSort != "Vol" && activeSort != ""{
            print("geçildi")
            if let image = lastImageView.image {
                lastImageView.image = image.withRenderingMode(.alwaysTemplate)
                lastImageView.tintColor = UIColor.gray
            }
            constant = 0
            activeSort = ""
        }
        
        if constant != 2{
            if activeSort != "Vol"{
                downVolImageView.image = UIImage(systemName: "arrowtriangle.down.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.white)
                lastImageView = downVolImageView
                coins = coins.sorted { coin1, coin2 in
                    guard let volume1 = Float(coin1.the24HVolume ?? ""), let volume2 = Float(coin2.the24HVolume ?? "") else {
                        return false
                    }
                    return volume1 > volume2
                }
            }else{
                upVolImageView.image = UIImage(systemName: "arrowtriangle.up.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.white)
                downVolImageView.image = UIImage(systemName: "arrowtriangle.down.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.gray)
                lastImageView = upVolImageView
                
                coins = coins.sorted { coin1, coin2 in
                    guard let volume1 = Float(coin1.the24HVolume ?? ""), let volume2 = Float(coin2.the24HVolume ?? "") else {
                        return false
                    }
                    return volume1 < volume2
                }
            }
            activeSort = "Vol"
            constant += 1
        }else{
            constant = 0
            activeSort = ""
            isActive = false
            upVolImageView.image = UIImage(systemName: "arrowtriangle.up.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.gray)
            coins = result.data.coins
        }
       
        reloadData(result: result, coins: coins)
        
    }
    @objc func priceClicked(){
        guard let result = cryptoResult else {
            return
        }
        var coins = result.data.coins
        
        if activeSort != "Price" && activeSort != ""{
            print("geçildi")
            if let image = lastImageView.image {
                lastImageView.image = image.withRenderingMode(.alwaysTemplate)
                lastImageView.tintColor = UIColor.gray
            }
            constant = 0
            activeSort = ""
        }
        
        if constant != 2{
            if activeSort != "Price"{
                downLastPriceImageView.image = UIImage(systemName: "arrowtriangle.down.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.white)
                lastImageView = downLastPriceImageView

                coins = coins.sorted { coin1, coin2 in
                    guard let price1 = Float(coin1.price ?? ""), let price2 = Float(coin2.price ?? "") else {
                        return false
                    }
                    return price1 > price2
                }
            }else{
                upLastPriceImageView.image = UIImage(systemName: "arrowtriangle.up.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.white)
                downLastPriceImageView.image = UIImage(systemName: "arrowtriangle.down.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.gray)
                lastImageView = upLastPriceImageView
                coins = coins.sorted { coin1, coin2 in
                    guard let price1 = Float(coin1.price ?? ""), let price2 = Float(coin2.price ?? "") else {
                        return false
                    }
                    return price1 < price2
                }
            }
            activeSort = "Price"
            constant += 1
        }else{
            constant = 0
            activeSort = ""
            upLastPriceImageView.image = UIImage(systemName: "arrowtriangle.up.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.gray)
            coins = result.data.coins
        }
       
        reloadData(result: result, coins: coins)
    }
    @objc func changeClicked(){
        guard let result = cryptoResult else {
            return
        }
        var coins = result.data.coins
        
        if activeSort != "Change" && activeSort != ""{
            print("geçildi")
            if let image = lastImageView.image {
                lastImageView.image = image.withRenderingMode(.alwaysTemplate)
                lastImageView.tintColor = UIColor.gray
            }
            constant = 0
            activeSort = ""
        }
        
        if constant != 2{
            if activeSort != "Change"{
                downChangeImageView.image = UIImage(systemName: "arrowtriangle.down.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.white)
                lastImageView = downChangeImageView
                coins = coins.sorted { coin1, coin2 in
                    guard let change1 = Float(coin1.change ?? ""), let change2 = Float(coin2.change ?? "") else {
                        return false
                    }
                    return change1 > change2
                }
            }else{
                upChangeImageView.image = UIImage(systemName: "arrowtriangle.up.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.white)
                downChangeImageView.image = UIImage(systemName: "arrowtriangle.down.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.gray)
                lastImageView = upChangeImageView
                coins = coins.sorted { coin1, coin2 in
                    guard let change1 = Float(coin1.change ?? ""), let change2 = Float(coin2.change ?? "") else {
                        return false
                    }
                    return change1 < change2
                }
            }
            activeSort = "Change"
            constant += 1
        }else{
            constant = 0
            activeSort = ""
            upChangeImageView.image = UIImage(systemName: "arrowtriangle.up.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.gray)
            coins = result.data.coins
        }
       
        reloadData(result: result, coins: coins)
    }

    func reloadData(result: CryptoResult, coins: [Coin]) {
        var updatedResult = result
        updatedResult.data.coins = coins
        self.sortedResult = updatedResult
        collectionViewCrypto.reloadData()
    }
}

extension MarketViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sortedResult?.data.coins.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CryptoCell
        cell.configure(coin: sortedResult?.data.coins[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destinationVC = DetailViewController()
        destinationVC.singleCoin = sortedResult?.data.coins[indexPath.row]
        navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 60)
    }
}
