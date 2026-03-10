# Guía de Pruebas - Fase 1 (Auth & E2EE)

Sigue estos pasos para verificar que la base del sistema está funcionando correctamente.

## 1. Levantar la Infraestructura
Asegúrate de que Docker esté corriendo y ejecuta:
```bash
cd infra
docker compose up -d
```
Esto levantará **PostgreSQL**, **Redis** y **MinIO**.

## 2. Iniciar el Backend
En una terminal nueva:
```bash
cd apps/backend
npm install
npm run start:dev
```
El servidor debería mostrar: `Application is running on: http://localhost:3000`.

## 3. Crear una Invitación Inicial
Para poder registrarte, necesitas un código de invitación en la base de datos. Puedes ejecutar este comando SQL en tu Postgres (o usar un script):

```sql
-- Conéctate a la DB (chatdb) y ejecuta:
INSERT INTO invitations (id, code, "maxUses", uses, "createdAt") 
VALUES (gen_random_uuid(), 'FOTO2024', 10, 0, now());
```

## 4. Probar con Postman o Insomnia
Puedes verificar los endpoints manualmente antes de usar la app Flutter:

### A. Registro (con invitación)
- **POST** `http://localhost:3000/auth/register`
- **Body (JSON)**:
  ```json
  {
    "email": "test@example.com",
    "username": "fotografo1",
    "password": "Password123!",
    "invitationCode": "FOTO2024"
  }
  ```

### B. Login
- **POST** `http://localhost:3000/auth/login`
- **Body (JSON)**:
  ```json
  {
    "identifier": "fotografo1",
    "password": "Password123!"
  }
  ```
- **Resultado**: Recibirás un `access_token`.

### C. Subir Claves E2EE (Simulado)
Para probar que el servidor guarda las claves del Dispositivo:
- **POST** `http://localhost:3000/keys/upload`
- **Headers**: `Authorization: Bearer <TOKEN_RECIBIDO>`
- **Body (JSON)**:
  ```json
  {
    "deviceId": 1,
    "identityPublicKey": "SGVsbG8gd29ybGQ=",
    "signedPreKey": {
      "id": 1,
      "publicKey": "U2lnbmVkUHJlS2V5",
      "signature": "U2lnbmF0dXJl"
    },
    "oneTimePreKeys": [
      { "id": 1, "publicKey": "T05LMQ==" },
      { "id": 2, "publicKey": "T05LMgo=" }
    ]
  }
  ```

## 5. Verificar en la App Móvil
Si tienes un entorno de Flutter listo:
1. Asegúrate de que el backend sea accesible desde el emulador (usa `10.0.2.2` en lugar de `localhost` si es Android).
2. Ejecuta `flutter run` en `apps/mobile`. 
3. (Próximamente agregaremos las pantallas de UI; por ahora puedes ver los logs de los servicios que creamos).
