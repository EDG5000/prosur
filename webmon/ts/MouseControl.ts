namespace MouseControl{
    
let label: HTMLElement;

// Mouse panning
let isDown = false;
let startX: number;

export function init(){
    label = document.getElementById("zoom-level");

    updateLabel();

    // Add mouse listener
    Main.canvas.addEventListener("wheel", function(e: any){
        if(e.deltaY < 0 && Main.Settings.zoom < Const.MAX_ZOOM){
            //Main.UserSettings.zoom *= (1 + Const.ZOOM_AFFECTOR);
            Main.Settings.zoom += 1;
        }else if(e.deltaY > 0 && Main.Settings.zoom > 2){
            //Main.UserSettings.zoom *= (1 - Const.ZOOM_AFFECTOR);
            Main.Settings.zoom -= 1;
        }
        /*
        if(Main.UserSettings.zoom == 0){
            Main.UserSettings.zoom = 1;
        }
        */
       
        localStorage.zoom = Main.Settings.zoom;
        updateLabel();
        
        //Main.HTMLElements.scroller.scrollLeft = 
        //Main.Settings.pan = Main.Settings.pan - Main.Settings.pan * Main.HTMLElements.scroller.scrollWidth;;
        // TODO set pan
        localStorage.pan = Main.Settings.pan;
        ChunkLoader.tick();
    });

    Main.canvas.addEventListener("mousedown", e => {
        isDown = true;
        //Main.HTMLElements.scroller.classList.add("active");
        //startX = e.pageX - Main.HTMLElements.scroller.offsetLeft;
        //Main.Settings.pan = Main.HTMLElements.scroller.scrollLeft;
        localStorage.pan = Main.Settings.pan;
        ChunkLoader.tick();
    });

    Main.canvas.addEventListener("mouseleave", () => {
        isDown = false;
        //Main.HTMLElements.scroller.classList.remove("active");
    });

    Main.canvas.addEventListener("mouseup", () => {
        isDown = false;
        //Main.HTMLElements.scroller.classList.remove("active");
    });

    Main.canvas.addEventListener("mousemove", e => {
        // TODO
        //Plotter.onMouseMove(e.offsetX, e.offsetY);

        if (!isDown) return;
        e.preventDefault();
        //const x = e.pageX - Main.HTMLElements.scroller.offsetLeft;
        //const walk = x - startX;
        //Main.Settings.pan = Main.Settings.pan - walk;
        // TODO calculate pan
        localStorage.pan = Main.Settings.pan;
        ChunkLoader.tick();
    });
}

export function updateLabel(){
    label.innerText = "" + (Math.round(Main.Settings.zoom * 1000) / 1000);
}

}