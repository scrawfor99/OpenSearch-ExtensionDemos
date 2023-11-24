public class HelloWorldExtension extends BaseExtension implements ActionExtension {
    @Override
    public List<ExtensionRestHandler> getExtensionRestHandlers() {
        return List.of(new RestHelloAction());
    );
}

public class RestHelloAction extends BaseExtensionRestHandler {
    @Override
    public List<NamedRoute> routes() {
        return List.of(
           new NamedRoute.Builder().method(GET).path("/hello")
              .handler(handleGetRequest)
              .build();
        )
    }

    private Function<RestRequest, ExtensionRestResponse> handleGetRequest =
        (request) -> {
            return new ExtensionRestResponse(
                request, OK, "Hello from Java! 👋\n"
            );
        }
}
