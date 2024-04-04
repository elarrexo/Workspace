#!/bin/bash

# URL de la API SOAP de Zimbra para la autenticación de administración
api_url="https://172.16.99.30:6071/service/admin/soap/"

# Nombre de usuario y contraseña del administrador para autenticación
admin_username="zextras@sync.com.ec"
admin_password="f1lt4n3t."

# Construir la solicitud de autenticación para obtener el token de administración
auth_request="<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:urn=\"urn:zimbraAdmin\">
  <soapenv:Body>
    <urn:AuthRequest>
      <urn:name>${admin_username}</urn:name>
      <urn:password>${admin_password}</urn:password>
    </urn:AuthRequest>
  </soapenv:Body>
</soapenv:Envelope>"

# Realizar la solicitud de autenticación para obtener el token de administración
auth_response=$(curl -s -k -X POST -H "Content-Type: text/xml" -d "${auth_request}" ${api_url})

# Extraer el token de administración de la respuesta
admin_auth_token=$(echo "${auth_response}" | grep -oPm1 '<authToken>\K[^<]+')

# Verificar si se obtuvo un token de administración válido
if [ -n "$admin_auth_token" ]; then
  echo "Token de administración obtenido con éxito: ${admin_auth_token}"

  # Resto del script para realizar acciones de administración
  # Puedes agregar aquí el código para realizar operaciones de administración utilizando el token de administración
 # Datos de la cuenta a crear
  account_name="testo12@filtanet.net"
  account_password="FF1lt4n3to2023."  # Opcional, si no se proporciona, eliminar esta línea

  # Construir la solicitud SOAP con el token de autenticación
  request="<?xml version=\"1.0\" encoding=\"UTF-8\"?>
  <soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:urn=\"urn:zimbraAdmin\">
    <soapenv:Header>
      <context xmlns=\"urn:zimbra\">
        <authToken>${admin_auth_token}</authToken>
      </context>
    </soapenv:Header>
    <soapenv:Body>
      <urn:CreateAccountRequest name=\"${account_name}\""
  if [ -n "$account_password" ]; then
      request="$request password=\"${account_password}\""
  fi
  request="$request/>
    </soapenv:Body>
  </soapenv:Envelope>"

  # Realizar la solicitud SOAP con el token de autenticación
  response=$(curl -s -k -X POST -H "Content-Type: text/xml" -d "${request}" ${api_url})


else
  echo "Error al obtener el token de administración."
fi
# ejemplo de github
# hola
# hola2 