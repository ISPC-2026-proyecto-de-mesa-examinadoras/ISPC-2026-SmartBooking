# Plan mínimo — Login y registro (libre DWAD)

Solo lo exigido para **Splash**, **Login**, **Registro** y **Home** placeholder.

## Sprint 1 — API auth

| ID | Tarea |
|----|--------|
| #TK01 | Contrato Postman: `POST /api/auth/register/` y `POST /api/auth/login/` |
| #TK02 | Retrofit + Gson |
| #TK03 | `API_BASE_URL` en `local.properties` → `BuildConfig` |
| #TK04 | Paquetes `data.*` y `utils` |
| #TK05 | `ApiService` con los dos POST de auth |

## Sprint 2 — Pantallas

| ID | Tarea |
|----|--------|
| #US02 | Registro con contraseña robusta → `POST /api/auth/register/` |
| #TK06–#TK10 | Formulario, validación, errores 400, loading/red |
| #US03 | Login → `POST /api/auth/login/` → token → `HomeActivity` |

**Fuera de este alcance (issues cerrados en GitHub hasta próxima etapa):** refresh, logout, reservas, tests formales, APK release.