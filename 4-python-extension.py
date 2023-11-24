class HelloExtension(Extension, ActionExtension):
    def __init__(self):
        Extension.__init__(self, "hello-world")
        ActionExtension.__init__(self)

    @property
    def rest_handlers(self):
        return [HelloRestHandler()]
    
class HelloRestHandler(ExtensionRestHandler):
    def handle_request(self, rest_request):
        return ExtensionRestResponse(
            RestStatus.OK, 
            bytes("Hello from Python! 👋\n"),  
            ExtensionRestResponse.TEXT_CONTENT_TYPE
        )

    @property
    def routes(self):
        return [
            NamedRoute(method=RestMethod.GET, path="/hello")
        ]