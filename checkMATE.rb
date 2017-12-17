#!/bin/ruby

doc = <<DOCOPT
checkMATE.

Usage:
	#{__FILE__} consejo contra <jugador> <juego>
	#{__FILE__} consulta <juego>
	
Options:
	-h --help	Muestra esta pantalla.
	--version	Muestra la versión.

DOCOPT


begin
	require "docopt"
	args = Docopt::docopt(doc)
	if args["consejo"]
		require_relative "consejos"
		Consejos.maneja_argumentos(args);
	end
	if args["consulta"]
		require_relative "consulta"
		Consulta.consultar(args["<juego>"]);
#		Consulta.consultarCondicion(args["<juego>"],args["<diferencia/igual>"],args["<numero>"]);
#		Consulta.restriccion(args["<juego>"],args["<atributo>"],args["<valor>"])
	end
rescue Docopt::Exit => e
	puts e.message
end
