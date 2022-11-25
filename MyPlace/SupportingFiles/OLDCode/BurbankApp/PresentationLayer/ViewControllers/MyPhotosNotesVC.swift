//
//  MyPhotosNotesVC.swift
//  BurbankApp
//
//  Created by Mohan Kumar on 09/05/17.
//  Copyright © 2017 DMSS. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class MyPhotosNotesVC: UIViewController {

    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnAdd: UIButton!
    
    var addedNoteAction: (() -> Void)?

    
    @IBOutlet weak var noteTextView: UITextView!
    var photoInfo: MyPlaceDocuments!
    var imageId = "" //we are filling imageID according to region Select
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewSetUp()
        
       // let imageID = selectedJobNumberRegion == .VLC ? imageIdForVLC : photoInfo.urlId
        let noteDescription = MyPlacePhotoNote.fetchPhotoNote("\(imageId)")?.noteDescription
        noteTextView.text = noteDescription
        IQKeyboardManager.shared.enable = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enable = true
    }
    
    
    func viewSetUp () {
        
        setAppearanceFor(view: titleLabel, backgroundColor: COLOR_CLEAR, textColor: COLOR_BLACK, textFont: FONT_LABEL_HEADING(size: FONT_18))

        setAppearanceFor(view: noteTextView, backgroundColor: COLOR_WHITE, textColor: COLOR_BLACK, textFont: FONT_BUTTON_BODY(size: FONT_13))

        setAppearanceFor(view: btnCancel, backgroundColor: COLOR_BLACK, textColor: COLOR_WHITE, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_15))
        setAppearanceFor(view: btnAdd, backgroundColor: COLOR_WHITE, textColor: COLOR_ORANGE, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_15))

    }
    
    
    /**
     Back button action
     
     - parameter sender: button object
     */
    // MARK: Button action
    @IBAction func backTapped(_ sender: AnyObject) {
       // _  = self.navigationController?.popViewController(animated: true)
        dismissVC()
    }
    @IBAction func saveButtonTapped(_ sender: AnyObject)
    {
        let note = noteTextView.text ?? ""
        //let imageID = selectedJobNumberRegion == .VLC ?  imageIdForVLC : photoInfo.urlId
        MyPlacePhotoNote.addNotetoPhotoForQLDSA("\(imageId)",note)
        dismissVC()
    }
    
    @IBAction func handleCancelButton (_ sender: UIButton) {
        
        dismissVC()
    }
    
    fileprivate func dismissVC()
    {
        if let action = addedNoteAction {
            action()
        }
        
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
