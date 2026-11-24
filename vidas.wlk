



class Corazon{
    const property position
    method image() = "imagenesFondos/vida.png"
    method permiteApoyar() = false
}

const corazon1 = new Corazon(position = game.at(4, 2))
const corazon2 = new Corazon(position = game.at(5, 2))
const corazon3 = new Corazon(position = game.at(6, 2))
const corazon4 = new Corazon(position = game.at(7, 2))
const corazon5 = new Corazon(position = game.at(8, 2))

object vidas{
    var property corazones =[]

    method reiniciar(){
        self.limpiar()
        corazones = [corazon1, corazon2, corazon3, corazon4, corazon5]
        corazones.forEach({ corazon => game.addVisual(corazon) })
    }

    method limpiar(){
        corazones.forEach({corazon => 
            if(game.allVisuals().contains(corazon)){
                game.removeVisual(corazon)
            }
        })
    }

    method perderVida() {
        if (!corazones.isEmpty()) {
            const corazonAPerder = corazones.last() //pierde el último corazon agregado (el de mas a la derecha)
            if (game.allVisuals().contains(corazonAPerder)) {
                game.removeVisual(corazonAPerder)
            }
            corazones.remove(corazonAPerder)
        }
    }

    method cantidad() = corazones.size()

    method quedanVidas() = !corazones.isEmpty()


}