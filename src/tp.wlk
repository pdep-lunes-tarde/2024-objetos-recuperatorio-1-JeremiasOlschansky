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
    method cantidadAPerder(){
        rango.cantidadPerdidaAlSerVencido(self)
    }
    method enfrentarA(otroMago){
        const puntos = otroMago.cantidadAPerder()
        if (otroMago.puedeSerVencidoPor(self)){
            self.robarPuntos(puntos)
            otroMago.perderPuntos(puntos)
        }
    }

    method puedeVencerA(gremio){
        return self.poderTotal() > gremio.resistenciaMagica()
    }
    method enfrentarAUnGremio(gremio){
        if(self.puedeVencerA(gremio)){
            self.robarPuntos(gremio.reservaDeEnergiaMagica())
            gremio.perderContraUnMago()
        }
    }

    method esMago()=true
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

class Gremio{
    var property miembrosAfiliados
    var liderDelGremio = self.elegirLider()

    method sumarAtributoDeMiembros(funcion) = miembrosAfiliados.sum(funcion)
    
    method poderTotal() = self.sumarAtributoDeMiembros{miembro => miembro.poderTotal()}
    method reservaDeEnergiaMagica() = self.sumarAtributoDeMiembros{miembro => miembro.energiaMagica()}
    method resistenciaMagica() = self.sumarAtributoDeMiembros{miembro => miembro.resistenciaMagica()} + liderDelGremio.resistenciaMagica()
   method esMago() = false
    method elegirLider(){
        const elDeMasPoder =  miembrosAfiliados.max{miembro => miembro.poderTotal()}
        if(elDeMasPoder.esMago()){
            return elDeMasPoder
        }
        else{
            return elDeMasPoder.elegirLider() // este es el cambio que hice para el 3)
        }
    }

    method crearGremio(conjuntoDeMagos){
        if (conjuntoDeMagos.length() < 2 ){
            self.error("No se pudo crear el gremio")
        } 
        else{
            const nuevoGremio = new Gremio(miembrosAfiliados = conjuntoDeMagos)
        }
    }

    method puedeVencerA(alguien){
        return self.poderTotal() > alguien.resistenciaMagica()
    }  
       method darlePuntosAlLider(cantidad){
        liderDelGremio.robarPuntos(cantidad)
    }
   method atacarUnGremio(otroGremio){
    if (self.puedeVencerA(otroGremio)){
        self.darlePuntosAlLider(otroGremio.reservaDeEnergiaMagica())
        otroGremio.afectarATodoElGremio()
    }
   }

method afectarATodoElGremio(){
     miembrosAfiliados.foreach{miembro=>miembro.perderPuntos(miembro.cantidadAPerder())}
}
    method perderContraUnMago(){
        self.afectarATodoElGremio()
    }
   method atacarUnMago(mago){
    const puntos=mago.cantidadAPerder()
    if(self.puedeVencerA(mago)){
        self.darlePuntosAlLider(puntos)
        mago.perderPuntos(puntos)
    }
   }
}

