namespace Util{

// Based on: https://stackoverflow.com/a/847196
export let createTimeLabel = function(unixTime: number){
    let date = new Date(unixTime * 1000);
    let year = date.getFullYear();
    let month = "0" + date.getMonth();
    let day = "0" + date.getDay();
    let hours = date.getHours();
    let minutes = "0" + date.getMinutes();
    let seconds = "0" + date.getSeconds();
    let formattedTime = year + "-" + month + "-" + day + "T" + hours + ':' + minutes.substr(-2) + '.' + seconds.substr(-2);
    return formattedTime;
}

}
