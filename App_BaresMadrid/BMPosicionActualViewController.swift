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
    var calloutImagenSeleccionada : UIImage?
    
    
    
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
                self.myAddBTN.isEnabled = false
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
       
        
        
        //FASE 1 -> SINGLETON
        APIManagerData.shared.cargarDatos()
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //DELEGADO DEL MAPA
        myMapView.delegate = self
        myMapView.addAnnotations(APIManagerData.shared.baresMadrid)
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
            present(muestraAlertVC("Localización desactivada",
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
        
        if segue.identifier == "showPinImage"{
            let navVC = segue.destination as! UINavigationController
            let detalleImVC = navVC.topViewController as! BMImagenDetalleViewController
            detalleImVC.calloutIm = calloutImagenSeleccionada
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
        //FASE 2 -> SINGLETON
        APIManagerData.shared.baresMadrid.append(barEtiquetado)
        APIManagerData.shared.salvarDatos()
    }
}

//MARK: - MKMAPVIEWDELEGATE
extension BMPosicionActualViewController : MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        //1
        if annotation is MKUserLocation{
            return nil
        }
        
        //2 - pasa algo parecido a las celdas de las tablas / se reaprovechan
        var annotationView = myMapView.dequeueReusableAnnotationView(withIdentifier: "barPin")
        
        if annotationView == nil{
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "barPin")
        }else{
            annotationView?.annotation = annotation
        }
        
        //3 - Vamos a configurar la anotacion
        if let place = annotation as? BMBaresModel{
            //hacemos referencia a las diferentes piezas de nuestro objeto
            let imageName = place.imagenBares
            //debemos comprobar la imagen
            if let imagenUrl = APIManagerData.shared.imagenUrl(){
                do{
                    let imageData = try Data(contentsOf: imagenUrl.appendingPathComponent(imageName!))
                    self.calloutImagenSeleccionada = UIImage(data: imageData)
                    let myImageFromDDBB = resizeImage(calloutImagenSeleccionada!, newWidth: 40.0)
                    let btnImageView = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
                    btnImageView.setImage(myImageFromDDBB, for: .normal)
                    annotationView?.leftCalloutAccessoryView = btnImageView
                    annotationView?.image = #imageLiteral(resourceName: "img_pin")
                    annotationView?.canShowCallout = true
                }catch let error{
                    print("Error en la configuracionde la imagen: \(error.localizedDescription)")
                }
            }
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.leftCalloutAccessoryView{
            performSegue(withIdentifier: "showPinImage", sender: view)
        }
    }
    
    
    
    
    //MATK: - Util
    func resizeImage(_ imagen : UIImage, newWidth : CGFloat) -> UIImage{
        let scale = newWidth / imagen.size.width
        let newHeigth = imagen.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeigth))
        imagen.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeigth))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    
    
    
}



















