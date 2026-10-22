import wollok.game.*
import puntaje.*

class Pedido{

    var property position //van apareciendo a la derecha y "caen"
    var property estado = "NUEVO"// estados NUEVO, ESPERA1, ESPERA2, PERDIDO
    const ingredientes // por ahora creo "ingredientes" para luego verifivcar si cumplen
    var property seEntrego = false

    method ingredientes() = ingredientes

    method image() {
        //Cada subclase lo maneja según le corresponda
    }

    method estadoDelPedido() {
        game.addVisual(self)
        game.schedule(20000,  { estado = "ESPERA1" })
        game.schedule(30000, { estado = "ESPERA2" })
        game.schedule(40000, { 
            if (!seEntrego) {
                estado = "PERDIDO" 
                puntaje.restar(100)
                game.schedule(2000, {
                    game.removeVisual(self)
                    generadorDePedidos.listaPedidos().remove(self)}) 
                }
            })
                
    }

    // ESPERA2 es el más urgente, se entrega primero
    method prioridad() {
        if (estado == "ESPERA2") return 3
        if (estado == "ESPERA1") return 2
        return 1
    }
}

class PedidoPolloConPapas inherits Pedido {

    override method image() {
        if(estado == "NUEVO") return "pedidoPolloNuevo.png"
        if(estado == "ESPERA1") return "pedidoPolloEspera1.png"
        if(estado == "ESPERA2") return "pedidoPolloEspera2.png"
        if(estado == "PERDIDO") return "pedidoPolloPerdido.png"
        return "vacio.png"
    }
}

class PedidoOjoDeBifeConHuevo inherits Pedido {

    override method image() {
        if(estado == "NUEVO") return "pedidoOjoBifeNuevo.png"
        if(estado == "ESPERA1") return "pedidoOjoBifeEspera1.png"
        if(estado == "ESPERA2") return "pedidoOjoBifeEspera2.png"
        if(estado == "PERDIDO") return "pedidoOjoBifePerdido.png"
        return "vacio.png"
    }
}


object generadorDePedidos {
    var contadorDePedidos = 0
    var posicionSegunFila = null
    const listapedidos = []

    method listaPedidos() = listapedidos
    
    method nuevoPedido() {
        contadorDePedidos += 1
        posicionSegunFila = contadorDePedidos % 4 // el primer pedido es 1, el segundo 2, el tercero 3, el 4 0
        const numeroDePedido = 0.randomUpTo(1).round()  //Por ahora puede salir 0 o 1 para los dos pedidos.
        if (numeroDePedido == 0) {
            self.pedirPolloConPapas()
        } else {
            self.pedirOjoDeBifeConHuevo()
        }
    }

    //posicion en Y va del 3 al 14, creo que cada pedido ocupa 3

    method cambiarPosicionPedidosActivos(){
        if(listapedidos.size() != 0){
            listapedidos.forEach({pedido => pedido.position(pedido.position().down(3))})
        }
    }

    method pedirPolloConPapas() {
        const pedidoX = new PedidoPolloConPapas ( 
                position = game.at(27, 12), //Hice cambios en las posiciones!
                // X se mantiebe igual, voy a hacer que por ahora haya 4 en pantalla
                ingredientes = ["plato", "pechugaCocinada", "papasFritas"]
            )
            listapedidos.add(pedidoX)
            pedidoX.estadoDelPedido()
    }

    method pedirOjoDeBifeConHuevo() {
        const pedidoX = new PedidoOjoDeBifeConHuevo ( 
                position = game.at(27,12),
                ingredientes = ["plato", "ojoBifeCocinado", "huevoFrito"]
            )
            listapedidos.add(pedidoX)
            pedidoX.estadoDelPedido()
    }

    method empezar() {
        self.nuevoPedido()                                     
        game.onTick(20000, "generarPedido", { self.cambiarPosicionPedidosActivos()
        self.nuevoPedido() }) //Creacion de pedidos cda 40 sec
    }
    //esta parte se modificaria segun el nivel
}

object selectorPedidos{
    method eleccionDePedido(elementosPlato) { //pedido con la receta mas urgente
        const candidatos = generadorDePedidos.listaPedidos().filter({pedido => self.coincide(pedido, elementosPlato)})
        if (candidatos.isEmpty()) return null 
        else return candidatos.max({pedido => pedido.prioridad()})
    }

    method coincide(pedido, elementosPlato) = (!pedido.seEntrego() && pedido.estado() != "PERDIDO") &&
        elementosPlato.size() == pedido.ingredientes().size() && 
        elementosPlato.all({elemento => pedido.ingredientes().contains(elemento.elementoYEstado()) 
    })
}