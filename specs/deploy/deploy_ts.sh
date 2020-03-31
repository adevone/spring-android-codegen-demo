#!/bin/sh

GIT=$1

BUILD_DIR="build/es-api/ts"
TS_GIT_DIR="ts"
GIT_URL="https://$GITLAB_ACCESS_NAME:$GITLAB_ACCESS_TOKEN@$GIT"

echo "Cloning $GIT_URL"
git clone $GIT_URL $TS_GIT_DIR
if [[ $CI_COMMIT_REF_NAME != "master" ]] ; then 
    cd $TS_GIT_DIR
    git checkout -b $CI_COMMIT_REF_NAME
    cd ..
fi

mkdir tmp
mv $TS_GIT_DIR/.git tmp/.git

rm -Rf $TS_GIT_DIR
mkdir $TS_GIT_DIR
mv tmp/.git $TS_GIT_DIR/.git

rm -Rf tmp

cd $TS_GIT_DIR
TS_GIT_DIR=$(pwd)
cd ..

cp configs/ts.json /local/ts.json

VERSION=$(cat /local/panel.json | grep -E "\"version\": \"[0-9]+\.[0-9]+\.[0-9]+\"" | sed "s/\"//g" | tr " " "\n" | tail -n1)
sed -i "s/\%{version}/$VERSION/g" /local/ts.json

cd /local

java -cp gen.jar io.swagger.codegen.v3.cli.SwaggerCodegen generate \
        --lang ru.napoleonit.eshopCodegen.typescript.TypescriptCodegen \
        --input-spec panel.json \
        --output $BUILD_DIR \
        --config ts.json

rm -f $BUILD_DIR/.swagger-codegen-ignore
cp -R $BUILD_DIR/* $TS_GIT_DIR

cd $TS_GIT_DIR

git add -A
if [[ $CI_COMMIT_REF_NAME == "master" ]] ; then 
    git commit -m "go-client latest"
else
    git commit -m "ts-client v$CI_COMMIT_REF_NAME"
fi
git push -f -u origin $CI_COMMIT_REF_NAME

cd ..
rm -rf $TS_GIT_DIR

echo "Finish deploy"