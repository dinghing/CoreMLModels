//
//  ViewController.swift
//  personrecognition
//
//  Created by dinghing on 2017/06/06.
//  Copyright © 2017年 dinghing.sample.com. All rights reserved.
//

import UIKit
import CoreML
import Vision


class ViewController: UIViewController,UIImagePickerControllerDelegate,
UINavigationControllerDelegate{
    
    @IBOutlet weak var recogLabel: UILabel!
    @IBOutlet weak var imagePicked: UIImageView!
    @IBAction func openCamera(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        else{
            print("camera can not be open")
        }
    }
    @IBAction func saveImage(_ sender: Any) {
        //let imageData = UIImageJPEGRepresentation(imagePicked.image!, 0.6)
        let imageData = imagePicked.image?.cgImage
        let model = try! VNCoreMLModel(for: Resnet50().model)
        let request = VNCoreMLRequest(model: model, completionHandler: myResultsMethod)
        let handler = VNImageRequestHandler(cgImage: imageData!)
        try! handler.perform([request])
        
    }
    @IBAction func openLibrary(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePicked.contentMode = .scaleToFill
            imagePicked.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func myResultsMethod(request: VNRequest, error: Error?) {
        guard let results = request.results as? [VNClassificationObservation]
            else { fatalError("huh") }
        recogLabel.text = results[0].identifier
        for classification in results {
            print(classification.identifier, // the scene label
                classification.confidence)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

