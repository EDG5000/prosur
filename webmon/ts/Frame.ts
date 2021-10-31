namespace Frame{

// Deserialize frame
export class Frame{
	timeUnix: number;
	temps: Array<number>;
	constructor(rawFrame: string){
		this.temps = [];
		
		let start = 0;
		let end = rawFrame.indexOf('\t');
		let endReached = false;

		while(start != end){
			if(end == -1){
				end = rawFrame.length;
				endReached = true;
			}
			let valueRaw = rawFrame.substr(start, end-start);

			if(start == 0){
                this.timeUnix = parseInt(valueRaw);
			}else{
				this.temps.push(parseFloat(valueRaw));
			}
			
			start = end;
			if(endReached){
				break;
			}
			end = rawFrame.indexOf('\t', start+1);
		}


	}
};

}