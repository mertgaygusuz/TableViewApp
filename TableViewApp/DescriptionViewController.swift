//
//  DescriptionViewController.swift
//  TableViewApp
//
//  Created by Mert Gaygusuz on 10.07.2022.
//

import UIKit

class DescriptionViewController: UIViewController {

    @IBOutlet weak var lblBrandDescription: UITextView!
    var bDescription : String = ""
    var masterView : ViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        lblBrandDescription.text = bDescription
        self.navigationItem.largeTitleDisplayMode = .never
    }
    
    func setDescription(b : String) {
        bDescription = b
        if isViewLoaded {
            lblBrandDescription.text = bDescription
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        masterView?.brandDescription = lblBrandDescription.text
        lblBrandDescription.resignFirstResponder()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lblBrandDescription.becomeFirstResponder()
    }
    


}
