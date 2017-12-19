module Estadistica

	def Estadistica.estadistica2D(args)
    require 'sqlite3'
		atr1 = args[2]
		nom = args[1]
		puts atr1
    begin
      db = SQLite3::Database.open "MATE/Mate.db"
      db.results_as_hash = true
      p = db.execute <<-QUERY
      SELECT valor,fecha,nombreJugador FROM Rellena
			NATURAL JOIN juega
			NATURAL JOIN pertenece
			where nombreAtributo = '#{atr1}' and nombreJuego = '#{nom}';
			QUERY
    rescue SQLite3::Exception => e
      puts "Error al acceder a la base de datos: "
      puts e
    ensure
      db.close if db
    end
 	end

	def Estadistica.nuevoIdEstadistica(usuario)
		require 'sqlite3'
    begin
      db = SQLite3::Database.open "MATE/Mate.db"
      db.results_as_hash = true
      p = db.execute <<-QUERY
      SELECT max(idEstadistica) from tiene_en_cache where nombreUsuario = '#{usuario}';
			QUERY
    rescue SQLite3::Exception => e
      puts "Error al acceder a la base de datos: "
      puts e
    ensure
      db.close if db
    end
	end

	def Estadistica.separarPorJugador(busqueda)
		b_aux = []
		b2 = []
		busqueda.each do |b|
			if b_aux.index(b[2]) == nil

				b_aux.push(b[2])
				b3 = []
				b3.push(b)
				b2.push(b3)
			else
				b2[b_aux.index(b[2])].push(b)
			end
		end
		b2
	end

	def Estadistica.InsertarEstadistica(nombreUsuario, nombreImagen,nombreJuego)
		n = nuevoIdEstadistica("admin")[0][0]
		if n == nil
			n = 0
		end
		n=n+1
		require 'sqlite3'
    begin
      db = SQLite3::Database.open "MATE/Mate.db"
      db.results_as_hash = true
      db.execute <<-QUERY
      INSERT INTO tiene_en_cache(idEstadistica,nombreUsuario) VALUES
			('#{n}', '#{nombreUsuario}');
			QUERY
			db.execute <<-QUERY
			INSERT INTO Estadistica(id,imagen) VALUES ('#{n}', '#{nombreImagen}');
			QUERY
			db.execute <<-QUERY
			INSERT INTO resume(idEstadistica, nombreJuego) VALUES
			('#{n}','#{nombreJuego}');
			QUERY
    rescue SQLite3::Exception => e
      puts "Error al acceder a la base de datos: "
      puts e
    ensure
      db.close if db
    end
	end
end
