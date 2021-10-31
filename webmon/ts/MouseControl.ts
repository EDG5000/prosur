namespace MouseControl{
    
let label: HTMLElement;

// Mouse panning
let isDown = false;
let startX: number;
let scrollLeft: number;

export function init(){
    label = document.getElementById("zoomLevel");

    Main.zoom = parseFloat(localStorage.zoom);
    if(isNaN(Main.zoom)){
        Main.zoom = 1;
    }

    updateLabel();

    // Add mouse listener
    Main.canvas.addEventListener("wheel", function(e: any){
        if(e.deltaY < 0){
            Main.zoom *= (1 + Const.zoomAffector);
        }else{
            Main.zoom *= (1 - Const.zoomAffector);
        }
        if(Main.zoom == 0){
            Main.zoom = 1;
        }
        localStorage.zoom = Main.zoom;
        updateLabel();
        Drawer.draw();
        Main.scroller.scrollLeft = Main.pan * Main.scroller.scrollWidth;
    });

    Main.canvas.addEventListener("mousedown", e => {
        isDown = true;
        Main.scroller.classList.add("active");
        startX = e.pageX - Main.scroller.offsetLeft;
        scrollLeft = Main.scroller.scrollLeft;
    });

    Main.canvas.addEventListener("mouseleave", () => {
        isDown = false;
        Main.scroller.classList.remove("active");
    });

    Main.canvas.addEventListener("mouseup", () => {
        isDown = false;
        Main.scroller.classList.remove("active");
    });

    Main.canvas.addEventListener("mousemove", e => {
        if (!isDown) return;
        e.preventDefault();
        const x = e.pageX - Main.scroller.offsetLeft;
        const walk = x - startX;
        Main.scroller.scrollLeft = scrollLeft - walk;
    });
}

export function updateLabel(){
    label.innerText = "" + (Math.round(Main.zoom * 1000) / 1000);
}

}