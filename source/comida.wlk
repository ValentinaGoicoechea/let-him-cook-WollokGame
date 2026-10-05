import wollok.game.*


class PechugaDePollo{
    var property position 
    var property modificado
    var property estaEnPlato = false
    var property sePuedeAgarrar = true 
    
    method elemento() = "comida"

    method elementoYEstado(){
        if(self.modificado() == "cocinado") return "pechugaCocinada"
        else return "pechugaDePollo"
    }
    
    
    method image(){
        if(self.modificado() ==  "cocinado") { return "pechugacocinada.png"}
        
        if(self.modificado() == "tirado") return "vacio.png"
        
        return "pechuga.png"
    }

    method tareas() {
        if(self.modificado() ==  "cocinado") return ["tirar"]
        if(self.modificado() == "tirado") return [] 
        return ["cocinar", "tirar"]
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

class Papa{
    var property position 
    var property modificado
    var property estaEnPlato = false
    var property sePuedeAgarrar = true 
    
    method elemento() = "comida"


    method elementoYEstado(){
        if(self.modificado() == "cocinado") return "papasFritas"
        else if(self.modificado() == "cortada") return "papaCortada"
        else return "papaCruda"
    }

    
    method image(){
        if(self.modificado() == "cocinado") { return "papaFrita.png"}
        
        if(self.modificado() == "cortada") { return "papaCortada.png"}

        if(self.modificado() == "tirado") return "vacio.png"
        
        return "papaCruda.png"
        
    }

    method tareas() {
        if(self.modificado() ==  "cortada") return ["cocinar", "tirar"]
        if(self.modificado() == "cocinado") return ["tirar"]
        if(self.modificado() == "tirado") return [] 
        return ["cortar", "tirar"]
    }
}

const papa1 = new Papa(
    position = game.at(9,3),
    modificado = ""
)

class Plato {    
    var property position 
    var property modificado 
    var property estaEnPlato = false
    var property sePuedeAgarrar = true 

    method elemento() = "plato"
    method elementoYEstado() = "plato"

    method image(){
        if(self.modificado() == "limpio") return "plato.png"
        else return "platoSucio.png"
    }

    method tareas() {
        if(self.modificado() == "limpio") return []
        else return ["limpiar"]
    }
}

const plato1 = new Plato(
    position = game.at(16,3),
    modificado = "limpio"
)

const plato2 = new Plato(
    position = game.at(16,3),
    modificado = "limpio"
)
