
#!/bin/bash

path="/opt/zimbra/bin"




    read -d '' signature <<_EOF_
    
    <div>
    <div style="font-size: 16px; font-family: 'calibri' , 'arial' , 'helvetica' , sans-serif; background-color: white;"><span style="font-size: small;"><span style="font-size: 16px;"><span style="font-family: 'segoe' , 'segoe ui' , sans-serif; font-size: small;">Saludos cordiales,</span></span></span></div>
    <div style="font-size: 16px; font-family: 'calibri' , 'arial' , 'helvetica' , sans-serif; background-color: white;"><span style="font-size: small;"><span style="font-size: 16px;"><span style="font-family: 'segoe' , 'segoe ui' , sans-serif; font-size: small;"><strong><i>Josselyn Toapanta R.</i></strong></span></span></span></div>
    <div style="font-size: 16px; font-family: 'calibri' , 'arial' , 'helvetica' , sans-serif; background-color: white;"><span style="font-size: small;"><span style="font-size: 16px;"><span style="font-family: 'segoe' , 'segoe ui' , sans-serif; font-size: small;"><strong>Direcci&oacute;n de Tecnolog&iacute;as de la Informaci&oacute;n y Comunicaciones</strong></span></span></span></div>
    <div style="font-size: 16px; font-family: 'calibri' , 'arial' , 'helvetica' , sans-serif; background-color: white;"><span style="font-size: 13.32px; font-family: 'segoe' , 'segoe ui' , sans-serif;">Av. Diego de Amagro N31-95 entre Whymper y Alpallana</span></div>
    <div style="font-size: 16px; font-family: 'calibri' , 'arial' , 'helvetica' , sans-serif; background-color: white;"><span style="font-size: small;"><span style="font-size: 16px;"><span style="font-family: 'segoe' , 'segoe ui' , sans-serif; font-size: small;">Telf.: (593 02) 2 946 800 ext. 1306</span></span></span></div>
    <div style="font-size: 16px; font-family: 'calibri' , 'arial' , 'helvetica' , sans-serif; background-color: white;"><span style="font-size: small;"><span style="font-size: 16px;"><a tabindex="0" href="http://www.arcotel.gob.ec/" target="_blank" rel="noopener noreferrer nofollow noopener noreferrer"><span style="font-family: 'segoe' , 'segoe ui' , sans-serif; font-size: small;"><strong>www.arcotel.gob.ec</strong></span></a></span></span></div>
    <div style="font-size: 16px; font-family: 'calibri' , 'arial' , 'helvetica' , sans-serif; background-color: white;"><span style="font-size: small;"><span style="font-size: 16px;"><span style="font-family: 'segoe' , 'segoe ui' , sans-serif; font-size: small;">Quito-Ecuado</span><span style="font-family: 'segoe' , 'segoe ui' , sans-serif; font-size: small;">r</span></span></span></div>
    <div style="font-size: 16px; font-family: 'calibri' , 'arial' , 'helvetica' , sans-serif; background-color: white;"><span style="font-size: small;"><span style="font-size: 16px;"><span style="font-family: 'segoe' , 'segoe ui' , sans-serif; font-size: small;">&nbsp;</span></span></span></div>
    <div style="font-size: 16px; font-family: 'calibri' , 'arial' , 'helvetica' , sans-serif; background-color: white;"><img src="https://www.arcotel.gob.ec/wp-content/uploads/2023/06/Pie-de-firma.jpg" /></div>
    </div>_EOF_

    signId=$(/opt/zimbra/bin/zmprov csig $1 corpSignature zimbraPrefMailSignatureHTML "$signature")

    
    $(echo $path/zmprov ma $1 zimbraPrefDefaultSignatureId $signId)
    echo "done!"
#firma script 

