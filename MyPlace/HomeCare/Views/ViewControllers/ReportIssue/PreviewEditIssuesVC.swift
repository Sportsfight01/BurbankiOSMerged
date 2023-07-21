//
//  PreviewEditIssuesVC.swift
//  BurbankApp
//
//  Created by Naveen Kourampalli on 07/06/23.
//  Copyright © 2023 Sreekanth tadi. All rights reserved.
//

import UIKit

class PreviewEditIssuesVC: UIViewController {

    @IBOutlet weak var imagesView: ImagePickerCollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUPUi()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigationBarButtons()
    }
    
    func setUPUi(){
        let imagesArr = [UIImage(named: "documents")!,UIImage(named: "menrepair")!]
        imagesView.isDeleteEnabled = true
        imagesView.collectionDataSource  = imagesArr
        
    }
    
    @IBAction func didTappedOnEditIssueDatils(_ sender: UIButton) {
        let imagesArr = [UIImage(named: "documents")!,UIImage(named: "menrepair")!]
        let vc = LogIssueVC.instace(sb: .reports)
        vc.isEditIssueScreen = true
//        vc.imagesPickerColectionView.collectionDataSource = imagesArr
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func didTappedOnViewAllIssues(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
