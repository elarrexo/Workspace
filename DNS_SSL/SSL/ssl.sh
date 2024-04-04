#!/bin/bash

# Lista de dominios a monitorear
DOMAINS=(
    "mail.sync.com.ec"
    "tipti.com.ec"
    "tipti.market"
    "tipti.us"
    "tipti.com.pa"
    # Agrega más dominios según sea necesario
)

# Configuración de InfluxDB
INFLUXDB_URL="http://172.16.99.28:8086/api/v2/write?org=filtanet&bucket=ssltipti&precision=s"
TOKEN="iwyuJgH8Lmr8zYgs2aAQWnk1Y9oP5wPk_Gzu2QBf_BVtkY_tCsi3AM7wn5N5m6Cn2iVr-sSG6FZ3xHnTWjq9NA=="

# Función para verificar la vigencia de un certificado SSL de forma remota
check_cert_expiry_remote() {
    local domain="$1"
    local result=$(echo | openssl s_client -servername "$domain" -connect "$domain":443 2>/dev/null | openssl x509 -noout -enddate)
    
    if [[ -n "$result" ]]; then
        local expiration_date=$(echo "$result" | cut -d '=' -f 2)
        local expiration_epoch=$(date -d "$expiration_date" +%s)
        local current_epoch=$(date +%s)
        local remaining_days=$(( (expiration_epoch - current_epoch) / 86400 ))

        if [[ $remaining_days -gt 0 ]]; then
            echo "El certificado para el dominio $domain está vigente. Expira en $remaining_days día(s)."
            # Envía información a InfluxDB
            send_to_influxdb "$domain" "$remaining_days"
        else
            echo "¡Atención! El certificado para el dominio $domain ha caducado."
            # Envía información a InfluxDB
            send_to_influxdb "$domain" "0"
        fi
    else
        echo "No se pudo obtener información sobre el certificado para el dominio $domain."
    fi
}

# Función para enviar datos a InfluxDB
send_to_influxdb() {
    local domain="$1"
    local remaining_days="$2"
    local timestamp=$(date +%s)

    local line_protocol="ssl_cert_expiry,domain=$domain remaining_days=$remaining_days $timestamp"
    curl -X POST -H "Authorization: Token $TOKEN" -H "Content-Type: text/plain" --data "$line_protocol" "$INFLUXDB_URL"
}

# Iterar sobre cada dominio y verificar la vigencia de su certificado SSL de forma remota
for domain in "${DOMAINS[@]}"; do
    result=$(check_cert_expiry_remote "$domain")
    echo "$result"
done