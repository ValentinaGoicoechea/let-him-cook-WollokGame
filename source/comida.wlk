import wollok.game.*


object pechugaDePollo{
    var property position = game.at(6,3)
    var cocinada = false
    method image(){
        if(cocinada){
            return "pechugacocinada.png"
        } else{
            return "pechuga.png"
        }
    }

    method elemento() = "comida"
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
    method elemento() = "plato"
}