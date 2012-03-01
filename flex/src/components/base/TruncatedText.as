/**
 * Created by IntelliJ IDEA.
 * User: jho
 * Date: 3/1/12
 * Time: 4:19 PM
 * To change this template use File | Settings | File Templates.
 */
package components.base {
import mx.core.mx_internal;

import spark.components.Label;

use namespace mx_internal;

public class TruncatedText extends Label {

    protected static const TRUNCATION_INDICATOR : String = "...";

    public function TruncatedText() {
        super();
    }
    
    private var originalText : String = '';

    override public function set text(text : String) : void {
        originalText = text;
        super.text = text;
    }

    public var truncateAt: int = 8;

    protected function get truncationRequired() : Boolean {
        return originalText.length > truncateAt + 2;
    }

    override protected function updateDisplayList(w : Number, h : Number) : void {
        super.updateDisplayList(w, h);
        if (truncationRequired) {
           text = originalText.substr(0, truncateAt) + TRUNCATION_INDICATOR;
        }
    }

}
}
