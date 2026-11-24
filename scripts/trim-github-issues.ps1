$ErrorActionPreference = "Stop"
$input = "protocol=https`nhost=github.com`n`n"
$cred = $input | git credential fill 2>$null
$u = ($cred | Select-String '^username=').ToString().Substring(9)
$p = ($cred | Select-String '^password=').ToString().Substring(9)
$headers = @{
    Authorization = "Basic $([Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes("${u}:${p}")))"
    Accept        = "application/vnd.github+json"
    "User-Agent"  = "SmartBooking"
}
$base = "https://api.github.com/repos/ISPC-2026-proyecto-de-mesa-examinadoras/ISPC-2026-SmartBooking/issues"

$short = @{
    4  = "**Libre DWAD · Sprint 1**`n`nDocumentar en Postman:`n- POST /api/auth/register/`n- POST /api/auth/login/`n`nEntregable: JSON request/response acordado con backend."
    5  = "**Sprint 1** · Retrofit + Gson + OkHttp. Compila assembleDebug."
    6  = "**Sprint 1** · API_BASE_URL en local.properties y BuildConfig."
    7  = "**Sprint 1** · Paquetes data.api, data.model, data.local, utils."
    8  = "**Sprint 1** · ApiService solo auth (register, login)."
    9  = "**#US01** Splash — Hecho (PR #3)."
    10 = "**#US02** Registro → POST /api/auth/register/ · contraseña robusta (libre DWAD)."
    11 = "**Sprint 2** · Formulario sin campos ServiMatch; solo lo del serializer."
    12 = "**Sprint 2** · Validación app: >8 chars, letra, número, especial."
    13 = "**Sprint 2** · Llamada Retrofit register; 201 → Login."
    14 = "**Sprint 2** · Mostrar errores 400 del backend."
    15 = "**Sprint 2** · Progress + error de red en registro."
    16 = "**#US03** Login → POST /api/auth/login/ → HomeActivity (libre DWAD)."
}

foreach ($num in $short.Keys | Sort-Object) {
    $json = @{ body = $short[$num] } | ConvertTo-Json
    $null = Invoke-RestMethod -Method Patch -Uri "$base/$num" -Headers $headers -Body $json -ContentType "application/json; charset=utf-8"
    Write-Output "TRIM #$num"
    Start-Sleep -Milliseconds 250
}

17..26 | ForEach-Object {
    $json = @{ state = "closed"; body = "Pospuesto: fuera del alcance minimo login/registro (libre DWAD). Reabrir en etapa reservas/sesion." } | ConvertTo-Json
    $null = Invoke-RestMethod -Method Patch -Uri "$base/$_" -Headers $headers -Body $json -ContentType "application/json; charset=utf-8"
    Write-Output "CLOSE #$_"
    Start-Sleep -Milliseconds 250
}

Write-Output "DONE"