/*PROCESO 1*/

/*funcion*/
USE `barberia1`;
DROP function IF EXISTS `calcular_total`;

DELIMITER $$
USE `barberia1`$$
CREATE FUNCTION calcular_total(
    p_idservicio INT,
    p_idproducto INT
)
RETURNS FLOAT
DETERMINISTIC
BEGIN
    DECLARE v_servicio FLOAT DEFAULT 0;
    DECLARE v_producto FLOAT DEFAULT 0;

    SELECT valor INTO v_servicio FROM Servicios WHERE idservicios = p_idservicio;
    SELECT valor INTO v_producto FROM Productos WHERE idproducto = p_idproducto;

    RETURN v_servicio + v_producto;
END$$

DELIMITER ;


/*proce*/
USE `barberia1`;
DROP procedure IF EXISTS `crear_factura`;

DELIMITER $$
USE `barberia1`$$
CREATE PROCEDURE crear_factura(
    IN p_idcliente INT,
    IN p_idtrabajador INT,
    IN p_idbarberia TINYINT,
    IN p_idservicio INT,
    IN p_idproducto INT
)
BEGIN
    DECLARE total FLOAT;

    SET total = calcular_total(p_idservicio, p_idproducto);

    INSERT INTO Factura (
        idservicios,
        idproductos,
        valortotal,
        fecha,
        idcliente,
        idtrabajador,
        idbarberia
    ) VALUES (
        p_idservicio,
        p_idproducto,
        total,
        CURDATE(),
        p_idcliente,
        p_idtrabajador,
        p_idbarberia
    );
END$$

DELIMITER ;



/*trigger*/
DELIMITER $$

CREATE TRIGGER descontar_inventario_producto
AFTER INSERT ON Factura
FOR EACH ROW
BEGIN
    UPDATE Productos
    SET cantidad = cantidad - 1
    WHERE idproducto = NEW.idproductos;
END $$

DELIMITER ;

/*PROCESO 2*/
/*Funcion*/
USE `barberia1`;
DROP function IF EXISTS `horario_libre`;

DELIMITER $$
USE `barberia1`$$
CREATE FUNCTION horario_libre(
    p_idtrabajador INT,
    p_idbarberia TINYINT,
    p_fecha DATE,
    p_horario TIME
) RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE v_count INT;

    SELECT COUNT(*) INTO v_count
    FROM Agendamiento a
    JOIN Trabajador t ON a.idtrabajador = t.idtrabajador
    WHERE t.idtrabajador = p_idtrabajador
      AND t.idbarberia = p_idbarberia
      AND a.fechas = p_fecha
      AND a.horarios = p_horario;

    RETURN v_count = 0;
END$$

DELIMITER ;

/*procedure*/

DROP procedure IF EXISTS `agendar_cita`;

DELIMITER $$
USE `barberia1`$$
CREATE PROCEDURE agendar_cita(
    IN p_idcliente INT,
    IN p_idtrabajador INT,
    IN p_idbarberia TINYINT,
    IN p_fecha DATE,
    IN p_horario TIME
)
BEGIN
    IF horario_libre(p_idtrabajador, p_idbarberia, p_fecha, p_horario) THEN
        INSERT INTO Agendamiento (fechas, horarios, idcliente)
        VALUES (p_fecha, p_horario, p_idcliente);
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Horario ocupado. Elija otro horario.';
    END IF;
END$$

DELIMITER ;

/*trigger*/

DELIMITER $$

CREATE TRIGGER actualizar_contador_citas
AFTER INSERT ON Agendamiento
FOR EACH ROW
BEGIN
    UPDATE Cliente
    SET contador_citas = contador_citas + 1
    WHERE idcliente = NEW.idcliente;
END $$

DELIMITER ;