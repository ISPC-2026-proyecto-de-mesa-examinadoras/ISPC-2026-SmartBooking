$ErrorActionPreference = "Stop"
$input = "protocol=https`nhost=github.com`n`n"
$cred = $input | git credential fill 2>$null
if (-not $cred) { throw "Sin credenciales GitHub. Hace git push o gh auth login." }
$u = ($cred | Select-String '^username=').ToString().Substring(9)
$p = ($cred | Select-String '^password=').ToString().Substring(9)
$headers = @{
    Authorization = "Basic $([Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes("${u}:${p}")))"
    Accept        = "application/vnd.github+json"
    "User-Agent"  = "SmartBooking"
}
$base = "https://api.github.com/repos/ISPC-2026-proyecto-de-mesa-examinadoras/ISPC-2026-SmartBooking/issues"

$bodies = @{
    4  = @"
## Sprint 1 - Infraestructura API

### Objetivo
Documentar el contrato real del backend antes de implementar Retrofit.

### Alcance
- Probar en Postman ``POST /api/auth/register/`` y ``POST /api/auth/login/``.
- Registrar nombres exactos de campos JSON (request y response).
- Registrar codigos HTTP esperados: 201/400 en registro; 200/401 en login.
- Actualizar la coleccion Postman del equipo (o adjuntar export .json en Wiki).

### Criterios de aceptacion
- [ ] Request de registro documentado (campos obligatorios).
- [ ] Response exitosa y errores 400 con estructura de campos.
- [ ] Login devuelve ``access`` y ``refresh`` (o el formato acordado con backend).
- [ ] El equipo Android tiene una copia compartida del contrato.

### Referencias
- Libre DWAD: endpoints minimos de auth.
- Repo: ``docs/SPRINTS.md``
"@
    5  = @"
## Sprint 1

### Objetivo
Agregar dependencias de red en la app Android.

### Tareas
- Retrofit 2.x
- Gson converter (o Moshi si el equipo lo define)
- OkHttp (logging solo en debug)

### Criterios de aceptacion
- [ ] Dependencias en ``app/build.gradle``.
- [ ] ``./gradlew assembleDebug`` compila sin errores.
- [ ] No hay conflictos de version con Material/AppCompat actuales.

### Entregable
Build exitoso en rama ``loginYregistro``.
"@
    6  = @"
## Sprint 1

### Objetivo
Configurar la URL del backend sin hardcodear en codigo versionado.

### Tareas
- Clave ``API_BASE_URL`` en ``local.properties`` (gitignored).
- Exponer en ``BuildConfig.API_BASE_URL`` desde ``app/build.gradle``.
- Documentar en README como configurarlo en cada maquina.

### Criterios de aceptacion
- [ ] ``local.properties.example`` o instruccion en README.
- [ ] La URL no aparece en archivos Java commiteados.
- [ ] Cumple politica de secretos del enunciado.
"@
    7  = @"
## Sprint 1

### Objetivo
Organizar el codigo segun el enunciado del final.

### Estructura sugerida
- ``com.ispc.smartbooking.data.api``
- ``com.ispc.smartbooking.data.model``
- ``com.ispc.smartbooking.data.local``
- ``com.ispc.smartbooking.utils``

### Criterios de aceptacion
- [ ] Paquetes creados y usados al menos en una clase de cada capa.
- [ ] Sin mezclar UI con llamadas HTTP dentro de Activities (preparar extraccion).
"@
    8  = @"
## Sprint 1

### Objetivo
Cliente HTTP base listo para auth.

### Tareas
- Interface ``ApiService`` con:
  - ``POST api/auth/register/``
  - ``POST api/auth/login/``
- ``RetrofitClient`` singleton con timeout razonable.
- Base URL desde ``BuildConfig``.

### Criterios de aceptacion
- [ ] Rutas relativas correctas (sin duplicar host).
- [ ] Gson serializa modelos de prueba.
- [ ] Listo para agregar interceptor Bearer en Sprint 3.
"@
    9  = @"
## Sprint 1 (cerrado)

### Historia de usuario
**#US01** Como usuario quiero ver una pantalla de inicio al abrir la app para identificar SmartBooking.

### Estado
**Completado** — mergeado en ``develop`` via PR #3.

### Criterios de aceptacion (cumplidos)
- [x] ``SplashActivity`` con texto SmartBooking.
- [x] Transicion automatica a pantalla siguiente (login).
- [x] Tema splash sin action bar.

### Evidencia
Rama ``inicioFeature`` / commit en ``develop``.
"@
    10 = @"
## Sprint 2 - Registro

### Historia de usuario
**#US02** Como usuario quiero registrarme desde la app para poder iniciar sesion y gestionar reservas.

### Criterios de aceptacion
- [ ] Formulario alineado al serializer Django (sin campos de otro proyecto).
- [ ] Validacion de contrasena robusta en cliente (>8, letras, numeros, especial).
- [ ] ``POST /api/auth/register/`` exitoso → navegacion a login con email precargado.
- [ ] Errores 400 del backend mostrados en el formulario.
- [ ] Sin datos simulados (no solo Toast local).

### Endpoint
``POST /api/auth/register/`` (publico)

### Tareas vinculadas
#TK06 #TK07 #TK08 #TK09 #TK10
"@
    11 = @"
## Sprint 2

### Objetivo
Quitar del registro campos que no pertenecen a SmartBooking coworking si la API auth no los pide.

### Tareas
- Revisar contrato #TK01.
- Ajustar ``activity_register.xml`` y ``RegisterActivity``.
- Eliminar DNI / ubicacion / oficio si no estan en ``/api/auth/register/``.
- Agregar confirmacion de contrasena si el backend la exige.

### Criterios de aceptacion
- [ ] UI coincide con JSON de registro documentado.
- [ ] Labels y accesibilidad (hints, ``labelFor``).
"@
    12 = @"
## Sprint 2

### Objetivo
Cumplir politica de contrasenas del examen en la app.

### Regla
Mas de 8 caracteres, alfanumerica, al menos un caracter especial.

### Criterios de aceptacion
- [ ] Validacion antes de llamar a la API.
- [ ] Mensaje con ``TextInputLayout.setError()``.
- [ ] Misma regla documentada en README / plan de seguridad.
"@
    13 = @"
## Sprint 2

### Objetivo
Conectar el boton Registrarse al backend.

### Tareas
- Modelo ``RegisterRequest`` segun Postman.
- Llamada Retrofit asincrona.
- 201 Created: mensaje + ir a ``LoginActivity``.
- Deshabilitar boton durante la peticion.

### Criterios de aceptacion
- [ ] Registro real contra servidor del grupo (no mock).
- [ ] No se guarda la contrasena en el dispositivo.
"@
    14 = @"
## Sprint 2

### Objetivo
Mostrar al usuario los errores que devuelve Django.

### Tareas
- Parsear JSON de error (por campo: email, password, etc.).
- Mapear a cada ``TextInputLayout``.
- Mensaje generico si el formato no es conocido.

### Criterios de aceptacion
- [ ] Email duplicado → mensaje claro.
- [ ] Contrasena debil rechazada por backend → visible en UI.
- [ ] Codigo 400 no deja pantalla en estado inconsistente.
"@
    15 = @"
## Sprint 2

### Objetivo
UX minima obligatoria en registro.

### Criterios de aceptacion
- [ ] Indicador de carga durante POST.
- [ ] Sin red / timeout → Toast o Snackbar comprensible.
- [ ] Boton habilitado de nuevo tras error.
"@
    16 = @"
## Sprint 3 - Login

### Historia de usuario
**#US03** Como usuario quiero iniciar sesion con email y contrasena para acceder a las funciones de la app.

### Criterios de aceptacion
- [ ] ``POST /api/auth/login/`` con credenciales validas.
- [ ] Tokens guardados de forma segura (sin contrasena).
- [ ] Navegacion segun rol (usuario / administrador).
- [ ] 401 con mensaje claro, sin entrar a la app.

### Endpoint
``POST /api/auth/login/`` (publico)

### Tareas vinculadas
#TK11 #TK12 #TK13 #TK14 #TK15
"@
    17 = @"
## Sprint 3

### Objetivo
Implementar login real con JWT.

### Tareas
- ``LoginRequest`` / ``LoginResponse`` segun backend.
- Guardar ``access`` (y ``refresh`` si aplica).
- Extraer rol o llamar perfil si el token no trae rol.

### Criterios de aceptacion
- [ ] Login exitoso no usa Toast simulado.
- [ ] ``finish()`` en login al entrar a home.
"@
    18 = @"
## Sprint 3

### Objetivo
Persistir sesion de forma segura.

### Tareas
- Clase ``SessionManager`` en ``data.local``.
- Guardar access/refresh; **nunca** contrasena.
- Preferir ``EncryptedSharedPreferences`` (o justificar alternativa en Wiki).

### Criterios de aceptacion
- [ ] Metodos: save, getAccess, clear.
- [ ] ``clear`` usado en logout futuro.
"@
    19 = @"
## Sprint 3

### Objetivo
Enviar token en requests protegidas.

### Tareas
- Interceptor OkHttp: ``Authorization: Bearer <token>``.
- No adjuntar token a register/login.

### Criterios de aceptacion
- [ ] Interceptor registrado en ``RetrofitClient``.
- [ ] Listo para endpoints de reservas en sprints siguientes.
"@
    20 = @"
## Sprint 3

### Objetivo
Pantalla posterior al login segun rol del enunciado.

### Tareas
- ``HomeActivity`` (usuario) placeholder con menu hacia reservas/perfil.
- Ruta admin (puede ser misma activity con UI distinta o activity separada).
- Reemplazar destino temporal ``MainActivity`` (Hello World).

### Criterios de aceptacion
- [ ] Admin y usuario no ven el mismo panel si el backend distingue roles.
- [ ] Back stack coherente desde login.
"@
    21 = @"
## Sprint 3

### Objetivo
Manejo de credenciales incorrectas.

### Criterios de aceptacion
- [ ] HTTP 401 → mensaje (correo o contrasena incorrectos).
- [ ] No se guarda token parcial.
- [ ] Usuario permanece en ``LoginActivity``.
"@
    22 = @"
## Sprint 4 - Calidad

### Objetivo
Evidencia de pruebas para la defensa.

### Minimo 3 casos
1. Registro con contrasena debil → rechazado (app y/o 400 API).
2. Login con credenciales invalidas → 401 y mensaje.
3. Registro + login exitoso → acceso a home.

### Criterios de aceptacion
- [ ] Casos en planilla / Wiki con codigo (ej. AUT-APP-01).
- [ ] Trazabilidad a #US02 / #US03.
"@
    23 = @"
## Sprint 4

### Objetivo
Documentar auth para el tribunal.

### Tareas
- Endpoints ``/api/auth/*`` en README.
- Usuarios de prueba (user + admin).
- URL del backend y como configurar ``local.properties``.

### Criterios de aceptacion
- [ ] README sin secciones [Pendiente] en auth.
- [ ] Link a coleccion Postman si existe.
"@
    24 = @"
## Sprint 4

### Objetivo
Integrar trabajo en ``develop``.

### Tareas
- PR ``loginYregistro`` → ``develop``.
- Descripcion con resumen, test plan y issues cerrados.
- Resolver conflictos si hay.

### Criterios de aceptacion
- [ ] Review del equipo.
- [ ] Sin Co-authored-by indebido en commits finales.
"@
    25 = @"
## Sprint 4

### Objetivo
Entregable instalable para la mesa.

### Tareas
- Generar APK (debug firmado o release segun criterio del grupo).
- Subir a GitHub Releases.
- Actualizar link en README.

### Criterios de aceptacion
- [ ] APK descargable desde el repo.
- [ ] Version documentada (versionCode/Name).
"@
    26 = @"
## Sprint 4

### Objetivo
Demostracion end-to-end para instancia sincronica.

### Checklist demo
- [ ] Dispositivo o emulador conectado al backend del grupo.
- [ ] Registro de usuario nuevo.
- [ ] Login y entrada segun rol.
- [ ] Splash → login → home sin crashes.

### Criterios de aceptacion
- [ ] Video corto o guion de demo en Wiki (opcional pero recomendado).
- [ ] Lista de pasos para el dia del examen.
"@
}

foreach ($num in $bodies.Keys | Sort-Object) {
    $json = @{ body = $bodies[$num] } | ConvertTo-Json
    $null = Invoke-RestMethod -Method Patch -Uri "$base/$num" -Headers $headers -Body $json -ContentType "application/json; charset=utf-8"
    Write-Output "UPDATED #$num"
    Start-Sleep -Milliseconds 300
}

Write-Output "DONE"