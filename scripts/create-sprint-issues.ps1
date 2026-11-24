$input = "protocol=https`nhost=github.com`n`n"
$cred = $input | git credential fill 2>$null
if (-not $cred) {
  Write-Error "No hay credenciales Git para github.com. Hace push o git credential antes."
  exit 1
}
$usernameLine = $cred | Select-String '^username='
$passwordLine = $cred | Select-String '^password='
if (-not $usernameLine -or -not $passwordLine) {
  Write-Error "Credenciales incompletas. Ejecuta: gh auth login o git push para refrescar."
  exit 1
}
$username = $usernameLine.ToString().Substring(9)
$password = $passwordLine.ToString().Substring(9)
$pair = "${username}:${password}"
$basic = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($pair))
$headers = @{ Authorization = "Basic $basic"; Accept = "application/vnd.github+json"; "User-Agent" = "SmartBooking" }
$repo = "ISPC-2026-proyecto-de-mesa-examinadoras/ISPC-2026-SmartBooking"
$base = "https://api.github.com/repos/$repo"

$sprints = @(
  @{ key = "S1"; title = "Sprint 1 - Infraestructura API"; desc = "Retrofit, BuildConfig, paquetes y contrato Postman para auth."; due = "2026-11-24T23:59:59Z" }
  @{ key = "S2"; title = "Sprint 2 - Registro"; desc = "RegistroActivity + POST /api/auth/register/ segun DWAD."; due = "2026-11-28T23:59:59Z" }
  @{ key = "S3"; title = "Sprint 3 - Login y sesion"; desc = "Login JWT, SessionManager, Home por rol."; due = "2026-12-01T23:59:59Z" }
  @{ key = "S4"; title = "Sprint 4 - Calidad y entrega"; desc = "Tests, README, PR, APK y demo."; due = "2026-12-07T23:59:59Z" }
)

$milestoneIds = @{}
foreach ($s in $sprints) {
  $body = @{ title = $s.title; description = $s.desc; due_on = $s.due; state = "open" } | ConvertTo-Json
  $m = Invoke-RestMethod -Method Post -Uri "$base/milestones" -Headers $headers -Body $body -ContentType "application/json; charset=utf-8"
  $milestoneIds[$s.key] = $m.number
  Write-Output "MILESTONE $($m.number): $($s.title)"
}

$issues = @(
  @{ m = "S1"; title = "#TK01 Confirmar contrato Postman register/login"; body = "Sprint 1. Ver docs/SPRINTS.md" }
  @{ m = "S1"; title = "#TK02 Agregar Retrofit, Gson y OkHttp"; body = "Sprint 1" }
  @{ m = "S1"; title = "#TK03 Configurar API_BASE_URL en BuildConfig"; body = "Sprint 1" }
  @{ m = "S1"; title = "#TK04 Crear paquetes data y utils"; body = "Sprint 1" }
  @{ m = "S1"; title = "#TK05 ApiService y RetrofitClient base"; body = "Sprint 1" }
  @{ m = "S1"; title = "#US01 Splash de bienvenida"; body = "Estado: hecho (PR #3)." }
  @{ m = "S2"; title = "#US02 Como usuario quiero registrarme en la app"; body = "POST /api/auth/register/" }
  @{ m = "S2"; title = "#TK06 Ajustar formulario de registro SmartBooking"; body = "Sprint 2" }
  @{ m = "S2"; title = "#TK07 Validacion contrasena robusta en app"; body = "Sprint 2" }
  @{ m = "S2"; title = "#TK08 POST /api/auth/register/ con Retrofit"; body = "Sprint 2" }
  @{ m = "S2"; title = "#TK09 Manejo errores 400 por campo"; body = "Sprint 2" }
  @{ m = "S2"; title = "#TK10 Estados loading y error de red en registro"; body = "Sprint 2" }
  @{ m = "S3"; title = "#US03 Como usuario quiero iniciar sesion"; body = "POST /api/auth/login/" }
  @{ m = "S3"; title = "#TK11 POST /api/auth/login/"; body = "Sprint 3" }
  @{ m = "S3"; title = "#TK12 SessionManager sin guardar contrasena"; body = "Sprint 3" }
  @{ m = "S3"; title = "#TK13 Interceptor Authorization Bearer"; body = "Sprint 3" }
  @{ m = "S3"; title = "#TK14 HomeActivity segun rol"; body = "Sprint 3" }
  @{ m = "S3"; title = "#TK15 Manejo HTTP 401 en login"; body = "Sprint 3" }
  @{ m = "S4"; title = "#TK16 Casos de prueba auth minimo 3"; body = "Sprint 4" }
  @{ m = "S4"; title = "#TK17 Actualizar README auth"; body = "Sprint 4" }
  @{ m = "S4"; title = "#TK18 PR loginYregistro hacia develop"; body = "Sprint 4" }
  @{ m = "S4"; title = "#TK19 Publicar APK en GitHub Releases"; body = "Sprint 4" }
  @{ m = "S4"; title = "#TK20 Demo en dispositivo con backend"; body = "Sprint 4" }
)

foreach ($i in $issues) {
  $mid = $milestoneIds[$i.m]
  $payload = @{ title = $i.title; body = $i.body; milestone = $mid }
  $json = $payload | ConvertTo-Json
  $iss = Invoke-RestMethod -Method Post -Uri "$base/issues" -Headers $headers -Body $json -ContentType "application/json; charset=utf-8"
  Write-Output "ISSUE #$($iss.number): $($i.title)"
  Start-Sleep -Milliseconds 350
}