
object musicaDeFondo {
    var musicaActual = null //game.sound("musica/musicaJuegoPrincipal.wav")
    var musicaIniciada = false
    var musicaPausada = false
    var muteadaPorUsuario = false
    var pausadaPorCarga = false
    var tecladoConfigurado = false

    method position() = game.at(25,14)
    method image() {
        if (musicaIniciada && !musicaPausada) return "imagenesFondos/musicaActiva.png"
        else return "imagenesFondos/musicaInactiva.png"
    }

    method iniciarMusica(pista) {
        if (!musicaIniciada) {
            musicaActual = game.sound(pista)
            const esMusicaPrincipal = (pista == "musica/musicaJuegoPrincipal.wav" || pista == "musica/musicaJuegoPrincipal.mp3")
            musicaActual.shouldLoop(esMusicaPrincipal)
            musicaActual.play()
            musicaIniciada = true
            musicaPausada = false
            muteadaPorUsuario = false
            pausadaPorCarga = false
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
        muteadaPorUsuario = false
        pausadaPorCarga = false
    }

    method cambiarMusica(nuevaMusica) {
        self.pararMusica()
        self.iniciarMusica(nuevaMusica)
    }

    method pausarOReanudarMusica() {
        if (musicaIniciada) {
            if (muteadaPorUsuario) {
                muteadaPorUsuario = false
                if (!pausadaPorCarga) {
                    musicaActual.resume()
                    musicaPausada = false
                }
            } else {
                muteadaPorUsuario = true
                if (!musicaPausada) {
                    musicaActual.pause()
                    musicaPausada = true
                }
            }
        }
    }

    method pausarPorCargaDeNivel() {
        pausadaPorCarga = true
        if (musicaIniciada && !musicaPausada) {
            musicaActual.pause()
            musicaPausada = true
        }
    }

    method reanudarPorFinDeCarga() {
        pausadaPorCarga = false
        if (musicaIniciada && !muteadaPorUsuario) {
            musicaActual.resume()
            musicaPausada = false
        }
    }

    method resetearTeclado() {
        tecladoConfigurado = false
    }

    //sino cada vez dsp del clear no se puede volver ausar
    method configurarTeclado() {
        if (!tecladoConfigurado) {
            keyboard.p().onPressDo({self.pausarOReanudarMusica()})
            tecladoConfigurado = true
        }
    }
}


object controladorSonidos {
    var sonidosActivados = true
    var sonidosEnReproduccion = #{}
    var tecladoConfigurado = false

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

    method resetearTeclado() {
        tecladoConfigurado = false
    }

    method configurarMuteo() {
        if (!tecladoConfigurado) {
            keyboard.o().onPressDo({self.desactivarSonidos()})
            tecladoConfigurado = true
        }
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