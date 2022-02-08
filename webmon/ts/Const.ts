namespace Const{

    export const SENSOR_COLORS = [
        "#e6194B",
        "#3cb44b",
        "#7d90d6",
        "#f58231",
        "#db7af8",
        "#42d4f4",
        "#f032e6",
        "#469990",
        "#dcbeff",
        "#9A6324",
        "#fffac8",
        "#aaffc3",
        "#ffd8b1",
        "#a9a9a9",// end
        "#e6194B",
        "#3cb44b",
        "#7d90d6",
        "#f58231",
        "#db7af8",
        "#42d4f4",
        "#f032e6",
        "#469990",
        "#dcbeff",
        "#9A6324",
        "#fffac8",
        "#aaffc3",
        "#808000",
        "#ffd8b1",
        "#a9a9a9",
    ];

    export const XHR = {
        DONE: 4,
        LOADING: 3,
        HEADERS_RECEIVED: 2,
        OPENED: 1,
        UNSENT: 0

    };

    //export const ZOOM_AFFECTOR = 0.05; Perhaps still needed to set mouse wheel sensitivity
    export const SIDEBAR_WIDTH = 400; // px; needs to match with values in CSS
    export const FREQ_HZ = 1; // Assumed frequency of souce data. (timestamps ignored)
    export const WINDOW_TIME_SPAN_S = 60 * 60; // Display 1 hr of data in one windows' width
    export const BASE_ZOOM_FACTOR = WINDOW_TIME_SPAN_S / window.innerWidth; // Pixels per frame (pixels per frequencyHz seconds)
    export const X_GRID_INTERVAL = 0.2; // Relative to graph width
    export const Y_GRID_INTERVAL = 0.1; // Relative to graph height
    export const Y_MARGIN = 40;
    export const X_MARGIN = 50;
    export const Y_LABEL_X_OFFSET = 10;
    export const X_LABEL_Y_OFFSET = 20;
    export const SCROLL_BAR_SIZE = 50; // Needs to be set to browser scroll bar size or larger
    export const MAX_ZOOM = 13; // 2^13 = ~24hr
    export const CACHE_MAX_FRAMES = 100000 // ~100 bytes per frame
    export let CHUNK_RANGE = []; // Delta time per chunk, per zoom level. With modulus of 1, this equals the plot width in pixels.
    export const CHUNK_SIZE = window.innerWidth - Const.X_MARGIN - Const.SIDEBAR_WIDTH; // Amount of frames in chunk
    export const STILL_CAPTURE_INTERVAL = 6;
    export const STILL_WIDTH = 1280; // Dimensions of images taken on frame
    export const STILL_HEIGHT = 960;

    export function init(){
        // Frame count depends on modulus and chunk size, calculated at init 
        for(let zoom = 0; zoom <= Const.MAX_ZOOM; zoom++){
            // Using an object for this, as the first element can have non-zero value.
            CHUNK_RANGE.push(CHUNK_SIZE * Math.pow(2, zoom));
        }
    }   
}
