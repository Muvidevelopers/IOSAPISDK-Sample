//
//  StartPageViewController.swift
//  IOSSDKSample
//
//  Created by admin on 23/11/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import MuviSDK

class StartPageViewController: UIViewController {
    
    var window: UIWindow?
   // var activityIndicator : NVActivityIndicatorView!
    @IBOutlet var retryButton: UIButton!
    @IBOutlet weak var myLabel: UILabel!
    var objectC = Controller.init()
    var appD = UIApplication.shared.delegate as? AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
//        let size = CGSize(width: 50, height:50)
//        let rect = CGRect(
//            origin: CGPoint(x: 0, y: 0),
//            size: CGSize(width: 60,height: 60)
//        )
//        
//        activityIndicator = NVActivityIndicatorView(frame: rect,  type: NVActivityIndicatorType(rawValue: 3), color: UIColor.indicatorColor())
//        activityIndicator.center = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2)
//        
//        self.view.addSubview(activityIndicator)
//        activityIndicator.startAnimating()
        
        self.myLabel.isHidden = true
        self.retryButton.isHidden = true
        
        self.initalAPI()
    }

    func initalAPI()
    {
        
        let keyHashInput = KeyHashInputModel.init(authtoken: (self.appD?.authToken)!, bundle: "com.muvi.apisdksampleapp")
        
        self.objectC.getHashKey(keyHashInput) { (keymod:KeyModel) in
            
            
            DispatchQueue.main.async(execute: { () -> Void in
               // self.activityIndicator.stopAnimating()
                
                
                if keymod.code == 200 {
                    if keymod.msg == "Invalid Package name"{
                        self.myLabel.isHidden = false
                        self.myLabel.text = "Invalid Package name"
                    }
                    else{
                        self.callForCountry()
                    }
                    
                    // self.getSectionList()
                }
                else{
                    self.myLabel.isHidden = false
                    self.myLabel.text = "KIndly initialize the SDK Initializer API"
                }
                
            })
        }
        
    }

    //for Geo-block code
    //*************************************************************************************
    
    func callForCountry()
    {
      //  self.activityIndicator.startAnimating()
        let check_Input = CheckInput.init(authToken: (self.appD?.authToken)!)
        
        objectC.postForCountry(check_Input){(checkOutput: CheckOutput) in
            
            // Move to the UI thread
            DispatchQueue.main.async(execute: { () -> Void in
            //    self.activityIndicator.stopAnimating()
                print(checkOutput.code)
                
                if(checkOutput.code != 200){
                    
                    
                    let date = NSDate()
                    
                    var formatter: DateFormatter = DateFormatter()
                    formatter.dateFormat = "MM-dd-yyyy"
                    //defaults.setObject(formatter.stringFromDate(date), forKey: "loginDate")
                    
                    let defaults = UserDefaults.standard
                    defaults.set("active", forKey: "countryRestrictionTest")
                    defaults.set(formatter.string(from: date as Date), forKey: "countryRestrictionTestDate")
                    if let c = self.appD?.country{
                        defaults.set(self.appD?.country, forKey: "countryRestrictionValue")
                    }
                    else
                    {
                        //FRPadichi
                        defaults.set("UK", forKey: "countryRestrictionValue")
                    }
                    
                    defaults.synchronize()
                    
                    NSLog("After data received from country")
                    if let c = UserDefaults.standard.object(forKey: "internetSpeedCheckStatus"){
                        self.switchToDataTab()
                        
                    }
                    else
                    {
                        self.callforImageDownload()
                    }
                }
                else
                {
                    self.appD?.ip = checkOutput.ip
                    
                    self.checkForCountryRestriction()
                }
            })
        }
    }
    
    
    
    func checkForCountryRestriction()
    {
        
        let check_input = CheckGeoBlockInputModel.init(authToken: (self.appD?.authToken)!, ip: (self.appD?.ip)!)
        
        self.objectC.CheckGeoBlockCountryAsynTask(check_input){(checkOutput:CheckGeoBlockOutputModel) in
            
            // Move to the UI thread
            DispatchQueue.main.async(execute: { () -> Void in
                
                if(checkOutput.code == 200){
                    
                    self.appD?.country = checkOutput.country!
                    let date = NSDate()
                    
                    var formatter: DateFormatter = DateFormatter()
                    formatter.dateFormat = "MM-dd-yyyy"
                    let defaults = UserDefaults.standard
                    defaults.set("active", forKey: "countryRestrictionTest")
                    defaults.set(formatter.string(from: date as Date), forKey: "countryRestrictionTestDate")
                    defaults.set(self.appD?.country, forKey: "countryRestrictionValue")
                    
                    defaults.synchronize()
                    
                    NSLog("After data received from country")
                    if let c = UserDefaults.standard.object(forKey: "internetSpeedCheckStatus"){
                        self.switchToDataTab()
                        
                    }
                    else
                    {
                        self.callforImageDownload()
                    }
                }
                else if (checkOutput.code == 454){
                    self.appD?.country = checkOutput.country!
                    
                    
                    let date = NSDate()
                    
                    var formatter: DateFormatter = DateFormatter()
                    formatter.dateFormat = "MM-dd-yyyy"
                    //defaults.setObject(formatter.stringFromDate(date), forKey: "loginDate")
                    
                    let defaults = UserDefaults.standard
                    defaults.set("active", forKey: "countryRestrictionTest")
                    defaults.set(formatter.string(from: date as Date), forKey: "countryRestrictionTestDate")
                    if let c = self.appD?.country{
                        defaults.set(self.appD?.country, forKey: "countryRestrictionValue")
                    }
                    else
                    {
                        defaults.set("US", forKey: "countryRestrictionValue")
                    }
                    
                    defaults.synchronize()
                    
                    NSLog("After data received from country")
                    if let c = UserDefaults.standard.object(forKey: "internetSpeedCheckStatus"){
                        self.switchToDataTab()
                        
                    }
                    else
                    {
                        self.callforImageDownload()
                    }
                    
                }
                else{
                    
                  //  self.activityIndicator.stopAnimating()
                    self.myLabel.isHidden = false
                    self.myLabel.text = "Account is Blocked in this country."
                }
                
            })
        }
    }
    
    func switchToDataTab(){
        
        //        self.objectC.getSectionName(["authToken": (self.appD?.authToken)!], url: (self.appD?.appBaseUrl)! + "getSectionName") {
        //            (succeeded: Bool, msg: String) -> () in
        //            DispatchQueue.main.async(execute: { () -> Void in
        //                // Show the alert
        //
        //                if(!succeeded)
        //                {
        //
        //                }
        //                else
        //                {
        //
        //                }
        //
        //            })
        //        }
        //*************GetMenuList*******************
        self.language()
        
        
    }
    func callforImageDownload()
    {
        UserDefaults.standard.set("continue", forKey: "internetSpeedCheckStatus")
        UserDefaults.standard.synchronize()
        
        //////////////////////////////////////
        let postInput = PostforImageInput.init(authToken: (self.appD?.authToken)!)
        objectC.postForImage(postInput) { (postOutput:PostforImageOutput) in
            
            
            
            // Move to the UI thread
            DispatchQueue.main.async(execute: { () -> Void in
                // Show the alert
                
                // MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                
                if(postOutput.code != 200){
                    
                    UserDefaults.standard.set("0.0", forKey: "InternetSpeed")
                    UserDefaults.standard.set("true", forKey: "internetSpeedCheckStatus")
                    UserDefaults.standard.synchronize()
                    // self.tableView.hidden = false
                    self.switchToDataTab()
                    
                    
                }
                else
                {
                    
                    self.testDownloadSpeed(urlx: postOutput.imageUrl!)
                    self.switchToDataTab()
                }
            })
        }
    }
    
    func beginBackgroundUpdateTask() -> UIBackgroundTaskIdentifier {
        return UIApplication.shared.beginBackgroundTask(expirationHandler: {})
    }
    func endBackgroundUpdateTask(taskID: UIBackgroundTaskIdentifier) {
        UIApplication.shared.endBackgroundTask(taskID)
    }
    
    func testDownloadSpeed(urlx:String) {
        
        let url: NSURL = NSURL(string: urlx)!
        let request: NSURLRequest = NSURLRequest(url: url as URL)
        
        self.appD?.startTime = NSDate() as Date! as Date! as! NSDate
        self.appD?.length = 0
        self.appD?.taskID = beginBackgroundUpdateTask()
        self.appD?.connection = NSURLConnection(request: request as URLRequest, delegate: self)
        
        self.appD?.connection.start()
        let delayInSeconds:Int64 =  1000000000  * 2
        
        
    }
    
    
    
    
    //************************************************************************************
    
    
    func language(){
        print("coming here for lang")
        
      //  self.activityIndicator.startAnimating()
        let check_input = LanguageListInputModel.init(authToken: (self.appD?.authToken)!)
        
        self.objectC.getLanguageList(check_input){(checkOutput:[LanguageListOutputModel]) in
            print(checkOutput[0].code)
            // Move to the UI thread
            
            DispatchQueue.main.async(execute: { () -> Void in
                // Show the alert
            //    self.activityIndicator.stopAnimating()
                if checkOutput[0].code == 200 {
                    
                    self.appD?.languageData.append(contentsOf: checkOutput)
                    self.appD?.langCodeList = [String]()
                    self.appD?.langNameList = [String]()
                    
                    let defaults = UserDefaults.standard
                    if var c = defaults.string(forKey: "setDefault") {
                        
                        print("Default already registered")
                        
                    }
                    else{
                        
                        defaults.setValue(self.appD?.languageData[0].defaultLanuage, forKey: "LangChoose")
                        defaults.synchronize()
                        
                    }
                    for index:Int in 0  ..< checkOutput.count {
                        
                        self.appD?.langCodeList.append(checkOutput[index].langcode!)
                        self.appD?.langNameList.append(checkOutput[index].language!)
                        
                    }
                    
                    self.checkForlogin()
                    self.getSectionList()
                    
                }
                else {
                    //language not comming
                    
                }
                
            })
        }
    }
    
    
    //new API implementation by DIpya
    func getSectionList(){
        print("lanncerrerr")
      //  self.activityIndicator.startAnimating()
        
        let sectionInput = SectionInput.init(authToken: (self.appD?.authToken)!)
        objectC.getsectionname(sectionInput) { (sectionArray:[SectionOutput],BannerOutPut:[BannerListModel]) in
            
            
            DispatchQueue.main.async(execute: { () -> Void in
                // Show the alert
              //  self.activityIndicator.stopAnimating()
                
                if(sectionArray[0].code == 200){
                    
                    for index:Int in 0  ..< sectionArray.count {
                        
                        // if sectionArray[index].total != "0"{
                        
                        self.appD?.mySectionList.append(sectionArray[index].title!)
                        self.appD?.mySectionId.append(sectionArray[index].section_id!)
                        
                        self.appD?.BannerOutPut.append(BannerOutPut[index].original)

                        //}
                        
                    }
                    
                    self.getMenuList()
                    
                }
                else{
                    
                }
                
            })
        }
    }
    
    
    var myList :[String] = []
    var myPermalinkList :[String] = []
    var subMenuTitle:[String] = []
    var subMenuPermalink:[String] = []
    
    
    func getMenuList() {
        
        let menu_input = MenuListInput.init(authToken: (self.appD?.authToken)!)
        objectC.getMenuListAsync(menu_input) { (menuArray:[MenuListArray], footmenuArray:[FootMenuListArray],childArray:[ChildMenuArray]) in
            
            
            // Move to the UI thread
            DispatchQueue.main.async(execute: { () -> Void in
                // Show the alert
               // self.activityIndicator.stopAnimating()
                if(menuArray[0].code == 200){
                    
                    
                    print(menuArray)
                    
                    self.myList = [String]()
                    self.myPermalinkList = [String]()
                    self.appD?.myList.removeAll()
                    self.appD?.myPermalinkList.removeAll()
                    self.appD?.myList =  [String]()
                    self.appD?.mylists.removeAll()
                    self.appD?.mylists = [String]()
                    self.appD?.myPermalinkList = [String]()
                    self.appD?.footer_menuDis = [String]()
                    self.appD?.footer_menuPer = [String]()
                    
                    self.appD?.subMenuTitle = [String]()
                    self.appD?.subMenuPermalink = [String]()
                    
                    
                    for index:Int in 0 ..< footmenuArray.count
                    {
                        
                        var disname = footmenuArray[index].display_name
                        
                        if(disname?.contains("&amp;"))!{
                            
                            disname?.replacingOccurrences(of: "&amp;", with: "&")
                            // disname.replace("&amp;", with: "&")
                        }
                        self.appD?.footer_menuDis.append(disname!)
                        self.appD?.footer_menuPer.append(footmenuArray[index].permalink!)
                        
                    }
                    
                    
                    
                    if let con = UserDefaults.standard.string(forKey: "Keylogin")
                    {
                        
                        if menuArray.count > 0
                        {
                            for index:Int in 0 ..< menuArray.count
                            {
                                if menuArray[index].display_name != ""
                                {
                                    self.appD?.mylists.append(menuArray[index].display_name!)
                                }
                                if menuArray[index].permalink != ""
                                {
                                    self.appD?.myPermalinkList.append(menuArray[index].permalink!)
                                }
                            }
                        }
                        
                        self.appD?.myList.append(UserDefaults.standard.string(forKey: "my_library")!)
                        
                        self.appD?.myList.append(contentsOf: self.myList)
                        
                        if childArray.count > 0{
                            for index:Int in 0 ..< childArray.count
                            {
                                if childArray[index].display_name != ""
                                {
                                    self.appD?.subMenuTitle.append(childArray[index].display_name!)
                                }
                                if childArray[index].permalink != ""{
                                    self.appD?.subMenuPermalink.append(childArray[index].permalink!)
                                }
                            }
                        }
                    }
                    else
                    {
                        if menuArray.count > 0
                        {
                            for index:Int in 0 ..< menuArray.count
                            {
                                if menuArray[index].display_name != ""
                                {
                                    self.appD?.mylists.append(menuArray[index].display_name!)
                                }
                                if menuArray[index].permalink != ""
                                {
                                    self.appD?.myPermalinkList.append(menuArray[index].permalink!)
                                }
                            }
                        }
                        if childArray.count > 0{
                            for index:Int in 0 ..< childArray.count
                            {
                                if childArray[index].display_name != ""
                                {
                                    self.appD?.subMenuTitle.append(childArray[index].display_name!)
                                }
                                if childArray[index].permalink != ""{
                                    self.appD?.subMenuPermalink.append(childArray[index].permalink!)
                                }
                            }
                        }
                    }
                    
                    
                    
                    self.window = UIWindow(frame: UIScreen.main.bounds)
                    
                    let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    // start from here now
                    
                    var destination = storyboard.instantiateViewController(withIdentifier: "MainpageViewController") as! MainpageViewController
                    
                    var navBar = UINavigationController(rootViewController: destination)
                    self.window?.backgroundColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
                    self.window?.rootViewController = navBar
                    self.window?.makeKeyAndVisible()
                    
                }
                else{
                    
                }
                
            })
        }
        
    }
    func checkForlogin() {
        
      //  self.activityIndicator.startAnimating()
        
        let registrationCheckInput = IsRegistrationEnabledInputModel.init(authToken: (self.appD?.authToken)!)
        
        objectC.isRegistrationEnabledAsynTask(registrationCheckInput){(regOutput:IsRegistrationEnabledOutputModel) in
            
            // Move to the UI thread
            DispatchQueue.main.async(execute: { () -> Void in
                // Show the alert
             //   self.activityIndicator.stopAnimating()
                
                if(regOutput.code == 200) {
                    
                    let defaults = UserDefaults.standard
                    if regOutput.isLogin == 1 {
                        
                    }
                    else{
                        
                    }
                    if regOutput.chromecast == 1 {
                        
                    }
                    else{
                        
                    }
                    print(regOutput.hasFavourite)
                    if regOutput.hasFavourite == 1 {
                        //isFavEnable
                        defaults.set("1", forKey: "isFavEnable")
                    }
                    else{
                        defaults.set("0", forKey: "isFavEnable")
                        
                    }
                    if regOutput.isMylibrary == 1 {
                        defaults.set("1", forKey: "isMyLib")
                    }
                    else{
                        defaults.set("0", forKey: "isMyLib")
                    }
                    if regOutput.isOffline == 1 {
                        
                    }
                    else{
                        
                    }
                    if regOutput.isRating == 1 {
                        //isRatingEnable
                        defaults.set("1", forKey: "isRatingEnable")
                    }
                    else{
                        defaults.set("0", forKey: "isRatingEnable")
                    }
                    if regOutput.isRestrictDevice == 1 {
                        defaults.set("1", forKey: "deviceRestrict")
                    }
                    else{
                        defaults.set("0", forKey: "deviceRestrict")
                    }
                    
                    if regOutput.isStreamingRestriction == 1 {
                        defaults.set("1", forKey: "isStream")
                    }
                    else{
                        defaults.set("0", forKey: "isStream")
                    }
                    
                    if regOutput.signupStep == 1 {
                        
                    }
                    else{
                        
                    }
                }
                else
                {
                    print("Logincheck success")
                    
                    
                    
                }
                
            })
        }
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
