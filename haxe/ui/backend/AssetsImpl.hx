package haxe.ui.backend;
import haxe.Resource;
import haxe.ui.assets.ImageInfo;
import haxe.ui.backend.pdcurses.Image;
import haxe.ui.backend.pdcurses.ppm.PPMImage;

class AssetsImpl extends AssetsBase {
    private override function getImageInternal(resourceId:String, callback:ImageInfo->Void) {
        if (Resource.getString(resourceId) != null) {
            var ppm = PPMImage.fromString(Resource.getString(resourceId));
            callback({
                data: ppm,
                width: ppm.width,
                height: ppm.height
            });
            return;
        }
        
        var ppm = PPMImage.fromChar(resourceId);
        if (ppm == null) {
            callback(null);
        } else {
            callback({
                data: ppm,
                width: ppm.width,
                height: ppm.height
            });
        }
        /*
        var char = Image.charFromString(resourceId);
        if (char == -1) {
            callback(null); 
        } else {
            callback({
                data: resourceId,
                width: 1,
                height: 1
            });
        }
        */
    }
}