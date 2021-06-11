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

    $_result = mysqli_query($link, "SELECT Shop_id FROM foodMenu GROUP BY Shop_id");
	//$row = mysqli_fetch_array($_result);
					
         while($rs = $_result->fetch_assoc()) {
			$Shopid = $rs['Shop_id'];

			$result = mysqli_query($link, "SELECT * FROM infomationShop WHERE Shop_id = '$Shopid' GROUP BY User_id");

			if ($result) {

				while($row=mysqli_fetch_assoc($result)){
				$output[]=$row;

				}	// while

			}
	
		}
   echo json_encode($output);

	} else echo "Welcome Sulaiman Food";	// if2
   
}	// if1


	mysqli_close($link);
?>