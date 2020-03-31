# Demo of enhanced Swagger codegen

[Spring demo](./spring-codegen-demo/README.md)  
[Android demo](./android-codegen-demo/README.md)  

[API specs](./specs/README.md)

# Which problem solves codegen?

API code generation introduces single source of truth between backend and frontend (web/mobile).  
API specs will can be developed using modern fork of Swagger called OpenAPI.

# How API specs with codegen works

Codegen generates API models and route handlers by API specs both for backend and frontend.  
Users of API will be notices about each change of API in compile-time on API specs version bump.  
API specs just adds strict schema to existing API. There is no need to change transport between backend and frontend.

Example of API Specs:
```json
{
  "openapi": "3.0.2",
  "info": {
    "title": "Demo",
    "version": "0.1"
  },
  "paths": {
    "/about": {
      "get": {
        "operationId": "getAbout",
        "responses": {
          "200": {
            "description": "ok",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/About"
                }
              }
            }
          },
          "400": {
            "description": "wrongParam"
          }
        }
      },
      "put": {
        "operationId": "setAbout",
        "requestBody": {
          "content": {
            "application/json": {
              "schema": {
                "$ref": "#/components/schemas/About"
              }
            }
          }
        },
        "responses": {
          "200": {
            "description": "ok"
          }
        }
      }
    }
  },
  "components": {
    "schemas": {
      "About": {
        "type": "object",
        "required": [
          "title",
          "text"
        ],
        "properties": {
          "title": {
            "type": "string"
          },
          "text": {
            "type": "string"
          }
        }
      }
    }
  }
}
```

Usage of generated code with Java+Spring+Jackson:
```java
@RestController("/")
public class AboutController {

    private DefaultApi api = new DefaultApi(JsonFactory.builder().build());

    @DefaultApi.GetAbout.Mapping
    public void get(HttpServletRequest request, HttpServletResponse response) throws IOException {
        api.getAbout.respondOk(
                about,
                response
        );
    }

    @DefaultApi.SetAbout.Mapping
    public void set(HttpServletRequest request, HttpServletResponse response) throws IOException {
        DefaultApi.SetAbout.Params params = api.setAbout.paramsFrom(request);
        about = params.getBody();
        api.setAbout.respondOk(response);
    }
}
```

With this syntax backend developer will be notified about response type change or new fields addition in compile-time.

*Status of Spring generator: Initial prototype*  
I spent near 6 hours for implementation of Spring generator for now so it have some [Limitations](./spring-codegen-demo/README.md#Limitations)

Usage of generated code with Kotlin+Coroutines+Moxy+Kodein:
```kotlin
interface MainView : MvpView {

    @StateStrategyType(AddToEndSingleStrategy::class)
    fun displayAbout(about: About)
}

@InjectViewState
class MainPresenter : BasePresenter<MainView>() {

    private val getAbout: GetAbout by instance()
    private val setAbout: SetAbout by instance()

    fun onSendClick(title: String, text: String) {
        launch {
            setAbout(body = About(title, text))
        }
    }

    fun onRefreshClick() {
        launch {
            val about = getAbout().ok()
            viewState.displayAbout(about)
        }
    }
}
```
Kotlin mobile codegen is production-ready.

# Delivery
Codegen can generate code during API specs CI. Generated code can be deployed into Maven or on Git with assigned version. Developers of backend and frontend can be notified about new version using messenger integration.
Codegen is infrastructure component thus it can be reused between several projects. It can be deployed as Docker container and used in CI.  

# Backward compatibility
There is the way to ensure backward compatibility of new versions of API. Language that used for writing of API specs is JSON so it's pretty easy to implement a script that will check that new version of API contains all fields and operations that present in previous version of API. This script can be run in CI so deploying of not backward compatible API can be prohibited.  
Breaking changes can be made only in major version that must be explicitly marked as major.  

# No runtime errors
If frontend uses same or older version of API as backend than problem of runtime errors caused by schema mismatch will be completely solved.    

# API modification step-by-step
1. Developer modifies the API specs
2. Developer commits changes to remote repository with configured CI
3. CI builds API clients, assigns version and deploys the artifact to some repository (Maven, Git...)
4. Developers gets a notification about new version and updates generated clients in their projects 

## Status of Mobile Kotlin generator: Production ready
## Status of Spring generator: Initial prototype