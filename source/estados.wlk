import source.ambiente.*
import tareas.*


//Unicamente para estados de COMIDAS y PLATOS

//COSAS A CAMBIAR
//Elemento y estado 
//Tareas


object cruda {
    method nombre() = "Cruda"
    method tareas(tipo) = tipo.tareasCruda()
    method invalidaEntrega() = false
}

object cortada {
    method nombre() = "Cortada"
    method tareas(tipo) = tipo.tareasCortada()
    method invalidaEntrega() = false
}

object cocinada {
    method nombre() = "Cocinada"
    method tareas(tipo) = [tareaTirar]
    method invalidaEntrega() = false
   
}

object quemada {
    method nombre() = "Quemada"
    method tareas(tipo) = [tareaTirar]
    method invalidaEntrega() = true
}

// Estados para el plato
object limpio {
    method image(plato) = plato.imagenLimpio()
    method tareas(plato) = []

    method colocarseEnMesadaArmado(plato, mesada) { mesada.recibirPlatoLimpio(plato) }
    
}

object sucio {
    method image(plato) = plato.imagenSucio()
    method tareas(plato) = [tareaLimpiar]

    method colocarseEnMesadaArmado(plato, mesada) {}
    
}

object platoArmado{
    method image(plato) = "imagenesEstaciones/vacio.png"
    method tareas(plato) = [tareaTirar]

    method colocarseEnMesadaArmado(plato, mesada){ mesada.recibirPlatoArmado(plato)}

}

object lleno{//Para llenar el vaso con fernet, cambia la foto en este estado
    method image(vaso) = vaso.imagenLleno()
      
}


