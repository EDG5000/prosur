namespace Plotter{

	// Main.canvas and context
	export let ctx: CanvasRenderingContext2D = null;


	export function init(){
		// Get DOM nodes and Main.canvas context
		ctx = Main.canvas.getContext("2d");

		let active = false;
		/*
		// Adjust horizontal pan whenever the graph is scrolled horizontally
		Main.canvas.addEventListener("scroll", function(e: Event){
			if(!active){
				requestAnimationFrame(function(){
					Main.Settings.pan = Main.scroller.scrollLeft/Main.scroller.scrollWidth;
					draw();
					active = false;
				});
				active = true;
			}
		});
		*/
		Main.mouseValueContainer.innerText = (0).toFixed(2);

		/*addEventListener("resize", function(){
			requestAnimationFrame(draw);
		});*/
	}

	/*
	export function onMouseMove(x: number, y: number){
		let yValue = (Math.round(100 * ((yMax - yMin) * (1-(y / (Main.canvas.height-Const.Y_MARGIN))) + yMin))/100).toFixed(2);
		Main.mouseValueContainer.innerText = yValue;
	}
	*/

	export function draw(leftChunkTime: number, rightChunkTime: number, leftChunk: any, rightChunk: any, zoom: number){

		// Calculate additional parameters
		Main.canvas.width = innerWidth - Const.SIDEBAR_WIDTH;
		Main.canvas.height = innerHeight - Const.SCROLL_BAR_SIZE;
		const chunkRange = Const.CHUNK_RANGE[zoom];
		const pan = Main.Settings.pan;

		const scaleX = Main.Settings.zoom * Const.BASE_ZOOM_FACTOR;
		const xMax = pan + Const.CHUNK_RANGE[zoom];
		//const modulus = Math.pow(2, zoom);
		let yMin = 0;
		let yMax = 0;
		const columns: Array<string> = [];

		// If there is data in any of the chunks, update legend, obtain user-selected column list and determine y-range
		if(leftChunk != null || rightChunk != null){
			// List numeric columns available in the data by looking at the left chunk
			const allColumns: Array<string> = [];
			// Pick any non-null chunk
			const chunk = leftChunk != null ? leftChunk : rightChunk;
			for(let column in chunk){
				if(typeof leftChunk[column][0] != "number"){
					// We are here to plot numbers and numbers only. Understood?
					continue;
				}
				allColumns.push(column);
			}
		
			// Update legend based on columns present in the data
			// Create checkboxes for toggling the columns and attach a handler for when they are clicked
			Main.legend.innerText = "";
			for(let i = 0; i < allColumns.length; i++){
				let column = allColumns[i];
				let color = typeof Const.SENSOR_COLORS[i] != "undefined" ? Const.SENSOR_COLORS[i] : "white";
				// Create checkbox to toggle column
				const radio = document.createElement("input");
				// Columns are checked off unless a user setting with value "true" is present
				radio.checked = typeof Main.Settings.selectedColumns[column] != "undefined" && Main.Settings.selectedColumns[column];
				radio.type = "checkbox";
				radio.onclick = function(e){
					// Store choice in memory and flush to local storage
					Main.Settings.selectedColumns[column] = radio.checked;
					localStorage.selectedColumns = JSON.stringify(Main.Settings.selectedColumns);
					Main.tick();
				};
				
				radio.value = column;
				const span = document.createElement("span");
				span.style.color = color;
				span.innerText = column.toUpperCase();
				Main.legend.appendChild(radio);
				Main.legend.appendChild(span);
				Main.legend.appendChild(document.createElement("br"));
			}

			// List the user-selected columns if they are also present in the data
			for(let column of allColumns){
				if(typeof Main.Settings.selectedColumns[column] != "undefined" && Main.Settings.selectedColumns[column]){
					columns.push(column);
				}
			}

			// Determine y-range
			for(let column of columns){
				let chunks = [];
				if(leftChunk != null){
					chunks.push(leftChunk);
				}
				if(rightChunk != null){
					chunks.push(rightChunk);
				}
				for(let chunk of chunks){
					// Fetch value from the correct chunk
					for(let val of chunk[column]){
						// Update min and max as appropriate
						if(val < yMin || yMin == null){
							yMin = val;
						}
						if(val > yMax || yMax == null){
							yMax = val;
						}
					}
				}
			}
		}

		// Apply fallback y-range if needed (in the case of no data or other edge cases)
		if(yMin == null || yMax == 0 || !Number.isFinite(yMin) || !Number.isFinite(yMax) || isNaN(yMin) || isNaN(yMax) || Math.abs(yMax-yMin) == 0){
			// Unable to calculate range, set artifical range 1 below and 1 above current value, which should center the line if there is a line at all
			yMin = 1;
			yMax = 1;
		}

		// Calculate drawing scale
		const scaleY = (Main.canvas.height - Const.Y_MARGIN) / (yMax-yMin);
	
		// Start drawing grid 
		ctx.strokeStyle = "#909090"; // Grid and axis color
		ctx.fillStyle = "white"; // Text color
		ctx.beginPath(); 
		ctx.font = "1em monospace";
		
		// Draw horizontal grid lines and y axis labels
		let yRelative = 0;
		ctx.textAlign = "right";
		let valueString: string;
		while(yRelative <= 1){
			let yValue = yMin + ((yMax-yMin) * (1-yRelative));
			let yPosition = (Main.canvas.height-Const.Y_MARGIN) * yRelative;
			ctx.moveTo(Const.X_MARGIN, yPosition);
			ctx.lineTo(Main.canvas.width, yPosition);
			valueString = yValue.toFixed(1);
			// These offsets should be constants!
			let ylabelYOffset = 4;
			if(yRelative == 0){
				ylabelYOffset = 10;
			}else if(yRelative == 1){
				ylabelYOffset = -10;
			}
			ctx.fillText(valueString, Const.X_MARGIN - Const.Y_LABEL_X_OFFSET, yPosition + ylabelYOffset);
			yRelative += Const.Y_GRID_INTERVAL;
		}

		// Draw vertical grid lines and x axis labels
		let xRelative = 0;
		while(xRelative <= 1){
			let xValue = pan + (xMax-pan) * xRelative;
			let xPosition = Const.X_MARGIN + (xValue - pan) * scaleX;
			ctx.moveTo(xPosition, 0);
			ctx.lineTo(xPosition, Main.canvas.height - Const.Y_MARGIN);
			let timeUnix = leftChunkTime + (xValue / Const.FREQ_HZ);
			valueString = Util.createTimeLabel(timeUnix);
			if(xValue - pan == 0){
				ctx.textAlign = "left";
			}else if(Math.round(xValue) == xMax){ // The rounding here is a bit hacky.
				ctx.textAlign = "right";
			}else{
				ctx.textAlign = "center";
			}
			ctx.fillText(valueString, xPosition, Main.canvas.height - Const.X_LABEL_Y_OFFSET);
			xRelative +=  Const.X_GRID_INTERVAL;
		} 
		ctx.stroke();
	
		

		// Plot the data if at least one of the chunks are non-null
		if(leftChunk != null || rightChunk != null){
			let startIndex: number;
			let endIndex: number;

			if(leftChunk != null){
				// Starting at left chunk
				startIndex = Math.floor(((pan % chunkRange) / chunkRange) * Const.CHUNK_SIZE);
			}else{
				// First row of right chunk
				startIndex = 0;
			}
			if(rightChunk != null){
				// Inverse of startIndex
				endIndex = Const.CHUNK_SIZE - startIndex;
			}else{
				// Ending at left chunk
				endIndex = Const.CHUNK_SIZE - 1;
			}

			// Draw data for each column
			for(let colno = 0; colno < columns.length; colno++){
				// Get colname, set color, start path
				const column = columns[colno];
				let color = Const.SENSOR_COLORS[colno];
				ctx.strokeStyle = color;
				ctx.beginPath();
				
				// Draw a line per value
				let inLeftChunk = leftChunk != null; // Still in left chunk. Set low once right chunk is reached.
				let ready = false;
				let initial = true;
				// Start iterating at startIndex of left chunk if possible. Otherwise, start at leftIndex of right chunk
				// End at endIndex of right chunk or endIndex in left chunk if right chunk is not available
				// Move from left chunk to right chunk as needed
				for(let index = startIndex; !ready; index++){
					let val: number;
					let time: number;
					if(inLeftChunk && index < leftChunk[column].length){
						val = leftChunk[column][index];
						time = leftChunk["time"][index];
					}else if(inLeftChunk && index == Const.CHUNK_SIZE){
						// Left chunk fully traversed
						if(rightChunk == null){
							// There is no right chunk, so all drawing is complete
							break;
						}else{
							// Proceed to right chunk or abort when right chunk is not available
							index = 0;
							inLeftChunk = false;
							continue;
						}
					}else if(rightChunk != null && index < endIndex && index < rightChunk[column].length){
						// In right chunk
						val = rightChunk[column][index];
						time = rightChunk["time"][index];
						if(rightChunk == null){
							// Only the left chunk was present, abort now.
							break;
						}
					}else{
						break;
					}
					let xPos = ((time - Main.Settings.pan)/Const.FREQ_HZ) * scaleX + Const.X_MARGIN;
					let yPos = Main.canvas.height - ((val-yMin) * scaleY) - Const.Y_MARGIN;
					if(initial){
						ctx.moveTo(xPos, yPos);
						initial = false;
					}else{
						ctx.lineTo(xPos, yPos);
					}
				}
				ctx.stroke();
			}
			// Complete drawing of grid
			ctx.stroke();
		}
	}

}