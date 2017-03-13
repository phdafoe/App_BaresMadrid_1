//
//  BMPosicionActualViewController.swift
//  App_BaresMadrid
//
//  Created by formador on 22/2/17.
//  Copyright © 2017 formador. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class BMPosicionActualViewController: UIViewController {
    
    //MARK: - Variables locales
    var baresMadrid : BMBaresModel?
    let locationManager = CLLocationManager()
    var actualizandoLocalizacion = false{
        didSet{
            if actualizandoLocalizacion{
                self.buscarmapa.setImage(#imageLiteral(resourceName: "btn_localizar_off"), for: .normal)
                self.myActivityInd.isHidden = false
                self.myActivityInd.startAnimating()
                self.buscarmapa.isUserInteractionEnabled = false
            }else{
                self.buscarmapa.setImage(#imageLiteral(resourceName: "btn_localizar_on"), for: .normal)
                self.myActivityInd.isHidden = true
                self.myActivityInd.stopAnimating()
                self.buscarmapa.isUserInteractionEnabled = true
            }
        }
    }
    
    
    //MARK: - IBOutlet
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var buscarmapa: UIButton!
    @IBOutlet weak var myMapView: MKMapView!
    @IBOutlet weak var myActivityInd: UIActivityIndicatorView!
    @IBOutlet weak var myAddBTN: UIBarButtonItem!
    
    //MARK: - IBActions
    @IBAction func obtenerLocalizacionACTION(_ sender: Any) {
        iniciaLocationManager()
    }
    
    

    //MARK: - LIFE VC
    override func viewDidLoad() {
        super.viewDidLoad()
        
        actualizandoLocalizacion = false
        
        //TODO: - Titulo de la Barra de navegacion
        let imageNavBarTitle = #imageLiteral(resourceName: "img_navbar_title")
        self.navigationItem.titleView = UIImageView(image: imageNavBarTitle)
        
        //TODO: - Gestion de statusBar
        UIApplication.shared.statusBarStyle = .lightContent
        
        //TODO: - Gestion del menu superior Izq.
        if revealViewController() != nil{
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rightViewRevealWidth = 150
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Utils
    func iniciaLocationManager(){
        let estadoAutorizado = CLLocationManager.authorizationStatus()
        switch estadoAutorizado {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            present(muestraAlertVC("Localización desacativada",
                                   messageData: "Porfavor, activa la localización para esta aplicacion en los ajustes del dispositivo",
                                   titleActionData: "OK"),
                    animated: true,
                    completion: nil)
            self.myAddBTN.isEnabled = false
        default:
            if CLLocationManager.locationServicesEnabled(){
                self.actualizandoLocalizacion = true
                self.myAddBTN.isEnabled = false
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager.requestLocation()
                
                let region = MKCoordinateRegionMakeWithDistance(myMapView.userLocation.coordinate, 1000, 1000)
                myMapView.setRegion(myMapView.regionThatFits(region), animated: true)
            }
        }
    }
    
    //MARK: - SEGUES
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tagBaresMadrid"{
            let navController = segue.destination as! UINavigationController
            let detalleVC = navController.topViewController as! BmDetalleBarViewController
            detalleVC.detalleBarMadrid = baresMadrid
            detalleVC.bmDelegate = self
        }
    }
    
    
    
    
    
    
    
    
    
}//TODO: - Fin de la clase

extension BMPosicionActualViewController : CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("*** Error en Core Location ***")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let userLocation = locations.last else {return}
        
        //if let userLocation = locations.last{
            let latitud = userLocation.coordinate.latitude
            let longitud = userLocation.coordinate.longitude
            
            //TODO: - CLGeocoder -> Api de los mapas de Apple
            CLGeocoder().reverseGeocodeLocation(userLocation, completionHandler: { (placemarks, error) in
                
                if error == nil{
                    var direccion = ""
                    if let placemarksData = placemarks?.last{
                        direccion = self.stringFromPlacemarks(placemarksData)
                    }
                    self.baresMadrid = BMBaresModel(pDireccionBares: direccion,
                                                    pLatitudBares: latitud,
                                                    pLongitudBares: longitud,
                                                    pImagenBares: "")
                }
                self.actualizandoLocalizacion = false
                self.myAddBTN.isEnabled = true
            })
        //}
    }
    
    func stringFromPlacemarks(_ placemarkData : CLPlacemark) -> String{
        
        var lineaUno = ""
        if let stringUno = placemarkData.thoroughfare{
            lineaUno += stringUno + ", "
        }
        if let stringUno = placemarkData.subThoroughfare{
            lineaUno += stringUno
        }
        
        var lineaDos = ""
        if let stringDos = placemarkData.postalCode{
            lineaDos += stringDos + " "
        }
        if let stringDos = placemarkData.locality{
            lineaDos += stringDos
        }
        
        var lineaTres = ""
        if let stringTres = placemarkData.administrativeArea{
            lineaTres += stringTres + " "
        }
        if let stringTres = placemarkData.country{
            lineaTres += stringTres
        }
        
        return lineaUno + "\n" + lineaDos + "\n" + lineaTres
    }
    
}

//MARK: - Detalle DELEGATE
extension BMPosicionActualViewController : BmDetalleBarViewControllerDelegate{
    
    func bmBaresEtiquetados(_ detalleVC: BmDetalleBarViewController, barEtiquetado: BMBaresModel) {
        //Code
    }
}



















