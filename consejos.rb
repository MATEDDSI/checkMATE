module Consejos

	def Consejos.maneja_argumentos(args)
		if args["contra"]
			puts aconsejar_contra(args["<jugador>"])
		end
	end

	
	def Consejos.aconsejar_contra(usuario)
		return "Te aconsejo contra #{usuario}"
	end
end
