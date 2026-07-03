-- Script de inicialización de la base de datos para el reto

CREATE TABLE IF NOT EXISTS usuarios (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insertar registros iniciales de prueba (idempotente)
INSERT INTO usuarios (nombre, email) VALUES
('Juan Pérez', 'juan.perez@example.com'),
('María Gómez', 'maria.gomez@example.com'),
('Carlos Rodríguez', 'carlos.rodriguez@example.com')
ON CONFLICT (email) DO NOTHING;
