module Consulta

	def Consulta.consultar(juego)
		id_list = sacarIDs(juego)
		id_list.each do |id_i|
			mostrarID(id_i)
		end
	end


	def Consulta.consultarCondicion(juego,condicion,numero)
		# condicion == diferencia
		res_id = []
		id_list = sacarIDs(juego)
		id_list.each do |id_i|
			nomypun_list = sacarNombreJugsYPuntuaciones(id_i["idPartida"])
			if nomypun_list.length == 2
				p_a = nomypun_list[0]["puntuacion"].to_i
				p_b = nomypun_list[1]["puntuacion"].to_i
				if( (p_a - p_b)*(p_a - p_b) <= numero.to_i*numero.to_i)
					res_id << id_i
				end
			end
		end
		res_id.each do |id_j|
			mostrarID(id_j)
		end
	end

	def Consulta.consultarID(numero)
		id = { "idPartida" => numero.to_i }
		mostrarID(id)
	end

	def Consulta.mostrarID(id)
		nomypun_list = sacarNombreJugsPuntuacionesYFecha(id["idPartida"])
		if( nomypun_list.empty? )
			puts "No existe la Partida #{id["idPartida"]}."
		else
			puts "--Partida #{id["idPartida"]}--"
			print "   " , "Jugadores: "
			cont = 1
			nomypun_list.each do |nomypun_i|
				if nomypun_list.length == cont
					print nomypun_i["nombreJugador"]
				else
					print nomypun_i["nombreJugador"] , " vs. "
				end
				cont = cont +1
			end
			print "\n"

			print "   " , "Resultado: "
			cont = 1
			nomypun_list.each do |nomypun_i|
				if nomypun_list.length == cont
					print nomypun_i["puntuacion"]
				else
					print nomypun_i["puntuacion"] , "-"
				end
				cont = cont +1
			end
			puts
		
			nomypun_list.each do |nomypun_i|
				puts "     " + nomypun_i["nombreJugador"] + ":"
				atrval_list = sacarAtributosValores(id["idPartida"],nomypun_i["nombreJugador"])
				atrval_list.each do |atrval_i|
					puts "       " + atrval_i["nombreAtributo"] + " -> " + atrval_i["valor"]
				end
			end

			puts "   " + "Fecha: " + nomypun_list[0]["fecha"]
		end
		
	end

	def Consulta.restriccion(juego,atributo,valor)
		id_list = restringir(juego,atributo,valor)
		id_list.each do |id_i|
			mostrarID(id_i)
		end
	end

	def Consulta.sacarIDs(juego)
		require 'sqlite3'
		begin
			db = SQLite3::Database.open "MATE/Mate.db"
			db.results_as_hash = true
			db.execute <<-QUERY
			SELECT idPartida FROM Pertenece
			WHERE nombreJuego = '#{juego}';
			QUERY
		rescue SQLite3::Exception => e
			puts "Error al acceder a la base de datos: "
			puts e
		ensure
			db.close if db
		end

	end

	def Consulta.sacarNombreJugsPuntuacionesYFecha(id)
		require 'sqlite3'
		begin
			db = SQLite3::Database.open "MATE/Mate.db"
			db.results_as_hash = true
			db.execute <<-QUERY
			SELECT nombreJugador, puntuacion, fecha FROM juega
			WHERE idPartida = '#{id}';
			QUERY
		rescue SQLite3::Exception => e
			puts "Error al acceder a la base de datos: "
			puts e
		ensure
			db.close if db
		end
	end

	def Consulta.sacarAtributosValores(id,nombreJug)
		require 'sqlite3'
		begin
			db = SQLite3::Database.open "MATE/Mate.db"
			db.results_as_hash = true
			db.execute <<-QUERY
			SELECT nombreAtributo, valor FROM rellena
			WHERE idPartida = '#{id}' AND nombreJugador = '#{nombreJug}';
			QUERY
		rescue SQLite3::Exception => e
			puts "Error al acceder a la base de datos: "
			puts e
		ensure
			db.close if db
		end
	end

	def Consulta.restringir(juego,atributo,valor_p)
		require 'sqlite3'
		begin
			db = SQLite3::Database.open "MATE/Mate.db"
			db.results_as_hash = true
			db.execute <<-QUERY
			SELECT idPartida FROM pertenece
			WHERE nombreJuego = '#{juego}'
			INTERSECT
			SELECT idPartida FROM rellena
			WHERE nombreAtributo = '#{atributo}' AND valor = '#{valor_p}'; 
			QUERY
		rescue SQLite3::Exception => e
			puts "Error al acceder a la base de datos: "
			puts e
		ensure
			db.close if db
		end
	end

end
