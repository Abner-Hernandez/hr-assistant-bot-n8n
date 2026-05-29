# HR Buddy - Automation System 🚀

**HR Buddy** es un ecosistema automatizado de asistencia virtual y gestión de Recursos Humanos diseñado para **ChocolaTech**. El sistema permite a los colaboradores autenticarse de manera segura a través de **Telegram** y realizar consultas en tiempo real sobre su información laboral (como saldo de vacaciones, puesto y departamento) interactuando de forma natural con un Agente de Inteligencia Artificial.

Este repositorio centraliza tanto la lógica de automatización visual en **n8n** como el diseño de la arquitectura de datos en **PostgreSQL**.

---

## 🛠️ Arquitectura Tecnológica

El proyecto se sostiene sobre tres pilares principales:

1. **Orquestación (n8n):** Flujo avanzado basado en nodos LangChain que gestiona el control de estados de la conversación, la memoria contextual y la ejecución de herramientas de IA (*Tool Calling*).
2. **Capa de Datos (PostgreSQL / Neon):** Base de datos relacional encargada del almacenamiento seguro de credenciales cifradas, control de dispositivos autenticados e información maestra de empleados.
3. **Interfaz de Usuario (Telegram Bot API):** Canal conversacional accesible y amigable para el usuario final.

---

## 📊 Modelo de Datos (DDL)

El sistema opera bajo un esquema relacional estructurado que separa el núcleo de negocio de la gestión de accesos:

*   **`public.empleados`**: Almacena el perfil del colaborador, incluyendo información contractual y balances clave (`saldo_vacaciones`, `banco_horas`).
*   **`public.canales_autenticados`**: Registra el estado de la sesión y el enlace único entre la ID de la plataforma de mensajería (Telegram) y el identificador secuencial de `empleados`.
*   **`public.credenciales`**: Aloja las contraseñas cifradas utilizando funciones criptográficas nativas (`crypt` con `bf`).

---

## 🚀 Requisitos Previos

Antes de desplegar el sistema, asegúrate de contar con:

*   Una instancia activa de **n8n** (v1.0 o superior) con soporte para nodos de IA Avanzada (LangChain).
*   Una cuenta de **Telegram** y un token de Bot generado a través de `@BotFather`.
*   Un clúster de **PostgreSQL** (compatible con extensiones criptográficas como `pgcrypto`).
*   Credenciales de API de **Cohere** (para el modelo de lenguaje `Cohere Chat` y los `Embeddings`).

---

## 🔧 Instrucciones de Despliegue

### 1. Inicialización de la Base de Datos
Ejecuta el script SQL incluido en este repositorio (`database/ddl.sql` o el bloque de código provisto) en tu gestor de base de datos para levantar los esquemas, tablas, índices y restricciones de llaves foráneas requeridas.

### 2. Importación del Flujo en n8n
1. Descarga el archivo de automatización JSON provisto en este repositorio.
2. Abre tu panel de n8n, crea un nuevo flujo (*Workflow*).
3. En la esquina superior derecha, selecciona la opción **Import from File** y selecciona el archivo JSON.

### 3. Configuración de Credenciales en n8n
Asegúrate de vincular y validar las siguientes conexiones dentro del flujo importado:
*   **Telegram API:** Configura el token de tu bot en el nodo *Telegram Trigger* y *mensaje user*.
*   **Postgres Account:** Configura los datos de conexión a tu base de datos Neon en todos los nodos que interactúan con SQL.
*   **Cohere API:** Provee tu API Key en los nodos *Cohere Chat Model* y *Embeddings Cohere*.

---

## 🔒 Flujo de Autenticación y Seguridad

El Agente de IA cuenta con un blindaje perimetral controlado por un nodo `Switch` que evalúa el estado del canal en tiempo real:

```text
[Mensaje Recibido] 
       │
       ▼
¿Existe Registro? ──(No)──► Solicitar Correo ──► Enviar Código ──► Registrar Contraseña
       │
      (Sí)
       │
¿Está Autenticado? ──(No)──► Verificar Contraseña
       │
      (Sí)
       ▼
[Activar AI Agent + Acceso Seguro a PostgresTool]
