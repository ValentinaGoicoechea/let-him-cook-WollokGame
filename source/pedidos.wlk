import wollok.game.*

class Pedido{

    var property position //van apareciendo a la derecha y "caen"
    var property estado = "NUEVO"// estados NUEVO, ESPERA1, ESPERA2, PERDIDO
    const receta   //por ahora solo pollo con papas
    const ingredientes // por ahora creo "ingredientes" para luego verifivcar si cumplen
    var property seEntrego = false

    method ingredientes() = ingredientes

    method image() {
        //Cada subclase lo maneja según le corresponda
    }

    method estadoDelPedido() {
        game.addVisual(self)
        game.schedule(10000,  { estado = "ESPERA1" })
        game.schedule(20000, { estado = "ESPERA2" })
        game.schedule(30000, { 
            estado = "PERDIDO" 
            game.schedule(2000, {game.removeVisual(self)}) //Y ACÁ DESCONTAR PUNTOS
            })
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
    var property puedeGenerarPedidos = true
    var contadorDePedidos = 0
    var posicionSegunFila = null
    const listapedidos = []

    method listaPedidos() = listapedidos
    
    method nuevoPedido() {
        contadorDePedidos += 1
        posicionSegunFila = contadorDePedidos % 4
        const numeroDePedido = 0.randomUpTo(1).round()  //Por ahora puede salir 0 o 1 para los dos pedidos.
        if (numeroDePedido == 0) {
            self.pedirPolloConPapas()
        } else {
            self.pedirOjoDeBifeConHuevo()
        }
    }

    method pedirPolloConPapas() {
        const pedidoX = new PedidoPolloConPapas ( 
                position = game.at(27, 3 + (posicionSegunFila * 3)), // X se mantiebe igual, voy a hacer que por ahora haya 4 en pantalla
                receta = "polloConPapas",
                ingredientes = ["plato", "pechugaCocinada", "papasFritas"]
            )
            listapedidos.add(pedidoX)
            pedidoX.estadoDelPedido()
    }

    method pedirOjoDeBifeConHuevo() {
        const pedidoX = new PedidoOjoDeBifeConHuevo ( 
                position = game.at(27, 3 + (posicionSegunFila * 3)),
                receta = "ojoDeBifeConHuevo",
                ingredientes = ["plato", "ojoBifeCocinado", "huevoFrito"]
            )
            listapedidos.add(pedidoX)
            pedidoX.estadoDelPedido()
    }

    method empezar() {
        self.nuevoPedido()                                        
        game.onTick(20000, "generarPedido", { self.nuevoPedido() }) //Creacion de pedidos cda 20 sec
    }
}