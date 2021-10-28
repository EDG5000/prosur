namespace LegendUpdater{

export function updateLegend(){
    const legend = document.getElementById("legend");
    for(let labelIndex in Main.currentSensorLabels){
        let label = Main.currentSensorLabels[labelIndex];
        let color = typeof Const.SENSOR_COLORS[labelIndex] != "undefined" ? Const.SENSOR_COLORS[labelIndex] : "black";
        const span = document.createElement("span");
        span.style.color = color;
        span.innerText = label;
        legend.appendChild(span);
        legend.appendChild(document.createElement("br"));
    }
}

}