
*** Settings ***

Library  RequestsLibrary
Library  JSONLibrary

Library  Collections

*** Variables ***
${URL}


*** Test Cases ***
My HomeWork1
   # ${header}=  Create Dictionary   Content-Type=application/json
    Create Session      GetAssets     ${URL}
    ${my_reponse}=     Get Request    GetAssets     /assets
    #1.1
    #Log To Console  ${my_reponse.status_code}
    #Log To Console  ${my_reponse.headers}
    Should Be Equal As Integers     ${my_reponse.status_code}      200      #check status = 200

    #1.2
    ${homework2_2_headers} =        get from dictionary     ${my_reponse.headers}   Doppio-Header   #check key
    Should Be Equal     ${homework2_2_headers}  DoppioFamilyTraining  #check value
    ${homework2_2_headers} =        get from dictionary     ${my_reponse.headers}   Content-Type    #check key
    Should Be Equal     ${homework2_2_headers}  application/json    #check value
    #1.2 new
    Should Be Equal     ${my_reponse.headers['Doppio-Header']}      DoppioFamilyTraining   #check headers means new
    Should Be Equal     ${my_reponse.headers['Content-Type']}       application/json       #check headers means new


    #1.3                                                #####แก้การบ้าน#####
    ${my_response_json}=    Convert String To JSON     ${my_reponse.content}

    FOR     ${checkAsset}   IN      @{my_response_json}
        ${checkAssetresults}=   Evaluate    '${checkAsset['assetId']}'or'${checkAsset['assetName']}'or'${checkAsset['assetType']}' != ''
        #Log To Console  ${checkAssetresults}
    END



    #1.4
    FOR     ${people}   IN      @{my_response_json}  #Start For loop
    ${results}=  Evaluate    isinstance(${people['inUse']}, bool)   ##check ว่า inUse เป็น boolean หรือไม่ ถ้าเป็นเก็บค่า True##
    #Log To Console  ${results}
    #Log To Console  ${people}
    Should Be Equal      '${results}'  'True'
    END        #end loop



My HomeWork2
    ${header}=  Create Dictionary   Content-Type=application/json
    Create Session      PostAssets     ${URL}
    ${my_post}=        POST Request     PostAssets      /assets    data={"assetId": "a14444", "assetName":"14444", "assetType":14, "inUse": true}     headers=${header}



    #2.1                        #####แก้การบ้าน######
    Should Be Equal As Integers     ${my_post.status_code}      200      #check status = 200
    Log To Console  ${my_post.status_code}



    #2.2                        #####แก้การบ้าน#####
    ${status_body}=    convert String to JSON    ${my_post.content}
    Should Be Equal     ${status_body['status']}    success



    #2.3
    Create Session      getpostlast     ${URL}
    ${getpost_last}=     Get Request   getpostlast   /assets
    ${getpostlast_json}=    Convert String To JSON    ${getpost_last.content}
    FOR     ${people}   IN      @{getpostlast_json}  #Start For loop
        Log To Console  ${people['assetId']}
        Run Keyword If    '${people['assetId']}' == 'a1'    exit for loop
    END        #end loop
    Should Be Equal   ${people['assetId']}   a1

My HomeWork3
    ${header}=  Create Dictionary   Content-Type=application/json
    Create Session      petAssets     ${URL}
    ${my_reponse}=     post Request    petAssets     /assets        data={"assetId": "a14", "assetName":"14", "assetType":14, "inUse": true}     headers=${header}
    #3.1
    Should Be Equal As Integers     ${my_reponse.status_code}   200
    #3.2
    #${status_body}=    convert to string    ${my_reponse.content}
    ${my_response_json}=    Convert String To JSON     ${my_reponse.content}
    Should Be Equal As Strings     ${my_response_json['status']}  failed
    #should contain  ${status_body}  failed

    #3.3
    #Should Be Equal As Strings     ${my_response_json['message']}  please try with another id
    ${status_body}=    convert to string    ${my_reponse.content}
    should contain  ${status_body}  please try with another id


HomeWork4
    Create Session      delpost     ${URL}
    ${getpost_last}=    Delete Request   delpost   /assets/a14
    #4.1
    Log To Console  ${getpost_last.status_code}
    #4.2
    ${respDel_json}=    Convert String To JSON     ${getpost_last.content}
    Should Be Equal As Strings     ${respDel_json['status']}  success
    #4.3
    Create Session      getpostlast     ${URL}
    ${getpost_last}=     Get Request   getpostlast   /assets
    ${getpostlast_json}=    Convert String To JSON    ${getpost_last.content}
    FOR     ${people}   IN      @{getpostlast_json}  #Start For loop
    Log To Console  ${people['assetId']}
    Run Keyword If    '${people['assetId']}' == 'a14'    exit for loop
    END        #end loop
    Should Not Be Equal   ${people['assetId']}   a14
    Log To Console     ${people['assetId']}



