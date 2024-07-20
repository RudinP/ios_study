
import UIKit

class ImageListViewController: UIViewController {
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    let backgroundQueue = DispatchQueue(label: "BackgroundQueue", attributes: .concurrent) //백에서 실행
    let mainQueue = DispatchQueue.main // 메인에서 실행
    
    let downloadGroup = DispatchGroup()
    
    var ds = PhotoDataSource()
    
    var isCancelled: Bool = false
    
    @IBAction func cancelWorkItems(_ sender: Any) {
        isCancelled = true
    }
    
    @IBAction func startWorkItem(_ sender: Any) {
        isCancelled = false
        downloadImages()
    }
    
    func downloadImages(){
        guard !isCancelled else {return}
        
        for photoData in ds.list {
            let workItem = DispatchWorkItem {
                do{
                    guard !self.isCancelled else {return}
                    
                    let data = try Data(contentsOf: photoData.url)
                    
                    if let image = UIImage(data: data) {
                        let size = image.size.applying(CGAffineTransform(scaleX: 0.5, y: 0.5))
                        UIGraphicsBeginImageContextWithOptions(size, true, 0.0)
                        let frame = CGRect(origin: .zero, size: size)
                        image.draw(in: frame)
                        
                        guard !self.isCancelled else {return}
                        
                        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
                        UIGraphicsEndImageContext()
                        
                        guard !self.isCancelled else {return}
                        
                        photoData.data = resultImage
                    }
                }catch{
                    print(photoData.url, error.localizedDescription)
                }
            }
            
            backgroundQueue.async(group: downloadGroup, execute: workItem)
            
        }
        downloadGroup.notify(queue: .main){
            self.reloadAll()
        }//tableViewReload
    }
    
    func reloadAll(){
        guard !self.isCancelled else {return}
        
        imageCollectionView.reloadData()
        applyFilter()
    }
    
    func applyFilter(){
        guard !self.isCancelled else {return}
        let context = CIContext(options: nil)
        
        for photoData in ds.list{
            backgroundQueue.async {
                guard let source = photoData.data?.cgImage else { fatalError() }
                let ciImage = CIImage(cgImage: source)
                
                guard !self.isCancelled else {return}
                
                let filter = CIFilter(name: "CIPhotoEffectNoir")
                filter?.setValue(ciImage, forKey: kCIInputImageKey)
                
                guard let ciResult = filter?.value(forKey: kCIOutputImageKey) as? CIImage else {
                    fatalError()
                }
                
                guard !self.isCancelled else {return}
                
                guard let cgImage = context.createCGImage(ciResult, from: ciResult.extent) else {
                    fatalError()
                }
                
                photoData.data = UIImage(cgImage: cgImage)
                
                guard !self.isCancelled else {return}
                
                if let index = self.ds.list.firstIndex(where: {$0.url == photoData.url}){
                    let indexPath = IndexPath(item: index, section: 0)
                    
                    self.mainQueue.async {
                        self.imageCollectionView.reloadItems(at: [indexPath])
                    }
                }
            }
        }
    }
    
    
    
    func setupLayout(){
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .estimated(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .flexible(10)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        imageCollectionView.collectionViewLayout = layout
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageCollectionView.dataSource = self
        setupLayout()
    }

}

extension ImageListViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ds.list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        
        cell.imageView.image = ds.list[indexPath.item].data
        
        return cell
    }
}
