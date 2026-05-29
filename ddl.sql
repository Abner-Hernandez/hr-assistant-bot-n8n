-- ==========================================
-- 1. CREACIÓN DE TABLAS (ESQUEMA PUBLIC)
-- ==========================================

-- Tabla Maestra de Empleados
CREATE TABLE "public"."empleados" (
    "id" SERIAL PRIMARY KEY,
    "nombre" VARCHAR(100) NOT NULL,
    "email" VARCHAR(150) NOT NULL,
    "departamento" VARCHAR(100) NOT NULL,
    "puesto" VARCHAR(100) NOT NULL,
    "fecha_ingreso" DATE NOT NULL,
    "saldo_vacaciones" INTEGER DEFAULT 0 NOT NULL,
    "banco_horas" NUMERIC(5, 1) DEFAULT 0.0 NOT NULL,
    "modalidad" VARCHAR(20) DEFAULT 'hibrido' NOT NULL,
    "codigo_corporativo" VARCHAR(20),
    CONSTRAINT "empleados_email_key" UNIQUE ("email"),
    CONSTRAINT "empleados_codigo_corporativo_key" UNIQUE ("codigo_corporativo")
);

-- Tabla de Control de Canales y Sesiones (Telegram)
CREATE TABLE "public"."canales_autenticados" (
    "id" SERIAL PRIMARY KEY,
    "empleado_id" INTEGER,
    "plataforma" VARCHAR(30) NOT NULL,
    "canal_user_id" VARCHAR(255) NOT NULL,
    "nombre_canal" VARCHAR(255),
    "autenticado" BOOLEAN DEFAULT FALSE NOT NULL,
    "estado" VARCHAR(50) DEFAULT 'pendiente' NOT NULL,
    "intentos_fallidos" INTEGER DEFAULT 0 NOT NULL,
    "bloqueado" BOOLEAN DEFAULT FALSE NOT NULL,
    "fecha_autenticacion" TIMESTAMP,
    "ultimo_acceso" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "creado_en" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "canales_autenticados_plataforma_canal_user_id_key" UNIQUE ("plataforma", "canal_user_id")
);

-- Tabla de Credenciales de Acceso Cifradas
CREATE TABLE "public"."credenciales" (
    "id" SERIAL PRIMARY KEY,
    "empleado_id" INTEGER NOT NULL,
    "password_hash" TEXT NOT NULL,
    "password_temporal" BOOLEAN DEFAULT TRUE NOT NULL,
    "requiere_cambio_password" BOOLEAN DEFAULT TRUE NOT NULL,
    "ultimo_cambio_password" TIMESTAMP,
    "activo" BOOLEAN DEFAULT TRUE NOT NULL,
    "creado_en" TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT "credenciales_empleado_id_key" UNIQUE ("empleado_id")
);

-- ==========================================
-- 2. CREACIÓN DE ÍNDICES
-- ==========================================
CREATE UNIQUE INDEX IF NOT EXISTS "empleados_pkey" ON "public"."empleados" ("id");
CREATE UNIQUE INDEX IF NOT EXISTS "canales_autenticados_pkey" ON "public"."canales_autenticados" ("id");
CREATE UNIQUE INDEX IF NOT EXISTS "credenciales_pkey" ON "public"."credenciales" ("id");
CREATE UNIQUE INDEX IF NOT EXISTS "uq_codigo_corporativo" ON "public"."empleados" ("codigo_corporativo");

-- ==========================================
-- 3. RELACIONES Y LLAVES FORÁNEAS (CONSTRAINTS)
-- ==========================================
ALTER TABLE "public"."canales_autenticados" 
    ADD CONSTRAINT "canales_autenticados_empleado_id_fkey" 
    FOREIGN KEY ("empleado_id") REFERENCES "public"."empleados" ("id") ON DELETE CASCADE;

ALTER TABLE "public"."credenciales" 
    ADD CONSTRAINT "credenciales_empleado_id_fkey" 
    FOREIGN KEY ("empleado_id") REFERENCES "public"."empleados" ("id") ON DELETE CASCADE;