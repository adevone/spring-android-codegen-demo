#!/bin/sh

apk add --no-cache git
apk add --no-cache curl
apk add --no-cache jq
git config --global user.email "$GITLAB_ACCESS_NAME@itnap.ru"
git config --global user.name $GITLAB_ACCESS_NAME
git config --global push.followTags true

export MAJOR_VERSION=$(cat major_version.txt)
export MINOR_VERSION=$(cat minor_version.txt)

cat specs/client.json | jq '.info.version = env.MAJOR_VERSION + "." + env.MINOR_VERSION' > /local/client.json
cat specs/panel.json | jq '.info.version = env.MAJOR_VERSION + "." + env.MINOR_VERSION' > /local/panel.json
cat specs/integrate.json | jq '.info.version = env.MAJOR_VERSION + "." + env.MINOR_VERSION' > /local/integrate.json

SPECS_VERSION=$(cat /local/client.json | jq -r '.info.version')

cat /local/client.json | jq -r '.info'
cat /local/client.json | jq -r '.info.version'
echo "SPECS_VERSION=${SPECS_VERSION}"

chmod +x ./deploy/deploy_kotlin.sh

curl "https://api.telegram.org/bot${TG_BOT_TOKEN}/sendMessage" -F "chat_id=${TG_CHAT_ID}" -F "text=зпшл ${CI_COMMIT_MESSAGE} short_sha=${CI_COMMIT_SHORT_SHA}, sha=${CI_COMMIT_SHA}"

./deploy/deploy_go.sh gitlab.itnap.ru/eShop/apiclients/goapiclient.git

curl "https://api.telegram.org/bot${TG_BOT_TOKEN}/sendMessage" -F "chat_id=${TG_CHAT_ID}" -F "text=сбрл go v0.0.0-${CI_COMMIT_SHA}"

./deploy/deploy_swift.sh gitlab.itnap.ru/eShop/apiclients/swiftapiclient.git

curl "https://api.telegram.org/bot${TG_BOT_TOKEN}/sendMessage" -F "chat_id=${TG_CHAT_ID}" -F "text=сбрл swift ${SPECS_VERSION}"

./deploy/deploy_ts.sh gitlab.itnap.ru/eShop/apiclients/tsapiclient.git

curl "https://api.telegram.org/bot${TG_BOT_TOKEN}/sendMessage" -F "chat_id=${TG_CHAT_ID}" -F "text=сбрл typescript v${SPECS_VERSION}"

#./deploy/deploy_kotlin.sh

#curl "https://api.telegram.org/bot${TG_BOT_TOKEN}/sendMessage" -F "chat_id=${TG_CHAT_ID}" -F "text=сбрл kotlin ${SPECS_VERSION}"