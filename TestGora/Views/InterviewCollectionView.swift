//
//  InterviewCollectionView.swift
//  TestGora
//
//  Created by Александр Галкин on 31.08.2021.
//

import Foundation
import UIKit

class InterviewCollectionView: UICollectionView {
    
    private var collectionLayout: UICollectionViewFlowLayout = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 28, height: UIScreen.main.bounds.height / 1.6)
        layout.minimumLineSpacing = 14.0
        return layout
    }()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: collectionLayout)
        
        register(InterviewCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
