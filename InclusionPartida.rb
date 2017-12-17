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

  def InsertaEnJuega(idJugador,puntuacion,nombreJuego)
    begin

    if @idPartida == 0
      numpartidas = @@MATE.execute("select max(id) from Partida")
      value =  numpartidas[0][0]
      tmp = value.to_i
      tmp = tmp.next
      @idPartida = tmp
      @@MATE.execute("INSERT INTO Partida VALUES(#{@idPartida})")
      @@MATE.execute(" INSERT INTO Pertenece  VALUES(#{@idPartida},'#{nombreJuego}')")
    end

    tiempo = Time.now
    fecha = tiempo.strftime("%d/%m/%Y")
    @@MATE.execute(" INSERT INTO JUEGA  VALUES('#{idJugador.to_s}',#{@idPartida},#{puntuacion},'#{fecha.to_s}')")
    end
  end

  def LeerPartidas
    begin
    @@MATE.execute("select * from Juega") do |result|
    puts result
    end
  end


end



mate = InclusionPartida.new("./Mate.db")

puts "Juego?"
juego = gets.chomp
puts "Numero de jugadores"
num = gets.chomp
num = num.to_i


  for  i in 1..num

    puts "Insertar identificador del jugador"
    id = gets.chomp

    puts "Insertar puntuación"
    punt = gets.chomp

    mate.InsertaEnJuega(id,punt,juego)

  end




