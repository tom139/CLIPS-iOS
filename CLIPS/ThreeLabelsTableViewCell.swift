//
//  ThreeLabelsTableViewCell.swift
//  CLIPS
//
//  Created by Tommaso Panozzo on 14/09/16.
//  Copyright © 2016 Beacon Strips. All rights reserved.
//

import UIKit

class ThreeLabelsTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	var state : ThreeLabelsDisplayable? {
		didSet {
			headline.text = state?.head
			subhead.text  = state?.subhead
			detail.text   = state?.detail
		}
	}
	
	@IBOutlet weak var headline: UILabel!
	@IBOutlet weak var subhead: UILabel!
	@IBOutlet weak var detail: UILabel!
}
