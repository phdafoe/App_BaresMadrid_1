//
//  BMOmdbTableViewController.swift
//  App_BaresMadrid
//
//  Created by formador on 8/3/17.
//  Copyright © 2017 formador. All rights reserved.
//

import UIKit
import PromiseKit
import Kingfisher
import PKHUD

class BMOmdbTableViewController: UITableViewController {
    
    //MARK: - Variables locales
    var idPoster = ""
    var idObjeto = "Superman"
    var arrayDatosOmdb : [BMImdbModel] = []
    var customRefresh = UIRefreshControl()
    
    //MARK: - IBOutlets
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var extraMenuButton: UIBarButtonItem!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        customRefresh.attributedTitle = NSAttributedString(string: "Arrastra para recargar")
        customRefresh.addTarget(self, action: #selector(self.muestraRecarga), for: .valueChanged)
        tableView.addSubview(customRefresh)
        

        idPoster = String(randomNumero())
        llamadaOmdb()
        
        //REGISTRAMOS EL XIB
        tableView.register(UINib(nibName: "BMPosterObdmCustomCell", bundle: nil), forCellReuseIdentifier: "PosterObdmCustomCell")
        
        //CREAMOS NUESTRO MENU IZQ / DERE
        if revealViewController() != nil{
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rightViewRevealWidth = 150
            extraMenuButton.target = revealViewController()
            extraMenuButton.action = #selector(SWRevealViewController.rightRevealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrayDatosOmdb.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PosterObdmCustomCell", for: indexPath) as! BMPosterObdmCustomCell
        

        // Configure the cell...
        let model = arrayDatosOmdb[indexPath.row]
        
        cell.myTituloLBL.text = model.title
        cell.myYearLBL.text = model.year
        cell.myIdLBL.text = model.imdbID
        cell.myTipoLBL.text = model.type
        
        cell.myImagenPoster.kf.setImage(with: URL(string: model.poster!),
                                        placeholder: #imageLiteral(resourceName: "placehoder"),
                                        options: nil,
                                        progressBlock: nil,
                                        completionHandler: nil)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 415
    }
    
    
    //MARK: - UTILS
    func llamadaOmdb(){
        let datosOmdb = BMParserOmDb()
        HUD.show(.progress)
        firstly{
            return when(resolved: datosOmdb.getDatosOmdb(idObjeto, idNumero: idPoster))
            }.then{_ in
                self.arrayDatosOmdb = datosOmdb.getParserOmDb()
            }.then{_ in
                self.tableView.reloadData()
            }.then{_ in
                HUD.hide(afterDelay: 0)
            }.catch { error in
                self.present(muestraAlertVC("", messageData: "", titleActionData: ""), animated: true, completion: nil)
            }
    }
    
    //MARK: - RANDOM ID POSTER
    func randomNumero() -> Int{
        let dimeNumero = Int(arc4random_uniform(11))
        return dimeNumero
    }
    
    //MARK: - RECARGA DATOS
    func muestraRecarga(){
        idPoster = String(randomNumero())
        print(" AQUI" + idPoster)
        llamadaOmdb()
        customRefresh.endRefreshing()
    }
}
