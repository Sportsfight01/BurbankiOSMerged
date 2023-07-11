//
//  HomeCareDashBoardScreenVC.swift
//  BurbankApp
//
//  Created by Naveen Kourampalli on 27/04/23.
//  Copyright © 2023 Sreekanth tadi. All rights reserved.
//

import UIKit

class HomeCareDashBoardVC: HomeCareBaseProfileVC,UITabBarDelegate {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var tabBar: UITabBar!
    
    
    @IBOutlet weak var homeCareDescriptionLBL: UILabel!
    @IBOutlet weak var homeCareTitleLBL: UILabel!
    @IBOutlet weak var homeCaredetailsBTN: UIButton!
    var currentIndex : Int = 0
    
   
    var dashBoardDataArr : [HomeCareDashBoard] = []
//    var menu : SideMenuNavigationController!
    var imagesArr = ["welcome","welcome","welcome","welcome","welcome","welcome"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.delegate = self
        collectionView.collectionViewLayout = createLayout()
        collectionView.delegate = self
        collectionView.dataSource = self
        setupDataArr()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpProfileView()
    }

    func setupDataArr(){
        self.dashBoardDataArr.removeAll()
        self.dashBoardDataArr = [HomeCareDashBoard(title: "WelCome", description: "Introduction on how to use the app. Lorem ipsum dolor sit amet, consectetuer adipiscing elitsed", image: "welcome")        ]
        self.collectionView.reloadData()
    }

    @IBAction func didTappedOnDetailsBTN(_ sender: UIButton) {
        let vc =  HomeScreenTabBarVC.instace(sb: .homeScreenSb)
        if sender.tag != 0{
            vc.selectedTab = sender.tag - 1
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func setUpProfileView(){
        profileBaseView.navigationView.backgroundColor = AppColors.AppGray
        profileBaseView.descriptionLBL.textColor = .black
        profileBaseView.profileView.image = UIImage(named: "BurbankLogo_Black")
        profileBaseView.baseImageView.image = UIImage(named: "")
        profileBaseView.baseImageView.backgroundColor = .clear
        profileBaseView.titleLBL.textColor = .black
        profileBaseView.titleLBL.text = "MyHomeCare"
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        tabBar.tintColor = .gray
        setAppearanceFor(view: profileBaseView.titleLBL, backgroundColor: .clear, textColor: APPCOLORS_3.Black_BG, textFont: FONT_BUTTON_LIGHT (size: FONT_20))
        setAppearanceFor(view: profileBaseView.descriptionLBL, backgroundColor: .clear, textColor: APPCOLORS_3.Black_BG, textFont: FONT_BUTTON_BODY (size: FONT_10))
        setStatusBarColor(color: AppColors.AppGray)
        setAttributetitleFor(view: profileBaseView.descriptionLBL, title: "Congratualtions on the completion of your new Burbank home. (\(CurrentUser.jobNumber ?? ""))", rangeStrings: ["Congratualtions on the completion of your new Burbank home. ", "(\(CurrentUser.jobNumber ?? ""))"], colors: [APPCOLORS_3.Black_BG, APPCOLORS_3.Orange_BG], fonts: [FONT_LABEL_BODY (size: FONT_10), FONT_LABEL_SEMI_BOLD (size: FONT_11)], alignmentCenter: false)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension HomeCareDashBoardVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dashBoardDataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "DashBoardImageCVC", for: indexPath) as! DashBoardImageCVC
            cell.imageView.contentMode = .scaleAspectFill
        cell.imageView.image = UIImage(named: dashBoardDataArr[indexPath.item].image)
        cell.detailViewTitleLBL.text = dashBoardDataArr[indexPath.item].title
        cell.detailViewDescriptionLBL.text = dashBoardDataArr[indexPath.item].description
        cell.detailViewBTN.tag = indexPath.item
        cell.detailViewBTN.addTarget(self, action: #selector(didTappedOnDetailsBTN), for: .touchUpInside)
        setAttributetitleFor(view: cell.detailViewDescriptionLBL, title: "Congratulations, your home is now complete. These tools will assist you with your home care needs including manuals, warranties and FAQs.", rangeStrings: ["Congratulations, your home is now complete. These tools will assist you with your home care needs including manuals, warranties and FAQs."], colors: [APPCOLORS_3.Black_BG], fonts: [FONT_LABEL_BODY (size: FONT_9)], alignmentCenter: false)
        
        return cell
    }
    
   
    //createLayout
    func createLayout() -> UICollectionViewCompositionalLayout
    {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.visibleItemsInvalidationHandler = { visibleItems, offset, environment in
            self.currentIndex = (visibleItems.last?.indexPath.item)!
            
        }
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}



extension HomeCareDashBoardVC: didTappedOncomplete {
    
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        let vc = HomeScreenTabBarVC.instace(sb: .homeScreenSb)
        vc.selectedTab = item.tag
        self.navigationController?.pushViewController(vc, animated: true)
        
        
        if item.tag == 3{
            let storyboard : UIStoryboard = UIStoryboard(name: "Report", bundle: nil)
            let popupVC = storyboard.instantiateViewController(withIdentifier: "CompleteAndLodgePopUPVC") as! CompleteAndLodgePopUPVC
            popupVC.modalPresentationStyle = .overCurrentContext
            popupVC.modalTransitionStyle = .crossDissolve
            popupVC.delegate = self
            popupVC.isPopUpFromHomeScreen = true
            present(popupVC, animated: true, completion: nil)
        }
          
    }
    
    
    func didTappedOnCompleteAndLodgeBTN() {
        print(log: "close")
    }
}


struct HomeCareDashBoard {
    var title : String
    var description : String
    var image : String
    
}


class PageControlStackView : UIStackView
{
    var numberOfPages : Int = 0
    {
        didSet {  setupViews() }
    }
    var currentPage : Int = 0
    {
        didSet { changeColorForSelectedView() }
    }
    var views : [UIView] = []
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    func setupViews()
    {
        self.views.removeAll()
        
        for i in 0..<numberOfPages
        {
            let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: Double(self.frame.width) / Double(numberOfPages), height: self.frame.height)))
            view.layer.cornerRadius = view.frame.height / 2
            view.layer.borderWidth = 1.0
            view.layer.borderColor = UIColor.white.cgColor
            view.tag = i
            self.views.append(view)
        }
        self.views.forEach({self.addArrangedSubview($0)})
        
    
        self.axis = .horizontal
        self.distribution = .fillEqually
        self.alignment = .fill
        self.spacing = 8
        changeColorForSelectedView()
    }
    
    func changeColorForSelectedView()
    {
        guard currentPage < self.views.count else {return}
        let selectedView = self.views[currentPage]
        selectedView.backgroundColor = UIColor.white
        UIView.animate(withDuration: 0.5) {
            for i in 0..<self.views.count
            {
                if i == self.currentPage {continue}
                else {
                    self.views[i].backgroundColor = .clear
                }
            }
        }
        
    }
}
