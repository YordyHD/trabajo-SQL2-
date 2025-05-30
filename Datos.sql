

INSERT INTO habitaciones (capacidad, precio_noche, disponible)
VALUES 
(1, 70.00, TRUE),
(2, 100.00, TRUE),
(3, 150.00, TRUE),
(4, 180.00, TRUE);

CALL registro_clientes("Luis Gómez", "CC10255", "luisgomez@gmail.com", "3233312444");
CALL registro_clientes("Ana Torres", "CC22334", "ana.torres@gmail.com", "3001122334");
CALL registro_clientes("Carlos Ruiz", "CC33445", "carlosruiz@hotmail.com", "3102233445");
CALL registro_clientes("Marta López", "CC44556", "marta.lopez@yahoo.com", "3013344556");
CALL registro_clientes("Pedro Sánchez", "CC55667", "pedro.sanchez@gmail.com", "3124455667");
CALL registro_clientes("Sofía Romero", "CC66778", "sofia.romero@hotmail.com", "3205566778");
CALL registro_clientes("Andrés Castillo", "CC77889", "andres.castillo@gmail.com", "3216677889");
CALL registro_clientes("Camila Herrera", "CC88990", "camila.herrera@gmail.com", "3007788990");

CALL registrar_reserva(3, 18, '2025-06-15', '2025-06-20', '2025-06-23');
DELETE FROM habitaciones WHERE id_habitacion = 16;
select * from habitaciones;
select * from clientes;
select * from reservas;
select * from reserva_activa;
