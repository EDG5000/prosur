<?php

ini_set('memory_limit', '2024M');

$dirPath = "/Users/joel/os/hc3d/hc3d-webmon/output";
//$outputPath = "/Users/joel/os/hc3d/hc3d-webmon/output";

foreach(scandir($dirPath) as $filename){
	if($filename == "." || $filename == ".." || $filename == ".DS_Store"){
		continue;
	}
	
	$filepath = $dirPath . "/" . $filename;
	
	
		
	
	
	$filedata = file_get_contents($filepath);
	$lines = preg_split("/\r\n|\n|\r/", $filedata);
	
	$time = trim(explode("\t", $lines[0])[0]);
	
	//echo $time;
	$newpath = $dirPath . "/" . $time . ".csv";
	echo $filepath . "\n" . $newpath . "\n";
	
	rename($filepath, $newpath);
	
	continue;
	
	$outputdata = "";
	foreach($lines as $lineno => $line){	
		$elements = explode("\t", $line);
		if(count($elements) != 29){
			echo count($elements) . "\n";
			continue; // Skip line, the line seems bad
		}
		$output_line = "";
		foreach($elements as $i => $element){
			
		    if($i == 0){
		    	// Obtain unix time
		   		$logprefix = str_replace(array("[", "]"), "", $element);
		    	$date = explode(" ", $logprefix)[0];
		    	$time = explode(" ", $logprefix)[1];
		    	$datetime = $date . " " .$time;
				$unixtime = strtotime($datetime);
				$output_line .= ($unixtime . "");
		    }else{
		    	// Only interested in elements prefixed with "vt"
		    	$prefix = substr($element, 0, 2);
		    	if($prefix != "vt"){
		    		continue;
		    	}
		    	$output_line .= "\t" . explode(":", $element)[1];
		    }
		}
		$outputdata .= $output_line . "\n";
	}
	file_put_contents($outputPath . "/" . $filename, $outputdata);
}


