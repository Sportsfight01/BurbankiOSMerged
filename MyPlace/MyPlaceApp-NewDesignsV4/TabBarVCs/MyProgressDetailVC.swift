//
//  MyProgressDetailVC.swift
//  BurbankApp
//
//  Created by naresh banavath on 26/11/21.
//  Copyright © 2021 DMSS. All rights reserved.
//

import UIKit
import AVKit

class MyProgressDetailVC: UIViewController {
    
    //MARK: - Properties
//    enum stageNames: String
//    {
//        case adminStage
//        case frameStage
//        case lockUpStage
//        case fixingStage
//        case finishStage
//        case none
//    }
    
    @IBOutlet weak var progressImgView: UIImageView!
    @IBOutlet weak var commentsLb: UILabel!
    @IBOutlet weak var noOfTaskCompletedLb: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    {
        didSet{
            progressBar.transform = CGAffineTransform(scaleX: 1.0, y: 2.0)
        }
    }
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var videoContainerView: UIView!
    @IBOutlet weak var stageTitleLb: UILabel!
    @IBOutlet weak var progressLb: UILabel!
    var progressData : CLItem?
    var progressColor : UIColor?
    var progressImgName : String?
    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
    var imgView : UIImageView!
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.separatorColor = .clear
        addVideo()
        setupDataForProgress()
        if let imgname = progressImgName
        {
            progressImgView.image = UIImage(named: imgname)
        }

