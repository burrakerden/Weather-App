//
//  MainCollectionViewCell.swift
//  Weather1
//
//  Created by Burak Erden on 8.03.2023.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellName: UILabel!
    @IBOutlet weak var cellCondition: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
