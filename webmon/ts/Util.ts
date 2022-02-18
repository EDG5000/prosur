namespace Util{

// Based on: https://stackoverflow.com/a/847196
export let createTimeLabel = function(unixTime: number){
    // Method A (well-mannered, ill-advised)
    //return new Date(unixTime * 1000).toLocaleString();
    
    unixTime += (new Date().getTimezoneOffset()*-60);

    // Method B (intelligent)
    let dateString = new Date(unixTime * 1000).toJSON();
    if(dateString == null){
        console.error("Date string is null. Unixtime was: " + unixTime);
        debugger;
    }
    return dateString.replace("T", " ").slice(0, 16);

    // Method C (artisanal, against recommendation)
    /*let date = new Date(unixTime * 1000);
    let year = date.getFullYear();
    let month = ("0" + (date.getMonth()+1)).substr(-1);
    let day = "0" + date.getDate();
    let hours = "0" + date.getHours();
    let minutes = "0" + date.getMinutes();
    let seconds = "0" + date.getSeconds();
    let formattedTime = year + "-" + month + "-" + day + " " + hours.substr(-2) + ':' + minutes.substr(-2) + '.' + seconds.substr(-2);
    return formattedTime;*/
}

}
