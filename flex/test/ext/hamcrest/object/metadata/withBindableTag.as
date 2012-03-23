package ext.hamcrest.object.metadata
{
   import org.hamcrest.Matcher;


   public function withBindableTag(eventType: String): Matcher {
      return withMetadataTag("Bindable", withAttribute("event", eventType));
   }
}
