#!/bin/ruby

require 'sqlite3'

class InclusionPartida

@@Nombre
@@MATE

  def initialize(string)
    begin
    @@Nombre=string
    @@MATE = SQLite3::Database.open("#{@@Nombre}")
    end
  end

  def InsertaPartida(idJugador,puntuacion1,puntuacion2)
    begin
    @@MATE.execute("INSERT INTO Partida VALUES(#{idJugador})")
    tiempo = Time.now
    fecha = tiempo.strftime("%d/%m/%Y")
    @@MATE.execute(" INSERT INTO JUEGA  VALUES(#{idJugador},#{puntuacion1},#{puntuacion2},#{fecha})")
    end
  end

  def LeerPartidas
    begin
    @@MATE.execute("select * from Juega") do |result|
    puts result
    end
  end

end



mate = InclusionPartida.new("./MATE/MATE.db")
# mate.InsertaPartida(1,2,2)
# mate.InsertaPartida(2,0,1)

mate.LeerPartidas

end
