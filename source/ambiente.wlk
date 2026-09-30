import wollok.game.*
import personajeprincipal.*

object horno{
    var property position = game.at(6,12)
    var prendido = false
    method image(){
        if(prendido){
            return "hornoprendido.png"
        } else{
            return "hornoapagado.png"
        }
    }




}