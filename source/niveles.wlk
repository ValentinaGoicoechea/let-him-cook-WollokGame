import pedidos.*
import ambiente.*
import controladorPantallasYNiveles.*
import puntaje.*

class Nivel{
    var property puntosParaGanar 
    var property siguienteNivel = null
    const pantalla

    method nuevoPedido() {
        //segun el nivel se crean distinto pedidos
    }

    method iniciar() {
        game.boardGround("imagenesFondos/fondoCocina.png")
        if (!game.allVisuals().contains(cajonDeHuevo)) {
            game.addVisual(cajonDeHuevo)
        }
        if (!game.allVisuals().contains(cajonDeBife)) { 
            game.addVisual(cajonDeBife)
        }
        cajonDeHuevo.reponerStock()
        cajonDeBife.reponerStock()

        pantalla.mostrarInfoNivel()

        game.schedule(5200, {
            controladorDePartida.puntosSegunNivel()
            generadorDePedidos.empezar(self) 
        })
    }
    method esTransitable(pos){//Para poder alternar el escenario de cada nivel
        const x = pos.x()
            const y= pos.y()    

            if (x == 20 && y == 7) return false //la basura
            else return  (y == 11 && (x.between(9, 13) || x.between(17, 18) || x.between(22, 24))) || 
                    (y.between(7, 10) && x.between(5, 24)) ||
                    (y == 6 && x.between(5, 18)) || 
                    (y.between(4, 5)  && x.between(5, 25))||
                    (y == 3 && x.between(18, 25))
            
            
            
            x == 5 && y.between(7,11)||
                    x.between(9,13) && y == 11||
                    x.between(21,24) && y == 11||
                    (x.between(5, 24) && y.between(7,10) || 
                    x.between(5,18) && y == 6||
                    x.between(5,25) && y.between(4, 5))||
                    x.between(18,25) && y == 3
    }
}

object nivel3 inherits Nivel(
    puntosParaGanar = 200, //Cambiar
    pantalla = pantallaNivel3 //CAMBIAR
){   override method iniciar(){
        game.boardGround("imagenesFondos/fondoCocinaNivel3.png")
        horno1.position(game.at(4,11))
        horno2.position(game.at(8,11))
        basura.position(game.at(11,3))
        bacha.position(game.at(25,6))
        tablaDeCortar.position(game.at(25,10))
        mesadaArmado1.position(game.at(18,3))
        mesadaArmado2.position(game.at(20,3))
        mesadaArmado3.position(game.at(22,3))
        cajonDePapas.position(game.at(4,5))
        cajonDePapas.posicionAlimento(game.at(19,9))
        cajonDePollo.position(game.at(6,3))
        cajonDePapas.posicionAlimento(game.at(19,8))
        cajonDeBife.position(game.at(6,6))
        cajonDeBife.posicionAlimento(game.at(18,9))
        cajonDeHuevo.position(game.at(4,3))
        cajonDeHuevo.posicionAlimento(game.at(18,8))

        if (!game.allVisuals().contains(cajonDePapas)) {
            game.addVisual(cajonDePapas)
        }
        if (!game.allVisuals().contains(cajonDePollo)) {
            game.addVisual(cajonDePollo)
        }
        cajonDePollo.reponerStock()
        cajonDePapas.reponerStock()
        super()      
    }

    override method nuevoPedido(){
         generadorDePedidos.pedir(0.randomUpTo(2).round())//Puede salir ojo de bife, pollo con papas o fernet
    }     


}

object nivel2 inherits Nivel(
    puntosParaGanar = 100,
    siguienteNivel = nivel3,
    pantalla = pantallaNivel2
    ){
    override method nuevoPedido() {
        generadorDePedidos.pedir(0.randomUpTo(2).round()) //Puede salir ojo de bife, pollo con papas o fernet
    }
    override method iniciar() {
        if (!game.allVisuals().contains(cajonDePapas)) {
            game.addVisual(cajonDePapas)
        }
        if (!game.allVisuals().contains(cajonDePollo)) {
            game.addVisual(cajonDePollo)
        }
        cajonDePollo.reponerStock()
        cajonDePapas.reponerStock()
        super()      
    }
}

object nivel1 inherits Nivel(
    puntosParaGanar = 300,
    siguienteNivel = nivel2,
    pantalla = pantallaNivel1
    ){
    override method nuevoPedido() {
        generadorDePedidos.pedir(0.randomUpTo(1).round()) //pide ojo de bife y fernet
        //generadorDePedidos.pedir(1)  //Solo ojo de bife con huevo
    }
}

