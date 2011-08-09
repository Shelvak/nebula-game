package namespaces
{
   /**
    * Properties defined in this namespace actually hold names of properties in other namespaces.
    * This is a way to use staticly typed (sort of) names of properties. I think this is helpful
    * while using <code>PropertyChangeEvent</code> events. For example, when you need to check the
    * name of a property which is contained in <code>event.property</code> in most cases you have to
    * check the name against hardcoded string value: and you have a problem renaming the property if
    * you listen to the same property change event in various places. Instead of checking against a
    * hardcoded string you can do this:
    * <ul>
    *    <li>Define your property and a static constant in <code>property_name</code> namespace in your
    *        class like this:
    * <pre>
    * class YourClass
    * {
    * &nbsp;&nbsp;&nbsp;property_name static const yourProperty:String = "yourProperty";
    * &nbsp;&nbsp;&nbsp;public var yourProperty:int = 0;
    * }
    * </pre>
    *    </li>
    *    <li>When listening for change event of that property, check <code>event.property</code> like
    *        this:
    * <pre>
    * function propertyChangeHandler(event:PropertyChangeEvent) : void
    * {
    * &nbsp;&nbsp;&nbsp;if (event.property == YourClass.property_name::yourProperty) {...}
    * }
    * </pre>
    *    </li>
    * </ul>
    * This way you will only have to rename two properties in different namespaces and change the
    * string value held by the property in <code>property_name</code> namespace.
    */
   public namespace prop_name;
}