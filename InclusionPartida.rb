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

puts "Insertar identificador"
id = gets.chomp

puts "Insertar puntuación del jugador 1"
jug1 = gets.chomp

puts "Insertar puntuacion del jugador 2"
jug2 = gets.chomp


mate.InsertaPartida(id,jug1,jug2)

mate.LeerPartidas


CREATE TRIGGER puntuacion BEFORE INSERT
ON JUEGA FOR EACH ROW WHEN puntuacion1 < 0 || puntuacion2 < 0
BEGIN





end
