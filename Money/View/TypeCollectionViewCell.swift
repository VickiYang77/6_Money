//
//  TypeCollectionViewCell.swift
//  Money
//
//  Created by Vicki Yang on 2023/6/5.
//

import UIKit

class TypeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    
    func setup(name: String, image: String) {
        self.imageView.image = UIImage(systemName: image)
        self.typeLabel.text = name
    }
}
