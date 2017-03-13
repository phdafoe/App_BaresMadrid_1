//
//  BmDetalleBarViewController.swift
//  App_BaresMadrid
//
//  Created by formador on 13/3/17.
//  Copyright © 2017 formador. All rights reserved.
//

import UIKit

//TODO: - Fase 1 delegado
protocol BmDetalleBarViewControllerDelegate{
    func bmBaresEtiquetados(_ detalleVC : BmDetalleBarViewController, barEtiquetado : BMBaresModel)
}



class BmDetalleBarViewController: UIViewController {
    
    //MARK: - Variables locales
    var detalleBarMadrid : BMBaresModel?
    
    //TODO: - Fase 2 delegado
    var bmDelegate : BmDetalleBarViewControllerDelegate?
    
    
    //MARK: - IBOutlets
    @IBOutlet weak var myImageViewPicker: UIImageView!
    @IBOutlet weak var myLatitudLBL: UILabel!
    @IBOutlet weak var myLongitudLBL: UILabel!
    @IBOutlet weak var myDireccionLBL: UILabel!
    @IBOutlet weak var mySalvarDatosBTN: UIBarButtonItem!
    
    
    //MARK: - IBActions
    @IBAction func cerraVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func salvarFotografiaBar(_ sender: Any) {
        
        
    }
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: - PickerView
        myImageViewPicker.isUserInteractionEnabled = true
        let tomaFotoGR = UITapGestureRecognizer(target: self, action: #selector(self.pickerPhoto))
        myImageViewPicker.addGestureRecognizer(tomaFotoGR)
        
        //TODO: - Configuracion labels
        configuraLabels()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Utils
    func configuraLabels(){
        myLatitudLBL.text = String(format: "%.8f", (detalleBarMadrid?.coordinate.latitude)!)
        myLongitudLBL.text = String(format: "%.8f", (detalleBarMadrid?.coordinate.longitude)!)
        myDireccionLBL.text = detalleBarMadrid?.direccionBares
    }
    


}//TODO: - fin de la clase

extension BmDetalleBarViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func pickerPhoto(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            muestraMenu()
        }else{
            muestraLibreriaFotos()
        }
    }
    
    func muestraMenu(){
        let alertVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        let tomaFotoAction = UIAlertAction(title: "Toma Foto", style: .default) { _ in
            self.muestraCamara()
        }
        let seleccionaLibreriaAction = UIAlertAction(title: "Selecciona de la Librería", style: .default) { _ in
            self.muestraLibreriaFotos()
        }
        alertVC.addAction(cancelAction)
        alertVC.addAction(tomaFotoAction)
        alertVC.addAction(seleccionaLibreriaAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    func muestraCamara(){
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    func muestraLibreriaFotos(){
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let imageData = info[UIImagePickerControllerOriginalImage] as? UIImage{
            myImageViewPicker.image = imageData
            mySalvarDatosBTN.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}




