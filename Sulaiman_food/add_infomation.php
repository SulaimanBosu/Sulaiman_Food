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

		$sqlShopid = "SELECT MAX(Shop_id)AS ShopID FROM infomationShop";
		$_result = $link->query($sqlShopid);
                if($_result->num_rows > 0) {
                    while($rs = $_result->fetch_assoc()) {
                       
						$id = substr($rs['ShopID'], -3);
						if($id==""){
							$nextShopId ="S00001";
						}else{
						$shopid = ($id + 1);
						$maxId = substr("S0000".$shopid, -3);
                        $nextShopId = "S00".$maxId;
						}

		
					}
				}
			
				
		$Nameshop = $_GET['nameShop'];
		$Addressshop = $_GET['addressShop'];
		$Phoneshop = $_GET['phoneShop'];
		$Urlimage = $_GET['urlImage'];
		$Latitude = $_GET['latitude'];
		$Longitude = $_GET['longitude'];
		$Userid = $_GET['id'];
		$Token = $_GET['token'];

		
							
		// $sql = "UPDATE `infomationShop` SET `Name_shop` = '$Nameshop', `Address_shop` = '$Addressshop', `Phone_shop` = '$Phoneshop', `Url_image` = '$Urlimage', `Latitude` = '$Latitude', `Longitude` = '$Longitude' WHERE User_id = '$Userid'";

		$sql = "INSERT INTO infomationShop(Shop_id,Name_shop,Address_shop,Phone_shop,Url_image,Latitude,Longitude,User_id)values
	('$nextShopId','$Nameshop','$Addressshop','$Phoneshop','$Urlimage','$Latitude','$Longitude','$Userid')";

	    $sql2 = "UPDATE `userTABLE` SET `Token` = '$Token', `Shop_id` = '$nextShopId' WHERE User_id = '$Userid'";

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