import source.ambiente.*
import wollok.game.*

// COMIDAS Y VAJILLA (CLASES Y OBJETOS)


class Comida{
    var property position 
    var property modificado = ""
    var property estaEnPlato = false
    var property sePuedeAgarrar = true 
    //method elemento() = "comida"

    method esPlato() = false
    
    method vaciarElementos() {}

    method desaparecerDeBasura() {
        game.removeVisual(self)
    }

    method procesarEnMesadaEntrega(mesadaEntrega) {
        // Por defecto, los alimentos sueltos no se pueden entregar en la mesada de entrega
    }

    method colocarseEnMesadaArmado(){
        MesadaArmado.recibirComida(self)
    }

    method elementoYEstado()
    method image()
    method tareas() {
        if(self.modificado() ==  "cocinado") return ["tirar"]
        if(self.modificado() == "tirado") return [] 
        return ["cocinar", "tirar"]
    }
    method nuevaPosicion(posicion){
        self.position(posicion)
    }
}


class PechugaDePollo inherits Comida{

    override method elementoYEstado(){
        if(self.modificado() == "cocinado") return "pechugaCocinada"
        else return "pechugaDePollo"
    }
    
    
    override method image(){
        if(self.modificado() ==  "cocinado") { return "imagenesComida-Vajilla/pechugacocinada.png"}
        
        if(self.modificado() == "tirado") return "vacio.png"

        if(self.modificado() == "quemado") return "imagenesComida-Vajilla/pechugaquemada.png"

        
        return "imagenesComida-Vajilla/pechuga.png"
    }
    
}

class Papa inherits Comida{
    
    override method elementoYEstado(){
        if(self.modificado() == "cocinado") return "papasFritas"
        else if(self.modificado() == "cortada") return "papaCortada"
        else return "papaCruda"
    }

    
    override method image(){
        if(self.modificado() == "cocinado") { return "imagenesComida-Vajilla/papaFrita.png"}
        
        if(self.modificado() == "cortada") { return "imagenesComida-Vajilla/papaCortada.png"}

        if(self.modificado() == "tirado") return "vacio.png"

        if(self.modificado() == "quemado") return "imagenesComida-Vajilla/papaFritaQuemada.png"
        
        return "imagenesComida-Vajilla/papaCruda.png"
        
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
        if (self.modificado() == "cocinado") return "imagenesComida-Vajilla/ojoBifeCocinado.png"

        else if(self.modificado() == "quemado") return "imagenesComida-Vajilla/ojoBifeQuemado.png"

        else return "imagenesComida-Vajilla/ojoBife.png"
    }
}

class Huevo inherits Comida {

    override method elementoYEstado() {
        if (self.modificado() == "cocinado") return "huevoFrito"
        else return "huevo"
    }

    override method image() {
        if (self.modificado() == "cocinado") return "imagenesComida-Vajilla/huevoFrito.png"
        else if (self.modificado() == "quemado") return "imagenesComida-Vajilla/huevoFritoQuemado.png"
        else return "imagenesComida-Vajilla/huevo.png"
    }
}

class Vajilla {
    var property position
    var property estaEnPlato = false
    var property sePuedeAgarrar = true
    var property modificado


    method tareas() 
    method elemento()

    method nuevaPosicion(posicion){
        self.position(posicion)
    }
}
class Plato inherits Vajilla() {  
    
    method colocarseEnMesadaArmado(){
        if(modificado == "limpio"){
            MesadaArmado.recibirPlatoLimpio(self)
        }
    }

    method image(){
        if(self.modificado() == "limpio") return "imagenesComida-Vajilla/plato.png"
        else return "imagenesComida-Vajilla/platoSucio.png"
    }
    override method tareas() {
        if(self.modificado() == "limpio") return []
        else return ["limpiar"]
    }
    override method elemento() = "plato"
    
    method elementoYEstado() = "plato"

}

const plato1 = new Plato(
    position = game.at(16,3),
    modificado = "limpio"
)

const plato2 = new Plato(
    position = game.at(16,3),
    modificado = "limpio"
)

const plato3 = new Plato(
    position = game.at(16,3),
    modificado = "limpio"
)

class PlatoArmado inherits Vajilla(modificado = null){
    
    override method tareas() = ["tirar"]
    override method elemento() = "plato armado"

    var property elementosPlato = []
    
    override method nuevaPosicion(nuevaPos) {
        position = nuevaPos
        elementosPlato.forEach({ elem => elem.position(nuevaPos) })
    } 
    
    method colocarseEnMesadaArmado(){
        MesadaArmado.recibirPlatoArmado(self)
    }

    method vaciarElementos() {
    self.categoria().sePuedeAgarrar(false)
    elementosPlato.forEach({ elemento => 
        if (elemento.elemento() != "plato") {
            game.removeVisual(elemento)
            elementosPlato.remove(elemento)
        }
    })
    self.categoria().sePuedeAgarrar(true)
}

}
