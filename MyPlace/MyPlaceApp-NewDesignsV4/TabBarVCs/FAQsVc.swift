//
//  FAQsVc.swift
//  BurbankApp
//
//  Created by naresh banavath on 16/12/21.
//  Copyright © 2021 DMSS. All rights reserved.
//

import UIKit

class FAQsVc: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var selectedIndexPath : IndexPath?
    var tableDataSource = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let rowData = ["I have received a stage invoice, what do I do?" , "What is a Protection Works Notice?" , "What is a Soil report?", "What is a Feature Survey?", "What is a Building Regulation?" , "What is a Build over Easement?" , "What is a Re-Establishment Survey?" , "What is a Building Contract? When will I receiv..."]
//        tableDataSource = [Section(title: "Building Process", rowsData: rowData),
//                           Section(title: "Documentation", rowsData: rowData),
//                           Section(title: "Permits", rowsData: rowData),
//                           Section(title: "Builder Terminology (Glossary)", rowsData: rowData),
//                           Section(title: "Building Costs", rowsData: rowData),
//                           Section(title: "Design / Edge Studio", rowsData: rowData)
      //  ]
        
        tableView.tableFooterView = UIView()
        //To Stop Floating headerView
        let dummyViewHeight = CGFloat(50)
        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: dummyViewHeight))
        self.tableView.contentInset = UIEdgeInsets(top: -dummyViewHeight, left: 0, bottom: 0, right: 0)
        if #available(iOS 15.0, *) {
          tableView.sectionHeaderTopPadding = 0.0
        }
        getFaqs()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBarButtons()
        // setupNavigationBar()
    }
    
    
    //MARK: - Service Call
    func getFaqs()
    {
        NetworkRequest.makeRequest(type: FAQStruct.self, urlRequest: Router.faqsQuestionAndAnswers) { [weak self] result in
            switch result
            {
            case .success(let faqs):
               // print(faqs)
                
                var listOfFaqs =  [LstFAQ]()
               
                var currenUserJobDetails : MyPlaceDetails?
                currenUserJobDetails = (UIApplication.shared.delegate as! AppDelegate).currentUser?.userDetailsArray![0].myPlaceDetailsArray[0]

                let region = getRegionName(currenUserJobDetails?.region ?? "")
                for i in 0..<faqs.lstFAQ.count{
                    if faqs.lstFAQ[i].state.contains(region){
                        
                        listOfFaqs.append(faqs.lstFAQ[i])
                    }
                        
                }
                for i in 0..<listOfFaqs.count
                {
                    listOfFaqs[i].answer = listOfFaqs[i].answer.htmlToString
                }
                let groupedValues = Dictionary.init(grouping: listOfFaqs, by: {$0.category})
                
                for key in groupedValues.keys
                {
                    let section = Section(title: key, rowsData: groupedValues[key]!)
                    self?.tableDataSource.append(section)
                    self?.tableDataSource = (self?.tableDataSource.sorted(by: {$0.title < $1.title}))!
                }
                DispatchQueue.main.async {
                    
                    self?.tableView.reloadData()
                }
                
            case .failure(let err):
                print("error :- \(err.localizedDescription)")
            }
        }
    }
}


