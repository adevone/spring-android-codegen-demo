# How launch Spring app
1. Launch Spring server using `./gradlew :app:run`
2. Set about using Android app or `curl -X PUT localhost:8080/about --data '{"title":"ti2","text":"te12"}'`
3. Obtain about using Android app or `curl localhost:8080/about`

Server uses `8080` port by default

# How to launch codegen
1. Modify specs [specs](../specs/specs/client.json)
2. Run `./generate.sh`