//
//  QuizTableViewCell.swift
//  BeeSL_1
//
//  Created by Taylor, Joe [sgjtay21] on 12/03/2024.
//

import UIKit

protocol QuizTableViewDelegate: AnyObject    {
    func didTapButton(with title: String)
}

//when button gets clicked on table, it delegates that call
//bubble it back up to the view controller to know the contents of the cell
class QuizTableViewCell: UITableViewCell {
    
    weak var delegate: QuizTableViewDelegate?
    
    static let identifier = "QuizTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "QuizTableViewCell", bundle: nil)
    }


    
    
    @IBOutlet var buttonCell: UIButton!
    private var title: String = ""
    
    @IBAction func didTapButton() {
        delegate?.didTapButton(with: title)
        
    }
    
    func configure(with title: String) {
        self.title = title
        buttonCell.setTitle(title, for: .normal)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        buttonCell.setTitleColor(.link, for: .normal)
    }
    
}
