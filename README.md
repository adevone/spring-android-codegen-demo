# Demo of enhanced Swagger codegen

[Spring demo](./spring-codegen-demo/README.md)  
[Android demo](./android-codegen-demo/README.md)  

[Specs itself](./specs/README.md)

# About codegen

API code generation introduces single source of truth between backend and frontend (web/mobile).     
Codegen generates API models and route handler both for backend and frontent.

Example of usage with Java+Spring+Jackson:
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

With this syntax backend developer will be notified in compile-time about response type change or new fields addition.

Example of usage with Kotlin+Coroutines+Moxy+Kodein:
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

# Architecture

![Architecture](https://i.ibb.co/WBdRKTZ/architecture-full-en.png)

Project that uses codegen can contain 4 parts:
1. API specs in OpenAPI format (modern fork of SwaggerAPI)
2. Codegen itself
3. Backend API client
4. Frontend API client

API completely independent from another parts of system. Codegen knows how to generate models and routes for supported platforms. Frontend and backend depends from API specs through generated code.

# Delivery
Codegen is infrastructure component thus it can be reused between several projects. It can be deployed as Docker container and used in CI.  
Codegen can generate code during API specs CI. Generated code can be deployed into Maven or on Github with assigned version. Developers of backend and client can be notified about new version using messenger integration.

# API modification step-by-step
1. Developers modifies the API specs
2. Developer commits changes to remote repository with configured CI
3. CI builds API clients, assigns version and deploys artifact it to some repository
4. Developers gets a notification about new version and updates their projects 

## Status of Spring generator: Initial prototype
## Status of Mobile Kotlin generator: Production ready