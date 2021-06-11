<?php
error_reporting(E_ERROR | E_PARSE);
	include 'connected.php';
	header("Access-Control-Allow-Origin: *");


// Response object structure
$response = new stdClass;
$response->status = null;
$response->message = null;

// Uploading file
$destination_dir = "Shop/imageFood/";
$base_filename = basename($_FILES["file"]["name"]);
$target_file = $destination_dir . $base_filename;


if(!$_FILES["file"]["error"])
{
    if (move_uploaded_file($_FILES["file"]["tmp_name"], $target_file)) { 
    	//echo "true";      
        $response->status = true;
        $response->message = "successfully";

    } else {

        $response->status = false;
        $response->message = "File uploading failed";
    }    
} 
else
{
    $response->status = false;
    $response->message = "File uploading failed";
}

header('Content-Type: application/json');
echo json_encode($response);
mysqli_close($link);