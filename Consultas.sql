INSERT INTO Servicios (valor, cantidad, idcategoria) VALUES (100.0, 10, 1);
INSERT INTO Productos (valor, cantidad, idcategoria) VALUES (50.0, 20, 1);
CALL crear_factura(424, 2, 1, 3, 2);
SELECT * FROM agendamiento;
CALL agendar_cita(226, 2, 1, '2025-05-28', '10:00:00');








