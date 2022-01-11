//
//  KeywordsViewController.swift
//  Time_Visualizer
//
//  Created by administrator on 1/10/22.
//

import UIKit


class KeywordsViewController: UIViewController {
    
    var controllDelegate: ControllDelegate?
    var indexPath: NSIndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func keywordsButton(_ sender: UIButton) {
        guard let indexPath = self.indexPath else { return }
        
        switch sender.tag {
        case 1:
            controllDelegate?.keywordPassing(keyword: "ios", indexPath: indexPath)
        case 2:
            controllDelegate?.keywordPassing(keyword: "swift", indexPath: indexPath)
        case 3:
            controllDelegate?.keywordPassing(keyword: "algorithms", indexPath: indexPath)
        case 4:
            controllDelegate?.keywordPassing(keyword: "data structures", indexPath: indexPath)
        case 5:
            controllDelegate?.keywordPassing(keyword: "uikit", indexPath: indexPath)
        case 6:
            controllDelegate?.keywordPassing(keyword: "swift ui", indexPath: indexPath)
        default:
            return
        }
        dismiss(animated: true, completion: nil)
    }

}