//MARK: - TableViewDelegate & Datasource
extension FAQsVc : UITableViewDelegate , UITableViewDataSource
{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableDataSource.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableDataSource[section].isOpened
        {
            return tableDataSource[section].rowsData.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: FAQsVCCell.identifier) as! FAQsVCCell
        cell.questionLb.text = tableDataSource[indexPath.section].rowsData[indexPath.row].question
        cell.answerLb.text = tableDataSource[indexPath.section].rowsData[indexPath.row].answer
        let videoURL = tableDataSource[indexPath.section].rowsData[indexPath.row].videoURL
        //cell.videoStackView.isHidden = true
        if selectedIndexPath == indexPath
        {
            
            cell.videoStackView.isHidden = false
            cell.videoContainerView.isHidden = videoURL.count == 0 ? true : false
            cell.dotView.backgroundColor = AppColors.appOrange
            cell.questionLb.textColor = AppColors.appOrange
            cell.addVideo(url: videoURL)
           // cell.addVideo(url: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")
            
        }
        else {
            cell.videoStackView.isHidden = true
            cell.dotView.backgroundColor = UIColor.black
            cell.questionLb.textColor = UIColor.black
        }
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // guard tableDataSource[indexPath.section].rowsData[indexPath.row].videoURL.count != 0 else {return}
        //    let cell = tableView.cellForRow(at: indexPath) as! FAQsVCCell
        //   // cell.videoStackView.isHidden.toggle()
        var previosIndxPth : IndexPath?
        if selectedIndexPath != nil{
            
            //tapped on another cell so we are making current cell as selected cell
            if selectedIndexPath != indexPath
            {
                previosIndxPth = selectedIndexPath
                selectedIndexPath = indexPath
            }else {
                selectedIndexPath = nil
            }
        }
        else {
            selectedIndexPath = indexPath
        }
        //    tableView.beginUpdates()
        //    tableView.endUpdates()
        tableView.reloadRows(at: [previosIndxPth,indexPath].compactMap({$0}), with: .none)
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //    if indexPath == selectedIndexPath
        //    {
        //      return UITableView.automaticDimension
        //    }
        //    else {
        //      return UITableView.automaticDimension
        //    }
        return UITableView.automaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        //Label
      //  view.backgroundColor = UIColor.lightGray
        let label = UILabel()
        label.text = tableDataSource[section].title
        label.font = UIFont.systemFont(ofSize: 17.0 , weight: .medium)
        label.textColor = tableDataSource[section].isOpened ? AppColors.appOrange : UIColor.black
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor , constant: 4).isActive = true
        //*Label
        
        //imgView
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon_rightArrow")
        imageView.tintColor = AppColors.appOrange
        if tableDataSource[section].isOpened
        {
            imageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
            
        }
        else {
            imageView.transform = CGAffineTransform.identity
        }
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        
        //*imgView
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(sectionTapped))
        view.tag = section
        view.addGestureRecognizer(tapGesture)
        
        //SeperatorView
        let seperatorView = UIView()
        seperatorView.backgroundColor = .lightGray
        view.addSubview(seperatorView)
        seperatorView.translatesAutoresizingMaskIntoConstraints = false
        seperatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        seperatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        seperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        seperatorView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        return view
    }
    @objc func sectionTapped(_ sender : UITapGestureRecognizer)
    {
        guard let view = sender.view else {return}
        let secNo = view.tag
        //  (0..<tableDataSource.count).forEach({tableDataSource[$0].isOpened = false})
        tableDataSource[secNo].isOpened.toggle()
        
        for subV in view.subviews
        {
            if let lb = subV as? UILabel
            {
                lb.textColor = tableDataSource[secNo].isOpened == true ? AppColors.appOrange : UIColor.black
            }
            if let imgV = subV as? UIImageView
            {
                imgV.transform = tableDataSource[secNo].isOpened == true ? CGAffineTransform(rotationAngle: .pi/2) : CGAffineTransform.identity
            }
        }
        
        tableView.reloadSections([secNo], with: .automatic)
    }
}

struct Section {
    var title : String
    var rowsData : [LstFAQ]
    var isOpened : Bool = false
}


// MARK: - FAQStruct

struct FAQStruct: Codable {
    let lstFAQ: [LstFAQ]
    
    enum CodingKeys: String, CodingKey {
        case lstFAQ = "lstFaq"
    }
}

// MARK: - LstFAQ
struct LstFAQ: Codable {
    var state, category, question, answer: String
    let videoURL: String
    
    enum CodingKeys: String, CodingKey {
        case state = "State"
        case category = "Category"
        case question = "Question"
        case answer = "Answer"
        case videoURL = "VideoUrl"
    }
    
    
}
extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String { html2AttributedString?.string ?? "" }
}
