//
//  CurrencyCell.swift
//  CurrencyConvertor
//
//  Created by Anugrah on 14/08/24.
//

import UIKit

class CurrencyCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var currencyName: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    func setUp() {
        containerView.layer.cornerRadius = 5
        containerView.layer.shadowColor = UIColor.lightGray.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 1)
        containerView.layer.shadowOpacity = 0.5
        containerView.layer.shadowRadius = 3
        containerView.layer.masksToBounds = false 
    }

}
