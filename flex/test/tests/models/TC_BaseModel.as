package tests.models
{
   import ext.hamcrest.object.equals;
   
   import flash.geom.Point;
   
   import models.BaseModel;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.core.not;
   import org.hamcrest.core.throws;
   import org.hamcrest.number.isNotANumber;
   import org.hamcrest.object.equalTo;
   import org.hamcrest.object.notNullValue;
   
   import tests.models.classes.ModelAggregator;
   import tests.models.classes.ModelNested;
   import tests.models.classes.ModelRequiredSelf;

   public class TC_BaseModel
   {
      [Test]
      public function createModel_error() : void
      {
         assertThat(
            function():void{ createModel(ModelInvalidMetadata, {invalid: "invalid"}) },
            throws(Error)
         );
         
         assertThat(
            function():void{ createModel(ModelMissingCollectionMetadata, {collection: [1]}) },
            throws (Error)
         );
         
         assertThat(
            function():void{ createModel(ModelUnsupportedCollectionItem, {collection: [new Date()]}) },
            throws (Error)
         );
         
         assertThat(
            function():void{ createModel(ModelRequiredProps, {name: "MikisM"}) },
            throws (Error)
         );
         
         assertThat(
            function():void{ createModel(ModelRequiredProps, {name: new Date(), age: 5}) },
            throws (Error)
         );
         
         assertThat(
            function():void{ createModel(ModelDateProp, {date: "not a date"}) },
            throws (Error)
         );
         
         assertThat(
            function():void{ createModel(ModelUnsupportedPropertyType, {point: new Point()}) },
            throws (Error)
         );
         
         assertThat(
            function():void{ createModel(ModelRequiredSelf, {id: 2, self: {id: 3}}) },
            throws (Error)
         );
         
         
         assertThat(
            function():void{ createModel(ModelAliasProperties, {}) },
            throws (Error)
         );
      };
      
      
      /**
       * Checks if tree-like structures are created using createModel().
       */
      public function createModel_nestedModels() : void
      {
         var model:ModelNested = createModel(ModelNested, {id: 1, nested: {id: 2}});
         assertThat( model.id, equalTo (1) );
         assertThat( model.nested, notNullValue() );
         assertThat( model.nested.id, equalTo (2) );
      };
      
      
      /**
       * Checks if null and undefined values are not copied when [Optional] tag is used. 
       */
      public function createModel_optional_undefinedAndNull() : void
      {
         var model:ModelOptionalMetadata = null;
         
         model = createModel(ModelOptionalMetadata, {optional: null});
         assertThat( model.optional, equalTo ("default") );
         
         model = createModel(ModelOptionalMetadata, {});
         assertThat( model.optional, equalTo ("default") );
      };
      
      
      [Test]
      /**
       * When "alias" attribute of [Optional] or [Required] metadata tag is specified property of
       * source object named as specified by that attribute should be used instead of staticly
       * typed property name of model beeing created.
       */
      public function createModel_propertyAlias() : void
      {
         var model:ModelAliasProperties = createModel(ModelAliasProperties, {
            "requiredAlias": "required",
            "optionalAlias": "optional",
            "requiredModelAlias": new BaseModel()
         });
         assertThat( model.required, equalTo ("required") );
         assertThat( model.optional, equalTo ("optional") );
         assertThat( model.requiredModel, notNullValue() );
      };
      
      [Test]
      public function createModel_aggregatesPropsErrors() : void {
         assertThat(
            "when no properties provided for required aggregator",
            function():void{ createModel(ModelPropsAggregatorRequired, {}) }, throws (Error)
         );
         assertThat(
            "when no properties provided for optional aggregator",
            function():void{ createModel(ModelPropsAggregatorOptional, {}) }, not (throws (Error))
         );
         assertThat(
            "not providing required property for aggregator",
            function():void{ createModel(ModelPropsAggregatorRequired, {"optional": 0}) }, throws (Error)
         );
         assertThat(
            "not providing optional but providing required property for aggregator",
            function():void{ createModel(ModelPropsAggregatorRequired, {"required": 0}) }, not (throws (Error))
         );
         assertThat(
            "alias attribute not allowed on aggregators",
            function():void{ createModel(ModelPropsAggregatorAlias, {"required": 0}) }, throws (Error)
         );
         assertThat(
            "aggregatesProps and aggregatesPrefix attributes not allowed together",
            function():void{ createModel(ModelPropsAndPrefixAggregator, {"required": 0, "optional": 0}) }, throws (Error)
         );
      }
      
      [Test]
      public function createModel_aggregatesPrefixErrors() : void {
         assertThat(
            "when no properties provided for required aggregator",
            function():void{ createModel(ModelPrefixAggregatorRequired, {}) }, throws (Error)
         );
         assertThat(
            "when no properties provided for optional aggregator",
            function():void{ createModel(ModelPrefixAggregatorOptional, {}) }, not (throws (Error))
         );
         assertThat(
            "not providing required property for aggregator",
            function():void{ createModel(ModelPrefixAggregatorRequired, {"prefixOptional": 0}) }, throws (Error)
         );
         assertThat(
            "not providing optional but providing required property for aggregator",
            function():void{ createModel(ModelPrefixAggregatorRequired, {"prefixRequired": 0}) }, not (throws (Error))
         );
      }
      
      [Test]
      public function createModel_aggregatesProps() : void {
         var aggregatorUser:IAggregatorUser;
         var aggregator:ModelAggregator;
         
         aggregatorUser = createModel(ModelPropsAggregatorRequired, {"required": 0});
         aggregator = aggregatorUser.getAggregator();
         assertThat( "aggregator without optional prop created", aggregator, notNullValue() );
         assertThat( "aggregator.required", aggregator.required, equals (0) );
         assertThat( "aggregator.optional", aggregator.optional, isNotANumber() );
         
         aggregatorUser = createModel(ModelPropsAggregatorRequired, {"required": 0, "optional" :1});
         aggregator = aggregatorUser.getAggregator();
         assertThat( "aggregator with optional prop created", aggregator, notNullValue() );
         assertThat( "aggregator.required", aggregator.required, equals (0) );
         assertThat( "aggregator.optional", aggregator.optional, equals (1) );
      }
      
      [Test]
      public function createModel_aggregatesPrefix() : void {
         var aggregatorUser:IAggregatorUser;
         var aggregator:ModelAggregator;
         
         aggregatorUser = createModel(ModelPrefixAggregatorRequired, {"prefixRequired": 0});
         aggregator = aggregatorUser.getAggregator();
         assertThat( "aggregator without optional prop created", aggregator, notNullValue() );
         assertThat( "aggregator.required", aggregator.required, equals (0) );
         assertThat( "aggregator.optional", aggregator.optional, isNotANumber() );
         
         aggregatorUser = createModel(ModelPrefixAggregatorRequired, {"prefixRequired": 0, "prefixOptional" :1});
         aggregator = aggregatorUser.getAggregator();
         assertThat( "aggregator with optional prop created", aggregator, notNullValue() );
         assertThat( "aggregator.required", aggregator.required, equals (0) );
         assertThat( "aggregator.optional", aggregator.optional, equals (1) );
      }
      
      private function createModel(type:Class, data:Object) : * {
         return BaseModel.createModel(type, data);
      }
   }
}


