//
//  AlertControllerShowable.swift
//  Diary
//
//  Created by Hyungmin Lee on 2023/09/06.
//

import UIKit

protocol AlertControllerShowable where Self: UIViewController {
    
}

extension AlertControllerShowable {
    func showAlertController(title: String = "",
                             message: String = "",
                             leftButtonTitle: String = "",
                             rightButtonTitle: String = "",
                             leftButtonAction: @escaping () -> Void = {},
                             rightButtonAcition: @escaping () -> Void = {}) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let leftAction = UIAlertAction(title: leftButtonTitle, style: .cancel) { action in
            leftButtonAction()
        }
        let rightAction = UIAlertAction(title: rightButtonTitle, style: .destructive) { action in
            rightButtonAcition()
        }
        
        [leftAction, rightAction].forEach {
            alertController.addAction($0)
        }
        
        present(alertController, animated: true)
    }
}
