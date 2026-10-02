import wollok.game.*


class PechugaDePollo{
    var property position 
    var property modificado
    
    method elemento() = "comida"
    method sePuedeAgarrar() = true
    method sePuedeCocinar() = true 
    method sePuedeCortar() = false
    
    method image(){
        if(self.modificado() ==  "cocinado") { return "pechugacocinada.png"}
        
        if(self.modificado() == "tirado") {game.removeVisual(self)}
        
        return "pechuga.png"
        
    }
}

const pechuga1 = new PechugaDePollo(
    position = game.at(6,3),
    modificado = ""
)

const pechuga2 = new PechugaDePollo(
    position = game.at(6,3),
    modificado = ""
)

const pechuga3 = new PechugaDePollo(
    position = game.at(6,3),
    modificado = ""
)

const pechuga4 = new PechugaDePollo(
    position = game.at(6,3),
    modificado = ""
)

const pechuga5 = new PechugaDePollo(
    position = game.at(6,3),
    modificado = ""
)

class Plato {    
    var property position 
    var property modificado 

    method image(){
        if(self.modificado() == "limpio") return "plato.png"
        else return "platoSucio.png"
    }

    method sePuedeAgarrar() = true
    method sePuedeCocinar() = false 
    method sePuedeCortar() = false 
    method elemento() = "plato"
}

const plato1 = new Plato(
    position = game.at(16,3),
    modificado = "limpio"
)
