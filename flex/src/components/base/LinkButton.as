/**
 * Created by IntelliJ IDEA.
 * User: jho
 * Date: 3/1/12
 * Time: 5:10 PM
 * To change this template use File | Settings | File Templates.
 */
package components.base {
import components.skins.TruncatedLinkButtonSkin;

import spark.components.Button;

public class LinkButton extends Button {

    public function LinkButton() {
        super();
        setStyle('skinClass', TruncatedLinkButtonSkin);
    }

    [Bindable]
    public var truncateAt: int = 14;
}
}
