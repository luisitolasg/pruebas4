#!/bin/bash

# Variables necesarias
export Key='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'
FROM="luisito.ds1jc@gmail.com"
TO="luisito.ds1jc@gmail.com"
SUBJECT="Reporte economico de ventas efectuados diariamente [Proyecto Final]"
MESSAGE="Le adjunto el reporte de ventas del dia de hoy"
REPORTE=$(base64 -w 0 /workspaces/ProyectoFinal/reporte_diario.txt)

# Notificación inicial
echo "Enviando correo..."

# Solicitud a SendGrid
response=$(curl --write-out "%{http_code}" --silent --output /dev/null \
  --request POST \
  --url https://api.sendgrid.com/v3/mail/send \
  --header "Authorization: Bearer $Key" \
  --header 'Content-Type: application/json' \
  --data '{
    "personalizations": [{"to": [{"email": "'"$TO"'"}]}],
    "from": {"email": "'"$FROM"'"},
    "subject": "'"$SUBJECT"'",
    "content": [{"type": "text/html", "value": "'"$MESSAGE"'"}],
    "attachments": [{
      "content": "'"$REPORTE"'",
      "type": "text/plain",
      "filename": "reporte_diario.txt",
      "disposition": "attachment"
    }]
  }')

# Evaluación de la respuesta
if [ "$response" -eq 202 ]; then
  echo "Correo enviado exitosamente. Código HTTP: $response"
else
  echo "Error al enviar el correo. Código HTTP: $response"
  echo "Revisa los parámetros y verifica que el API Key y la estructura del JSON sean correctos."
fi