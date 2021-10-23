namespace Frame{

// Deserialize frame
export class Frame{
	timeUnix: number;
	temps: Array<number>;
	constructor(rawFrame: string){
		this.temps = [];
		var i = 0;
		var lastIndex = 0;
		while(lastIndex !== -1){
			var index = rawFrame.indexOf('\t', lastIndex+1);
			var valueRaw = rawFrame.substr(lastIndex, index-lastIndex);
			if(index == -1){
				break;
			}
			if(lastIndex == 0){
                this.timeUnix = parseInt(valueRaw);
			}else{
				this.temps[i-1] = parseFloat(valueRaw);
			}
			
			if(lastIndex == rawFrame.length-1){
				break;
			}
			lastIndex = index;
			i++;
		}
	}
};

}