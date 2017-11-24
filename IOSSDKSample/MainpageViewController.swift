//
//  MainpageViewController.swift
//  IOSSDKSample
//
//  Created by admin on 22/11/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import MuviSDK
import KFSwiftImageLoader
import NVActivityIndicatorView

class MainpageViewController: UIViewController,KASlideShowDelegate,KASlideShowDataSource,UIGestureRecognizerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    
    var imageData = ["banner_1600x900.png","banner_1600x900.png"]
    @IBOutlet weak var mainPageBanner: KASlideShow!
   // var activityIndicator:NVActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    var appD:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var mainPageSection = [NSArray]()
    var objectC = Controller.init()
    
   // var playerInput:[PlayerVCInputData] = [PlayerVCInputData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //KASlideShow delegate set here
        mainPageBanner.delegate = self
        mainPageBanner.datasource = self
        
        self.mainPageBanner.delay = 2.0 // Delay between transitions
        self.mainPageBanner.transitionDuration = 0.5
        self.mainPageBanner.transitionType = KASlideShowTransitionType.slideHorizontal
        self.mainPageBanner.imagesContentMode = UIViewContentMode.scaleAspectFill
        self.mainPageBanner.add(KASlideShowGestureType.swipe)
        
        
        var sideMenuButton:UIBarButtonItem = UIBarButtonItem(image: UIImage(named:"menu"), style: .plain, target: self, action: "sideMenuFunc")
        
        self.navigationItem.leftBarButtonItem = sideMenuButton
        
        //swipe gesture set here
        var swipeGest = UISwipeGestureRecognizer(target: self, action: "sideMenuFunc")
        swipeGest.direction = .right
        self.view.addGestureRecognizer(swipeGest)

         self.contentList(index: 0)
        
        //collection view size set here for collection view
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 15
        layout.headerReferenceSize = CGSize(width: 50, height: 40)
        collectionView.collectionViewLayout = layout
        
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
    }
    
    func sideMenuFunc()
    {
        //open sidemenuBar VC to see the getMenuList
        
        //register NIb here then called to that class
        let newViewController = SideMenuViewController(nibName: "SideMenuViewController", bundle: nil)
        
        newViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        
        // Present View "Modally"
        self.present(newViewController, animated: false, completion: nil)
        
    }
    
    func buttonTapped()
    {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
            
        case UICollectionElementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CollectionReusableView", for: indexPath as IndexPath) as! CollectionReusableView
            
            headerView.headerName.text = self.appD.mySectionList[indexPath.section]
           
            
            return headerView
            
//        case UICollectionElementKindSectionFooter:
//            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CollectionReusableView", for: indexPath) as! CollectionReusableView
//            
//            
//            return footerView
            
        default:
            
            assert(false, "Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView!,
                        layout collectionViewLayout: UICollectionViewLayout!,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if UIDevice.current.userInterfaceIdiom == .phone{
            if UIDevice.current.orientation.isLandscape{
                let sectionInsets = UIEdgeInsets(top: 5.0, left: 5, bottom: 5.0, right: 5)
                return sectionInsets
            }
            else{
                let sectionInsets = UIEdgeInsets(top: 5.0, left: 5, bottom: 5.0, right: 5)
                return sectionInsets
            }
        }
        else{
            let sectionInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 40.0, right: 5.0)
            return sectionInsets
        }
        
        return UIEdgeInsets(top: 5.0, left: 5.0, bottom: 40.0, right: 5.0)
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .phone{
            
            return 5.0
        }
        else
        {
            return 1.5
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var width:CGFloat!
        var height:CGFloat!
        
        //****************************
        
        var url : URL!
        
         var arr = self.mainPageSection[indexPath.section] as! [FeatureContentOutputModel]
        
        url = URL(string: arr[indexPath.row].posterUrl!)
        
        var nsd = NSData(contentsOf: url!)
        var image = UIImage(data: nsd as! Data)
        print("Image size")
        print(image?.size.width)
        print(image?.size.height)
        
        if(((image?.size.width)! / (image?.size.height)!) < 1){
            print("potrait")
            if UIDevice.current.deviceType == .iPhone6S || UIDevice.current.deviceType == .iPhone6 || UIDevice.current.deviceType == .iPhone7 || UIDevice.current.deviceType == .iPhone6SPlus || UIDevice.current.deviceType == .iPhone6Plus || UIDevice.current.deviceType == .iPhone7Plus
            {
                if(UIDevice.current.orientation.isLandscape){
                    
                    let cellSpacing = CGFloat(5) //Define the space between each cell
                    let leftRightMargin = CGFloat(16) //If defined in Interface Builder for "Section Insets"
                    let numColumns = CGFloat(4) //The total number of columns you want
                    
                    let totalCellSpace = cellSpacing * (numColumns - 2)
                    let screenWidth = UIScreen.main.bounds.width
                    width = (screenWidth - leftRightMargin - totalCellSpace) / numColumns
                    
                    height = (((image?.size.height)! / (image?.size.width)! ) * width )
                    print("Width and height landscape less than 1 iPhone6S")
                    print(width)
                    print(height)
                }
                else{
                    let cellSpacing = CGFloat(5) //Define the space between each cell
                    let leftRightMargin = CGFloat(16) //If defined in Interface Builder for "Section Insets"
                    let numColumns = CGFloat(3) //The total number of columns you want
                    
                    let totalCellSpace = cellSpacing * (numColumns - 1)
                    let screenWidth = UIScreen.main.bounds.width
                    width = (screenWidth - leftRightMargin - totalCellSpace) / numColumns
                    
                    height = (((image?.size.height)! / (image?.size.width)! ) * width )
                    print("Width and height potrait less than 1 iPhone6S protrait")
                    print(width)
                    print(height)
                }
            }
            if UIDevice.current.deviceType == .iPhone5 || UIDevice.current.deviceType == .iPhone5S || UIDevice.current.deviceType == .iPhoneSE || UIDevice.current.deviceType == .iPhone4 || UIDevice.current.deviceType == .iPhone4S || UIDevice.current.deviceType == .notAvailable
            {
                if(UIDevice.current.orientation.isLandscape){
                    
                    let cellSpacing = CGFloat(5) //Define the space between each cell
                    let leftRightMargin = CGFloat(16) //If defined in Interface Builder for "Section Insets"
                    let numColumns = CGFloat(3) //The total number of columns you want
                    
                    let totalCellSpace = cellSpacing * (numColumns - 2)
                    let screenWidth = UIScreen.main.bounds.width
                    width = (screenWidth - leftRightMargin - totalCellSpace) / numColumns
                    
                    
                    height = (((image?.size.height)! / (image?.size.width)! ) * width )
                    print("Width and height vert landscape less than 1 iPhone6S")
                    print(width)
                    print(height)
                }
                else{
                    let cellSpacing = CGFloat(5) //Define the space between each cell
                    let leftRightMargin = CGFloat(16) //If defined in Interface Builder for "Section Insets"
                    let numColumns = CGFloat(2) //The total number of columns you want
                    
                    let totalCellSpace = cellSpacing * (numColumns - 1)
                    let screenWidth = UIScreen.main.bounds.width
                    width = (screenWidth - leftRightMargin - totalCellSpace) / numColumns
                    
                    height = (((image?.size.height)! / (image?.size.width)! ) * width )
                    print("Width and height  vert potrait less than 1 iPhone6S protrait")
                    print(width)
                    print(height)
                }
            }
            
            
            
            if UIDevice.current.userInterfaceIdiom == .pad
            {
                let cellSpacing = CGFloat(8) //Define the space between each cell
                let leftRightMargin = CGFloat(5) //If defined in Interface Builder for "Section Insets"
                let numColumns = CGFloat(4) //The total number of columns you want
                let totalCellSpace = cellSpacing * (numColumns - 1)
                let screenWidth = UIScreen.main.bounds.width
                width = (screenWidth - leftRightMargin - totalCellSpace) / numColumns
                //height = 400.0 //whatever height you want
                height = (((image?.size.height)! / (image?.size.width)! ) * width )
                print("Width and height")
                print(width)
                print(height)
                
            }
            
        }
            
        else{
            print("landscape")
            
            if UIDevice.current.userInterfaceIdiom == .phone{
                print("UIDevice.current.orientation:\(UIDevice.current.orientation.isLandscape)")
                if(UIDevice.current.orientation.isLandscape){
                    let cellSpacing = CGFloat(1) //Define the space between each cell
                    let leftRightMargin = CGFloat(16) //If defined in Interface Builder for "Section Insets"
                    let numColumns = CGFloat(3) //The total number of columns you want
                    
                    let totalCellSpace = cellSpacing * (numColumns - 1)
                    let screenWidth = UIScreen.main.bounds.width
                    width = (screenWidth - leftRightMargin - totalCellSpace) / numColumns
                    
                    //height = 145.0
                    height = (((image?.size.height)! / (image?.size.width)! ) * width )
                    print("Width and height")
                    print(width)
                    print(height)
                }
                else{
                    let cellSpacing = CGFloat(1) //Define the space between each cell
                    let leftRightMargin = CGFloat(16) //If defined in Interface Builder for "Section Insets"
                    let numColumns = CGFloat(2) //The total number of columns you want
                    
                    let totalCellSpace = cellSpacing * (numColumns - 1)
                    let screenWidth = UIScreen.main.bounds.width
                    width = (screenWidth - leftRightMargin - totalCellSpace) / numColumns
                    
                    height = (((image?.size.height)! / (image?.size.width)! ) * width )
                    print("Width and height")
                    print(width)
                    print(height)
                }
                
                
                //whatever height you want
            }
            if UIDevice.current.userInterfaceIdiom == .pad
            {
                //            let cellSpacing = CGFloat(1) //Define the space between each cell
                //            let leftRightMargin = CGFloat(12) //If defined in Interface Builder for "Section Insets"
                //            let numColumns = CGFloat(3) //The total number of columns you want
                //            let totalCellSpace = cellSpacing * (numColumns - 1)
                //            let screenWidth = UIScreen.main.bounds.width
                //            width = (screenWidth - leftRightMargin - totalCellSpace) / numColumns + 3.5
                //            height = width + 3.5//whatever height you want
                
                let cellSpacing = CGFloat(8) //Define the space between each cell
                let leftRightMargin = CGFloat(5) //If defined in Interface Builder for "Section Insets"
                let numColumns = CGFloat(3) //The total number of columns you want
                let totalCellSpace = cellSpacing * (numColumns - 1)
                let screenWidth = UIScreen.main.bounds.width
                width = (screenWidth - leftRightMargin - totalCellSpace) / numColumns
                // height = width - 110 //whatever height you want
                height = (((image?.size.height)! / (image?.size.width)! ) * width )
                print("Width and height")
                print(width)
                print(height)
                
            }
            
            
        }
        
        
        
        return CGSize(width: width, height: height);
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //collectionview delegate and datasource here
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        print(self.mainPageSection.count)
        
        return mainPageSection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.mainPageSection.count > 0{
            return self.mainPageSection[section].count
        }
        else
        {
            return 0
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mainPageCollectionViewCell", for: indexPath) as! mainPageCollectionViewCell
        
        if mainPageSection.count > 0{
            var arr = mainPageSection[indexPath.section] as! [FeatureContentOutputModel]
            
            cell.mainPageLabel.numberOfLines = 2
            
                let placeholder = UIImage(named: "logo")!
                
                cell.mainPageImage.loadImage(urlString: arr[indexPath.item].posterUrl!, placeholderImage: placeholder) {
                    success, error in
                    
                    cell.mainPageImage.autoresizingMask = [UIViewAutoresizing.flexibleBottomMargin, UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleRightMargin, UIViewAutoresizing.flexibleLeftMargin, UIViewAutoresizing.flexibleTopMargin, UIViewAutoresizing.flexibleWidth]
                    cell.mainPageImage.contentMode = UIViewContentMode.scaleAspectFit
                    
                }
            
            cell.mainPageLabel.isHidden = false
            
        }
        
        return cell
    }
    
    var selectedIndexPath:Int = 0
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.selectedIndexPath = indexPath.row
        
        var arr = mainPageSection[indexPath.section] as! [FeatureContentOutputModel]
        
        self.getvideoDetails(arr[indexPath.row].muvi_uniq_id, arr[indexPath.row].movie_stream_uniq_id)
        
        
    }
    
    func getvideoDetails(_ muvi_uniq_id:String, _ movie_stream_uniq_id:String)
    {
        
        let videoInput = GetVideoDetailsInput.init(authToken: self.appD.authToken, contentUniqId: muvi_uniq_id, streamUniqId: movie_stream_uniq_id, internetSpeed: "2.0", userId: "", streamRestrict: UserDefaults.standard.string(forKey: "isStream")!)
        
        self.objectC.videoDetailsAsynctask(videoInput) { (videoOutput:GetVideoDetailsOutput,subtitleOutput: [SubtitleModel],resolutionOutput: [ResolutionOutput],watermarkOutput: WaterMarkOutPut) in
            
            
            DispatchQueue.main.async(execute: { () -> Void in
              
                var arr = self.mainPageSection[self.selectedIndexPath] as! [FeatureContentOutputModel]
                
                if videoOutput.code == 200
                {
                    let defaults = UserDefaults.standard
                    let date = Date()
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd.MM.yyyy"
                    let result = formatter.string(from: date)
                    
                    var iswatermark = false
                    var ip = ""
                    let id = ""
                    var email = ""
                    
                    var playerInputData:PlayerVCInputData!
                    
                    playerInputData = PlayerVCInputData(playTraier: "", muvi_uniq_id: muvi_uniq_id, movie_stream_uniq_id: movie_stream_uniq_id, season_id: "1", user_id: id, ip_address: ip, content_types_id: "1", authToken: self.appD.authToken, isWaterMarkEnable: iswatermark, email: "test@mvrht.net", currentDate: result, videoUrl: videoOutput.videoUrl!, contentName:arr[self.selectedIndexPath].name!, contentGenre:arr[self.selectedIndexPath].genre!, contentStory: arr[self.selectedIndexPath].story!, contentCensorRating: arr[self.selectedIndexPath].censor_rating!, contentVideoDuration: "null")
                        
                        // self.playerInput.append(playerInputData)
                    
                    
                    let bundleIdentifier = "com.release.MuviSDK"
                    let bundle = Bundle(identifier: bundleIdentifier)
                    
                    var storyboard = UIStoryboard(name: "Main", bundle: bundle)
                    
                    var destination = storyboard.instantiateViewController(withIdentifier: "PlayerViewController") as! PlayerViewController
                    
                    destination.PlayerVCInputDataArray = playerInputData
                    
                    self.present(destination, animated: false, completion: nil)
                    
                    
                }else
                {
                    
                }
                
            })
            
        }
    }
    
    //Banner display hide / show now
    //////////////////////////
    func slideShowDidShowNext(slideShow: KASlideShow!) {
        
    }
    func slideShowWillShowPrevious(slideShow: KASlideShow!) {
        
    }
    func slideShowWillShowNext(slideShow: KASlideShow!) {
        
        
    }
    func slideShowDidShowPrevious(slideShow: KASlideShow!) {
        
        
    }
    
    func slideShow(_ slideShow: KASlideShow!, objectAt index: UInt) -> NSObject! {
        return self.imageData[Int(index)] as NSObject
    }
    func slideShowImagesNumber(_ slideShow: KASlideShow!) -> UInt {
        return UInt(self.imageData.count)
    }
    
    func contentList(index:Int)
    {
        
        if let c = UserDefaults.standard.string(forKey: "LangChoose")
        {
            self.appD.lang = c
            print("Default Language:-\(c)")
        }
        print(self.appD.mySectionId)
        print(self.appD.mySectionId[index])
        
        
        if self.appD.mySectionId.count > 0{
            
            let featureInput = FeatureContentInputModel.init(authToken: self.appD.authToken, sectionId: self.appD.mySectionId[index], Limit: "20", offset: "1", orderby: "", language: (self.appD.lang)!)
            
            objectC.getFeatureContentAsynTask(featureInput) { (featureOutput:[FeatureContentOutputModel]) in
                
                DispatchQueue.main.async(execute: { () -> Void in
                    UIApplication.shared.endIgnoringInteractionEvents()
                   // self.activityIndicator.stopAnimating()
                    
                    if featureOutput.count > 0{
                        if(featureOutput[0].code == 200){
                            
                            self.mainPageSection.append(featureOutput as NSArray)
                            if self.mainPageSection.count > 1{
                              //  self.activityIndicator.stopAnimating()
                              //  self.activityIndicator.removeFromSuperview()
                            }
                            
                            print("self.collectionView?.reloadData()")
                            if index < self.appD.mySectionId.count - 1{
                                
                                print("index is \(index)")
                                var ind = index + 1
                              //  self.activityIndicator.stopAnimating()
                                self.contentList(index: ind)
                                
                                if index == 0 || index == 1{
                                    
                                    self.collectionView?.alpha = 0.3
                                    
                                    
                                    UIView.animate(withDuration: 0.25, delay: 0.0, options: [], animations: {
                                        
                                        self.collectionView?.reloadData()
                                        
                                    }, completion: { (finished: Bool) in
                                        
                                        self.collectionView?.alpha = 1.0
                                        
                                        
                                    })
                                    
                                    
                                }
                            }
                            else
                            {
                                self.collectionView?.alpha = 1.0
                                
                                print("End Now")
                                // for mainArray.count == 0{
                                
                                
                                // }
                                UIView.animate(withDuration: 0.25, delay: 0.0, options: [], animations: {
                                    
                                    self.collectionView?.reloadData()
                                    
                                }, completion: { (finished: Bool) in
                                    
                                    self.collectionView?.alpha = 1.0
                                    //self.collectionView?.reloadData()
                                    
                                })
                                
//                                self.activityIndicator.stopAnimating()
//                                self.activityIndicator.removeFromSuperview()
                                return
                            }
                            
                        }
                        else{
                            self.collectionView?.isHidden = false
                          //  self.activityIndicator.stopAnimating()
                        }
                    }
                    else{
                        self.collectionView?.isHidden = false
                       // self.activityIndicator.stopAnimating()
                    }
                })
            }
        }else{
          //  activityIndicator.stopAnimating()
        }
    }
    
}
