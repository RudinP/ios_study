import UIKit

protocol Filter{
    func apply(to image: UIImage) -> UIImage
}

class NoirFilter: Filter{
    func apply(to image: UIImage) -> UIImage{
        print("느와르 필터 적용중...")
        return image
    }
}

class SkyFilter: Filter{
    func apply(to image: UIImage) -> UIImage{
        print("스카이 필터 적용중...")
        return image
    }
}

class OceanFilter: Filter{
    func apply(to image: UIImage) -> UIImage{
        print("오션 필터 적용중...")
        return image
    }
}

class PhotoExporter{
    var filter: NoirFilter?
    
    func export(image: UIImage){
        guard let filter else{
            fatalError("필터가 필요합니다.")
        }
        filter.apply(to: image)
        
        print("사진을 익스포트 합니다.")
    }
}

let img = UIImage(systemName: "star")!
let exporter = PhotoExporter()
exporter.filter = NoirFilter() // 속성 주입, Property Injection
exporter.export(image: img)

class PhotoExporterIDI{
    private let filter: NoirFilter
    
    init(filter: NoirFilter) {
        self.filter = filter
    }
    
    func export(image: UIImage){
        filter.apply(to: image)
        
        print("사진을 익스포트 합니다.")
    }
}

let exporter2 = PhotoExporterIDI(filter: NoirFilter())
exporter2.export(image: img)


class PhotoExporterII{
    private var filter: Filter
    
    init(filter: Filter) { //Interface Injection
        self.filter = filter
    }
    
    func export(image: UIImage){
        filter.apply(to: image)
        
        print("사진을 익스포트 합니다.")
    }
}

let exporter3 = PhotoExporterII(filter: NoirFilter())
exporter3.export(image: img)
