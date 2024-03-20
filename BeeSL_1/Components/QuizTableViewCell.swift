//
//  QuizTableViewCell.swift
//  BeeSL_1
//
//  Created by Taylor, Joe [sgjtay21] on 12/03/2024.
//

import UIKit


//allows cells delegate to handle button taps
protocol QuizTableViewDelegate: AnyObject    {
    func didTapButton(with title: String)
}

//when button gets clicked on table, it delegates that call
//bubble it back up to the view controller to know the contents of the cell
class QuizTableViewCell: UITableViewCell {
    
    //delegate property to notify about button tap events
    weak var delegate: QuizTableViewDelegate?
    
    
    static let identifier = "QuizTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "QuizTableViewCell", bundle: nil)
    }


    @IBOutlet weak var buttonCell: UIButton!
    
    private var title: String = ""
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBAction func didTapButton(_ sender: UIButton) {
        //tells delegate button was tapped
        delegate?.didTapButton(with: title)
    }
    
    //configures the cell ui so both the button and label can fit
    func configure(with title: String, scoreText: String?) {
        self.title = title
        buttonCell.setTitle(title, for: .normal)
        scoreLabel.text = scoreText
        //print("\(scoreText ?? title)")
    }
   
    //called when cell is loaded from the nib()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        scoreLabel.text = "Static Score"
        buttonCell.setTitleColor(.link, for: .normal)
    }
    
}
