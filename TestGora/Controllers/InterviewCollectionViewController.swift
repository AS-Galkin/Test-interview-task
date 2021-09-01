//
//  InterviewCollectionViewController.swift
//  TestGora
//
//  Created by Александр Галкин on 31.08.2021.
//

import Foundation
import UIKit

class InterviewCollectionViewController: UIViewController {
    
    private var queue: DispatchQueue = DispatchQueue.global(qos: .utility)
    private var collectionView: InterviewCollectionView?
    private var imageCache: ImageCache?
    private var imagesData: [ImageModel.ImageData]?
    private var imageDownloadURL: [URL]?
    
    
    init(imagesData: [ImageModel.ImageData], imageCache: ImageCache) {
        super.init(nibName: nil, bundle: nil)
        collectionView = InterviewCollectionView()
        self.imagesData = imagesData
        self.imageCache = imageCache
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Photos"
        
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        self.view.addSubview(collectionView ?? UICollectionView())
        
        collectionView?.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView?.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        collectionView?.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    //MARK: - Method that creates job for downloading each image
    func createDowloadingWork(url: URL, completion: @escaping (_ url: URL) -> ()) {
        queue.async {
            completion(url)
        }
    }
}

extension InterviewCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    //MARK: - How many cells
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard imagesData != nil else {
            return 1
        }
        
        return imagesData!.count
    }
    
    //MARK: - Finaly setting each cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! InterviewCollectionViewCell
        
        guard let label = imagesData?[indexPath.row].title,
              imagesData != nil else { return myCell }
        
        //Загружаем картинки из сети если они не были найдены в кэш. И обновляем содержимое дисплея.
        createDowloadingWork(url: URL(string: imagesData![indexPath.row].url ?? "")!) {
            do {
                if let image = self.imageCache?.image(for: $0 as NSURL) {
                    DispatchQueue.main.async {
                        myCell.image = image
                    }
                } else {
                    let image = UIImage(data: try Data(contentsOf: $0))
                    if let im = image {
                        self.imageCache?.insertImage(im, url: $0 as NSURL)
                    }
                    DispatchQueue.main.async {
                        myCell.image = image
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Ошибка", message: "Ошибка загрузки данных", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "ОК", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        
        myCell.labelString = label
        
        return myCell
    }
}
