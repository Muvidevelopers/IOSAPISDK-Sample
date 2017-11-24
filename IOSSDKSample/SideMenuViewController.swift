//
//  SideMenuViewController.swift
//  XibTest
//
//  Created by Muvi on 08/06/17.
//  Copyright © 2017 Muvi. All rights reserved.
//

import UIKit

class SideMenuViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    var appd:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.register(UINib(nibName:"TableViewControllerCell",bundle:nil), forCellReuseIdentifier: "TableViewControllerCell")
        
        self.tableView.register(UINib(nibName:"ImageHeaderView",bundle:nil), forCellReuseIdentifier: "ImageHeaderView")
        
        var gest = UITapGestureRecognizer(target: self, action: "sideMenuBarDismiss")
        gest.delegate = self
        self.view.addGestureRecognizer(gest)
        
        
        //swipe gesture setup here
        var swipeGest = UISwipeGestureRecognizer(target: self, action: "sideMenuBarDismiss")
        swipeGest.direction = .left
        self.view.addGestureRecognizer(swipeGest)
        
    }
    
    func sideMenuBarDismiss()
    {
        self.dismiss(animated: false, completion: nil)
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        if (touch.view?.isDescendant(of: self.tableView))!
        {
            return false
        }else
        {
            return true
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0
        {
            return 1
        }else{
            return self.appd.mylists.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageHeaderView", for: indexPath) as! ImageHeaderView
            
            cell.isUserInteractionEnabled = false
            
            return cell
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewControllerCell", for: indexPath) as! TableViewControllerCell
            
            cell.label.text = self.appd.mylists[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0
        {
            return 150
        }else{
            return 50
        }
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    
}
