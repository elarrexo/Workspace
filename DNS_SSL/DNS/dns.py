from influxdb_client import InfluxDBClient, Point, WritePrecision
from datetime import datetime
import os
import whois

# Configurar las variables de entorno para InfluxDB
INFLUX_URL = os.getenv('INFLUX_URL', 'http://172.16.99.28:8086')
INFLUX_TOKEN = os.getenv('INFLUX_TOKEN', 'xQmZmasZCEZytHs4xmcUrRsJ42kEVAJ9EBHg9El6gVECRRdJac9rTHnhTLbLv-nMLngkk6FRCJ-YkDKyXzpMPg==')
INFLUX_ORG = os.getenv('INFLUX_ORG', 'filtanet')
INFLUX_BUCKET = os.getenv('INFLUX_BUCKET', 'dnstipti')

# Función para verificar la caducidad de un dominio
def verificar_caducidad_dominio(dominio):
    try:
        w = whois.whois(dominio)

        if isinstance(w.expiration_date, list):
            expiration_date = w.expiration_date[0]
        else:
            expiration_date = w.expiration_date

        if expiration_date is None:
            return None

        today = datetime.now()

        if expiration_date < today:
            return 0
        else:
            days_remaining = (expiration_date - today).days
            return days_remaining

    except Exception as e:
        print("Error al verificar la caducidad del dominio {}: {}".format(dominio, str(e)))
        return None

# Función para enviar datos a InfluxDBv2
def enviar_a_influxdb(nombre_dominio, dias_vigencia):
    # Crear un cliente de InfluxDB
    client = InfluxDBClient(url=INFLUX_URL, token=INFLUX_TOKEN, org=INFLUX_ORG)

    # Crear un punto de datos
    punto = Point("verificacion_dominio") \
        .tag("dominio", nombre_dominio) \
        .field("dias_vigencia", dias_vigencia) \
        .time(datetime.utcnow(), WritePrecision.NS)

# Imprimir lo que se enviará a InfluxDB
    print("Enviando a InfluxDB:", punto.to_line_protocol())

    # Escribir el punto en el bucket de InfluxDB
    write_api = client.write_api()
    write_api.write(bucket=INFLUX_BUCKET, record=punto)

# Ejemplo de uso
dominios = ["mysuper.market", "tiptimarket.com", "tipti.us", "tipti.com.mx", "tipti.mx", "zuper-market.com", "misuper.market", "grupo-sync.com", "urbasipo.com", "urbasipo.net", "urbasipo.org", "tipti.market", "ecuador.ec", "instacart.com.ec", "instacart.ec", "tipti.ec", "tipti.com.ec", "sync.com.ec", "sync.ec", "pets-mart.com.ec", "pets-mart.ec", "tipti.com.pa"]

for dominio in dominios:
    dias_vigencia = verificar_caducidad_dominio(dominio)
    if dias_vigencia is not None:
        enviar_a_influxdb(dominio, dias_vigencia)
