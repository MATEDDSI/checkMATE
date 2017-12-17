CREATE TRIGGER insertar_partida_nuevo_jugador AFTER INSERT ON juega
BEGIN
	DECLARE @nuevo_jugador varchar(max)
	SELECT @nuevo_jugador = nombreJugador FROM INSERTED

	IF @nuevo_jugador NOT IN (SELECT nombre FROM Jugador)
	BEGIN
		INSERT INTO Jugador VALUES( @nuevo_jugador )
	END
END;
