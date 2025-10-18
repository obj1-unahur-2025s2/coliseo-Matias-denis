import armas.*
import defensa.*

class Mirmillon {
    var vida = 100
    var proteccion
    const property fuerza
    const arma

    method destreza() = 15
    method cambiarProteccion(unaProteccion) {
        proteccion = unaProteccion
    }

    method vida() = vida
    method estaVivo() = vida > 0
    method ataque() = fuerza + arma.ataque()
    method defensa() = self.destreza() + proteccion.defensa(self)
    method atacar(enemigo) {
        if(self.puedeInfringirDanio(enemigo) && enemigo.estaVivo()) {
            enemigo.sufrirDanio(self.ataque() - enemigo.defensa())
        }
    }
    method sufrirDanio(unValor) {
        vida = (vida - unValor).max(0)
    }

    method puedeInfringirDanio(enemigo) {
        return self.ataque() > enemigo.defensa()
    }

    method pelear(enemigo) {
        self.atacar(enemigo)
        enemigo.atacar(self)
    }

    method curar() {vida = 100}
    method crearGrupo(otroGladiador) = 
        new Grupo(nombre="mirmillolandia", gladiadores = #{self,otroGladiador})
}

class Dimachaerus {
    const armas = []
    var destreza
    var vida = 100

    method vida() = vida
    method estaVivo() = vida > 0
    method fuerza() = 10
    method ataque() = self.fuerza() + armas.sum({a=>a.ataque()})
    method defensa() = destreza / 2
    method puedeInfringirDanio(enemigo) {
        return self.ataque() > enemigo.defensa()
    }
    method sufrirDanio(unValor) {
        vida = (vida - unValor).max(0)
    }

    method atacar(enemigo) {
        if(self.puedeInfringirDanio(enemigo) && enemigo.estaVivo()) {
            enemigo.sufrirDanio(self.ataque() - enemigo.defensa())
            destreza += 1
        }
    }
    method pelear(enemigo) {
        self.atacar(enemigo)
        enemigo.atacar(self)
    }

    method curar() {vida = 100}
    method crearGrupo(otroGladiador) = 
        new Grupo(
            nombre = "D-" + (self.ataque() + otroGladiador.ataque()).toString()
            ,gladiadores = #{self,otroGladiador}
        )
}

class Grupo {
    const property nombre
    const gladiadores = #{}
    var cantidadDePeleas = 0

    method agregarGladiador(unGladiador) {
        gladiadores.add(unGladiador)
    }

    method quitarGladiador(unGladiador) {
        gladiadores.remove(unGladiador)
    }

    method gladiadoresVivos() = gladiadores.filter({g=>g.estaVivo()})
    method hayAlgunGladiadorVivo() = gladiadores.any({g=>g.estaVivo()})
    method campeon() {
        return self.gladiadoresVivos().max({g=>g.fuerza()})
    }
    method pelearCon(otroGrupo) {
        if(self.hayAlgunGladiadorVivo() && otroGrupo.hayAlgunGladiadorVivo()) {
            self.campeon().pelear(otroGrupo.campeon())
        }
    }
    method registrarPelea() {cantidadDePeleas += 1}
    method combatir(otroGrupo) {
        (1..3).forEach({
            self.pelearCon(otroGrupo)
        })
        self.registrarPelea()
        otroGrupo.registrarPelea()
    }
    method curar() {
        gladiadores.forEach({g=>g.curar()})
    }

}

object coliseo {
    const property grupos = #{}
    method combateEntreGrupos(unGrupo,otroGrupo) {
        unGrupo.combatir(otroGrupo)
    }
    method combateDesigual(unGrupo,unGladiador) {
        const unGrupoSolitario = new Grupo(nombre="solitario",gladiadores=#{unGladiador})
        unGrupo.combatir(unGrupoSolitario)
        grupos.add(unGrupoSolitario)
    }
    method curar() {
        grupos.forEach({g=>g.curar()})
    }
}