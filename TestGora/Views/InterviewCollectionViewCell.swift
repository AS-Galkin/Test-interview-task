//
//  InterviewCollectionViewCell.swift
//  TestGora
//
//  Created by Александр Галкин on 31.08.2021.
//

import Foundation
import UIKit

class InterviewCollectionViewCell: UICollectionViewCell {
    
    var labelString: String? {
        didSet {
            label.text = labelString
        }
    }
    
    //Пока данное свойство не будет установленно будет показываться activity indicator
    var image: UIImage? {
        didSet {
            imageView.image = image
            activityIndicator.isHidden = true
            activityIndicator.stopAnimating()
        }
    }
    
    fileprivate var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = label.font.withSize(14.0)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    fileprivate var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    fileprivate var activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.translatesAutoresizingMaskIntoConstraints = false
        activity.isHidden = false
        activity.startAnimating()
        return activity
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 3.0
        backgroundColor = .white
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.black.cgColor.copy(alpha: 0.1)
        layer.masksToBounds = true
        
        
        contentView.addSubview(imageView)
        imageView.addSubview(activityIndicator)
        contentView.addSubview(label)
        
        makeConstraints()
        
    }
    
    fileprivate func makeConstraints() {
        activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: layer.frame.width).isActive = true
        

        label.topAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -1).isActive = true
        label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant:  6).isActive  = true
        label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant:  -6).isActive  = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
