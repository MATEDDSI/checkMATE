#!/bin/ruby

doc = <<DOCOPT
checkMATE.

Usage:
	#{__FILE__} consejo contra <jugador> <juego>
	#{__FILE__} consulta <juego>
	#{__FILE__} consulta <juego> empate
	#{__FILE__} consulta <juego> diferencia <numero>
	#{__FILE__} consulta <juego> donde <atributo> <valor>
	#{__FILE__} consulta ID <numero>
	
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
		if args["empate"]
			Consulta.consultarCondicion(args["<juego>"],'diferencia',0);
		elsif args["diferencia"]
			Consulta.consultarCondicion(args["<juego>"],args["diferencia"],args["<numero>"]);
		elsif args["donde"]
			Consulta.restriccion(args["<juego>"],args["<atributo>"],args["<valor>"])
		elsif args["ID"]
			Consulta.consultarID(args["<numero>"]);
		else
			Consulta.consultar(args["<juego>"]);
		end
	end

rescue Docopt::Exit => e
	puts e.message
end
