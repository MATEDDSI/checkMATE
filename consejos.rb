module Consejos

	def Consejos.maneja_argumentos(args)
		if args["contra"]
			puts aconsejar_contra args["<jugador>"], args["<juego>"]
		end
	end


	def Consejos.aconsejar_contra(jugador, juego)
		res = {} 
		atr = atributos juego
		atr.each do |a|
			val = valores_ganadores_contra jugador, juego, a["nombre"]
			if a["tipo"] == "int"
				sum_pt = val.inject(0) {|sum, v| sum + v["puntuacion"].to_i} 
				res[a["nombre"]] = val.inject(0) {|res, v| res + v["valor"].to_i*(v["puntuacion"].to_i/sum_pt)}	
			elsif a["tipo"] == "string"
				valor_sum_pt = {}
				val.each do |v|
					valor_sum_pt[v["valor"]] = 0
				end
				val.each do |v|
					valor_sum_pt[v["valor"]] += v["puntuacion"].to_i
				end
				res[a["nombre"]] = (valor_sum_pt.max_by {|k, v| v}).first 
			end
		end
		res
	end


	def Consejos.atributos(juego)
		require 'sqlite3'
		begin
			db = SQLite3::Database.open "MATE/Mate.db"
			db.results_as_hash = true
			db.execute <<-QUERY
			SELECT nombre, tipo FROM Atributo INNER JOIN Tiene ON
			Atributo.nombre = Tiene.nombreAtributo WHERE
			Tiene.nombreJuego = '#{juego}';
			QUERY
		rescue SQLite3::Exception => e
			puts "Error al acceder a la base de datos: "
			puts e
		ensure
			db.close if db
		end

	end

	
	def Consejos.valores_ganadores_contra(jugador, juego, atributo)
		require 'sqlite3'
		begin
			db = SQLite3::Database.open "MATE/Mate.db"
			db.results_as_hash = true
			p = db.execute <<-QUERY
SELECT valor, puntuacion FROM (
SELECT idPartida, nombreJugador, puntuacion FROM (
	SELECT PartidasYJugadoresDelJuego.idPartida,
	PartidasYJugadoresDelJuego.nombreJugador,
	PartidasYJugadoresDelJuego.puntuacion FROM (
		SELECT idPartida, nombreJugador, puntuacion FROM Juega WHERE idPartida IN (
			SELECT idPartida FROM Pertenece WHERE nombreJuego='#{juego}'
		) 
	) AS PartidasYJugadoresDelJuego INNER JOIN (
		SELECT idPartida, puntuacion FROM (
			SELECT idPartida, nombreJugador, puntuacion FROM Juega WHERE idPartida IN (
				SELECT idPartida FROM Pertenece WHERE nombreJuego='#{juego}'
			) AND nombreJugador = '#{jugador}'
		)
	) AS PartidasYPuntuacionDelJugador
	ON PartidasYJugadoresDelJuego.idPartida = PartidasYPuntuacionDelJugador.idPartida
	WHERE PartidasYJugadoresDelJuego.puntuacion > PartidasYPuntuacionDelJugador.puntuacion
)) AS Ganadores INNER JOIN Rellena
ON Ganadores.idPartida = Rellena.idPartida AND Ganadores.nombreJugador = Rellena.nombreJugador
WHERE Rellena.nombreAtributo = '#{atributo}';
QUERY
		rescue SQLite3::Exception => e
			puts "Error al acceder a la base de datos: "
			puts e
		ensure
			db.close if db
		end
	end
end
