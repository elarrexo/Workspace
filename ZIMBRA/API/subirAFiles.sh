#!/bin/bash

# Obtener el token de autenticación
auth_response=$(curl -X POST \
  -H "Content-Type: application/xml" \
  -H "SOAPAction: urn:zimbraAccount" \
  -d '<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns="urn:zimbraAccount">
    <soap:Body>
      <AuthRequest>
        <account by="id">6af469e4-95be-414b-91c0-10b1d4a8cb60</account>
        <password>Tempo2023.</password>
      </AuthRequest>
    </soap:Body>
  </soap:Envelope>' \
  -k https://172.16.99.30/service/soap/)


auth_token=$(echo "${auth_response}" | grep -oPm1 '<authToken>\K[^<]+')

# Preparar la solicitud de carga de archivos
file_path="/home/darwin/hola.txt"
parent_id="LOCAL_ROOT"
filename="my-file.txt"

upload_body='{
  "file": "$file_path",
  "parent_id": "$parent_id",
  "name": "$filename"
}'

# Enviar la solicitud
curl -X POST \
  -H "Content-Type: application/json" \
  -H "Cookie: ZM_AUTH_TOKEN=$auth_token" \
  -d "$upload_body" \
 -k https://172.16.99.30/services/files/upload
