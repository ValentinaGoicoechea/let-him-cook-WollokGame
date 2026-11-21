import estados.*

//UNICAMENTE PARA TAREAS DE CADA COMIDA Y ELEMENTO
object tareaCocinar{
    method ejecutar(objeto){objeto.estado(cocinada)}
}

object tareaTirar{
    method ejecutar(objeto){
    objeto.sePuedeAgarrar(false) 
    objeto.desaparecer()}
}
object tareaCortar{
    method ejecutar(objeto){objeto.estado(cortada)}
}

object tareaLimpiar{
    method ejecutar(objeto){objeto.estado(limpio)}
}

object tareaQuemar{
    method ejecutar(objeto){objeto.estado(quemada)}
}

object tareaLlenar{
    method ejecutar(objeto){objeto.estado(lleno)}
}