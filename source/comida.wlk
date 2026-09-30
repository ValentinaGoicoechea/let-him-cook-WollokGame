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