public class RenameFieldResponseProcessor extends AbstractProcessor implements SearchResponseProcessor {
    @Override
    public SearchResponse processResponse(SearchRequest request, SearchResponse response) throws Exception {
        boolean foundField = false;

        SearchHit[] hits = response.getHits().getHits();
        for (SearchHit hit : hits) {
            Map<String, DocumentField> fields = hit.getFields();
            if (fields.containsKey(oldField)) {
                foundField = true;
                DocumentField old = hit.removeDocumentField(oldField);
                DocumentField newDocField = new DocumentField(newField, old.getValues());
                hit.setDocumentField(newField, newDocField);
            }

            if (hit.hasSource()) {
                BytesReference sourceRef = hit.getSourceRef();
                Tuple<? extends MediaType, Map<String, Object>> typeAndSourceMap = XContentHelper.convertToMap(
                    sourceRef,
                    false,
                    (MediaType) null
                );

                Map<String, Object> sourceAsMap = typeAndSourceMap.v2();
                if (sourceAsMap.containsKey(oldField)) {
                    foundField = true;
                    Object val = sourceAsMap.remove(oldField);
                    sourceAsMap.put(newField, val);

                    XContentBuilder builder = XContentBuilder.builder(typeAndSourceMap.v1().xContent());
                    builder.map(sourceAsMap);
                    hit.sourceRef(BytesReference.bytes(builder));
                }
            }

            if (!foundField && !ignoreMissing) {
                throw new IllegalArgumentException("Document with id " + hit.getId() + " is missing field " + oldField);
            }
        }

        return response;
    }
}
