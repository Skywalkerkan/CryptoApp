import UIKit

class ViewController: UIViewController {
    
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
    
    var cryptoResult: CryptoResult?
    var categories = ["Favorites", "Hot", "Gainers", "Losers", "24h Volume", "Market Cap"]
    var selectedCategoryIndex: IndexPath? = [0, 1] // Seçilen hücre

    override func viewDidLoad() {
        super.viewDidLoad()
        
 
      
        
        viewsSetup()
        collectionViewSetup()
 
        CryptoLogic.shared.getAllCryptos { [weak self] result in
            guard let self else{return}
            
            switch result{
            case .success(let cryptoResult):
                self.cryptoResult = cryptoResult
                DispatchQueue.main.async {
                    self.collectionViewCrypto.reloadData()
                }
            case .failure(let error):
                print("error")
            }
            
        }
        
    }
    
    
    private func viewsSetup(){
        
        view.backgroundColor = UIColor(red: 38/255, green: 41/255, blue: 48/255, alpha: 1)
        
        view.addSubview(collectionViewCategory)
        collectionViewCategory.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionViewCategory.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        collectionViewCategory.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        collectionViewCategory.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(collectionViewCrypto)
        collectionViewCrypto.topAnchor.constraint(equalTo: collectionViewCategory.bottomAnchor).isActive = true
        collectionViewCrypto.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        collectionViewCrypto.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        collectionViewCrypto.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true

    }
    
    
    private func collectionViewSetup(){
        collectionViewCrypto.delegate = self
        collectionViewCrypto.dataSource = self
        collectionViewCrypto.register(CryptoCell.self, forCellWithReuseIdentifier: "cell")
        
        collectionViewCategory.delegate = self
        collectionViewCategory.dataSource = self
        collectionViewCategory.register(CategoryCell.self, forCellWithReuseIdentifier: "cell2")

    }
}


extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch collectionView{
        case collectionViewCrypto:
            let destinationVC = DetailViewController()
            destinationVC.singleCoin = cryptoResult?.data.coins[indexPath.row]
            navigationController?.pushViewController(destinationVC, animated: true)
        
        case collectionViewCategory:
            
            guard let category = Category(rawValue: categories[indexPath.row]) else {
                return
            }
            sortCryptos(cryptoResult: cryptoResult, category: category)
            // Önceki seçilen hücrenin alt çizgisini gizle
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
            
        default:
            break
        }
    }
    
    func sortCryptos(cryptoResult: CryptoResult?, category: Category) {
        
        print(category)
        guard var result = cryptoResult else {
            return  // Eğer cryptoResult nil ise, nil döndür
        }

        var coins = result.data.coins
    
        switch category{
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
            print("a")
            break
        }
       
        result.data.coins = coins
        self.cryptoResult = result
        collectionViewCrypto.reloadData()
    }


    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView{
        case collectionViewCrypto:
            return cryptoResult?.data.coins.count ?? 0
        case collectionViewCategory:
            return categories.count
        default:
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView{
        case collectionViewCrypto:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CryptoCell
            cell.configure(coin: cryptoResult?.data.coins[indexPath.row])
            
            return cell
        case collectionViewCategory:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath) as! CategoryCell
            cell.categoryNameLabel.text = categories[indexPath.row]
            if indexPath.row == 1{
                cell.bottomLine.isHidden = false
                cell.categoryNameLabel.textColor = . white
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
                    
                    // Ek bir padding veya boşluk eklemek isterseniz burada ekleyebilirsiniz
                    let cellWidth = min(labelSize.width + 16, availableWidth) // Etiket genişliğinin, kullanılabilir genişlikten fazla olmamasını sağlar
                    
                    // Hücre boyutunu döndür
                    return CGSize(width: cellWidth, height: collectionView.bounds.height) // collectionView'ın yüksekliği kadar genişlik, herhangi bir yükseklik
        default:
            return CGSize()
        }
        
    }

    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch collectionView{
        case collectionViewCategory:
            return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        case collectionViewCrypto:
           return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        default:
            return UIEdgeInsets()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    
    
}





