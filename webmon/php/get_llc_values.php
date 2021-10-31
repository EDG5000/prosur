<?php

$line = '';

// Get filename of current data log file (take 1st one from folder listing)
$directory = "/mnt/data/";
$files = scandir ($directory);
$file = $directory . $files[2];// because [0] = "." [1] = ".." 
$file = "/mnt/data/hc3d-tm.csv";
//how many lines?
$linecount=5;

//what's a typical line length?
$length=396;

//we double the offset factor on each iteration
//if our first guess at the file offset doesn't
//yield $linecount lines
$offset_factor=1;


$bytes=filesize($file);
$fp = fopen($file, "r") or die("Can't open $file");


$complete=false;
while (!$complete)
{
    //seek to a position close to end of file
    $offset = $linecount * $length * $offset_factor;
    fseek($fp, -$offset, SEEK_END);


    //we might seek mid-line, so read partial line
    //if our offset means we're reading the whole file, 
    //we don't skip...
    if ($offset<$bytes)
        fgets($fp);

    //read all following lines, store last x
    $lines=array();
    while(!feof($fp))
    {
        $line = fgets($fp);
        array_push($lines, $line);
        if (count($lines)>$linecount)
        {
            array_shift($lines);
            $complete=true;
        }
    }

    //if we read the whole file, we're done, even if we
    //don't have enough lines
    if ($offset>=$bytes)
        $complete=true;
    else
        $offset_factor*=2; //otherwise let's seek even further back

}
fclose($fp);

echo $lines[0];
