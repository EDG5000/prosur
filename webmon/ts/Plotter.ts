namespace Plotter{
	// Main.canvas and context
	export let ctx: CanvasRenderingContext2D = null;

	export function init(){
		// Get DOM nodes and Main.canvas context
		ctx = Main.canvas.getContext("2d");
		Main.mouseValueContainer.innerText = (0).toFixed(2);

		addEventListener("resize", function(){
			if(Main.leftChunkTime == -1){
				// Only redraw upon resize after first frame is drawn
				return;
			}
			requestAnimationFrame(function(){
				draw();
			});
		});
	}

	let yMin;
	let yMax;
	let allColumns: Array<string> = [];

	export function onMouseMove(x: number, y: number){
		let yValue = (Math.round(100 * ((yMax - yMin) * (1-(y / (Main.canvas.height-Const.Y_MARGIN))) + yMin))/100).toFixed(2);
		Main.mouseValueContainer.innerText = yValue;
	}
	
	export function draw(){
		Main.canvas.width = Main.canvas.clientWidth;
		Main.canvas.height = Main.canvas.clientHeight;
		const leftChunkTime = Main.leftChunkTime;
		const rightChunkTime = Main.rightChunkTime;
		const zoom = Main.Settings.zoom;
		const leftChunk = typeof Main.chunks[zoom][leftChunkTime + ""] != "undefined" ? Main.chunks[zoom][leftChunkTime + ""] : null;
		const rightChunk = typeof Main.chunks[zoom][rightChunkTime + ""] != "undefined" ? Main.chunks[zoom][rightChunkTime + ""] : null;
		const chunkRange = Const.CHUNK_RANGE[zoom];
		const pan = Main.Settings.pan;
		const columns: Array<string> = [];
		
		const initialChunkOffset = Math.floor(((pan % chunkRange) / chunkRange) * Const.CHUNK_SIZE);

		// If there is data in any of the chunks, update legend, obtain user-selected column list and determine y-range
		if(leftChunk != null || rightChunk != null){
		
		
			// Update legend based on columns present in the data
			// Create checkboxes for toggling the columns and attach a handler for when they are clicked
			if(Main.legend.innerHTML == ""){
				// Pick any non-null chunk
				const chunk = leftChunk != null ? leftChunk : rightChunk;
				let i = 0;
				for(let column in chunk){
					if(column == "time"){
						continue;
					}
					allColumns.push(column);
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
						Main.canvasInvalidated = true;
					};
					radio.id = column;
					radio.value = column;
					const label: HTMLLabelElement = document.createElement("label");
					label.htmlFor = column;
					label.style.color = color;
					label.innerText = column.toUpperCase();
					Main.legend.appendChild(radio);
					Main.legend.appendChild(label);
					Main.legend.appendChild(document.createElement("br"));
					i++;
				}
			}

			// List the user-selected columns if they are also present in the data
			for(let column of allColumns){
				if(typeof Main.Settings.selectedColumns[column] != "undefined" && Main.Settings.selectedColumns[column]){
					columns.push(column);
				}
			}

			// Determine y-range
			yMin = null;
			yMax = null;
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
						if(val == null){
							continue;
						}
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
			const xPosition = Const.X_MARGIN + xRelative * (Main.canvas.width - Const.X_MARGIN);
			ctx.moveTo(xPosition, 0);
			ctx.lineTo(xPosition, Main.canvas.height - Const.Y_MARGIN);
			let timeUnix = Main.Settings.pan + Const.CHUNK_RANGE[zoom] * xRelative;
			valueString = Util.createTimeLabel(timeUnix);
			if(xRelative == 0){
				ctx.textAlign = "left";
			}else if(xRelative == 1){ // The rounding here is a bit hacky.
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
			// Load new job data if jobId changed. Clear job panel if no job in first frame
			let jobId = -1;
			if(leftChunk != null && typeof leftChunk.job_id != "undefined"){
				// Offset still within left chunk
				jobId = leftChunk.job_id[initialChunkOffset];
				if(jobId == null){
					jobId = -1;
				}
			}

			if(jobId != Main.jobId){
				// Job ID has changed; persist it and trigger job load
				Main.jobId = jobId;
				JobInfo.load(jobId);
			}


			// Draw data for each column
			for(let colno = 0; colno < columns.length; colno++){
				// Get index of column in full column list in order to pick the color
				let color: string;
				let column = columns[colno];
				for(let allcolno = 0; allcolno < allColumns.length; allcolno++){
					if(allColumns[allcolno] == column){
						color = Const.SENSOR_COLORS[allcolno];
						break;
					}
				}
				// Get colname, set color, start path
				ctx.strokeStyle = color;
				ctx.beginPath();

				let startLine = true;
				for(let plotIndex = 0; plotIndex < Const.CHUNK_SIZE; plotIndex++){
					let chunkOffset = initialChunkOffset + plotIndex;
					let val = null;
					//console.log(chunkOffset + " en " + chunkOffset % Const.CHUNK_SIZE);
					if(leftChunk != null && chunkOffset < Const.CHUNK_SIZE){
						// Offset still within left chunk
						val = leftChunk[column][chunkOffset];
					}else if(rightChunk != null && chunkOffset > Const.CHUNK_SIZE){
						// Offset beyond left chunk and within right chunk
						val = rightChunk[column][chunkOffset % Const.CHUNK_SIZE];
					}

					if(colno == 0){
						console.log(val);
					}
					

					if(val == null){
						// No data for this plot index. Prevent next line (if any) from connecting with the last drawn data.
						startLine = true;
						continue;
					}
	
					let x = Const.X_MARGIN + Math.round(((plotIndex/Const.CHUNK_SIZE) * (Main.canvas.width - Const.X_MARGIN)));
					let y = Main.canvas.height - Math.round(((val-yMin) * scaleY)) - Const.Y_MARGIN;

					if(startLine){
						//console.log("moveTo " + x + ", " + " " + y);
						ctx.moveTo(x, y);
						startLine = false;
					}else{
						//console.log("lineTo " + x + ", " + " " + y);
						ctx.lineTo(x, y);
					}
				}

				ctx.stroke();
			}

			// Complete drawing of grid
			ctx.stroke();
		}
	}

}