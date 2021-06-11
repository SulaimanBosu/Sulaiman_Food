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
			
		
		$FoodName = $_GET['foodname'];
		$FoodDetail = $_GET['fooddetail'];
		$Price = $_GET['price'];
		$Urlimage = $_GET['urlImage'];
		$foodid = $_GET['Foodid'];
		//$Shopid = $_GET['Shopid'];

	$sql = "UPDATE `foodMenu` SET `Food_Name` = '$FoodName', `Food_Detail` = '$FoodDetail', `Price` = '$Price', `Image_Path` = '$Urlimage' WHERE Food_id = '$foodid'";


		$result = mysqli_query($link, $sql);

		if ($result){
			echo "true";
		} else {
			echo "false";
		}
	  

	} else echo "Welcome Sulaiman Food";
   
}

	mysqli_close($link);
?>