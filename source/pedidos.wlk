import source.comida.*
import wollok.game.*
import puntaje.*

//PEDIDOS(CLASES Y OBJETOS) + GENERADOR + SELECTOR DE PEDIDOS

class Pedido{

    var receta //pollo con papas u ojo de bife con huevo
    var property position //van apareciendo a la derecha y "caen"
    var property estado = nuevo //Pruebo que estado tenga asignado un objeto
    var property seEntrego = false

    method ingredientes() = receta.ingredientes()

    method image() = receta.imagenSegun(estado)

    method estadoDelPedido() {
        game.addVisual(self)
        game.schedule(20000,  { estado = espera1 })
        game.schedule(30000, { estado = espera2 })
        game.schedule(40000, { 
            if (!seEntrego) {
                estado = perdido 
                puntaje.restar(100)
                game.schedule(2000, {
                    game.removeVisual(self)
                    generadorDePedidos.listaPedidos().remove(self)}) 
                }
            })
                
    }

    // ESPERA2 es el más urgente, se entrega primero
    method prioridad() = estado.prioridad()
}
object nuevo {
    var property prioridad = 1

    method imagenPollo() = "pedidoPolloNuevo.png"
    method imagenOjoDeBife() = "pedidoOjoBifeNuevo.png"
}
object espera1 {
    var property prioridad = 2
    method imagenPollo() = "pedidoPolloEspera1.png"
    method imagenOjoDeBife() = "pedidoOjoBifeEspera1.png"
}
object espera2 {
    var property prioridad = 3
    method imagenPollo() = "pedidoPolloEspera2.png"
    method imagenOjoDeBife() = "pedidoOjoBifeEspera2.png"
}
object perdido {
    var property prioridad = 0
    method imagenPollo() = "pedidoPolloPerdido.png"
    method imagenOjoDeBife() = "pedidoOjoBifePerdido.png"
}

object polloConPapas {
    method imagenSegun(estado) = estado.imagenPollo()
    method ingredientes() = ["plato", "pechugaCocinada", "papasFritas"]
}

object ojoDeBifeConHuevo {
    method imagenSegun(estado) = estado.imagenOjoDeBife()
    method ingredientes() = ["plato", "ojoBifeCocinado", "huevoFrito"]
}


object generadorDePedidos {
    var contadorDePedidos = 0
    var posicionSegunFila = null
    const listapedidos = []

    method listaPedidos() = listapedidos
    
    method nuevoPedido() {
        contadorDePedidos += 1
        posicionSegunFila = contadorDePedidos % 4 // el primer pedido es 1, el segundo 2, el tercero 3, el 4 0
        self.pedir(0.randomUpTo(1).round())
    }

    //posicion en Y va del 3 al 14, creo que cada pedido ocupa 3

    method cambiarPosicionPedidosActivos(){
        if(listapedidos.size() != 0){
            listapedidos.forEach({pedido => pedido.position(pedido.position().down(3))})
        }
    }

    method agregarNuevoPedido(pedidoX){
        listapedidos.add(pedidoX)
        pedidoX.estadoDelPedido()
    }

    method pedir(numeroDePedido) {
        var pedidoX
        if(numeroDePedido == 0){
            pedidoX = new Pedido (
                    position = game.at(27, 12), //Hice cambios en las posiciones!
                    // X se mantiebe igual, voy a hacer que por ahora haya 4 en pantalla
                    receta = polloConPapas
                )
        }
        else{
            pedidoX = new Pedido ( 
                position = game.at(27,12),
                receta = ojoDeBifeConHuevo
            )
        }
        self.agregarNuevoPedido(pedidoX)
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