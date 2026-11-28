
object musicaDeFondo {
    var musicaActual = null //game.sound("musica/musicaJuegoPrincipal.wav")
    var musicaIniciada = false
    var musicaPausada = false
    var tecladoConfigurado = false

    method position() = game.at(25,14)
    method image() {
        if (musicaIniciada && !musicaPausada) return "imagenesFondos/musicaActiva.png"
        else return "imagenesFondos/musicaInactiva.png"
    }

    method iniciarMusica(pista) {
        if (!musicaIniciada) {
            musicaActual = game.sound(pista)
            musicaActual.shouldLoop(true)
            musicaActual.play()
            musicaIniciada = true
            musicaPausada = false
        }
    }

    method pararMusica() {
    if (musicaIniciada) {
        try {
            musicaActual.stop()
        } catch e {
            // el sonido ya estaba detenido o fue limpiado por game.clear()
        }
        musicaActual = null
    }
    musicaIniciada = false
    musicaPausada = false
}

    method cambiarMusica(nuevaMusica) {
        self.pararMusica()
        self.iniciarMusica(nuevaMusica)
    }

    method pausarOReanudarMusica() {
        if (musicaIniciada) {
            if (musicaPausada) {
                musicaActual.resume()
            } else {
                musicaActual.pause()
            }
            musicaPausada = !musicaPausada //como es lo contrario...
        }
    }


    //sino cada vez dsp del clear no se puede volver  ausar
    method configurarTeclado() {
        keyboard.p().onPressDo({self.pausarOReanudarMusica()})
    }
}


object controladorSonidos {
    var sonidosActivados = true
    var sonidosEnReproduccion = #{}

    method desactivarSonidos() {
        sonidosActivados = !sonidosActivados
        sonidosEnReproduccion.forEach({ sonido =>
            if (sonidosActivados) {
                sonido.volume(0.4)
            } else {
                sonido.volume(0)
            }
        })
    }

    method configurarMuteo() {
        keyboard.o().onPressDo({self.desactivarSonidos()})
    }

    method detenerSonido(sonido) {
        sonido.stop()
    }

    method reproducirSonido(sonido, volumen) {
        sonidosEnReproduccion.add(sonido)
        if (sonidosActivados) {
            sonido.volume(volumen)
        } else {
            sonido.volume(0)
        }
        sonido.play()
    }
}