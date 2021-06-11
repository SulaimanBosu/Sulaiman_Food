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
				
	//$userid = $_GET['id'];
	
	// $_result = mysqli_query($link, "SELECT Shop_id FROM foodMenu WHERE Shop_id = '$Shopid'");
	// $row = mysqli_fetch_array($_result);
	// $ShopId = $row['Shop_id'];

	// if ($ShopId == Null || $ShopId == '') {

	// 	echo '[{"Shop_id":"null"}]';
	// 	//echo "User => $User_id";
		
	// }else{

// 		$result = mysqli_query($link, "SELECT f.*,
// (SELECT Name_shop FROM infomationShop WHERE Shop_id = f.Shop_id GROUP BY Shop_id ORDER BY Shop_id ASC LIMIT 0,1) AS Name_shop
// FROM foodMenu f INNER JOIN infomationShop i ON f.Shop_id = i.Shop_id");
				$result = mysqli_query($link, "SELECT f.*,i.Name_shop,i.Latitude as latitude,i.Longitude as longitude,i.Url_image
FROM foodMenu f INNER JOIN infomationShop i ON f.Shop_id = i.Shop_id");

		if ($result) {

			while($row=mysqli_fetch_assoc($result)){
			$output[]=$row;

			}	// while

			echo json_encode($output);

		}
//	  } //if

	} else echo "Welcome Sulaiman Food";	// if2
   
}	// if1


	mysqli_close($link);
?>