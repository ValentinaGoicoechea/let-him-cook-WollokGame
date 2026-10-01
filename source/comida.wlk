import wollok.game.*


object pechugaDePollo{
    var property position = game.at(6,3)
    var property cocinada = false
    method image(){
        if(cocinada){
            return "pechugacocinada.png"
        } else{
            return "pechuga.png"
        }
    }
    method sePuedeAgarrar() = true
    method elemento() = "comida"
    method sePuedeCocinar() = true 
}

object plato {
    var cantidadPlatos = 5
    var property position = game.at(16,3) 
    method image(){
        if(cantidadPlatos > 0){
            return "plato.png"
        } else{
            return "sinplato.png"
        }
    }
    method sePuedeAgarrar() = cantidadPlatos > 0
    method elemento() = "plato"
}