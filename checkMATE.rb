#!/bin/ruby

doc = <<DOCOPT
checkMATE.

Usage:
	#{__FILE__} consejo contra <jugador>
	
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
rescue Docopt::Exit => e
	puts e.message
end
