//
//  DocumentPreviewer.swift
//  BurbankApp
//
//  Created by Naresh Banavath on 05/04/23.
//  Copyright © 2023 Sreekanth tadi. All rights reserved.
//

import UIKit
import QuickLook

class DocumentPreviewer : NSObject
{
    //MARK: - Properties
    var fileName : String = ""
    var url : String = ""
    weak var parentViewController : DocumentsVC?
    
    private var preViewItem : PreviewItem!
    private var destinationURL : URL!
   
    //MARK: - Initialization
    init(fileName : String , url : String)
    {
        super.init()
        self.fileName = fileName
        self.url = url
        
    }
    
    func loadDocument()
    {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        self.destinationURL = documentDirectory.appendingPathComponent(fileName)
       // Check Weather File Present or not
        if FileManager.default.fileExists(atPath: destinationURL.path)
        {
            loadPreviewController()
        }else { // Hit the service when file is not available
            appDelegate.showActivity()
            guard let url = URL(string: url) else {debugPrint("url is empty");return}
            let downloadTask = URLSession.shared.dataTask(with: url) { data, response, error in
                DispatchQueue.main.async { appDelegate.hideActivity() }
                guard  let data = data, (response as? HTTPURLResponse)?.statusCode == 200, error == nil else {
                    DispatchQueue.main.async {
                        AlertManager.sharedInstance.showAlert(alertMessage: error?.localizedDescription ?? somethingWentWrong)
                    }; return
                }
                
                //Data present
                DispatchQueue.main.async {
                    self.saveDataToFileManager(fileURl: data)
                }
            }
            
            downloadTask.resume()
        }
        
    }
    
    private func saveDataToFileManager(fileURl : Data)
    {
        do {
            try fileURl.write(to: destinationURL)
//            if ((fileName.components(separatedBy: ".").last?.contains("eml")) != nil)
//            {
//                let url = URL(fileURLWithPath: destinationURL.path)
//                UIApplication.shared.open(url)
//            }else {
                loadPreviewController()
           // }
            
        } catch let err
        {
            debugPrint(err.localizedDescription)
        }
        
    }
    
    private func loadPreviewController()
    {
        let url1 = URL(fileURLWithPath: destinationURL.path.replacingOccurrences(of: "file://", with: ""))
        self.preViewItem = PreviewItem(previewItemURL: url1, previewItemTitle: fileName)
        let qlPreviewController = QLPreviewController()
        qlPreviewController.dataSource = self
        qlPreviewController.delegate = self
//        qlPreviewController.modalPresentationStyle = .overCurrentContext
        if let vc = self.parentViewController
        {


    
            vc.present(qlPreviewController, animated: true)
        
        }
        
    }
    
}
//MARK: - QLPreviewDataSource
extension DocumentPreviewer : QLPreviewControllerDataSource, QLPreviewControllerDelegate
{
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return preViewItem
    }
    
    func previewControllerWillDismiss(_ controller: QLPreviewController) {
        debugPrint(#function)
    }

}

fileprivate class PreviewItem : NSObject, QLPreviewItem
{
    var previewItemURL: URL?
    var previewItemTitle: String?
    
    init(previewItemURL: URL? = nil, previewItemTitle: String? = nil) {
        self.previewItemURL = previewItemURL
        self.previewItemTitle = previewItemTitle
    }
}
