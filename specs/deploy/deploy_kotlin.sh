#!/bin/sh

CLIENT_BUILD_DIR="build/es-api/kotlin/client"
PANEL_BUILD_DIR="build/es-api/kotlin/panel"
INTEGRATE_BUILD_DIR="build/es-api/kotlin/integrate"

MVN_URL_FIX=${MVN_URL//\//\\/}
MVN_SL_CLIENT_REPO_FIX=${MVN_SL_CLIENT_REPO//\//\\/}
MVN_USERNAME_FIX=${MVN_USERNAME//\//\\/}
MVN_PASSWORD_FIX=${MVN_PASSWORD//\//\\/}

cd /local

java -jar gen.jar generate \
        --lang ru.napoleonit.eshopCodegen.kotlin.KotlinClientCodegen \
        --input-spec client.json \
        --output ${CLIENT_BUILD_DIR} \
        --api-package client \
        --model-package client \
        --model-name-prefix Generated \
        --group-id eshop.openapi \
        --artifact-id client

cd ${CLIENT_BUILD_DIR}

cp gradle.properties gradle.properties.back

sed "s/\%{mvn_url}/$MVN_URL_FIX/g" gradle.properties.back| \
sed "s/\%{mvn_sl_client_repo}/$MVN_SL_CLIENT_REPO_FIX/g"| \
sed "s/\%{mvn_username}/$MVN_USERNAME_FIX/g"| \
sed "s/\%{mvn_password}/$MVN_PASSWORD_FIX/g" > gradle.properties

chmod +x gradlew
./gradlew publish

cd /local

java -jar gen.jar generate \
        --lang ru.napoleonit.eshopCodegen.kotlin.KotlinClientCodegen \
        --input-spec panel.json \
        --output ${PANEL_BUILD_DIR} \
        --api-package panel \
        --model-package panel \
        --model-name-prefix Generated \
        --group-id eshop.openapi \
        --artifact-id panel

cd ${PANEL_BUILD_DIR}

cp gradle.properties gradle.properties.back

sed "s/\%{mvn_url}/$MVN_URL_FIX/g" gradle.properties.back| \
sed "s/\%{mvn_sl_client_repo}/$MVN_SL_CLIENT_REPO_FIX/g"| \
sed "s/\%{mvn_username}/$MVN_USERNAME_FIX/g"| \
sed "s/\%{mvn_password}/$MVN_PASSWORD_FIX/g" > gradle.properties

chmod +x gradlew
./gradlew publish

cd /local

java -jar gen.jar generate \
        --lang ru.napoleonit.eshopCodegen.kotlin.KotlinClientCodegen \
        --input-spec integrate.json \
        --output ${INTEGRATE_BUILD_DIR} \
        --api-package integrate \
        --model-package integrate \
        --group-id eshop.openapi \
        --artifact-id integrate

cd ${INTEGRATE_BUILD_DIR}

cp gradle.properties gradle.properties.back

sed "s/\%{mvn_url}/$MVN_URL_FIX/g" gradle.properties.back| \
sed "s/\%{mvn_sl_client_repo}/$MVN_SL_CLIENT_REPO_FIX/g"| \
sed "s/\%{mvn_username}/$MVN_USERNAME_FIX/g"| \
sed "s/\%{mvn_password}/$MVN_PASSWORD_FIX/g" > gradle.properties

chmod +x gradlew
./gradlew publish