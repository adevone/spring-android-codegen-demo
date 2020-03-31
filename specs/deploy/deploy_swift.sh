#!/bin/sh

GIT=$1

SWIFT_API_CLIENT_GIT_URL="https://$GITLAB_ACCESS_NAME:$GITLAB_ACCESS_TOKEN@$GIT"
SWIFT_COCOAPODS_GIT_URL="https://$GITLAB_ACCESS_NAME:$GITLAB_ACCESS_TOKEN@gitlab.itnap.ru/eShop/iOS/cocoapodsspecs.git"
BUILD_DIR="build/es-api/swift"
SWIFT_API_CLIENT_GIT_DIR="swift"
SWIFT_COCOAPODS_GIT_DIR="swiftclient"

echo "Cloning $SWIFT_API_CLIENT_GIT_URL..."

git clone $SWIFT_API_CLIENT_GIT_URL $SWIFT_API_CLIENT_GIT_DIR
if [[ $CI_COMMIT_REF_NAME != "master" ]] ; then 
    cd $SWIFT_API_CLIENT_GIT_DIR
    git checkout -b $CI_COMMIT_REF_NAME
    cd ..
fi

mkdir tmp
mv $SWIFT_API_CLIENT_GIT_DIR/.git tmp/.git

rm -Rf $SWIFT_API_CLIENT_GIT_DIR
mkdir $SWIFT_API_CLIENT_GIT_DIR
mv tmp/.git $SWIFT_API_CLIENT_GIT_DIR/.git

rm -Rf tmp

SWIFT_API_CLIENT_GIT_DIR="$(pwd)/$SWIFT_API_CLIENT_GIT_DIR"

cp configs/swift.json /local/swift.json

GITFIX=${GIT//\//\\/}
GITFIX=${GITFIX//.git/}
VERSION=$(cat /local/client.json | grep -E "\"version\": \"[0-9]+\.[0-9]+\.[0-9]+\"" | sed "s/\"//g" | tr " " "\n" | tail -n1)
sed -i "s/\%{git}/$GITFIX/g" /local/swift.json
sed -i "s/\%{version}/$VERSION/g" /local/swift.json

cd /local

java -cp gen.jar io.swagger.codegen.v3.cli.SwaggerCodegen generate \
        --lang ru.napoleonit.eshopCodegen.swift.SwiftClientCodegen \
        --input-spec client.json \
        --output build/es-api/swift \
        --config swift.json

rm -f $BUILD_DIR/.swagger-codegen-ignore
rm -f $BUILD_DIR/git_push.sh
rm -f $BUILD_DIR/Cartfile
cp -R $BUILD_DIR/* $SWIFT_API_CLIENT_GIT_DIR
cd $SWIFT_API_CLIENT_GIT_DIR

git add -A
if [[ $CI_COMMIT_REF_NAME == "master" ]] ; then 
    git commit -m "swift-client latest"
else
    git commit -m "swift-client v$CI_COMMIT_REF_NAME"
fi
git push -f -u origin $CI_COMMIT_REF_NAME

cd ..

if [[ $CI_COMMIT_REF_NAME != "master" ]] ; then 
    echo "Cloning master of $SWIFT_COCOAPODS_GIT_URL..."
    git clone $SWIFT_COCOAPODS_GIT_URL $SWIFT_COCOAPODS_GIT_DIR
    mkdir $SWIFT_COCOAPODS_GIT_DIR/$CI_COMMIT_REF_NAME
    cp $SWIFT_API_CLIENT_GIT_DIR/ESHOPSwiftAPIClient.podspec $SWIFT_COCOAPODS_GIT_DIR/$CI_COMMIT_REF_NAME/ESHOPSwiftAPIClient.podspec
    cd $SWIFT_COCOAPODS_GIT_DIR
    git add -A
    git commit -m "swift-client v$CI_COMMIT_REF_NAME"
    git push -f -u origin master
    rm -rf ../$SWIFT_API_CLIENT_GIT_DIR
fi

cd ..
rm -rf $SWIFT_COCOAPODS_GIT_DIR

echo "Finish deploy"