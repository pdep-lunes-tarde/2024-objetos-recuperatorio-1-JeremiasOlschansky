object prueba {}
class Mago{
    const poderInnato
    var rango
    const nombre
    var objetosMagicosEquipados = []
    var property resistenciaMagica
    var property energiaMagica
    method poderTotal(){
        return objetosMagicosEquipados.sum(objetosMagicosEquipados.map{objeto=>objeto.poderAportado()}) * poderInnato
    }

    method cantidadDeLetrasDelNombre() = nombre.length()
      method suNombreTieneCantidadParDeLetras(){
        return self.cantidadDeLetrasDelNombre()% 2 == 0
    }

    method puedeSerVencidoPor(otroMago){
        rango.cumpleCondicionesParaSerDerrotadoPor(self,otroMago)
    }

    method robarPuntos(cantidad){
        energiaMagica += cantidad
    }

    method perderPuntos(cantidad){
        energiaMagica -= cantidad.max(0)
    }
    method enfrentarA(otroMago){
        if (otroMago.puedeSerVencidoPor(self)){
            self.robarPuntos(rango.cantidadPerdidaAlSerVencido(otroMago))
            otroMago.perderPuntos(rango.cantidadPerdidaAlSerVencido(otroMago))
        }
    }
}
class ObjetoMagico{
    const poderBaseAportado = 0
    const nombre = ""
    
    method poderAportadoA(mago){
     return poderBaseAportado + self.extraAportadoA(mago)
    }   
   method extraAportadoA(mago) = 0

   
}

object aprendiz{

method cumpleCondicionesParaSerDerrotadoPor(magoAtacante,magoDefensor) = magoDefensor.resistenciaMagica() < magoAtacante.poderTotal()
method cantidadPerdidaAlSerVencido(mago) =  mago.energiaMagica()/2
}

object veterano{
    method cumpleCondicionesParaSerDerrotadoPor(magoAtacante,magoDefensor) = magoAtacante.poderTotal() >= magoDefensor.resistenciaMagica() * 1.5  
    method cantidadPerdidaAlSerVencido(mago) = mago.energiaMagica()/4
}

object inmortal{
 method cumpleCondicionesParaSerDerrotadoPor(magoAtacante,magoDefensor) = false 
}

class Varitas inherits ObjetoMagico{
override method extraAportadoA(mago){
    if(mago.suNombreTieneCantidadParDeLetras()){
        return poderBaseAportado * 0.5
    }
    return poderBaseAportado
}
}

class TunicasComunes inherits ObjetoMagico{
    override method extraAportadoA(mago){
        return 2*mago.cantidadDeLetrasDelNombre()
    }
}

class TunicasEpicas inherits ObjetoMagico{
    override method extraAportadoA(mago){
        return 2*mago.resistenciaMagica()+10
    }
}

class Amuleto inherits ObjetoMagico{
    override method poderAportadoA(mago) = 200

}

object ojota inherits ObjetoMagico {
    override method poderAportadoA(mago) = 10* mago.cantidadDeLetrasDelNombre()
}

// parte B)
