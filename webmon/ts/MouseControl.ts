namespace MouseControl{
    
let label: HTMLElement;

// Mouse panning
let isDown = false;
let startX: number;
let scrollLeft: number;

export function init(){
    label = document.getElementById("zoom-level");

    updateLabel();

    // Add mouse listener
    Plotter.canvas.addEventListener("wheel", function(e: any){
        if(e.deltaY < 0){
            Main.UserSettings.zoom *= (1 + Const.ZOOM_AFFECTOR);
        }else{
            Main.UserSettings.zoom *= (1 - Const.ZOOM_AFFECTOR);
        }
        if(Main.UserSettings.zoom == 0){
            Main.UserSettings.zoom = 1;
        }
        localStorage.zoom = Main.UserSettings.zoom;
        updateLabel();
        Plotter.draw();
        Main.HTMLElements.scroller.scrollLeft = Plotter.pan * Main.HTMLElements.scroller.scrollWidth;
    });

    Plotter.canvas.addEventListener("mousedown", e => {
        isDown = true;
        Main.HTMLElements.scroller.classList.add("active");
        startX = e.pageX - Main.HTMLElements.scroller.offsetLeft;
        scrollLeft = Main.HTMLElements.scroller.scrollLeft;
    });

    Plotter.canvas.addEventListener("mouseleave", () => {
        isDown = false;
        Main.HTMLElements.scroller.classList.remove("active");
    });

    Plotter.canvas.addEventListener("mouseup", () => {
        isDown = false;
        Main.HTMLElements.scroller.classList.remove("active");
    });

    Plotter.canvas.addEventListener("mousemove", e => {
        //
        Plotter.onMouseMove(e.offsetX, e.offsetY);

        if (!isDown) return;
        e.preventDefault();
        const x = e.pageX - Main.HTMLElements.scroller.offsetLeft;
        const walk = x - startX;
        Main.HTMLElements.scroller.scrollLeft = scrollLeft - walk;
    });
}

export function updateLabel(){
    label.innerText = "" + (Math.round(Main.UserSettings.zoom * 1000) / 1000);
}

}