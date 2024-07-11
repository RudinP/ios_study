import UIKit

class DownloadOperation: Operation{
    let target: PhotoData
    
    init(target: PhotoData){
        self.target = target
        super.init()
    }
    
    override func main(){
        print(target.url, "Start")
        //블록이 포함된 코드가 바로 실행되지 않고 스코프가 끝나는 시점으로 연기됨. 즉, 메인메소드가 끝나기 직전 실행
        defer{
            if isCancelled {
                print(target.url, "Cancelled")
            } else {
                print(target.url, "Done")
            }
        }
        //메인스레드에서 실행하면 안되므로 강제 종료
        guard !Thread.isMainThread else {
            fatalError()
        }
        
        //취소 기능
        guard !isCancelled else {
            print(target.url, "Cancelled")
            return
        }
        
        //보통 URLSession을 사용하는 것이 바람직하나, 간단히 하기 위해 data생성자로 구현
        do{
            let data = try Data(contentsOf: target.url)
            
            //취소 기능 구현 시 중요한 작업 사이사이에 분기확인문을 넣어주는 것이 좋다.
            guard !isCancelled else {
                print(target.url, "Cancelled")
                return
            }
            
            if let image = UIImage(data: data){
                //이미지 크기 30% 줄이기
                let size = image.size.applying(CGAffineTransform(scaleX: 0.3, y: 0.3))
                
                //이미지 리사이징- 이미지 컨텍스트
                UIGraphicsBeginImageContextWithOptions(size, true, 0.0)
                let frame = CGRect(origin: .zero, size: size)
                image.draw(in: frame)
                let resultImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                
                guard !isCancelled else {
                    print(target.url, "Cancelled")
                    return
                }
                
                target.data = resultImage
            }
        } catch {
            print(target, error.localizedDescription)
        }
    }
    
    override func cancel() {
        super.cancel()
        
        print(target.url, "Cancel")
    }
}
