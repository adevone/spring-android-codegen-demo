#!/bin/sh

GIT=$1

BUILD_DIR="build/es-api/go"
GO_GIT_DIR="go"
GIT_URL="https://$GITLAB_ACCESS_NAME:$GITLAB_ACCESS_TOKEN@$GIT"

echo "Cloning $GIT_URL"
git clone $GIT_URL $GO_GIT_DIR
if [[ $CI_COMMIT_REF_NAME != "master" ]] ; then 
    cd $GO_GIT_DIR
    git checkout -b $CI_COMMIT_REF_NAME
    cd ..
fi

rm -Rf $GO_GIT_DIR/api
rm -Rf $GO_GIT_DIR/client
rm -Rf $GO_GIT_DIR/panel
rm -Rf $GO_GIT_DIR/integrate

cd $GO_GIT_DIR
GO_GIT_DIR=$(pwd)
cd ..

cd /local

java -jar gen.jar generate \
        --lang ru.napoleonit.eshopCodegen.go.GoServerCodegen \
        --input-spec client.json \
        --output $BUILD_DIR \
        --api-package client \
        --model-package client

java -jar gen.jar generate \
        --lang ru.napoleonit.eshopCodegen.go.GoServerCodegen \
        --input-spec panel.json \
        --output $BUILD_DIR \
        --api-package panel \
        --model-package panel

java -jar gen.jar generate \
        --lang ru.napoleonit.eshopCodegen.go.GoServerCodegen \
        --input-spec integrate.json \
        --output $BUILD_DIR \
        --api-package integrate \
        --model-package integrate

rm -f $BUILD_DIR/.swagger-codegen-ignore
cp -R $BUILD_DIR/api $GO_GIT_DIR/api
cp -R $BUILD_DIR/client $GO_GIT_DIR/client
cp -R $BUILD_DIR/panel $GO_GIT_DIR/panel
cp -R $BUILD_DIR/integrate $GO_GIT_DIR/integrate
cd $GO_GIT_DIR

git add -A
if [[ $CI_COMMIT_REF_NAME == "master" ]] ; then 
    git commit -m "go-client latest"
else
    git commit -m "go-client v$CI_COMMIT_REF_NAME"
fi
git push -f -u origin $CI_COMMIT_REF_NAME

cd ..
rm -rf $GO_GIT_DIR

echo "Finish deploy"