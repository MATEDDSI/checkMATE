module Consulta

	def Consulta.consultar(juego)
		id_list = sacarIDs(juego)
		id_list.each do |id_i|
			puts "Partida #{id_i["idPartida"]}:"

			nomypun_list = sacarNombreJugsYPuntuaciones(id_i)
			print "   " , "Jugadores: "
			cont = 0
			nomypun_list.each do |nomypun_i|
				if nomypun_list.length == cont
					print nomypun_i["nombreJugador"]
				else
					print nomypun_i["nombreJugador"] , "vs. "
				end
				cont = cont +1
			end
			print "\n"

			print "   " , "Puntuaciones: "
			cont = 0
			nomypun_list.each do |nomypun_i|
				if nomypun_list.length == cont
					print nomypun_i["puntuacion"]
				else
					print nomypun_i["puntuacion"] , "-"
				end
				cont = cont +1
			end
			print "\n"

			
			nomypun_list.each do |nomypun_i|
				puts "     " + nomypun_i["nombreJugador"]
				atrval_list = sacarAtributosValores(id_i,nomypun_i["nombreJugador"])
				atrval_list.each do |atrval_i|
					puts "     " , atrval_i["nombreAtributo"] , " -> " , atrval_i["valor"]
				end
			end
		end
	end


	def Consulta.consultar(juego,condicion,numero)
		if condicion == 'diferencia'
			res_id = {}
			id_list = sacarIDs(juego)
			id_list.each do |id_i|
				nomypun_list = sacarNombreJugsYPuntuaciones(id_i)
				p_a = nomypun_list["puntuacion"][0]
				p_b = nomypun_list["puntuacion"][1]
				if( (p_a - p_b)*(p_a - p_b) < numero*numero)
					res_id << id_i
				end
			end

			res_id.each do |id_i|
			puts "Partida #{id_i["idPartida"]}:"

			nomypun_list = sacarNombreJugsYPuntuaciones(id_i)
			print "   " , "Jugadores: "
			cont = 0
			nomypun_list.each do |nomypun_i|
				if nomypun_list.length == cont
					print nomypun_i["nombreJugador"]
				else
					print nomypun_i["nombreJugador"] , "vs. "
				end
				cont = cont +1
			end
			print "\n"

			print "   " , "Puntuaciones: "
			cont = 0
			nomypun_list.each do |nomypun_i|
				if nomypun_list.length == cont
					print nomypun_i["puntuacion"]
				else
					print nomypun_i["puntuacion"] , "-"
				end
				cont = cont +1
			end
			print "\n"

			
			nomypun_list.each do |nomypun_i|
				puts "     " + nomypun_i["nombreJugador"]
				atrval_list = sacarAtributosValores(id_i,nomypun_i["nombreJugador"])
				atrval_list.each do |atrval_i|
					puts "     " , atrval_i["nombreAtributo"] , " -> " , atrval_i["valor"]
				end
			end
		end
		else
			puts "No implementado."
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

	def Consulta.sacarNombreJugsYPuntuaciones(id)
		require 'sqlite3'
		begin
			db = SQLite3::Database.open "MATE/Mate.db"
			db.results_as_hash = true
			db.execute <<-QUERY
			SELECT nombreJugador, puntuacion FROM juega
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

	def Consulta.sacarIDnombreJugPuntuacion(id)
		require 'sqlite3'
		begin
			db = SQLite3::Database.open "MATE/Mate.db"
			db.results_as_hash = true
			db.execute <<-QUERY
			SELECT idPartida, nombreJugador, puntuacion FROM juega
			WHERE idPartida = '#{id}' AND nombreJugador = '#{nombreJug}' AND puntuacion = '#{}';
			QUERY
		rescue SQLite3::Exception => e
			puts "Error al acceder a la base de datos: "
			puts e
		ensure
			db.close if db
		end
	end
end
