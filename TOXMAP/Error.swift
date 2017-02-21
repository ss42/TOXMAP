//
//  Error.swift
//  TOXMAP
//
//  Created by Sanjay Shrestha on 2/20/17.
//  Copyright © 2017 NIH. All rights reserved.
//

import Foundation
import UIKit

class ErrorHandler: UIViewController{
    
    func showError(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}
