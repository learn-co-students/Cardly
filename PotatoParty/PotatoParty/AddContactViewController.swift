//
//  AddContactViewController.swift
//  PotatoParty
//
//  Created by Forrest Zhao on 11/16/16.
//  Copyright © 2016 ForrestApps. All rights reserved.
//

import UIKit

class AddContactViewController: UIViewController {
    
    var nameTextField = UITextField()
    var emailTextField = UITextField()
    var addButton = UIButton()
    var groupDropDown = UIPickerView()
    var importContactsButton = UIButton()
    var cancelButton = UIButton()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        layoutElements()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func cancelButtonTapped () {
        dismiss(animated: true, completion: nil)
    }
    
    func importContactButtonTapped () {
        print ("import Contact Button Tapped")
    }
    
    func addButtonTapped () {
        print ("add Button tapped")
    }

}
