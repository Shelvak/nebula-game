import mx.utils.ObjectUtil;

import utils.ClassUtil;


private function sendSimple_completeHandler(methodName:String, parameters:Array, status:uint) : void
{
   if (status == MessageDeliveryStatus.COMPLETE)
   {
      return;
   }
   var message:String = "[" + ClassUtil.getClassNameSimple(this) + "] Unable to invoke method '" +
                        methodName + "' with parameters " + ObjectUtil.toString(parameters) + ": ";
   switch (status)
   {
      case MessageDeliveryStatus.CANCEL:
         message += " call has been canceled because a call before this has failed!";
         break;
      case MessageDeliveryStatus.ERROR:
         message += " call has ended with an error!";
         break;
   }
   trace(message);
}


private function sendLarge_completeHandler(methodName:String, data:String, status:uint) : void
{
   if (status == MessageDeliveryStatus.COMPLETE)
   {
      return;
   }
   var message:String = "[" + ClassUtil.getClassNameSimple(this) + "] Unable to send message '" +
                        data + "' via method '" + methodName + ": ";
   switch (status)
   {
      case MessageDeliveryStatus.CANCEL:
         message += " call has been canceled because a call before this has failed!";
         break;
      case MessageDeliveryStatus.ERROR:
         message += " call has ended with an error!";
         break;
   }
   trace(message);
}