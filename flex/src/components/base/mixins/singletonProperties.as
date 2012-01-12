// Declares references to application wide singletons as public static variables.
// Declared variables are suided for components but can be used elsewhere although
// in ActionSript code Singleton.instance 
// Binding to these variables won't cause any warnings.

import models.ModelLocator;
import utils.assets.ImagePreloader;




[Bindable]
public var ML:  ModelLocator     = ModelLocator.getInstance ();
[Bindable]
public var IMG: ImagePreloader   = ImagePreloader.getInstance ();