import wollok.game.*

class Pedido{ 
    //clase para todos los pedidos! cuando veamos herencia va a haber una clase para cada receta
    // por ahora dejemoslo solo en pollo c papas

    var property position //van apareciendo a la derecha y "caen"
    var property estado = "NUEVO"// estados NUEVO, ESPERA1, ESPERA2, PERDIDO
    const receta   //por ahora solo pollo con papas
    const ingredientes // por ahora creo "ingredientes" para luego verifivcar si cumplen
    var property seEntrego = false

    method image() {
        //if(receta = "polloConPapas") ##para cuando haya mas recetas
            if(estado == "NUEVO") return "pedidoPolloNuevo.png"
            if(estado == "ESPERA1") return "pedidoPolloEspera1.png"
            if(estado == "ESPERA2") return "pedidoPolloEspera2.png"
            if(estado == "PERDIDO") return "pedidoPolloPerdido.png"
        return "vacio.png"
    }

    method estadoDelPedido() {
        game.addVisual(self)
        game.schedule(10000,  { estado = "ESPERA1" })
        game.schedule(20000, { estado = "ESPERA2" })
        game.schedule(30000, { 
            estado = "PERDIDO" 
            game.schedule(2000, game.removeVisual(self))})
    }

}

object generadorDePedidos {
    var property puedeGenerarPedidos = true
    
    method nuevoPedido() {
        const pedidoX = new Pedido(
            position = game.at(27, 4),
            receta = "polloConPapas",
            ingredientes = ["plato", "pechugaCocinada", "papasFritas"]
        )
        pedidoX.estadoDelPedido()
    }

    method empezar() {
        self.nuevoPedido()                                        
        game.onTick(35000, "generarPedido", { self.nuevoPedido() }) //Creacion de pedidos cda 35 sec
    }
}