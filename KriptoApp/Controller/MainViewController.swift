

import UIKit
import CoreData

class MainViewController: UIViewController, UIScrollViewDelegate {
    
   // var lineChartView: LineChartView!
    
    var collectionViewCrypto: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    var collectionViewCategory: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 150, height: 50)
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 60), collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    let balanceView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
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
    
    
    var cryptoResult: CryptoResult?
    var favCryptos = [Coin]()
    var isFavActive: Bool = false
    var categories = ["Favorites", "Hot", "Gainers", "Losers", "24h Volume", "Market Cap"]
    var coinIDs = [String]()
    var selectedCoinIndex: IndexPath = []
    
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
                    self.collectionViewCrypto.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
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
    
    private func viewsSetup(){
        
        view.backgroundColor = UIColor(red: 38/255, green: 41/255, blue: 48/255, alpha: 1)
        
       /* view.addSubview(balanceView)
        balanceView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        balanceView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        balanceView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        balanceView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        balanceView.addSubview(balanceStackView)
        balanceStackView.topAnchor.constraint(equalTo: balanceView.topAnchor, constant: 0).isActive = true
        balanceStackView.leadingAnchor.constraint(equalTo: balanceView.leadingAnchor, constant: 16).isActive = true
        balanceStackView.addArrangedSubview(balanceLabel)

        balanceView.addSubview(usdStackView)
        usdStackView.topAnchor.constraint(equalTo: balanceStackView.bottomAnchor, constant: 10).isActive = true
        usdStackView.leadingAnchor.constraint(equalTo: balanceView.leadingAnchor, constant: 16).isActive = true
        
        usdStackView.addArrangedSubview(totalBalanceLabelUsdt)
        usdStackView.addArrangedSubview(totalBalanceLabelUsd)*/
       
        /*balanceStackView.addArrangedSubview(totalBalanceLabelUsdt)
        balanceStackView.addArrangedSubview(totalBalanceLabelUsd)*/
        
     /*   view.addSubview(collectionViewCategory)
        collectionViewCategory.topAnchor.constraint(equalTo: balanceView.bottomAnchor).isActive = true
        collectionViewCategory.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        collectionViewCategory.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        collectionViewCategory.heightAnchor.constraint(equalToConstant: 40).isActive = true
        */
        
        navigationController?.navigationBar.isHidden = true
        view.addSubview(collectionViewCrypto)
        collectionViewCrypto.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionViewCrypto.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        collectionViewCrypto.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        collectionViewCrypto.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        

    }
    
    
    private func collectionViewSetup(){
        collectionViewCrypto.delegate = self
        collectionViewCrypto.dataSource = self
        collectionViewCrypto.register(CryptoCell.self, forCellWithReuseIdentifier: "cell")
        
        collectionViewCrypto.register(HeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderReusableView.reuseIdentifier)
/*
        collectionViewCategory.delegate = self
        collectionViewCategory.dataSource = self
        collectionViewCategory.register(CategoryCell.self, forCellWithReuseIdentifier: "cell2")*/

    }
    
    var lastContentOffset: CGFloat = 0

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
        
        print(category)
        guard var result = cryptoResult else {
            return
        }

        var coins = result.data.coins
    
        switch category{
            
        case .Favorites:
            favCryptos.removeAll()
            for coinID in coinIDs {
                // coinID'ye sahip coin'leri filtrele
                let filteredCoins = cryptoResult?.data.coins.filter { coin in
                    if let coinUUID = coin.uuid, coinUUID == coinID {
                        return true
                    } else {
                        return false
                    }
                } ?? []
                
                // Filtrelenen coin'leri favoritesCoins dizisine ekle
                favCryptos.append(contentsOf: filteredCoins)
            }
            print(favCryptos.count)
           
            
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

        default:
            break
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
        case collectionViewCategory:
            guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
                        return CGSize(width: 50, height: 50) // Varsayılan bir boyut döndür
                    }
                    
                    let collectionViewWidth = collectionView.frame.width
                    let sectionInset = layout.sectionInset
                    let availableWidth = collectionViewWidth - sectionInset.left - sectionInset.right
                    
                    let content = categories[indexPath.item] // yourContent, collectionView'daki içeriklerinizi temsil eden bir dizi olsun
                    let labelSize = (content as NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]) // Font size'ı istediğiniz gibi ayarlayabilirsiniz
                    
                    let cellWidth = min(labelSize.width + 16, availableWidth) // Etiket genişliğinin, kullanılabilir genişlikten fazla olmamasını sağlar
                    
                    return CGSize(width: cellWidth, height: collectionView.bounds.height) // collectionView'ın yüksekliği kadar genişlik, herhangi bir yükseklik
        default:
            return CGSize()
        }
        
    }

    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch collectionView{
        case collectionViewCategory:
            return UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
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
            return CGSize(width: collectionView.frame.size.width, height: 170)
        } else {
            return CGSize.zero
        }
    }
    


    
    
    
    
}





