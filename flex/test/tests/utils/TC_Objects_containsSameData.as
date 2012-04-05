package tests.utils
{
   import flash.geom.Point;
   import flash.utils.Dictionary;

   import mx.utils.ObjectUtil;

   import namespaces.client_internal;

   import org.hamcrest.assertThat;
   import org.hamcrest.object.isFalse;
   import org.hamcrest.object.isTrue;

   import tests.utils.classes.tc_objects_containssamedata.CollectionProperty;
   import tests.utils.classes.tc_objects_containssamedata.NameAndAge;
   import tests.utils.classes.tc_objects_containssamedata.NestedComplexProperty;
   import tests.utils.classes.tc_objects_containssamedata.ObjectProperty;
   import tests.utils.classes.tc_objects_containssamedata.TypeProcessorProperty;

   import utils.Objects;


   public class TC_Objects_containsSameData
   {

      [Test]
      public function nullData(): void {
         assertThat(
            "should not contain same data when data is null",
            sameData(new NameAndAge(null,0), null), isFalse()
         );
      }

      [Test]
      public function simpleProperties(): void {
         assertThat(
            "should contain same data",
            sameData(
               new NameAndAge("John", 20),
               {"name": "John", "age": 20}
            ), isTrue()
         );

         assertThat(
            "should not contain same data if at least one value does not match",
            sameData(
               new NameAndAge("John", 20),
               {"name": "Doe", "age": 20}
            ), isFalse()
         );

         assertThat(
            "should not check properties that are not present in data object",
            sameData(
               new NameAndAge("John", 20),
               {"name": "John"}
            ), isTrue()
         );
      }

      [Test]
      public function collectionProperties(): void {
         assertThat(
            "should not check properties of collection type",
            sameData(
               new CollectionProperty("Perlas"),
               {"lotteryName": "Perlas", "numbers": [0, 1]}
            ), isTrue()
         );
      }

      [Test]
      public function genericObjectProperties(): void {
         const gpValue: Object = {"one": 1, "do": true};
         assertThat(
            "should contain same data if generic object property "
               + "contains the same data",
            sameData(
               new ObjectProperty(10, gpValue),
               {"id": 10, "data": {"one": 1, "do": true}}
            ), isTrue()
         );

         assertThat(
            "should not contain same data if generic object property "
               + "does not contain the same data",
            sameData(
               new ObjectProperty(10, gpValue),
               {"id": 10, "data": {"one": 2, "do": true}}
            ), isFalse()
         );
      }

      private static function point_autoCreate(complex: Point,
                                               data: Object): Point {
         return null;
      }

      private static function point_sameDataCheck(complex: Point,
                                                  data: Object): Boolean {
         return complex.x == data["x"] && complex.y == data["y"];
      }

      [Test]
      public function propertiesWithTypeProcessors(): void {
         Objects.setTypeProcessors(
            Point,
            point_autoCreate,
            point_sameDataCheck
         );

         assertThat(
            "should contain same data if property with type processor "
               + "contains the same data",
            sameData(
               new TypeProcessorProperty(10, new Point(2, 2)),
               {"id": 10, "point": {"x": 2, "y": 2}}
            ), isTrue()
         );

         assertThat(
            "should not contain same data if property with type processor "
               + "does not contain the same data",
            sameData(
               new TypeProcessorProperty(10, new Point(2, 2)),
               {"id": 10, "point": {"x": 2, "y": 5}}
            ), isFalse()
         );

         assertThat(
            "should not contain same data if property with type processor "
               + "is null and the same property in data object is not",
            sameData(
               new TypeProcessorProperty(10, null),
               {"id": 10, "point": {"x": 2, "y": 2}}
            ), isFalse()
         );

         assertThat(
            "should not contain same data if property with type processor "
               + "is not null and the same property in data object is",
            sameData(
               new TypeProcessorProperty(10, new Point(2, 2)),
               {"id": 10, "point": null}
            ), isFalse()
         );

         assertThat(
            "should contain same data if property with type processor "
               + "is null and the same property in data object is also null",
            sameData(
               new TypeProcessorProperty(10, null),
               {"id": 10, "point": null}
            ), isTrue()
         );

         delete Objects.client_internal::TYPE_PROCESSORS[Point];
      }

      [Test]
      public function nestedComplexProperties(): void {
         assertThat(
            "should not contain the same data if nested complex object does not "
               + "contain the same data",
            sameData(
               new NestedComplexProperty(new NameAndAge("John", 20)),
               {"nameAndAge": {"name": "John", "age": 30}}
            ), isFalse()
         );

         assertThat(
            "should contain the same data if nested complex object contains"
               + " the same data",
            sameData(
               new NestedComplexProperty(new NameAndAge("John", 20)),
               {"nameAndAge": {"name": "John", "age": 20}}
            ), isTrue()
         );

         assertThat(
            "should not contain same data if nested property "
               + "is null and the same property in data object is not",
            sameData(
               new NestedComplexProperty(null),
               {"nameAndAge": {"name": "John", "age": 20}}
            ), isFalse()
         );

         assertThat(
            "should not contain same data if nested property "
               + "is not null but the same property in data object is",
            sameData(
               new NestedComplexProperty(new NameAndAge("John", 20)),
               {"nameAndAge": null}
            ), isFalse()
         );

         assertThat(
            "should not contain same data if nested property "
               + "is null and the same property in data object is also null",
            sameData(
               new NestedComplexProperty(null),
               {"nameAndAge": null}
            ), isTrue()
         );
      }

      private function sameData(complex: Object, data: Object): Boolean {
         return Objects.containsSameData(complex, data);
      }
   }
}