class ArmaDeFilo {
    const filo
    const longitud

    method initialize() {
        if(!filo.between(0, 1)) {
            self.error("El filo debe estar entre 0 y 1")
        }
    }
    method ataque() = filo * longitud
}

class ArmaContundente {
    const peso
    method ataque() = peso
}