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
    var cantidadPlatos = 1
    var property position = game.at(16,3) 
    var property limpio = false
    method image(){
        if(cantidadPlatos > 0 ){
            if(self.limpio()) return "plato.png"
            else return "platoSucio.png"
        } else{
            return "sinplato.png"
        }
    }
    method sePuedeAgarrar() = cantidadPlatos > 0
    method sePuedeCocinar() = false 
    method elemento() = "plato"
}