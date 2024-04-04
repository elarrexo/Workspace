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

#auth_token=$(echo "$auth_response" | jq -r '.authToken')

auth_token=$(echo "${auth_response}" | grep -oPm1 '<authToken>\K[^<]+')
echo $auth_token
