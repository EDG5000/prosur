namespace Const{
export const TEST_MODE = true;
export const SENSOR_LABELS = [
    "Chamber Mid",
    "Chamber Top",
    "Chamber Heater",
    "Motor X", 
    "Motor Y",
    "Motor Z",
    "Motor E"
];
export const SENSOR_COLORS = [
    "red",
    "green",
    "darkmagenta",
    "purple",
    "grey",
    "orange",
    "darkgreen"
];
export let DATA_FOLDER: string;
if(TEST_MODE){
    DATA_FOLDER = "testdata";
}else{
    DATA_FOLDER = "mnt-data";
}
export const CURRENT_LOG_FILE = "hc3d-temp.csv";
}