//
//  CustomTableViewCell.swift
//  Time_Visualizer
//
//  Created by administrator on 1/10/22.
//

import UIKit


class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var taskTextfieald: UITextField!
    
    weak var indexPath: NSIndexPath?
    weak var controllDelegate: ControllDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        taskTextfieald.delegate = self
    }
    
}

extension CustomTableViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let note = textField.text else { return }
        controllDelegate?.newEntryPassing(string: note, indexPath: indexPath!)
    }
}
