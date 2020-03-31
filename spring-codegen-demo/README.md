# Status of Spring generator: Initial prototype
I spent near 6 hours for implementation of Spring generator for now so it have some [Limitations](#Limitations)

# How launch Spring app
1. Launch Spring server using `./gradlew :app:run`
2. Set about using Android app or `curl -X PUT localhost:8080/about --data '{"title":"ti2","text":"te12"}'`
3. Obtain about using Android app or `curl localhost:8080/about`

Server uses `8080` port by default

# How to launch codegen
1. Modify specs [specs](../specs/specs/client.json)
2. Run `./generate.sh`

# Limitations
- Only non-array and non-primitive response schemas supported at now. This functionality can be implemented for something like 4 hours   