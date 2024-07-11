
import UIKit

class ReloadOperation: Operation {
    weak var collectionView: UICollectionView!
    //여기에 저장된 값이 nil이면 전체 reload
    var indexPath: IndexPath?
    
    init(collectionView: UICollectionView, indexPath: IndexPath? = nil) {
        self.collectionView = collectionView
        self.indexPath = indexPath
        
        super.init()
    }
    
    override func main() {
        print(self, "Start", indexPath)
        
        defer{
            if isCancelled {
                print(self, "Cancelled", indexPath)
            } else {
                print(self, "Done", indexPath)
            }
        }
        
        //UI 리로드이므로 메인스레드에서만 해야함
        guard Thread.isMainThread else{
            fatalError()
        }
        
        guard !isCancelled else{
            print(self, "Cancelled")
            return
        }
        
        if let indexPath {
            //indexPath가 nil이 아니라면 해당 indexPath에 있는 셀만 리로드. 셀이 화면에 표시된 상태가 아니라면 reload할 필요가 없음.
            if collectionView.indexPathsForVisibleItems.contains(indexPath){
                collectionView.reloadItems(at: [indexPath])
            }
        } else {
            collectionView.reloadData()
        }
    }
    
    override func cancel() {
        super.cancel()
        
        print(self, "Cancel")
    }
}
