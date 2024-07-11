//
//  ImageListViewController.swift
//  HelloOperation
//
//  Created by 루딘 on 7/11/24.
//

import UIKit

class ImageListViewController: UIViewController {
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    let backgroundQueue = OperationQueue() //백에서 실행
    let mainQueue = OperationQueue.main // 메인에서 실행
    
    var ds = PhotoDataSource()
    
    @IBAction func cancelOperation(_ sender: Any) {
        mainQueue.cancelAllOperations()
        backgroundQueue.cancelAllOperations()
    }
    
    @IBAction func startOperation(_ sender: Any) {
        
        var uiOperations = [Operation]()
        var backgroundOperations = [Operation]()
        
        //Reload Operation
        let reloadOp = ReloadOperation(collectionView: imageCollectionView)
        uiOperations.append(reloadOp)
        
        for index in 0..<20 {
            let data = ds.list[index]
            
            //Download Operation
            let downloadOp = DownloadOperation(target: data)
            //의존성 추가. 다운로드 완료 후 리로드 op 실행됨.
            reloadOp.addDependency(downloadOp)
            backgroundOperations.append(downloadOp)
            
            //Filter Operation
            let filterOp = FilterOperation(target: data)
            //리로드가 끝난 후 필터 적용해야 하므로 의존성 추가
            filterOp.addDependency(reloadOp)
            backgroundOperations.append(filterOp)
            
            //개별 셀 리로드
            let reloadItemOp = ReloadOperation(collectionView: imageCollectionView, indexPath: IndexPath(item: index, section: 0))
            //필터가 끝난 후 리로드 실행
            reloadItemOp.addDependency(filterOp)
            uiOperations.append(reloadItemOp)
        }
        //waitUntilFinished를 true로 하면 모든 오퍼레이션이 끝날 때까지 메소드가 리턴되지 않음.
        //백그라운드에서 실행하거나 의존성이 없으면 true를 해도 무방하지만 그게 아니라면 false
        //그렇지 않으면 메인이 블락되거나 op가 안끝남
        backgroundQueue.addOperations(backgroundOperations, waitUntilFinished: false)
        mainQueue.addOperations(uiOperations, waitUntilFinished: false)
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
        
        setupLayout()
        
        //동시 실행 작업 수 최대 값 설정
        backgroundQueue.maxConcurrentOperationCount = 20
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
