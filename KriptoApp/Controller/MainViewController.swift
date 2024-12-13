

import UIKit
import CoreData

class MainViewController: UIViewController, UIScrollViewDelegate{
        
    var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
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
        return searchBar
    }()
    
    let imagesStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let bellImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(systemName: "bell.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.white)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let infoImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(systemName: "info.circle.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.white)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let qrImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(systemName: "qrcode.viewfinder")?.withRenderingMode(.alwaysOriginal).withTintColor(.white)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
        
    let binanceImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "binance")
        return imageView
    }()
    
    
    
    var collectionViewCrypto: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    let backgroundView: UIView = {
       let view = UIView()
       view.translatesAutoresizingMaskIntoConstraints = false
       return view
    }()
    
    let arrowImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "arrowtriangle.down.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.lightGray)
        imageView.isHidden = true
        return imageView
    }()
    
    let noDataImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "nodata")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        return imageView
    }()
    
    let noDataLabel: UILabel = {
        let label = UILabel()
        label.text = "No Favorites found"
        label.isHidden = true
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Delete", for: .normal)
        button.backgroundColor =  .lightGray
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 4
        button.isHidden = true
        button.addTarget(self, action: #selector(deleteClicked), for: .touchUpInside)
        return button
    }()
    
    @objc func deleteClicked(){
         deleteCoin(withId: selectedId)
         coinIDs.removeAll()
         favCryptos.removeAll()
         fetchCoins()
          for coinID in coinIDs {
              let filteredCoins = cryptoResult?.data.coins.filter { coin in
                  if let coinUUID = coin.uuid, coinUUID == coinID {
                      return true
                  } else {
                      return false
                  }
              } ?? []
              favCryptos.append(contentsOf: filteredCoins)
          }
          DispatchQueue.main.async {
              self.collectionViewCrypto.reloadData()
          }
        deleteButton.isHidden = true
        arrowImageView.isHidden = true
    }
    
    var cryptoResult: CryptoResult?
    var favCryptos = [Coin]()
    var isFavActive: Bool = false
    var coinIDs = [String]()
    var selectedCoinIndex: IndexPath = []
    var selectedId: String = ""
    var isFiltering: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewsSetup()
        collectionViewSetup()
 
        NotificationCenter.default.addObserver(self, selector: #selector(receiveNotification), name: Notification.Name("CustomNotification"), object: nil)
        
        CryptoLogic.shared.getAllCryptos { [weak self] result in
            guard let self else{return}
            
            switch result{
            case .success(let cryptoResult):
                self.cryptoResult = cryptoResult
                DispatchQueue.main.async {
                    self.isFavActive = true
                    self.sortCryptos(cryptoResult: cryptoResult, category: .Favorites)
                    if self.favCryptos.isEmpty{
                        self.noDataImage.isHidden = false
                        self.noDataLabel.isHidden = false
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        longPressGesture.minimumPressDuration = 0.5
        collectionViewCrypto.addGestureRecognizer(longPressGesture)
        
    }
    
    @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
           if gesture.state == .began {
               let touchPoint = gesture.location(in: collectionViewCrypto)
               if let indexPath = collectionViewCrypto.indexPathForItem(at: touchPoint),
                  let cell = collectionViewCrypto.cellForItem(at: indexPath){
                 
                   let cellFrameInSuperview = collectionViewCrypto.convert(cell.frame, to: self.view)
                   if isFavActive{
                       guard let id = favCryptos[indexPath.row].uuid else{return}
                       selectedId = id
                       deleteButton.isHidden = false
                       deleteButton.transform = CGAffineTransform(translationX: view.frame.width/2-40, y: cellFrameInSuperview.origin.y-30)
                       arrowImageView.isHidden = false
                       arrowImageView.transform = CGAffineTransform(translationX: view.frame.width/2-10, y: cellFrameInSuperview.origin.y-5)
                       cell.backgroundColor = UIColor(red: 25/255, green: 24/255, blue: 35/255, alpha: 1)
                       DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            UIView.animate(withDuration: 0.2) {
                                cell.backgroundColor = .clear
                            }
                            }
                   }
                   
               }
           }
       }
    
    func deleteCoin(withId id: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoinData")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            let results = try context.fetch(fetchRequest)
            for object in results {
                guard let coin = object as? NSManagedObject else { continue }
                context.delete(coin)
            }
            try context.save()
            print("Coin \(id) silindi.")
        } catch {
            print("Coin silinirken hata oluştu: \(error.localizedDescription)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        coinIDs.removeAll()
        favCryptos.removeAll()
        fetchCoins()
        for coinID in coinIDs {
            let filteredCoins = cryptoResult?.data.coins.filter { coin in
                if let coinUUID = coin.uuid, coinUUID == coinID {
                    return true
                } else {
                    return false
                }
            } ?? []
            
            favCryptos.append(contentsOf: filteredCoins)
        }
        collectionViewCrypto.reloadData()
        searchBar.resignFirstResponder()
    }
    
    @objc func receiveNotification(_ notification: Notification) {
           if let chosenCategory = notification.object as? String {
               guard let category = Category(rawValue: chosenCategory) else {
                   return
               }
               if chosenCategory == "Favorites"{
                   isFavActive = true
               }else{
                   isFavActive = false
               }
               sortCryptos(cryptoResult: cryptoResult, category: category)
           }
       }
    
    var statusBarHeight: CGFloat = 0

    private func viewsSetup(){
        
        if #available(iOS 13.0, *) {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                statusBarHeight = windowScene.statusBarManager?.statusBarFrame.height ?? 0
            }
        } else {
            statusBarHeight = UIApplication.shared.statusBarFrame.height
        }
        
        view.backgroundColor = UIColor(red: 38/255, green: 41/255, blue: 48/255, alpha: 1)
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(backgroundView)
        backgroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        searchBar.delegate = self
        view.addSubview(searchBar)
        searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -4).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 48).isActive = true
        searchBar.widthAnchor.constraint(equalToConstant: 0.55*view.frame.size.width).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        view.addSubview(imagesStackView)
        imagesStackView.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor).isActive = true
        imagesStackView.leadingAnchor.constraint(equalTo: searchBar.trailingAnchor, constant: 16).isActive = true
        imagesStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        imagesStackView.addArrangedSubview(qrImageView)
        imagesStackView.addArrangedSubview(bellImageView)
        imagesStackView.addArrangedSubview(infoImageView)
        
        view.addSubview(binanceImageView)
        binanceImageView.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor).isActive = true
        binanceImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        binanceImageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        binanceImageView.widthAnchor.constraint(equalToConstant: 25).isActive = true

        backgroundView.addSubview(collectionViewCrypto)
        collectionViewCrypto.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 0).isActive = true
        collectionViewCrypto.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        collectionViewCrypto.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        collectionViewCrypto.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        view.addSubview(deleteButton)
        deleteButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        view.addSubview(arrowImageView)
        arrowImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        arrowImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true

        view.addSubview(noDataLabel)
        noDataLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        noDataLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        view.addSubview(noDataImage)
        noDataImage.topAnchor.constraint(equalTo: noDataLabel.bottomAnchor, constant: 8).isActive = true
        noDataImage.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 8).isActive = true
        noDataImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        noDataImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    private func collectionViewSetup(){
        collectionViewCrypto.delegate = self
        collectionViewCrypto.dataSource = self
        collectionViewCrypto.register(CryptoCell.self, forCellWithReuseIdentifier: "cell")
        collectionViewCrypto.register(HeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderReusableView.reuseIdentifier)
    }
    
}


extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch collectionView{
        case collectionViewCrypto:
            let destinationVC = DetailViewController()
            if isFavActive{
                destinationVC.singleCoin = favCryptos[indexPath.row]
            }else{
                destinationVC.singleCoin = cryptoResult?.data.coins[indexPath.row]
            }
            navigationController?.pushViewController(destinationVC, animated: true)
        default:
            break
        }
    }
    
    func sortCryptos(cryptoResult: CryptoResult?, category: Category) {
        
        guard var result = cryptoResult else {
            return
        }

        var coins = result.data.coins
    
        switch category{
            
        case .Favorites:
            favCryptos.removeAll()
            for coinID in coinIDs {
                let filteredCoins = cryptoResult?.data.coins.filter { coin in
                    if let coinUUID = coin.uuid, coinUUID == coinID {
                        return true
                    } else {
                        return false
                    }
                } ?? []
                
                favCryptos.append(contentsOf: filteredCoins)
            }
            
        case .Gainers:
            coins = coins.sorted { coin1, coin2 in
                guard let change1 = Float(coin1.change ?? ""), let change2 = Float(coin2.change ?? "") else {
                    return false
                }
                return change1 > change2
            }
        case .Losers:
            coins = coins.sorted { coin1, coin2 in
                guard let change1 = Float(coin1.change ?? ""), let change2 = Float(coin2.change ?? "") else {
                    return false
                }
                return change1 < change2
            }
        case .dayVol:
            coins = coins.sorted { coin1, coin2 in
                guard let volume1 = Float(coin1.the24HVolume ?? ""), let volume2 = Float(coin2.the24HVolume ?? "") else {
                    return false
                }
                return volume1 > volume2
            }
        case .marketCap:
            coins = coins.sorted { coin1, coin2 in
                guard let marketCap1 = Float(coin1.marketCap ?? ""), let marketCap2 = Float(coin2.marketCap ?? "") else {
                    return false
                }
                return marketCap1 > marketCap2
            }
        }
            deleteButton.isHidden = true
            arrowImageView.isHidden = true
            if isFavActive && favCryptos.isEmpty{
                noDataImage.isHidden = false
                noDataLabel.isHidden = false
            }else{
                noDataImage.isHidden = true
                noDataLabel.isHidden = true
            }
            result.data.coins = coins
            self.cryptoResult = result
            collectionViewCrypto.reloadData()
    }
    
    func fetchCoins(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoinData")
        fetchRequest.returnsObjectsAsFaults = false
        do{
            let coins = try context.fetch(fetchRequest)
                   
            for case let coin as NSManagedObject in coins {
                if let id = coin.value(forKey: "id") as? String {
                    coinIDs.append(id)
                }
            }
            
        }catch let error as NSError{
            print("veriler geitirlirken hata oluştu \(error.localizedDescription)")
        }
        
        if isFavActive && coinIDs.isEmpty{
            noDataImage.isHidden = false
            noDataLabel.isHidden = false
        }else{
            noDataImage.isHidden = true
            noDataLabel.isHidden = true
        }
        
    }


    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView{
        case collectionViewCrypto:
            if isFavActive{
                return favCryptos.count
            }else{
                return cryptoResult?.data.coins.count ?? 0
            }
        default:
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView{
        case collectionViewCrypto:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CryptoCell
            
            if isFavActive{
                cell.configure(coin: favCryptos[indexPath.row])
            }else{
                cell.configure(coin: cryptoResult?.data.coins[indexPath.row])
            }
            
            return cell
        default:
            return UICollectionViewCell()
        }
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch collectionView{
        case collectionViewCrypto:
            return CGSize(width: view.frame.size.width, height: 60)
        default:
            return CGSize()
        }
        
    }

    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch collectionView{
        case collectionViewCrypto:
           return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        default:
            return UIEdgeInsets()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if collectionView == collectionViewCrypto && kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderReusableView.reuseIdentifier, for: indexPath) as! HeaderReusableView
            return header
        } else {
            return UICollectionReusableView()
        }
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView == collectionViewCrypto {
            return CGSize(width: collectionView.frame.size.width, height: 165)
        } else {
            return CGSize.zero
        }
    }
}


extension MainViewController: UISearchBarDelegate {
  
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        let destinationVC = SearchViewController()
        destinationVC.cryptoResult = cryptoResult
        navigationController?.pushViewController(destinationVC, animated: false)
        return true
    }
}

