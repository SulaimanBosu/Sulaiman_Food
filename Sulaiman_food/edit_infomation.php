<?php
	include 'connected.php';
	header("Access-Control-Allow-Origin: *");

if (!$link) {
    echo "Error: Unable to connect to MySQL." . PHP_EOL;
    echo "Debugging errno: " . mysqli_connect_errno() . PHP_EOL;
    echo "Debugging error: " . mysqli_connect_error() . PHP_EOL;
    
    exit;
}

if (!$link->set_charset("utf8")) {
    printf("Error loading character set utf8: %s\n", $link->error);
    exit();
	}


if (isset($_GET)) {
	if ($_GET['isAdd'] == 'true') {			
				
		$Nameshop = $_GET['nameShop'];
		$Addressshop = $_GET['addressShop'];
		$Phoneshop = $_GET['phoneShop'];
		$Urlimage = $_GET['urlImage'];
		$Latitude = $_GET['latitude'];
		$Longitude = $_GET['longitude'];
		$Shopid = $_GET['shopid'];
		$Userid = $_GET['userid'];

		
							
		$sql = "UPDATE `infomationShop` SET `Name_shop` = '$Nameshop', `Address_shop` = '$Addressshop', `Phone_shop` = '$Phoneshop', `Url_image` = '$Urlimage', `Latitude` = '$Latitude', `Longitude` = '$Longitude' WHERE Shop_id = '$Shopid'";


	    $sql2 = "UPDATE `userTABLE` SET `Shop_id` = '$Shopid' WHERE User_id = '$Userid'";

		$result = mysqli_query($link, $sql);
		$result2 = mysqli_query($link, $sql2);

		if ($result && $result2){
			echo "true";
		} else {
			echo "false";
		}

	} else echo "Welcome Sulaiman Food";
   
}

	mysqli_close($link);
?>