
object musicaDeFondo {
    var musicaActual = game.sound("musica/musicaJuegoPrincipal.wav")
    var musicaIniciada = false
    var musicaPausada = false
    var tecladoConfigurado = false

    method position() = game.at(25,14)
    method image() {
        if (musicaIniciada && !musicaPausada) return "imagenesFondos/musicaActiva.png"
        else return "imagenesFondos/musicaInactiva.png"
    }

    method iniciarMusica() {
        if (!musicaIniciada) {
            musicaActual.shouldLoop(true)
            musicaActual.play()
            musicaIniciada = true
            musicaPausada = false
        }
    }

    method iniciarMusicaJuego() {
        if (!musicaIniciada) {
            self.cambiarMusica(game.sound("musica/musicaJuegoPrincipal.wav"))
            self.iniciarMusica()
        }
    }

    method pararMusica() {
        if (musicaIniciada) {
            musicaActual.stop()
            musicaIniciada = false
            musicaPausada = false
        }
    }

    method cambiarMusica(nuevaMusica) {
        self.pararMusica()
        musicaActual = nuevaMusica
    }

    method pausarOReanudarMusica() {
        if (musicaIniciada) {
            if (musicaPausada) {
                musicaActual.resume()
                musicaPausada = false
            } else {
                musicaActual.pause()
                musicaPausada = true
            }
        }
    }

    method mutearMusica() {
        if (!tecladoConfigurado) {
            keyboard.p().onPressDo({
                self.pausarOReanudarMusica()
            })
            tecladoConfigurado = true
        }
    }
}


object controladorSonidos {
    var sonidosActivados = true
    const sonidosEnReproduccion = #{}

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