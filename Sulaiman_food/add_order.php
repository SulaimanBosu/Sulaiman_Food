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

				$sqlOrderID = "SELECT MAX(Order_id)AS OrderID FROM orderTABLE";
		$_result = $link->query($sqlOrderID);
                if($_result->num_rows > 0) {
                    while($rs = $_result->fetch_assoc()) {
                       
						$id = substr($rs['OrderID'], -3);
						if($id==""){
							$nextOrderId ="D00001";
						}else{
						$orderid = ($id + 1);
						$maxId = substr("D0000".$orderid, -3);
                        $nextOrderId = "D00".$maxId;
						}

		
					}
				}
			
				
		
		$datetime = $_GET['Order_datetime'];
		$Shopid = $_GET['Shop_id'];
		$Nameshop = $_GET['Name_shop'];
		$distance = $_GET['Distance'];
		$transport = $_GET['Transport'];
		$Foodid = $_GET['Food_id'];
		$FoodName = $_GET['Food_Name'];
		$price = $_GET['Price'];
		$amount = $_GET['Amount'];
		$sum = $_GET['Sum'];
		$Riderid = $_GET['Rider_id'];
		$status = $_GET['Status'];
		$userid = $_GET['User_id'];
		$username = $_GET['User_name'];

	$result = "INSERT INTO `orderTABLE`(`Order_id`, `Order_datetime`, `Shop_id`, `Name_shop`, `Distance`, `Transport`, `Food_id`, `Food_Name`, `Price`, `Amount`, `Sum`, `Rider_id`, `Status`, `User_id`, `Name`) VALUES ('$nextOrderId','$datetime','$Shopid','$Nameshop','$distance','$transport','$Foodid','$FoodName','$price','$amount','$sum','$Riderid','$status','$userid','$username')";
	$row = mysqli_query($link,$result);

		if ($result){
			echo "true";
		} else {
			echo "false";
		}
	  

	} else echo "Welcome Sulaiman Food";
   
}

	mysqli_close($link);
?>