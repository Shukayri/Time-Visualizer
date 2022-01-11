//
//  ControllDelegate.swift
//  Time_Visualizer
//
//  Created by administrator on 1/10/22.
//

import Foundation
import UIKit

protocol ControllDelegate: AnyObject {
    func keywordPassing(keyword: String, indexPath: NSIndexPath)
    func newEntryPassing(string: String, indexPath: NSIndexPath)
}
