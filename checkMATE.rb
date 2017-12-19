#!/bin/ruby
# encoding: utf-8

doc = <<DOCOPT
checkMATE.

Usage:
	#{__FILE__} consejo contra <jugador> <juego>
	#{__FILE__} consulta <juego>
	#{__FILE__} consulta <juego> empate
	#{__FILE__} consulta <juego> diferencia <numero>
	#{__FILE__} consulta <juego> donde <atributo> <valor>
	#{__FILE__} consulta ID <numero>
	#{__FILE__} inserta <juego> <nombre_jugador_1> <puntuacion_1> <nombre_jugador_2> <puntuacion_2> ...
	#{__FILE__} estadistica2D <juego> <nombre_atributo_1>

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

	if args["inserta"]
		require_relative "InclusionPartida"
		mate = InclusionPartida.new("./MATE/Mate.db")
		mate.ManejaArgumentos(ARGV)
	end

	if args["estadistica2D"]
		require_relative "Estadistica"
		datosEstad = Estadistica.estadistica2D(ARGV)
		datosPorJ = Estadistica.separarPorJugador(datosEstad)
		n = Estadistica.nuevoIdEstadistica("admin")[0][0]
		if n == nil
			n = 0
		end
		files = []
		for i in 0..(datosPorJ.length-1)
			files.push("temporal_plot" + i.to_s + ".dat")

			File.open(files[i], 'w') { |file|
				datosPorJ[i].each do |j|
					file.puts j[1] + " " + j[0]
				end
			}
		end
		IO.popen('gnuplot', 'w') { |io|
			io.puts "set term png"

			io.puts "set output \"" + n.to_s + ".png\""
			io.puts "set xdata time"
			io.puts "set timefmt \"%d/%m/%y\""
			s = "plot "
			for i in 0..(datosPorJ.length-1)
				if i != 0
					s = s+","
				end
				s = s+ "\"" + files[i] + "\" using 1:2 t '" + ARGV[2] + " de " + (datosPorJ[i])[0][2] + "' with linespoints"
			end
		  io.puts s
		}
		Estadistica.InsertarEstadistica("admin", n.to_s+".png", ARGV[1])
		for i in 0..(datosPorJ.length-1)
			File.delete(files[i])
		end

	end

rescue Docopt::Exit => e
	puts e.message
end
