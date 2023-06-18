//
//  ViewController.swift
//  ProyectoFinal1
//
//  Created by Valeria Baeza on 19/04/23.
//

import Cocoa

class ViewController: NSViewController {
        
    @IBOutlet weak var vc: ViewController!
    
    @IBOutlet weak var txtUsuario: NSTextField!
    @IBOutlet weak var txtPassword: NSTextField!
    @IBOutlet weak var lblIncorrecto: NSTextField!
    
    @objc dynamic var usuarioLog:[UsuarioModelo] = []
    @objc dynamic var productoLog: [ProductoModelo] = []
    @objc dynamic var ventasLog:[VentaModelo] = []
    
    var idUsuarioActual: Int!
    var nombreUsuarioActual: String!

    var contadorIdVenta: Int = 1
    var usuarioEsAdmin: Bool = false
    
    var contadorGlobalProductos:Int = 0
    var contadorGlobalUsuarios:Int = 0
    
    override func viewDidLoad() {
        
        usuarioLog.append(UsuarioModelo(0, "Default User", "def", "def", "def@g.com","4771234567", "no binarie", 20, "123", "123","Cliente",formatStringToDate(date: "2002/10/10"), "Rosa", "cat"))
        usuarioLog.append(UsuarioModelo(1, "Uriel", "Resendiz", "Medina", "m@l.com","4771234567", "masculino", 20, "123", "123","Admin", formatStringToDate(date: "2003/04/26"), "Morado", "jade"))
        usuarioLog.append(UsuarioModelo(2, "Pedro", "Flores", "Razo", "pedro@gmail.com","4771234567", "masculino", 20, "123", "123","Ventas", formatStringToDate(date: "2002/08/23"), "Amarillo", "tori"))
        usuarioLog.append(UsuarioModelo(3, "Ivan", "Campos", "Solis", "ivan@gmail.com","4771234567", "masculino", 21, "123", "123","Cliente", formatStringToDate(date: "2001/02/17"), "Verde", "beck"))
        usuarioLog.append(UsuarioModelo(4, "Vale", "Baeza", "Morales", "vale@gmail.com","4771234567", "femenino", 20, "123", "123","Compras", formatStringToDate(date: "2002/07/20"), "Azul", "trina"))
        
        productoLog.append(ProductoModelo(0, "Default Prod", "def", "def", 1, 1, "def", 1, 0, "def"))
        productoLog.append(ProductoModelo(1, "Agua fig", "Agua de limón", "lt", 10, 5, "Aguas", 20, 4, "Vale"))
        productoLog.append(ProductoModelo(2, "Jugo Boing", "Jugo Boing de uva", "ml", 15, 10, "Jugos", 30, 4, "Vale"))
        productoLog.append(ProductoModelo(3, "Malteada", "Malteada sabor chocolate", "lt", 30, 20, "malteadas", 20, 4, "Vale"))

        contadorGlobalProductos = productoLog.count-1;
        contadorGlobalUsuarios = usuarioLog.count-1;

        print(contadorGlobalUsuarios,"contador global usuarios")
        lblIncorrecto.isHidden=true
    }
    
    override func viewDidAppear(){
        self.view.window?.title = "Iniciar sesión"
    }
    
    func formatStringToDate(date: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = date
        let date = dateFormatter.date(from: dateString)
        return date!
    }
    
    @IBAction func iniciarSesion(_ sender: NSButton) {
        
        let resultadoLogin = login(username: txtUsuario.stringValue, password: txtPassword.stringValue)
               
               if(resultadoLogin is UsuarioModelo){
                   txtUsuario.stringValue = ""
                   txtPassword.stringValue = ""
                   lblIncorrecto.isHidden = true
                   let UsuarioActual = resultadoLogin as! UsuarioModelo
                   idUsuarioActual=UsuarioActual.id
                   nombreUsuarioActual=UsuarioActual.nombre
                   if UsuarioActual.rol == "Cliente"{
                       usuarioEsAdmin = false
                       
                       performSegue(withIdentifier: "irVcCliente", sender: self)
                   }else if UsuarioActual.rol == "Admin"{
                       usuarioEsAdmin = true
                       performSegue(withIdentifier: "iniciarSesionCorrecto", sender: self)
                   }else if UsuarioActual.rol == "Ventas"{
                       usuarioEsAdmin = false
                       performSegue(withIdentifier: "irMenuVentas", sender: self)
                   }else if UsuarioActual.rol == "Compras"{
                       usuarioEsAdmin = false
                       performSegue(withIdentifier: "irVcMenuCompras", sender: self)
                   }
               }
               else{
                   lblIncorrecto.isHidden = false;
               }
    }
    

    func login(username: String, password: String) -> Any {
        for UsuarioModelo in usuarioLog {
            if (UsuarioModelo.email == username && UsuarioModelo.contraseña == password) {
                return UsuarioModelo
            }
        }
        return false
    }
    
    func cambiarImagen(idUsuarioActual:Int, imgAvatar:NSImageView){
         if usuarioLog[idUsuarioActual].imgFondo != "Sin avatar"{
             imgAvatar.isHidden = false
             imgAvatar.image = NSImage(named: usuarioLog[idUsuarioActual].imgFondo)
         }else{
            imgAvatar.isHidden = true
         }
    }
    
    func cambiarColorFondo(color:String, view:NSView){
        view.wantsLayer = true
        if color=="Rosa"{
            view.layer?.backgroundColor = NSColor(hex: 0xFBDEF9).cgColor
        }else if color=="Morado"{
            view.layer?.backgroundColor = NSColor(hex: 0xEEDEFB).cgColor
        }else if color=="Amarillo"{
            view.layer?.backgroundColor = NSColor(hex: 0xFBF4DE).cgColor
        }else if color=="Verde"{
            view.layer?.backgroundColor = NSColor(hex: 0xE2FFD9).cgColor
        }else if color == "Azul"{
            view.layer?.backgroundColor = NSColor(hex: 0xb2d1d1).cgColor
        }else{
            view.wantsLayer = false
        }
        
    }
    
    func cambiarImagenYFondo(idUsuarioActual:Int, imgAvatar:NSImageView, view:NSView){
        
       cambiarColorFondo(color: usuarioLog[idUsuarioActual].colorFondo, view:view)
        cambiarImagen(idUsuarioActual: idUsuarioActual, imgAvatar: imgAvatar)
    
    }
    

    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        
        if segue.identifier=="registrarUsuarioSegue"{
            (segue.destinationController as! RegistrarUsuario).vc = self
        }
        else if segue.identifier=="iniciarSesionCorrecto"{(segue.destinationController as! MenuAdmin).vc = self
        }
        else if segue.identifier=="irMenuVentas"{(segue.destinationController as! MenuVentas).vc = self
            (segue.destinationController as! MenuVentas).nombreVendedor = nombreUsuarioActual
        }else if segue.identifier=="irVcMenuCompras"{
            (segue.destinationController as! MenuCompras).vc = self
        }else if segue.identifier=="irVcCliente"{
            (segue.destinationController as! PedidosCliente).vcTablaPedidos = self
            (segue.destinationController as! PedidosCliente).ventasLog = self.ventasLog
        }
    }
    
    
    


}

