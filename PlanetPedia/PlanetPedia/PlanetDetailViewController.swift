//
//  PlanetDetailViewController.swift
//  PlanetPedia
//
//  Created by 루딘 on 6/19/24.
//

import UIKit

class PlanetDetailViewController: UIViewController {
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var detailCollectionView: UICollectionView!
    @IBOutlet weak var dimView: UIView!
    
    private let planet: Planet
    
    init?(planet: Planet, coder: NSCoder){
        self.planet = planet
        
        super.init(coder: coder)
    }
    
    //failable initializer
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout(){
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment in
            switch sectionIndex{
            case 1:
                //한 줄에 두 셀을 표시하고자 하므로 0.5
                var size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .estimated(130))
                //아이템 크기 설정
                var item = NSCollectionLayoutItem(layoutSize: size)
                //그룹은 섹션 너비 전체를 채우도록
                size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(130))
                //그룹 설정. 나란히 배치하고자 하므로 horizontal
                //첫번째 2개 셀 그룹
                var group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitems: [item])
                //그룹 내 inset 설정
                //.fixed = 고정값 지정, .flexible = 최소 여백 지정. 현재 상황에서는 비율로 너비가 지정되므로 오차발생 가능성이 있기 때문에 flexible이 바람직함.
                group.interItemSpacing = .flexible(20)
                //섹션 그룹 설정
                //두번째 1개 셀 그룹
                size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(130))
                item = NSCollectionLayoutItem(layoutSize: size)
                
                group = NSCollectionLayoutGroup.vertical(layoutSize: size, subitems: [group, item])
                //위 아래 inset 추가
                group.interItemSpacing = .fixed(20)
                
                let section = NSCollectionLayoutSection(group: group)
                //inset 설정
                section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
                section.interGroupSpacing = 20

                return section
                
            case 2:
                var size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200))
                
                let item = NSCollectionLayoutItem(layoutSize: size)
                
                size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.6), heightDimension: .estimated(200))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitems: [item])

                let section = NSCollectionLayoutSection(group: group)

                section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
                section.interGroupSpacing = 20
                section.orthogonalScrollingBehavior = .groupPaging

                return section

            default:
                //너비는 가능한 너비 전체로 채우고자 하면 비율적으로 1
                let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200))
                //아이템 크기 설정
                let item = NSCollectionLayoutItem(layoutSize: size)
                //그룹 설정
                let group = NSCollectionLayoutGroup.vertical(layoutSize: size, subitems: [item])
                //섹션 그룹 설정
                let section = NSCollectionLayoutSection(group: group)
                //inset 설정
                section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
                section.interGroupSpacing = 20

                return section
            }
        }
        detailCollectionView.collectionViewLayout = layout
    }
    
    var initialOffsetY = CGFloat(0)
    
    func adjustContentInset(){
        let indexPath = IndexPath(item: 0, section: 0)
        if let first = detailCollectionView.cellForItem(at: indexPath){
            let topInset = detailCollectionView.frame.height - first.frame.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom - 20//section inset
            detailCollectionView.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
            detailCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .bottom)
            
            initialOffsetY = detailCollectionView.contentOffset.y
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let img = UIImage(named: planet.englishName.lowercased())
        backgroundImageView.image = img
        
        setupLayout()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        adjustContentInset()
    }
}

extension PlanetDetailViewController: UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 3
        case 2:
            return planet.satellites.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PlanetSummaryCollectionViewCell.self), for: indexPath) as! PlanetSummaryCollectionViewCell
            
            cell.korNameLabel.text = planet.koreanName
            cell.engNameLabel.text = planet.englishName
            cell.descriptionLabel.text = planet.description
            
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PlanetInfoCollectionViewCell.self), for: indexPath) as! PlanetInfoCollectionViewCell
            
            switch indexPath.item {
            //행성의 크기
            case 0:
                cell.titleImageView.image = UIImage(systemName: "ruler")
                cell.titleLabel.text = "크기"
                cell.valueLabel.text = planet.sizeString
                cell.unitLabel.text = "km"
            //행성의 공전 주기
            case 1:
                cell.titleImageView.image = UIImage(systemName: "arrow.circlepath")
                cell.titleLabel.text = "공전 주기"
                cell.valueLabel.text = planet.orbitalPeriodString
                cell.unitLabel.text = planet.orbitalPeriod > 365 ? "년" : "일"
            //지구와의 거리
            case 2:
                cell.titleImageView.image = UIImage(systemName: "airplane")
                cell.titleLabel.text = "지구와의 거리"
                cell.valueLabel.text = planet.distanceString
                cell.unitLabel.text = "km"
            default:
                break
            }
            
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SatelliteCollectionViewCell.self), for: indexPath) as! SatelliteCollectionViewCell
            
            let target = planet.satellites[indexPath.item]
            cell.satelliteNameLabel.text = target.koreanName
            cell.satelliteSummaryLabel.text = target.description
            
            return cell
        default:
            fatalError("check section count")
        }
    }
}

extension PlanetDetailViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(#function, scrollView.contentOffset.y)
        
        let y = scrollView.contentOffset.y
        let half = scrollView.bounds.size.height / 2
        
        //스크롤 절반까지 서서히 dimView의 알파가 0.4가 되도록 하고 그 이상은 0.4 유지.
        if y <= initialOffsetY{
            dimView.alpha = 0.0
        } else if y <= -half{ //음수값이라 - 붙여서 계산해야 함.
            let progress = (initialOffsetY - y) / (initialOffsetY + half)
            dimView.alpha = progress * 0.4
        } else {
            dimView.alpha = 0.4
        }
    }
}
