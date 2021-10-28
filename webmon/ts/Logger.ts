namespace Logger{

let lastTime = new Date().getTime();

export function i(msg: string){
    let time = new Date().getTime();
    console.log("[" + (time-lastTime) + "] " + msg);
    lastTime = time;
}

}