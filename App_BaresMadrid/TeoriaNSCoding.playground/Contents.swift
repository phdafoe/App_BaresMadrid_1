//: Playground - noun: a place where people can play

import Foundation

//Segundo metodo de persistencia con el protocolo -> NSCoding

class Persona : NSObject, NSCoding{
    
    var nombre : String!
    var apellido : String!
    var direccion : String!
    var email : String!
    var wifi : String!
    var edad : String!
    var movil : String!
    
    
    init(pNombre : String, pApellido : String, pDireccion : String, pEmail : String, pWifi : String, pEdad : String, pMovil : String) {
        self.nombre = pNombre
        self.apellido = pApellido
        self.direccion = pDireccion
        self.email = pEmail
        self.wifi = pWifi
        self.edad = pEdad
        self.movil = pMovil
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let nombreDe = aDecoder.decodeObject(forKey: "nombreKey") as! String
        let apellidoDe = aDecoder.decodeObject(forKey: "apellidoKey") as! String
        let direccionDe = aDecoder.decodeObject(forKey: "direccionKey") as! String
        let emailDe = aDecoder.decodeObject(forKey: "emailKey") as! String
        let wifiDe = aDecoder.decodeObject(forKey: "wifiKey") as! String
        let edadDe = aDecoder.decodeObject(forKey: "edadKey") as! String
        let movilDe = aDecoder.decodeObject(forKey: "movilKey") as! String
        
        self.init(pNombre : nombreDe, pApellido : apellidoDe, pDireccion : direccionDe, pEmail : emailDe, pWifi : wifiDe, pEdad : edadDe, pMovil : movilDe)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.nombre, forKey: "nombreKey")
        aCoder.encode(self.apellido, forKey: "apellidoKey")
        aCoder.encode(self.direccion, forKey: "direccionKey")
        aCoder.encode(self.email, forKey: "emailKey")
        aCoder.encode(self.wifi, forKey: "wifiKey")
        aCoder.encode(self.edad, forKey: "edadKey")
        aCoder.encode(self.movil, forKey: "movilKey")
    }
}


var multitud = [Persona]()

multitud.append(Persona(pNombre: "Andres",
                        pApellido: "Ocampo",
                        pDireccion: "Calle povedilla 5",
                        pEmail: "info@info.com",
                        pWifi: "1123581321aS",
                        pEdad: "36",
                        pMovil: "666223344"))

multitud.append(Persona(pNombre: "Felipe",
                        pApellido: "Eljaiek",
                        pDireccion: "calle general pardiñas 57",
                        pEmail: "mail@mail.com",
                        pWifi: "112358aS",
                        pEdad: "35",
                        pMovil: "665667788"))

multitud.append(Persona(pNombre: "Pepito",
                        pApellido: "Grillo",
                        pDireccion: "El pais de nunca jamas",
                        pEmail: "jamas@jamas.com",
                        pWifi: "jamas12345",
                        pEdad: "100",
                        pMovil: "665009988"))
//este array de multitid podemos convertirlo en un objeto serializable
//tenemos que tener una ruta del fichero en la que vamos a persistir la informacion
//ulr? -> porque puede o no exisitir esa ruta

func dataBaseUrl() -> URL? {
    if let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first{
        let customUrl = URL(fileURLWithPath: documentDirectory)
        return customUrl.appendingPathComponent("multitud.data")
    }else{
        return nil
    }
}

func salvarInfo(){
    //si tengo un url guardada en databaseURl?
    //archivo con la pripiedad path la ruta del fichero
    if let urlData = dataBaseUrl(){
        NSKeyedArchiver.archiveRootObject(multitud, toFile: urlData.path)
        //print(urlData.path)
    }else{
        print("Erro guardando datos")
    }
}

func cargarDatos(){
    if let urlData = dataBaseUrl(){
        if let datosSalvados = NSKeyedUnarchiver.unarchiveObject(withFile: urlData.path) as? [Persona]{
            multitud = datosSalvados
        }else{
            print("Erro leyendo datos")
        }
    }
}


//1
salvarInfo()
//2
multitud.removeAll()
//3
cargarDatos()


for c_persona in multitud{
    print("Nombre: \(c_persona.nombre!)\nApellido: \(c_persona.apellido!)")
}





















