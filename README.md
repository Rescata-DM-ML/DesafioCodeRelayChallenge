# Code Relay Challenge - Ronda 1 (Docker)

Este proyecto contiene la configuración de Docker completa para una aplicación React (Vite) de frontend y una base de datos PostgreSQL de backend, aplicando las mejores prácticas de optimización multi-stage y seguridad (ejecución sin privilegios de root).

## Estructura de Archivos Creados
- **Dockerfile**: Configuración multi-stage (`node:20-alpine` para compilar y `nginx:alpine` para servir la app). Nginx se ejecuta como el usuario no privilegiado `nginx` en el puerto `8080`.
- **nginx.conf**: Configuración personalizada para Nginx que permite el funcionamiento en el puerto `8080` y define directorios temporales y de PID bajo `/tmp`.
- **docker-compose.yml**: Orquestación de los servicios `frontend` y `db` (Postgres 16).
- **init.sql**: Script SQL para la creación automática de la tabla `usuarios` e inserción de datos de prueba.
- **.dockerignore**: Archivo de exclusión para evitar la carga de archivos innecesarios al contexto del build.

---

## Comandos de Uso

### 1. Construir la imagen del Frontend
Si deseas construir únicamente la imagen de Docker para la aplicación de React:
```bash
docker compose build
```
*(También puedes usar el comando tradicional `docker build -t desafio-frontend .` si quisieras compilar la imagen individualmente).*

### 2. Levantar los servicios
Para levantar tanto la base de datos PostgreSQL como la aplicación React servida por Nginx de forma local en segundo plano (detached):
```bash
docker compose up -d
```
Esto iniciará:
- El **Frontend** en el puerto host **`8081`** (mapeado desde el puerto no privilegiado `8080` del contenedor).
- El **Backend (db)** en el puerto host **`5433`** (mapeado desde el puerto `5432` de PostgreSQL).
- La inicialización automática de la base de datos `desafio` a través de `init.sql`.

### 3. Verificar el estado de los contenedores
Para comprobar que ambos contenedores se están ejecutando correctamente:
```bash
docker compose ps
```

### 4. Verificar los registros insertados en la base de datos
Para corroborar que la base de datos se inicializó de forma correcta y que los registros de prueba están en la tabla `usuarios`, ejecuta el siguiente comando:
```bash
docker compose exec db psql -U postgres -d desafio -c "SELECT * FROM usuarios;"
```

### 5. Acceso Web
Abre tu navegador e ingresa a:
- [http://localhost:8081](http://localhost:8081)

---

## Apagar y limpiar servicios
Para detener los contenedores sin borrar los datos persistentes:
```bash
docker compose down
```

Para detener los contenedores y eliminar el volumen de datos persistentes asociado (`db-data`):
```bash
docker compose down -v
```
