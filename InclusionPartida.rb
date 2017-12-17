#!/bin/ruby
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

  def InsertaPartida(idJugador,puntuacion)
    begin
    @@numpartidas = @@MATE.execute("select max(id) from Partida")
    value =  @@numpartidas[0][0]
    tmp = value.to_i
    tmp = tmp.next
    @@MATE.execute("INSERT INTO Partida VALUES(#{tmp})")
    tiempo = Time.now
    fecha = tiempo.strftime("%d/%m/%Y")
    @@MATE.execute(" INSERT INTO JUEGA  VALUES('#{idJugador.to_s}',#{tmp},#{puntuacion},'#{fecha.to_s}')")
    end
  end

  def LeerPartidas
    begin
    @@MATE.execute("select * from Juega") do |result|
    puts result
    end
  end

end



mate = InclusionPartida.new("./MATE/Mate.db")

puts "Insertar identificador del jugador"
id = gets.chomp

puts "Insertar puntuación"
punt = gets.chomp


mate.InsertaPartida(id,punt)




end

