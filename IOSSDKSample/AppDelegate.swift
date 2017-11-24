//
//  AppDelegate.swift
//  IOSSDKSample
//
//  Created by admin on 22/11/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import MuviSDK
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var languageData : [LanguageListOutputModel] = [LanguageListOutputModel]()
    
    var streamMsg: String?
    var streaming_restriction:Int = 0
    
    let gcmMessageIDKey = "gcm.message_id"
    var backgroundSessionCompletionHandler : (() -> Void)?
    let cache = NSCache<AnyObject, AnyObject>()
    var mySectionId :[String] = []
    var mySectionList :[String] = []
    var myList :[String] = []
    var footer_menuDis:[String] = [String]()
    var footer_menuPer:[String] = [String]()
    var myPermalinkList :[String] = []
    var myContentTypesList:[String] = []
    var myfootorlist :[String] = []
    var myPermalinkList1 :[String] = []
    var langCodeList :[String] = []
    var langNameList :[String] = []
    var lang:String!
    var mylists:[String] = [String]()
    var ip:String!
    var country = "UK"
    var taskID:Int!
    var connection:NSURLConnection!
    var length:Int!
    var startTime:NSDate!
    var kGCKMediaDefaultReceiverApplicationID = "96B30BA0"      // "DF98C493"
    
    var sliderTouchCancelTime:Double = 0
    var sliderTouchCancelFuncBoolvalue:Bool = false
    
    //Chromecast Videolog
    var isSeekDetailsPageTag:Int = 0
    var played_length = "0"
    
    var log_temp_id:String = "0"
    var log_id:String = "0"
    
    var urlSize:Int64 = 0
    
    //submenu by Dipya
    var subMenuTitleMain = [[String]]()
    var subMenuPermalinkMain = [[String]]()
    var subMenuTitle :[String] = []
    var subMenuPermalink :[String] = []
    
    var BannerOutPut:[String] = []
    
    //add by durga for resolution
    var resolutionList :[String] = []
    var resolutionUrlList :[String] = []
    
    
    var myBannerUrl :[String] = []
    
    var isLandscape: Bool = false
    
    
    //vishwam
    //
    var appBaseUrl = "https://www.muvi.com/rest/"
    
    var appDomainName = "https://www.muvi.com/"
    
    var authToken = "25e74a5c88d19c4b57c8138bf47abdf7"
    
     var initialViewController:UIViewController?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        initialViewController  = StartPageViewController(nibName:"StartPageViewController",bundle:nil)
        
        
        let frame = UIScreen.main.bounds
        window = UIWindow(frame: frame)
        var navBar = UINavigationController(rootViewController: initialViewController!)
        
        window!.rootViewController = navBar
        window!.makeKeyAndVisible()
        
        UINavigationBar.appearance().barTintColor = UIColor(red: 12/255, green: 185/255, blue: 142/255, alpha: 1.0)
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

