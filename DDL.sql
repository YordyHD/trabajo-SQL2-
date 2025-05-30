CREATE DATABASE hotel;
USE hotel;


CREATE TABLE clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    documento VARCHAR(20),
    correo VARCHAR(100),
    telefono VARCHAR(20)
);

CREATE TABLE habitaciones (
    id_habitacion INT AUTO_INCREMENT PRIMARY KEY,
    capacidad INT,
    precio_noche DOUBLE,
    disponible BOOLEAN
);

CREATE TABLE reservas (
    id_reserva INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT,
    id_habitacion INT,
    fecha_reserva DATE,
    fecha_entrada DATE,
    fecha_salida DATE,
    total DOUBLE,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    FOREIGN KEY (id_habitacion) REFERENCES habitaciones(id_habitacion)
);

