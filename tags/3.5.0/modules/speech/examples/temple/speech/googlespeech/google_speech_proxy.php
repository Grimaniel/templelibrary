<?php

// fetch the api parameters, and pass the defaults if they are not in the request
$xjerr = isset($_GET['xjerr']) && !empty($_GET['xjerr']) ? $_GET['xjerr'] : '1';
$client = isset($_GET['client']) && !empty($_GET['client']) ? $_GET['client'] : 'chromium';
$maxresults = isset($_GET['maxresults']) && !empty($_GET['maxresults']) ? $_GET['maxresults'] : '1';
$lang = isset($_GET['lang']) && !empty($_GET['lang']) ? $_GET['lang'] : 'en-US';
$pfilter = isset($_GET['pfilter']) && !empty($_GET['pfilter']) ? $_GET['pfilter'] : '2';

// the key in the $_FILES superglobal that is used to pass the encoded FLAC file
$fileKey = isset($_GET['fileKey']) && !empty($_GET['fileKey']) ? $_GET['fileKey'] : 'recording';

// the samplerate in which the FLAC file is encoded
$rate = isset($_GET['rate']) && !empty($_GET['rate']) ? $_GET['rate'] : 8000;


// get the base path for this script, make sure this directory has write permissions
$path = substr($_SERVER["SCRIPT_FILENAME"], 0, strrpos($_SERVER["SCRIPT_FILENAME"], '/'));
// a random filename, so the file can be on disk without the risk to be overwritten
$file = time() . '_' . rand();

$infile = $path . '/' . $file . '.flac';


// move the file to disk so it can be send to the Google Speech server
if (isset($_FILES[$fileKey]))
{
	if (FALSE === move_uploaded_file($_FILES[$fileKey]['tmp_name'], $file . '.flac'))
	{
		// TODO: return json error message
		echo 'error saving recording.wav' . "<br />\n";
	}
}
else
{
	// TODO: return json error message
	die('no input file');
}


// create curl resource
$ch = curl_init();

// set url
$url = 'https://www.google.com/speech-api/v1/recognize?xjerr=' . $xjerr . '&client=' . $client . '&lang=' . $lang . '&maxresults=' . $maxresults . '&pfilter=' . $pfilter;
curl_setopt($ch, CURLOPT_URL, $url);

//return the transfer as a string
curl_setopt($ch, CURLOPT_RETURNTRANSFER, TRUE);

// do a POST
curl_setopt($ch, CURLOPT_POST, TRUE);

// add the .flac file as raw-post-data
curl_setopt($ch, CURLOPT_POSTFIELDS, file_get_contents($infile));

// set correct headers
curl_setopt($ch, CURLOPT_HTTPHEADER, array('Content-type: audio/x-flac; rate=' . $rate));

// $output contains the resulting json
$output = curl_exec($ch);

// close curl resource to free up system resources
curl_close($ch);   

// remove the temp file after the call is executed
unlink($infile);

//echo $url;

// output the result back to the client
echo $output;