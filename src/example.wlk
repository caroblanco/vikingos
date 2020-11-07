class Vikingos{
	var casta = jarl
	var oro = 0
	
	method oro() = oro
	
	method casta() = casta
	
	method puedeIrA(expedicion) = self.esProductivo() && self.castaOk()
	
	method castaOk() = casta.puedeSubir(self)
	
	method esProductivo()
	
	method agregarOro(cant){
		oro += cant
	}
	
	method escalarSocialmente(){
		casta.escalar(self)
	}
	
	method cambiarCastaA(nuevaC){
		casta = nuevaC
	}
}

class Soldado inherits Vikingos{
	var vidas
	var armas 
	
	method vidas() = vidas
	
	method cobrarUnaVida(){
		vidas++
	}
	
	override method esProductivo() = vidas >20 && self.tieneArmas()
	
	method tieneArmas() = armas > 0
	
	method escala1(){
		armas += 10
	}
}

class Granjero inherits Vikingos{
	var hijos
	var hectareas
	
	method tieneArmas() = false
	
	override method esProductivo() =  hectareas.div(hijos) >= 2 //hectareas * 2 >= hijos 
	
	method escala1(){
		hijos +=2
		hectareas += 2
	}
	method cobrarUnaVida(){
	}
}

class Casta{
	method puedeSubir(alguien) = true
}

object jarl inherits Casta{
	
	override method puedeSubir(alguien) = not alguien.tieneArmas()
	
	method escalar(vikingo){
		vikingo.escala1()
		vikingo.cambiarCastaA(karl)
	}
}

object karl inherits Casta{
	
	method escalar(vikingo){
		vikingo.cambiarCastaA(thrall)
	}
}

object thrall inherits Casta{
	
	method escalar(vikingo){}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////

class Expedicion{
	const objetivos = []
	const vikingos = []
	
	method vikingos() = vikingos
	
	method valeLaPena() = objetivos.all({unO => unO.valeLaPena(self.cantVikingos())})
	
	method subirVikingo(unVikingo){
		if(unVikingo.puedeIrA(self)){
			vikingos.add(unVikingo)
		}else{
			self.error("EL VIKINGO NO PUEDE IR")
		}
	}
	
	method botinTotal() = objetivos.sum({unO => unO.botin(self.cantVikingos())})
	
	method cantVikingos() = vikingos.size()
	
	method repartirOro(){
		const cant = self.botinTotal().div(self.cantVikingos())
		vikingos.forEach({unV => unV.agregarOro(cant)})
	}
	
	method realizarExpedicion(){
		objetivos.forEach({unO => unO.serInvadido(vikingos)})
		self.repartirOro()
	}
	
	method agregarLugar(algo){
		objetivos.add(algo)
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////

class Aldea{
	
	var crucifijos
	method crucifijos() = crucifijos
	method botin(vikingos) = crucifijos
	method valeLaPena(vikingos) = self.botin(vikingos) >= 15
	
	method serInvadido(vikingos){
		crucifijos = 0
	}
}

class AldeaAmurallada inherits Aldea{
	const min
	
	override method valeLaPena(vikingos) = super(vikingos) && self.cantMinVikingos(vikingos)
	
	method cantMinVikingos(vikingos) = vikingos >= min
}

class Capital{
	const factorRiqueza
	const defensores
	
	method defensores() = defensores
	
	method valeLaPena(vikingos) = self.botin(vikingos).div(vikingos) >= 3
	
	method botin(vikingos) = self.derrotados(vikingos) * factorRiqueza
	
	method derrotados(vikingos) = defensores.min(vikingos)
	
	method serInvadido(vikingos){
		vikingos.forEach({unV => unV.cobrarUnaVida()})
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////
/*Para agregar un nuevo objetivo castillo, este debe ser polimórfico con los otros objetivos existentes. 
  No hace falta modificar código existente, siempre y cuando se implementen los mensajes valeLaPenaPara, botin,
  y serInvadidoPor (y siempre y cuando no necesite más cosas del vikingo para resolver esos métodos, en cuyo caso
  convendría pasar el vikingo por parámetro)*/
