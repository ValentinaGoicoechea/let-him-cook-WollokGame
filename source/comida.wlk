import wollok.game.*


class Comida{
    var property position 
    var property modificado
    var property estaEnPlato = false
    var property sePuedeAgarrar = true 
    method elemento() = "comida"

    method elementoYEstado()
    method image()
    method tareas() {
        if(self.modificado() ==  "cocinado") return ["tirar"]
        if(self.modificado() == "tirado") return [] 
        return ["cocinar", "tirar"]
    }
}


class PechugaDePollo inherits Comida{

    override method elementoYEstado(){
        if(self.modificado() == "cocinado") return "pechugaCocinada"
        else return "pechugaDePollo"
    }
    
    
    override method image(){
        if(self.modificado() ==  "cocinado") { return "pechugacocinada.png"}
        
        if(self.modificado() == "tirado") return "vacio.png"
        
        return "pechuga.png"
    }
    
}

class Papa inherits Comida{
    
    override method elementoYEstado(){
        if(self.modificado() == "cocinado") return "papasFritas"
        else if(self.modificado() == "cortada") return "papaCortada"
        else return "papaCruda"
    }

    
    override method image(){
        if(self.modificado() == "cocinado") { return "papaFrita.png"}
        
        if(self.modificado() == "cortada") { return "papaCortada.png"}

        if(self.modificado() == "tirado") return "vacio.png"
        
        return "papaCruda.png"
        
    }

    override method tareas() {
        if(self.modificado() ==  "cortada") return ["cocinar", "tirar"]
        if(self.modificado() == "cocinado") return ["tirar"]
        if(self.modificado() == "tirado") return [] 
        return ["cortar", "tirar"]
    }
}

class OjoDeBife inherits Comida {

    override method elementoYEstado() {
        if (self.modificado() == "cocinado") return "ojoBifeCocinado"
        else return "ojoBife"
    }

    override method image() {
        if (self.modificado() == "cocinado") return "ojoBifeCocinado.png"
        else return "ojoBife.png"
    }

}

class Huevo inherits Comida {

    override method elementoYEstado() {
        if (self.modificado() == "cocinado") return "huevoFrito"
        else return "huevo"
    }

    override method image() {
        if (self.modificado() == "cocinado") return "huevoFrito.png"
        else return "huevo.png"
    }
}

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

class PlatoArmado {
    var property position
    var property elementosPlato = []
    const property estaEnPlato = false
    method tareas() = ["tirar"]
    
    method sePuedeAgarrar() = true
    method elemento() = "plato armado"
    
    method nuevaPosicion(nuevaPos) {
        position = nuevaPos
        elementosPlato.forEach({ elem => elem.position(nuevaPos) })
    }


}

class ObjetoQuemado {
    var property position 
    var property modificado
    var property estaEnPlato = false
    var property sePuedeAgarrar = true 
}