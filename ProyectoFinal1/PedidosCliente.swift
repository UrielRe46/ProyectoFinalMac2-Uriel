//
//  PedidosCliente.swift
//  ProyectoFinal1
//
//  Created by Diego Juárez on 07/05/23.
//

import Cocoa

class PedidosCliente: NSViewController {
    
    
    @IBOutlet weak var imgAvatar: NSImageView!
    
    @IBOutlet var vcTablaPedidos: ViewController!
    @objc dynamic var vieneDeAdmin: Bool  = false
    @objc dynamic var idClienteAdmin: Int = -1
    
    @objc dynamic var ventasLog:[VentaModelo] = []
    @objc dynamic var productosLog:[ProductoModelo] = []
    @objc dynamic var pedidosLog:[PedidoModelo] = []
    @objc dynamic var idsVentas:[Int] = []
    @objc dynamic var clientesLog:[UsuarioModelo] = []
    
    @IBOutlet weak var btnAtras: NSButton!
    
    @IBOutlet weak var tablaPedidos: NSTableView!
    var idClienteActual:Int!
    var idPedido:Int!
    var tempId:Int!
    var idUsuarioActual:Int!
    var usuarios:[UsuarioModelo]!
    var clientes:[UsuarioModelo]!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        idPedido=1;
        tempId = -1;
        usuarios = vcTablaPedidos.usuarioLog
        clientes = []
        
        cambiarImagenYFondo(idUsuarioActual: vcTablaPedidos.idUsuarioActual)
        
        
        if vcTablaPedidos.usuarioEsAdmin{
            btnAtras.isHidden = false
        }else{
            btnAtras.isHidden = true
        }
        
        
        if(idClienteAdmin == -1){
            idUsuarioActual = vcTablaPedidos.idUsuarioActual
        }
        else{
            idUsuarioActual = idClienteAdmin
        }
        
        
        buscarClientes()
        
        obtenerIdClienteActual()
        
        buscarPedidosDeCliente()
    }
    
    func cambiarImagenYFondo(idUsuarioActual:Int){
        
         colorFondo(color: usuarios[idUsuarioActual].colorFondo)
         if usuarios[idUsuarioActual].imgFondo != "Sin avatar"{
             imgAvatar.isHidden = false
             imgAvatar.image = NSImage(named: usuarios[idUsuarioActual].imgFondo)
         }else{
            imgAvatar.isHidden = true
         }
    }
    
    func colorFondo(color:String){
        view.wantsLayer = true
        if color=="Rosa"{
            view.layer?.backgroundColor = NSColor(hex: 0xFBDEF9).cgColor
        }else if color=="Morado"{
            view.layer?.backgroundColor = NSColor(hex: 0xEEDEFB).cgColor
        }else if color=="Amarillo"{
            view.layer?.backgroundColor = NSColor(hex: 0xFBF4DE).cgColor
        }else if color=="Verde"{
            view.layer?.backgroundColor = NSColor(hex: 0xFBF4DE).cgColor
        }else if color == "Azul"{
            view.layer?.backgroundColor = NSColor(hex: 0xb2d1d1).cgColor
        }else{
            view.wantsLayer = false
        }
        
    }
    
    func buscarClientes(){
        for usuario in usuarios {
            if (usuario.rol=="Cliente"){
                clientes.append(usuario)
            }
        }
    }
    
    func obtenerIdClienteActual(){
        for cliente in clientes {
            if (cliente.id == idUsuarioActual){
                idClienteActual = clientes.firstIndex(of: cliente)
            }
        }
    }
    func obtenerIdsVentas(){
        for venta in ventasLog{
            if (venta.idCliente == idClienteActual){
                if(!idsVentas.contains(venta.idVenta)){
                    idsVentas.append(venta.idVenta)
                }
            }
        }
    }
    
    func buscarPedidosDeCliente(){
        if (ventasLog.count>0){
           
            for i in 0...ventasLog.count-1
            { 
                if (ventasLog[i].idCliente == idClienteActual){
                    print(ventasLog[i].idVenta)
                    if(tempId == -1){
                        tempId=ventasLog[i].idVenta
                    }
                    else{
                        if(tempId != ventasLog[i].idVenta){
                            tempId=ventasLog[i].idVenta
                            pedidosLog.append(PedidoModelo(tempId-1, "", "Total Pedido", "" ,"" ,"$"+String(ventasLog[i-1].totalVenta), ventasLog[i-1].totalVenta))
                        }
                    }
                    
                    
                    pedidosLog.append(PedidoModelo(tempId, String(ventasLog[i].idProducto),
                        obtenerDescripcionProducto(id: ventasLog[i].idProducto)            ,String(ventasLog[i].cantidad), String(ventasLog[i].precioProducto), String(ventasLog[i].totalProducto), ventasLog[i].totalVenta))
                    
                }
                
            }
            
            print(ventasLog.count, "COUNT")
            
            var indiceUltimaVenta:Int!
               for venta in ventasLog {
                   if(venta.idVenta == tempId){
                       indiceUltimaVenta = ventasLog.firstIndex(of: venta)
                   }
                    
                }
               
                pedidosLog.append(PedidoModelo(tempId, "", "Total Pedido", "" ,"" ,"$"+String(ventasLog[indiceUltimaVenta].totalVenta), ventasLog[indiceUltimaVenta].totalVenta))
           
        }
            
    }
    
    func obtenerDescripcionProducto(id:Int) -> String{
        for producto in productosLog{
            if producto.id == id {
                return producto.descripcion
            }
        }
        return ""
    }
    
    @IBAction func CerrarVc(_ sender: NSButton) {
        dismiss(self)
    }
    
}
