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
				
	$shopid = $_GET['Shop_id'];
	
	// $_result = mysqli_query($link, "SELECT Shop_id FROM foodMenu WHERE Shop_id = '$Shopid'");
	// $row = mysqli_fetch_array($_result);
	// $ShopId = $row['Shop_id'];

	// if ($ShopId == Null || $ShopId == '') {

	// 	echo '[{"Shop_id":"null"}]';
	// 	//echo "User => $User_id";
		
	// }else{

		$result = mysqli_query($link, "SELECT * FROM orderTABLE WHERE Shop_id = '$shopid' ORDER BY Order_id DESC LIMIT 0,10");

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