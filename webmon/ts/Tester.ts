namespace Tester{

export function sine(){
    Main.loading = true;
    Main.frames = [];
    let csvData = "unixtime\tsine";
    for(let i = 0; i < 60 * 60 * 24; i++){
        let angle = (i / 1000) % Math.PI * 2;
        csvData += '\n' + i + '\t' + ((Math.sin(angle)*1000));
    }
    console.log(csvData);
    SessionLoader.processSessionData(csvData);
}

}