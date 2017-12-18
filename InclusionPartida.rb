#!/bin/ruby

require 'sqlite3'

class InclusionPartida

@@Nombre
@@MATE
@idPartida

  def initialize(string)
    begin
    @@Nombre=string
    @@MATE = SQLite3::Database.open("#{@@Nombre}")
    @idPartida = 0
    end
  end

	def ManejaArgumentos(args)
		juego = args[1]
		jug1 = args[2]
		pun1 = args[3]
		args_def = args.drop(4)
		ManejaInsercion(juego,jug1,pun1,args_def)
	end

	def ManejaInsercion(juego, jug1, pun1, *args)
		InsertaPartida(jug1,pun1,juego)
		args_def = args[0]
		while( !args_def.empty?) do
			InsertaPartida(args_def[0],args_def[1],juego)
			args_def = args_def.drop(2)
		end
	end

  def InsertaPartida(nombreJugador,puntuacion,nombreJuego)
    begin

    if @idPartida == 0
      numpartidas = @@MATE.execute("select max(id) from Partida")
      value =  numpartidas[0][0]
      tmp = value.to_i
      tmp = tmp.next
      @idPartida = tmp
      @@MATE.execute("INSERT INTO Partida(id) VALUES(#{@idPartida})")
      @@MATE.execute(" INSERT INTO Pertenece(idPartida,nombreJuego)  VALUES(#{@idPartida},'#{nombreJuego}')")
    end

    tiempo = Time.now
    fecha = tiempo.strftime("%d/%m/%Y")
    @@MATE.execute(" INSERT INTO Juega(nombreJugador, idPartida, puntuacion, fecha)  VALUES('#{nombreJugador}',#{@idPartida},#{puntuacion.to_i},'#{fecha.to_s}')")
    end
  end

  def LeerPartidas
    begin
    @@MATE.execute("select * from Juega") do |result|
   	 puts result
    end
  end


end
end
