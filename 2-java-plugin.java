public class HelloPlugin extends Plugin implements ActionPlugin {
    @Override
    public List getRestHandlers(final Settings settings,
        final RestController restController,
        final ClusterSettings clusterSettings,
        final IndexScopedSettings indexScopedSettings,
        final SettingsFilter settingsFilter,
        final IndexNameExpressionResolver indexNameExpressionResolver,
        final Supplier nodesInCluster) {
            return singletonList(new RestHelloAction());
    }
}

public class RestHelloAction extends BaseRestHandler {
    @Override
    public List routes() {
        return unmodifiableList(asList(
            new Route(GET, "/_plugins/hello-world-java")
        ));
    }

    @Override
    protected RestChannelConsumer prepareRequest(
        RestRequest request, 
        NodeClient client) throws IOException {
        
        return channel -> {
            channel.sendResponse(new BytesRestResponse(
                RestStatus.OK, 
                "Hello from Java! 👋\n"
            )
        );
    }
}