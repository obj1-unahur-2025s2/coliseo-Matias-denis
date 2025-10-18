import gladiadores.*

object escudo {
    method defensa(gladiador) = 5 + gladiador.destreza() * 0.10
}

object casco {
    method defensa(gladiador) = 10
}