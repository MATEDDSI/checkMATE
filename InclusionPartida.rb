#!/bin/ruby

require 'sqlite3'

class InclusionPartida

@@Nombre
@@MATE
@@Numpartidas = 0

  def initialize(string)
    begin
    @@Nombre=string
    @@MATE = SQLite3::Database.open("#{@@Nombre}")
    end
  end

  def InsertaPartida(idJugador,puntuacion)
    begin
    @@numpartidas = @@MATE.execute("select max(id) from Partida")
    value =  @@numpartidas[0][0]
    tmp = value.to_i
    tmp = tmp.next
    @@MATE.execute("INSERT INTO Partida VALUES(#{tmp})")
    tiempo = Time.now
    fecha = tiempo.strftime("%d/%m/%Y")
    @@MATE.execute(" INSERT INTO JUEGA  VALUES(#{idJugador},#{tmp},#{puntuacion},#{fecha})")
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

puts "Insertar identificador del jugador"
id = gets.chomp
#
puts "Insertar puntuación"
punt = gets.chomp

# puts "Insertar puntuacion del jugador 2"
# jug2 = gets.chomp
#
#
# mate.InsertaPartida(id,punt)
# 
# mate.LeerPartidas


# CREATE TRIGGER puntuacion BEFORE INSERT
# ON JUEGA FOR EACH ROW WHEN puntuacion1 < 0 || puntuacion2 < 0
# BEGIN
#
#



end
