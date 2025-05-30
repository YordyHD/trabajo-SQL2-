/*Funtion*/

USE `hotel`;
DROP function IF EXISTS `calcular_total`;

DELIMITER $$
USE `hotel`$$
CREATE FUNCTION calcular_total(
    fecha_reserva DATE,
    fecha_entrada DATE,
    fecha_salida DATE,
    precio_noche DOUBLE
) RETURNS DOUBLE
DETERMINISTIC
BEGIN
    DECLARE dias INT;
    DECLARE total DOUBLE;

    SET dias = DATEDIFF(fecha_salida, fecha_entrada);

    IF DATEDIFF(fecha_entrada, fecha_reserva) >= 15 THEN
        SET total = dias * precio_noche * 0.9;
    ELSE
        SET total = dias * precio_noche;
    END IF;

    RETURN total;
END$$

DELIMITER ;

/*Procedure 1*/

USE `hotel`;
DROP procedure IF EXISTS `registrar_reserva`;

DELIMITER $$
USE `hotel`$$
CREATE PROCEDURE registrar_reserva(
    IN p_id_cliente INT,
    IN p_id_habitacion INT,
    IN p_fecha_reserva DATE,
    IN p_fecha_entrada DATE,
    IN p_fecha_salida DATE
)
BEGIN
    DECLARE precio DOUBLE;
    DECLARE total DOUBLE;

    SELECT precio_noche INTO precio
    FROM habitaciones
    WHERE id_habitacion = p_id_habitacion;

    SET total = calcular_total(p_fecha_reserva, p_fecha_entrada, p_fecha_salida, precio);

    INSERT INTO reservas (
        id_cliente, id_habitacion, fecha_reserva, fecha_entrada, fecha_salida, total
    ) VALUES (
        p_id_cliente, p_id_habitacion, p_fecha_reserva, p_fecha_entrada, p_fecha_salida, total
    );

    UPDATE habitaciones
    SET disponible = FALSE
    WHERE id_habitacion = p_id_habitacion;
END$$

DELIMITER ;

/*Procedure 2*/

USE `hotel`;
DROP procedure IF EXISTS `registro_clientes`;

DELIMITER $$
USE `hotel`$$
CREATE PROCEDURE `registro_clientes` (
 in c_nombre varchar(100),
 in c_documento varchar(20),
 in c_correo varchar(100),
 in c_telefono varchar(20)
 )
BEGIN
insert into clientes(nombre, documento, correo, telefono)
values(c_nombre, c_documento, c_correo, c_telefono);
END$$

DELIMITER ;

/*view*/

USE `hotel`;
CREATE  OR REPLACE VIEW `reserva_activa` AS
SELECT r.id_reserva, c.nombre, h.capacidad, r.fecha_entrada, r.fecha_salida, r.total
FROM reservas r
JOIN clientes c ON r.id_cliente = c.id_cliente
JOIN habitaciones h ON r.id_habitacion = h.id_habitacion;;
