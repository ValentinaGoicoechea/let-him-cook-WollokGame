
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