import flash.geom.Point;

import models.BaseModel;

import tests.models.classes.ModelAggregator;


class ModelInvalidMetadata extends BaseModel
{
   [Required]
   [Optional]
   public var invalid:String = null;
}


class ModelOptionalMetadata extends BaseModel
{
   [Optional]
   public var optional:String = "default";
}


class ModelMissingCollectionMetadata extends BaseModel
{
   [Required]
   public var collection:Array = null;
}


class ModelUnsupportedCollectionItem extends BaseModel
{
   [Required(elementType="Date")]
   public var collection:Array = null;
}


class ModelRequiredProps extends BaseModel
{
   [Required]
   public var name:String = "";
   [Required]
   public var age:int = 0;
}


class ModelDateProp extends BaseModel
{
   [Required]
   public var date:Date = null;
}


class ModelUnsupportedPropertyType extends BaseModel
{
   [Required]
   public var point:Point;
}


class ModelAliasProperties extends BaseModel
{
   [Required(alias="requiredAlias")]
   /**
    * [Required(serverAlias="requiredAlias")]
    */
   public var required:String = null;
   
   [Optional(alias="optionalAlias")]
   /**
    * [Optional(serverAlias="optionalAlias")]
    */
   public var optional:String = null;
   
   [Required(alias="requiredModelAlias")]
   /**
    * [Required(alias="requiredModelAlias")]
    */
   public var requiredModel:BaseModel = null;
}

interface IAggregatorUser
{
   function getAggregator() : ModelAggregator;
}

class ModelPropsAggregatorAlias extends BaseModel implements IAggregatorUser {
   [Required(alias="aggregatorAlias", aggregatesProps="optional, required")]
   public var aggregator:ModelAggregator;
   public function getAggregator() : ModelAggregator {
      return aggregator;
   }
}

class ModelPropsAggregatorRequired extends BaseModel implements IAggregatorUser
{
   [Required(aggregatesProps="optional, required")]
   public var aggregator:ModelAggregator;
   public function getAggregator() : ModelAggregator {
      return aggregator;
   }
}

class ModelPropsAggregatorOptional extends BaseModel implements IAggregatorUser
{
   [Optional(aggregatesProps="optional, required")]
   public var aggregator:ModelAggregator;
   public function getAggregator() : ModelAggregator {
      return aggregator;
   }
}

class ModelPrefixAggregatorRequired extends BaseModel implements IAggregatorUser
{
   [Required(aggregatesPrefix="prefix")]
   public var aggregator:ModelAggregator;
   public function getAggregator() : ModelAggregator {
      return aggregator;
   }
}

class ModelPrefixAggregatorOptional extends BaseModel implements IAggregatorUser
{
   [Optional(aggregatesPrefix="prefix")]
   public var aggregator:ModelAggregator;
   public function getAggregator() : ModelAggregator {
      return aggregator;
   }
}

class ModelPropsAndPrefixAggregator extends BaseModel implements IAggregatorUser
{
   [Required(aggregatesProps="required", aggregatesPrefix="prefix")]
   public var aggregator:ModelAggregator;
   public function getAggregator() : ModelAggregator {
      return aggregator;
   }
}
