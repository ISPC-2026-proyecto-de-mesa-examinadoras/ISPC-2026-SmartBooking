#  SmartBooking Solutions - Gestión de reservas para espacios de coworking

### ISPC-2026 - Programador de Aplicaciones para Móviles - Segundo Cuatrimestre 2026

##  Descripción del Proyecto

**SmartBooking Solutions** es una aplicación móvil desarrollada para facilitar la gestión de reservas de un espacio de coworking, permitiendo a los usuarios y administradores organizar y administrar las reservas desde dispositivos Android.

El sistema busca ofrecer una solución que permita gestionar el uso de las salas, evitando conflictos de horarios y facilitando la administración de las reservas.

La aplicación se conecta con una API REST desarrollada con Django REST Framework, que permite gestionar la información y mantenerla sincronizada con la base de datos.

SmartBooking Solutions propone una plataforma sencilla, organizada y accesible, que permite a los usuarios administrar sus propias reservas y a los administradores gestionar los usuarios y las reservas del sistema.

##  Objetivo del proyecto

Desarrollar una aplicación móvil para Android que permita gestionar reservas de un espacio de coworking, ofreciendo funcionalidades de registro, autenticación, consulta, creación, modificación y cancelación de reservas, con diferentes permisos según el tipo de usuario.

##  Funcionalidades de la aplicación

###  Autenticación de usuarios

- Registro de nuevos usuarios.
- Inicio de sesión mediante correo electrónico y contraseña.
- Autenticación mediante tokens JWT.
- Identificación de usuarios según su rol.
- Acceso a funcionalidades según los permisos correspondientes.
- Cierre de sesión.

###  Usuario estándar

El usuario dispone de las siguientes funcionalidades:

- Registrarse e iniciar sesión.
- Consultar y modificar sus datos personales.
- Crear nuevas reservas.
- Consultar el listado de sus reservas.
- Visualizar los detalles de una reserva.
- Modificar sus propias reservas.
- Cancelar sus reservas.

###  Administrador

El administrador dispone de funcionalidades de gestión del sistema.

**Gestión de usuarios:**

- Consultar los usuarios registrados.
- Activar o desactivar usuarios.
- Modificar el rol de los usuarios.

**Gestión de reservas:**

- Consultar todas las reservas.
- Crear nuevas reservas.
- Modificar reservas existentes.
- Cancelar o eliminar reservas.

###  Gestión de reservas

Las reservas permiten registrar:

- Fecha de la reserva.
- Hora de inicio.
- Hora de finalización.
- Motivo u observaciones.

**Reglas de negocio:**

- No se permiten reservas que se superpongan en la misma sala.
- No se permiten reservas en fechas u horarios pasados.
- La hora de finalización debe ser posterior a la hora de inicio.
- Los usuarios estándar solamente pueden consultar y modificar sus propias reservas.
- Los administradores pueden gestionar las reservas de todos los usuarios.

##  Tecnologías utilizadas

- **Android Studio:** entorno de desarrollo de la aplicación móvil.
- **Java:** lenguaje de programación para Android.
- **XML:** diseño de las interfaces de usuario.
- **Retrofit o Volley:** comunicación entre la aplicación y la API REST.
- **Gson o Moshi:** conversión de datos JSON.
- **Django:** desarrollo del backend.
- **Django REST Framework:** creación y gestión de la API REST.
- **MySQL:** sistema de gestión de bases de datos.
- **JWT:** autenticación mediante tokens.
- **Postman:** pruebas de los endpoints de la API.
- **Newman:** ejecución automatizada de pruebas de API.
- **Git y GitHub:** control de versiones y gestión del proyecto.

##  Arquitectura de la aplicación

La aplicación móvil utiliza una arquitectura cliente-servidor, en la que Android se comunica con un backend mediante una API REST.

El funcionamiento general es el siguiente:

1. El usuario interactúa con la aplicación Android.
2. La aplicación realiza solicitudes HTTP mediante Retrofit o Volley.
3. La API REST desarrollada con Django REST Framework recibe y procesa las solicitudes.
4. El backend realiza las operaciones correspondientes sobre la base de datos MySQL.
5. La API devuelve las respuestas en formato JSON.
6. La aplicación móvil procesa la información y muestra los resultados al usuario.

##  Seguridad

La aplicación incorpora diferentes mecanismos de seguridad para proteger la información y controlar el acceso a las funcionalidades del sistema.

- **Contraseñas robustas:** validación de contraseñas con más de 8 caracteres, números, letras y al menos un carácter especial.
- **Autenticación JWT:** utilización de tokens para identificar a los usuarios autenticados.
- **Control de sesiones:** expiración y renovación de tokens, además del cierre de sesión.
- **Control de roles y permisos:** diferenciación entre usuarios estándar y administradores.
- **Protección de reservas:** los usuarios solamente pueden acceder a sus propias reservas.
- **Gestión de secretos:** protección de credenciales y claves mediante variables de entorno.
- **Comunicación segura:** utilización de HTTPS cuando el backend se encuentre desplegado.
- **Almacenamiento seguro:** protección del token de autenticación en el dispositivo.
- **Registros de seguridad:** registro de intentos fallidos de inicio de sesión, accesos denegados y modificaciones administrativas.

##  Testing y control de calidad

El proyecto contempla pruebas para verificar el correcto funcionamiento de la aplicación y del backend.

- Elaboración de un plan de pruebas.
- Creación de al menos 10 casos de prueba.
- Pruebas funcionales y negativas.
- Pruebas de seguridad.
- Pruebas de los endpoints mediante Postman y Newman.
- Pruebas de accesibilidad mediante TalkBack.
- Registro y seguimiento de errores mediante GitHub Issues.
- Matriz de trazabilidad entre pruebas e historias de usuario.

##  Instalación de la aplicación

Para instalar SmartBooking Solutions en un dispositivo Android:

- Acceder al enlace de descarga del APK.
- Descargar el archivo de instalación.
- Abrir el archivo desde el dispositivo Android.
- Autorizar la instalación desde esa fuente si Android lo solicita.
- Completar la instalación y abrir SmartBooking Solutions.

**Link del APK:**

[Pendiente de completar]

**Usuarios para probar la aplicación:**

**Usuario estándar**
- Usuario: [Pendiente]
- Contraseña: [Pendiente]

**Administrador**
- Usuario: [Pendiente]
- Contraseña: [Pendiente]

**Link del video demostrativo:**

[Pendiente de completar]

##  Documentación del proyecto

La documentación del proyecto se encontrará disponible en la Wiki de GitHub.

Se incluirán las siguientes secciones:

- Diseño y arquitectura del sistema.
- Diagrama Entidad-Relación (DER).
- Modelo Relacional.
- Diseño de clases.
- Plan de ciberseguridad.
- Plan y casos de prueba.
- Documentación de accesibilidad.

**Link de la Wiki:** [Pendiente de completar]

##  Integrantes del equipo

| Integrante | Rol |
|------------|------|
| Kevin Cristofer Lorea Tannfeld | Scrum Master y Developer |
| [Nombre del integrante] | [Rol] |

##  Repositorio

**GitHub:** https://github.com/ISPC-2026-proyecto-de-mesa-examinadoras/ISPC-2026-SmartBooking

