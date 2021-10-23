namespace SessionLoader{

// Load session data by filename.  
export function load(filename: string){

	console.log("Loading session...");
	App.loading = true;
	App.frames = [];

    var xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function() {
        if(this.readyState != 4) return;
        console.log("Parsing data...");
        var responseData = xhttp.responseText;
        var lastIndex = 0;
        while(lastIndex !== -1){
            var index = responseData.indexOf('\n', lastIndex+1);
            var line = responseData.substr(lastIndex, index-lastIndex);
            var frame = new App.Frame(line);
            App.frames.push(frame);
            if(lastIndex == responseData.length-1){
            	break;
            } 
            lastIndex = index;
        }
        App.loading = false;
        console.log("Session loaded. Frames: " + frames.length);
        Drawer.draw();
    };
    
    if(App.TEST_MODE){
        var url = "testdata/" + filename
    }else{
        var url = "mnt-data/" + filename;
    }

    xhttp.open("GET", url, true);
    xhttp.send();
};


}