        setupdescriptionText()
//        print(progressData?.progressDetails?.map({$0.datedescription}))
       // print(progressData?.progressDetails)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "BURBANK MYPLACE"
        setupNavigationBarButtons(notificationIcon: false)
       
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let contentheight = tableView.contentSize.height
        self.tableHeightConstraint.constant = contentheight
    }
    //MARK: - Helper Methods

    func setupDataForProgress()
    {
        // let progress = Float(progressData?.progress ?? 0.0)
        //progressBar.progress = progress
        stageTitleLb.text = progressData?.title
        let totalTaks = progressData?.progressDetails?.count
        let completedTaks = progressData?.progressDetails?.filter({$0.status == "Completed"}).count
        noOfTaskCompletedLb.text = "\(completedTaks ?? 0) of \(totalTaks ?? 0) Tasks Complete"
        let progressBarData = Double(Double(completedTaks ?? 0) / Double(totalTaks ?? 0))
        print(progressBarData)
        let isProgrssData = progressBarData.isNaN
        if isProgrssData{
//            let progressInt = Int(progressBarData * 100)
            progressBar.progress = 0
            progressLb.text = "0%"
        }else{
            let progressInt = Int(progressBarData * 100)
            progressBar.progress = Float(progressBarData)
            progressLb.text = "\(progressInt)%"
        }
//        let progressInt = Int(progressBarData * 100)
//        progressBar.progress = Float(progressBarData)
//        progressLb.text = "\(progressInt)%"
        progressBar.progressTintColor = progressColor
        
        tableView.reloadData()
        
    }

    func addVideo()
    {
        //http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4
        
//        let playerView = VideoPlayerView(videoURL: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4" , frame: videoContainerView.bounds)
//        self.videoContainerView.addSubview(playerView)
//        playerView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            playerView.leadingAnchor.constraint(equalTo: videoContainerView.leadingAnchor),
//            playerView.trailingAnchor.constraint(equalTo: videoContainerView.trailingAnchor),
//            playerView.topAnchor.constraint(equalTo: videoContainerView.topAnchor),
//            playerView.bottomAnchor.constraint(equalTo: videoContainerView.bottomAnchor)
//        ])
//
        //ImageView
//         imgView = UIImageView(image: UIImage(named: "1"))
//        imgView.contentMode = .scaleToFill
//        self.videoContainerView.addSubview(imgView)
//        imgView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            imgView.leadingAnchor.constraint(equalTo: videoContainerView.leadingAnchor),
//            imgView.trailingAnchor.constraint(equalTo: videoContainerView.trailingAnchor),
//            imgView.topAnchor.constraint(equalTo: videoContainerView.topAnchor),
//            imgView.bottomAnchor.constraint(equalTo: videoContainerView.bottomAnchor)
//        ])
        
    }
    
    func setupdescriptionText()
    {
        switch progressData?.title.lowercased()
        {
        case "admin stage":
            commentsLb.text = "This is the stage where lots of things happen behind the scenes and where we have to work together to get it all done. Soil reports, Council approvals and everything in between. This may take time, but we’ll have it all ready and finalised ready to build your perfect home."
            imgView = UIImageView(image: UIImage(named: "Admin-Stage-Image"))
        case "base stage" :
            commentsLb.text = "Base Stage is where we measure out your design on site, turn the sod, pour the footings, under slab drainage and special mesh for termite protection. You’ll also start to see activity on site and the beginning of the exciting times. Once the building foundation is complete, it is inspected by a building surveyor and we’re ready to start framing your home."
            imgView = UIImageView(image: UIImage(named: "Base-Stage-Image"))
            
        case "frame stage":
            commentsLb.text = "The timber is delivered to site and, following your chosen floorplan, we start to construct the walls along with roof trusses, windows and door frames including the installation of your internal and external support structure. Conduits for electrical and plumbing, will also be installed. A building inspector will inspect this once it’s all up."
            imgView = UIImageView(image: UIImage(named: "Frame-Stage-Image"))
        case "lockup stage":
            commentsLb.text = "Bricks will be delivered and laid, and the windows, doors and walls will be installed. Plumbers, electricians, carpenters and other trades can begin fitting out your dream home ready to start the fixing stage where your internal selections that you chose will start to come to life. There will literally be a roof over your head."
            imgView = UIImageView(image: UIImage(named: "Lockup-Stage-Image"))
        case "fixing stage":
            commentsLb.text = "This is where all the activity begins to happen behind closed doors. Fixtures and fittings start to come together to form the inside of the home. Features such as cornices, tiling, cabinets and shelving that make your house a home. It’s like the dressing up part."
            imgView = UIImageView(image: UIImage(named: "Fixing-Stage-Image"))
        case "finishing stage":
            commentsLb.text = "The finishing touches are being made. All the painting, tiling, installations and detailing will be completed with your choices made at selections and your home is pretty much almost ready to move in."
            imgView = UIImageView(image: UIImage(named: "Finishing-Stage-Image"))

        default:
            imgView = UIImageView(image: UIImage(named: "Overall-Stage-Image"))

            print("default")
    
        }
        
        imgView.contentMode = .scaleToFill
        self.videoContainerView.addSubview(imgView)
        imgView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imgView.leadingAnchor.constraint(equalTo: videoContainerView.leadingAnchor),
            imgView.trailingAnchor.constraint(equalTo: videoContainerView.trailingAnchor),
            imgView.topAnchor.constraint(equalTo: videoContainerView.topAnchor),
            imgView.bottomAnchor.constraint(equalTo: videoContainerView.bottomAnchor)
        ])

    }
    
    
}

//MARK: - Tableview Delegate & Datasource

extension MyProgressDetailVC : UITableViewDelegate , UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return progressData?.progressDetails?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyProgressDetailsCell") as! MyProgressDetailsCell
        cell.progressNameLb.text = progressData?.progressDetails?[indexPath.row].name
        let date = dateFormatter(dateStr: progressData?.progressDetails?[indexPath.row].dateactual ?? "", currentFormate: "yyyy-MM-dd'T'HH:mm:ss", requiredFormate: "dd/MM/yyyy")
        cell.dateLb.text = date
        cell.checkMarkImage.tintColor = progressColor
        cell.checkMarkImage.image = progressData?.progressDetails?[indexPath.row].status == "Completed" ? UIImage(named: "icon_Check")?.withRenderingMode(.alwaysTemplate) : UIImage(named: "icon_UnCheck")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
//    func formateDateToNumbers(str : String)
//    {
//
//    }
    
    
}
