import wollok.game.*


class PechugaDePollo{
    var property position 
    var property modificado
    var property estaEnPlato = false
    
    method elemento() = "comida"
    method sePuedeAgarrar() = true
    
    
    method image(){
        if(self.modificado() ==  "cocinado") { return "pechugacocinada.png"}
        
        if(self.modificado() == "tirado") {game.removeVisual(self)}
        
        return "pechuga.png"
        
    }

    method puede() = ["cocinar", "tirar"]
    
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

class Papa{
    var property position 
    var property modificado
    
    method elemento() = "comida"
    method sePuedeAgarrar() = true

    method sePuedeCocinar() = true 
    method sePuedeCortar() = true
    
    method image(){
        if(self.modificado() == "cocinado") { return "papaFrita.png"}
        
        if(self.modificado() == "cortada") { return "papaCortada.png"}

        if(self.modificado() == "tirado") {game.removeVisual(self)}
        
        return "papaCruda.png"
        
    }

    method puede() = ["cocinar", "tirar", "cortar"]
}

const papa1 = new Papa(
    position = game.at(9,3),
    modificado = ""
)

class Plato {    
    var property position 
    var property modificado 
    var property estaEnPlato = false

    method image(){
        if(self.modificado() == "limpio") return "plato.png"
        else return "platoSucio.png"
    }

    method sePuedeAgarrar() = true
    method sePuedeCocinar() = false 
    method sePuedeCortar() = false 
    method elemento() = "plato"

    method puede() = ["limpiar"]
}

const plato1 = new Plato(
    position = game.at(16,3),
    modificado = "limpio"
)
